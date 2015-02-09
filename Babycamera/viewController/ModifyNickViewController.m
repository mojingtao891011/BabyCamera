//
//  ModifyNickViewController.m
//  Babycamera
//
//  Created by CC on 15/2/3.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import "ModifyNickViewController.h"

@interface ModifyNickViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nickTextField;

@end

@implementation ModifyNickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.nickTextField becomeFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
