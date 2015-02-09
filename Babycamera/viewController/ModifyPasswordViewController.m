//
//  ModifyPasswordViewController.m
//  Babycamera
//
//  Created by CC on 15/2/3.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import "ModifyPasswordViewController.h"

@interface ModifyPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *loginPswTextField;
@property (weak, nonatomic) IBOutlet UITextField *pswTextfield;

@end

@implementation ModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.loginPswTextField becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
