//
//  RegisterViewController.m
//  Babycamera
//
//  Created by bear on 15/1/22.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import "RequestVcodeViewController.h"
#import "NetworksRequest.h"
#import "NSString+Extension.h"
#import "SVProgressHUD.h"
#import "WebViewController.h"
#import "Macro.h"
#import "VcodeViewController.h"


@interface RequestVcodeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton1;
@property (weak, nonatomic) IBOutlet UIImageView *line;

@property (nonatomic , assign)BOOL  isAgree ;

@end

@implementation RequestVcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
     [super setNavgationBar:YES];
    
    self.navigationController.navigationBarHidden = NO ;
     [self.phoneTextField  becomeFirstResponder];
    [self _initView];

   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark-UI
- (void)_initView
{
    self.agreeButton.hidden = _isForgetPassword ;
    self.agreeButton1.hidden = _isForgetPassword ;
    self.label.hidden = _isForgetPassword ;
    self.line.hidden = _isForgetPassword ;
}
#pragma mark
#pragma mark-Action

- (void)backAction
{
    self.navigationController.navigationBarHidden = YES ;
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)fetchVcodeAction:(UIButton *)sender
{
    /*     
     请求id               int     req_id          0：未知、1：注册、2：找回密码
     接收通道           int	channel		1：手机、2：邮箱
     接收通道标识	string	receiver		手机号码、邮箱或者uid等唯一标识
     */
    if (![NSString checkTelNumber:_phoneTextField.text])
    {
        NSString *stateTitle = nil ;
        NSInteger telNumberLeght = [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
        if (telNumberLeght == 0) {
            stateTitle = @"手机号码不能留空请输入" ;
        }
        else{
            stateTitle = @"手机号码有误请重新输入";
        }
        [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:stateTitle delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
        
        return ;
    }
    if (!_isAgree && !_agreeButton.hidden) {
        [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还未同意注册服务协议" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
        return ;
    }
    
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeBlack];
    
    [NetworksRequest requestWithCommand:RequestVcodeCommand andNeedUserId:@"-1" AndNeedBobyArrKey:@[@"req_id" , @"channel" , @"receiver" ] andNeedBobyArrValue:@[@"1" , @"1" , _phoneTextField.text ] completeBlock:^(id result){
        
        NSArray *arr = (NSArray*)result ;
        if ([arr[0] integerValue] == RequestVcodeCommand ) {
            if ([arr[1] integerValue] == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    VcodeViewController *vcodeViewCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"VcodeViewCtl"];
                    vcodeViewCtl.telNumber = _phoneTextField.text ;
                    [self.navigationController pushViewController:vcodeViewCtl animated:YES];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"获取验证码失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
                });
            }
        }
        [SVProgressHUD dismiss];
        
    }netFailBlock:^(id fail){
        [SVProgressHUD dismiss];
    }];
}
- (IBAction)clickAgreeAction:(UIButton*)sender {
    
    sender.selected = !sender.selected ;
    _isAgree = sender.selected ;
    
}
- (IBAction)readServiceProtocol:(UIButton *)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WebViewController *webViewCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"WebViewCtl"];
    webViewCtl.urlStr = AGREEMENT_URL ;
    [self.navigationController pushViewController:webViewCtl animated:YES];
}
@end
