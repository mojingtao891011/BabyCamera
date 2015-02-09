//
//  LoginViewController.m
//  Babycamera
//
//  Created by bear on 15/1/22.
//  Copyright (c) . All rights reserved.
//

#import "LoginViewController.h"
#import "Macro.h"
#import "NetworksRequest.h"
#import "NSString+Extension.h"
#import "SVProgressHUD.h"
#import <ShareSDK/ShareSDK.h>
#import "RequestVcodeViewController.h"
#import "loginService.h"

typedef enum :NSInteger{
    weixin = 1,
    weibo = 2,
    QQ = 3,
    taobao = 4,
}ThirdLoginEnum;

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userPasswordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *loginButton_lineImg;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
   
    [self _initLoginView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault ];
}
#pragma mark
#pragma mark-UI
- (void)_initLoginView
{
    //修改UITextfield的Placeholder字体的颜色
    
    [_userNameTextField setValue:[UIColor colorWithRed:255/255.0 green:92/255.0 blue:92/255.0 alpha:0.5] forKeyPath:@"_placeholderLabel.textColor"];
    [_userPasswordTextField setValue:[UIColor colorWithRed:255/255.0 green:92/255.0 blue:92/255.0 alpha:0.5] forKeyPath:@"_placeholderLabel.textColor"];
    
    //设置圆头像
    _userImgView.layer.cornerRadius = self.userImgView.bounds.size.height / 2.0;
    _userImgView.clipsToBounds = YES ;
    
    
}
#pragma mark
#pragma mark - Action

- (IBAction)showRequestVcodeViewCtl:(UIButton *)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RequestVcodeViewController *requestViewCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"RequestViewCtl"];
    if (sender.tag == 10)
    {
        requestViewCtl.isForgetPassword = YES ;
    }
    else if (sender.tag == 20)
    {
        requestViewCtl.isForgetPassword = NO ;
    }
    [self.navigationController pushViewController:requestViewCtl animated:YES];
}

- (IBAction)loginAction:(UIButton *)sender
{
    
    /*
     账号	字符串                 account	Y	账号
     密码	字符串                 pwd
     登陆账户类型                atype(Int)		1：用户名 2：邮箱 3：手机 4：qq 5：微信  6：微博 7：淘宝
     手机品牌                        pbrand
     操作系统类型                ostype(Int)
     操作系统版本                string	osver
     Imei	字符串                 imei		登陆终端的唯一识别号
     ip地址	string                ip		
     终端类型	Int                 etype		登陆终端类型  1：手机
     
     
     -100		宝贝看看的用户不存在
     -101		密码错误
     -102		用户已经登陆
     -103		用户已经被冻结
     -104		账号异常，需要启用确认机制
     -105		账号长期不使用，需要重新激活
     
     */
    sender.selected = YES ;
    self.loginButton_lineImg.highlighted = YES ;
    
    if ([self isUserNameWithPasswordRight]) {
        self.appDelegate.loginType = Normal ;
        [LoginService handleLoginRequest:_userNameTextField.text anduserPassword:_userPasswordTextField.text andLoginType:@"1" andShareSDkLogin:NO andShareType:ShareTypeAny];
        
    }
    
}

- (BOOL)isUserNameWithPasswordRight
{
    NSInteger userNameLeght = [_userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
    if (userNameLeght == 0) {
        [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"用户名不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
        return NO ;
    }
    
    NSInteger passwordLeght = [_userPasswordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
    if ( passwordLeght == 0) {
        [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"密码不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
        return NO ;
    }
    
    return YES ;
}

- (IBAction)thirdLoginAction:(UIButton *)sender {
    
    ShareType loginType ;
    if (sender.tag == weixin)
    {
        loginType = ShareTypeWeixiSession ;
    }
    else if (sender.tag == weibo)
    {
         loginType = ShareTypeSinaWeibo ;
    }
    else if (sender.tag == QQ)
    {
        loginType = ShareTypeQQSpace ;
    }
    else if (sender.tag == taobao)
    {
         [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"开发中……" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
        return ;
    }
    
    //判断是否已授权
    if ([ShareSDK hasAuthorizedWithType:loginType]) {
        
        NSLog(@"已授权");
        [ShareSDK cancelAuthWithType:loginType];
        
    }
    else{
        //[self startAuthorized:loginType];
        [LoginService handleShareSDKLoginRequest:loginType];
    }

}

/*
//开始授权
- (void)startAuthorized:(ShareType)loginType
{
    
    __weak LoginViewController *safeSelf = (LoginViewController*)self ;
    [ShareSDK authWithType:loginType options:nil result:^(SSAuthState authState , id<ICMErrorInfo> error){
        if (authState == SSAuthStateSuccess) {
            
           // safeSelf.appDelegate.loginSuccessBlock();
            [safeSelf fetchUserInfo:loginType];
            
            if (loginType == ShareTypeWeixiSession) {
                safeSelf.appDelegate.loginType = weixinLogin ;
            }
            else if (loginType == ShareTypeSinaWeibo){
                safeSelf.appDelegate.loginType = weiboLogin ;
            }
            else if (loginType == ShareTypeQQSpace){
                safeSelf.appDelegate.loginType = QQLogin ;
            }
           
        }
        
    }];
}

//第三方登陆成功后获取用户信息
- (void)fetchUserInfo:(ShareType)loginType
{
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeBlack];
    
    __weak LoginViewController *safeSelf = (LoginViewController*)self ;
    
     [ShareSDK getUserInfoWithType:loginType
     authOptions:nil
     result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
     
         if (result) {
             //4：qq 5：微信  6：微博 7：淘宝
             NSDictionary *dict = userInfo.sourceData ;
             NSString *name = dict[@"nickname"];
             
             [[NSUserDefaults standardUserDefaults]setObject:dict[@"headimgurl"] forKey:USERIMG];
             [[NSUserDefaults standardUserDefaults]synchronize];
             
             [[NSUserDefaults standardUserDefaults]setObject:[userInfo uid] forKey:SHARESDKUID];
             [[NSUserDefaults standardUserDefaults]synchronize];
             
             NSString *loginTypeInt = nil ;
             if (loginType == ShareTypeWeixiSession) {
                 loginTypeInt = @"5";
             }
             else if (loginType == ShareTypeSinaWeibo ){
                 loginTypeInt = @"6";
             }
             else if (loginType == ShareTypeQQSpace){
                 loginTypeInt = @"7";
             }
             
             [safeSelf authSuccess:loginTypeInt andUserName:name andUid:[userInfo uid]];
         }
         else{
             [SVProgressHUD dismiss];
         }
     }];
     
}

//第三方登陆成功后告诉服务器
- (void)authSuccess:(NSString*)loginType andUserName:(NSString*)userName andUid:(NSString*)userUID
{
    //登陆账户类型                atype(Int)		1：用户名 2：邮箱 3：手机 4：qq 5：微信  6：微博 7：淘宝
    
    
    __weak LoginViewController *safeSelf = self ;
   
    [NetworksRequest requestWithCommand:loginCommand andNeedUserId:@"-1" AndNeedBobyArrKey:@[@"account" , @"pwd",  @"atype" , @"pbrand" , @"ostype" , @"osver" , @"imei" , @"ip"   ,@"etype"]  andNeedBobyArrValue:@[userUID , @" ",  loginType , @" " , @"-1" , @" " , @" " , @""   ,@"1"]  completeBlock:^(id results)
     {
         if ([results isKindOfClass:[NSArray class]]) {
             NSArray *resultArr = (NSArray*)results ;
             if ([resultArr[0] isEqualToString:@"726"] && [resultArr[1] isEqualToString:@"0"])
             {
                 //保存用户名、密码、用户ID
                 [[NSUserDefaults standardUserDefaults]setObject:userName forKey:USERNAME];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 
                 [[NSUserDefaults standardUserDefaults]setObject:[results lastObject] forKey:USERID];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     safeSelf.appDelegate.loginSuccessBlock();
                 });
             }
             else
             {
                  [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"未知错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
             }
             
         }
         
         [SVProgressHUD dismiss];
     }
                           netFailBlock:^(id fail)
     {
         [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请求超时" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
         [SVProgressHUD dismiss];
     }];
    
    
    
}
 */
@end
