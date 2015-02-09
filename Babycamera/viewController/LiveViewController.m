//
//  LiveViewController.m
//  Babycamera
//
//  Created by bear on 15/2/5.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import "LiveViewController.h"

@interface LiveViewController ()

@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)openFolderAction:(UIButton*)sender {
    sender.selected = !sender.selected ;
}
- (IBAction)photographAction:(UIButton *)sender {
    sender.selected = !sender.selected ;
}
- (IBAction)videoRecord:(UIButton *)sender {
    sender.selected = !sender.selected ;
}
- (IBAction)voiceAction:(UIButton *)sender {
    sender.selected = !sender.selected ;
}

@end
