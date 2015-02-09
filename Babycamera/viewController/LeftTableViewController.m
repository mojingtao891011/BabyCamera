//
//  LeftTableViewController.m
//  Babycamera
//
//  Created by bear on 15/2/2.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import "LeftTableViewController.h"
#import "NoteName.h"
#import "UIViewController+XTSideMenu.h"
#import "XTSideMenu.h"
#import "Macro.h"

@interface LeftTableViewController ()

@property (weak, nonatomic) IBOutlet UIButton *userImgButton;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation LeftTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self _initLeftViewUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark
#pragma mark-UI
- (void)_initLeftViewUI
{
    self.sideMenuViewController.menuOpacityViewLeftBackgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ic_leftBgview"]];
    
    UILabel *cameralabel = [[UILabel alloc]initWithFrame:CGRectMake(50, self.view.bounds.size.height - 50, 150, 50)];
    cameralabel.backgroundColor = [UIColor clearColor];
    cameralabel.text = @"宝贝看看 baby camera";
    cameralabel.textColor = [UIColor whiteColor];
    cameralabel.font = [UIFont fontWithName:customFontName size:12.0];
    
    [self.view insertSubview:cameralabel belowSubview:self.tableView];

}
- (IBAction)showAccountViewCtl:(id)sender {
    
    [self.sideMenuViewController hideMenuViewController];
    
    //发送通知给main界面push出账号管理界面
    [[NSNotificationCenter defaultCenter]postNotificationName:pushAccountManagerViewCtl object:nil];
}


@end
