//
//  VcodeViewController.m
//  Babycamera
//
//  Created by bear on 15/1/22.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import "VcodeViewController.h"
#import "SetPasswordViewController.h"
#import "NetworksRequest.h"
#import "SVProgressHUD.h"
#import "SetPasswordViewController.h"

@interface VcodeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *vcodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *repeatSendButton;
@property (nonatomic , assign)NSInteger   time ;

@end

@implementation VcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setNavgationBar:YES];
    
    [self.vcodeTextField becomeFirstResponder];
    _time = 60 ;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startCountTime:) userInfo:nil repeats:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)startCountTime:(NSTimer*)timer
{
   
    if (_time == 0) {
        [timer invalidate];
        timer = nil ;
        _time = 60 ;
        [_repeatSendButton setTitle:@"点击重新获取" forState:UIControlStateNormal];
        _repeatSendButton.titleLabel.adjustsFontSizeToFitWidth = YES ;
    }
    else{
        [_repeatSendButton setTitle:[NSString stringWithFormat:@"%d秒后重发",_time--] forState:UIControlStateNormal];
    }
    
    
}
- (IBAction)repeatSendAction:(UIButton *)sender {
    
    if ([sender.currentTitle isEqualToString:@"点击重新获取"]) {
        
        
        [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
        [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeBlack];
        
        [NetworksRequest requestWithCommand:RequestVcodeCommand andNeedUserId:@"-1" AndNeedBobyArrKey:@[@"req_id" , @"channel" , @"receiver" ] andNeedBobyArrValue:@[@"1" , @"1" , _telNumber ] completeBlock:^(id result){
            
            NSArray *arr = (NSArray*)result ;
            if ([arr[0] integerValue] == RequestVcodeCommand ) {
                if ([arr[1] integerValue] == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startCountTime:) userInfo:nil repeats:YES];
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
}

- (IBAction)pushSetPasswordCtl:(UIButton *)sender {
   
    /*
     请求id                       int	    req_id		0：未知、1：注册、2：找回密码
    接收通道                    int     channel		1：手机、 2：邮箱
     接收通道标识           string	receiver		手机号码、邮箱或者uid等唯一标识
     验证码                      string	vfcode		接收到的请求验证码
     */
    if ([_repeatSendButton.currentTitle isEqualToString:@"点击重新获取"]) {
        [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"验证码失效请重新获取" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
        return ;
    }
    
     NSInteger vcodeLeght = [_vcodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length;
    if (vcodeLeght == 0) {
        [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入验证码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
        return ;

    }
    
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeBlack];
    
    [NetworksRequest requestWithCommand:SubmitVcodeCommand andNeedUserId:@"-1" AndNeedBobyArrKey:@[@"req_id" , @"channel" , @"receiver" , @"vfcode"] andNeedBobyArrValue:@[@"1" , @"1" , _telNumber , _vcodeTextField.text] completeBlock:^(id result){
        
        NSArray *arr = (NSArray*)result ;
        if ([arr[0] integerValue] == SubmitVcodeCommand ) {
            if ([arr[1] integerValue] == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    SetPasswordViewController *setPasswordCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"SetPasswordCtl"];
                    setPasswordCtl.telNumber = _telNumber ;
                    [self.navigationController pushViewController:setPasswordCtl animated:YES];
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"输入验证码有误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
                });
            }
        }
        [SVProgressHUD dismiss];
        
    }netFailBlock:^(id fail){
        [SVProgressHUD dismiss];
    }];

    
}


@end
