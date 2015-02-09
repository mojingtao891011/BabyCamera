//
//  SetPasswordViewController.m
//  Babycamera
//
//  Created by bear on 15/1/22.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "Macro.h"
#import "NetworksRequest.h"
#import "SVProgressHUD.h"
#import "NSString+Extension.h"

@interface SetPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setNavgationBar:YES];
    
    [self.passwordTextField becomeFirstResponder];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showPasswordAction:(UIButton *)sender {
    _passwordTextField.secureTextEntry = sender.selected;
    sender.selected = !sender.selected ;
    
}
- (IBAction)regiterFininshAction:(UIButton *)sender {
    
    /*
     725
     消息段        类型                  KEY-NAME	必需	说明
     
     用户名            字符串               name		Base64编码
     密码                 字符串                 pwd         MD5
     邮箱                 字符串                 email
     手机                 字符串                 Phone
     用户注册           int                     atype		   1：宝贝看看 、 2未知
     IP地址               字符串                 ip
     手机识别码        字符串             imei
     */
    
    NSInteger passwordLeght = [_passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ] ].length;
    if (!(passwordLeght >= 6 && passwordLeght <= 16)) {
        [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"密码长度6-16字符" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
        return  ;
    }
    
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeBlack];
    
    [NetworksRequest requestWithCommand:RegisterCommand andNeedUserId:@"-1" AndNeedBobyArrKey:@[@"name" , @"pwd" , @"email" , @"phone" , @"atype" , @"ip" , @"imei"] andNeedBobyArrValue:@[[NSString BASE64EncodedString:_telNumber] , [NSString MD5EncodedString:_passwordTextField.text] , @"" , _telNumber , @"1" , @"" , @""]  completeBlock:^(id result){
        NSArray *arr = (NSArray*)result ;
        if ([arr[0] integerValue] == RegisterCommand) {
            if ([arr[1] integerValue] == 0)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.appDelegate.loginIsSuccessBlock(YES );
                    
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"未知错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
                });
            }
        }
        
        [SVProgressHUD dismiss];
    }netFailBlock:^(id fail){
        [SVProgressHUD showErrorWithStatus:@"请求失败" maskType:SVProgressHUDMaskTypeNone];
    }];
    
    
}


@end
