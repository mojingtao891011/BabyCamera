//
//  ViewController.m
//  Babycamera
//
//  Created by bear on 15/1/22.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import "MainViewController.h"
#import "UIViewController+XTSideMenu.h"
#import "XTSideMenu.h"
#import <CommonCrypto/CommonDigest.h>
#import "NetworksRequest.h"
#import "NSString+Extension.h"
#import "NoteName.h"
#import "MainTableViewCell.h"

@interface MainViewController ()<UITableViewDataSource , UITableViewDelegate>
{
    BOOL _isDevice ;
    
}
@property (weak, nonatomic) IBOutlet UIButton *addDeviceButton;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    _isDevice = YES ;
    
    [self _initMainViewUI];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showAccountManagerViewCtl:) name:pushAccountManagerViewCtl object:nil];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNavgationBar:NO];
    
    self.sideMenuViewController.panGestureEnabled = YES ;
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.sideMenuViewController.panGestureEnabled = NO ;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark
#pragma mark-UI
- (void)_initMainViewUI
{
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor blackColor], UITextAttributeTextColor,
                                                                     nil]];
    
    //设置背景
    if (_isDevice) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.addDeviceButton.hidden = YES ;
    }
    else{
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ic_no_device"]];
        self.addDeviceButton.hidden = NO ;
    }
    
    
    //添加导航栏的左右按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 40, 30)];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"showLeftButton"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(showLeftViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem ;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 40, 30)];
    rightButton.backgroundColor = [UIColor clearColor];
    NSString *rightImgName = nil ;
    if (_isDevice) {
        rightImgName = @"showRightButton" ;
    }
    else{
        rightImgName = @"ic_add_device" ;
    }
    [rightButton setImage:[UIImage imageNamed:rightImgName] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(clickRightButtonItem) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem ;

    //
}

#pragma mark
#pragma mark-UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 10 ;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainTableViewCell" forIndexPath:indexPath];
    return cell ;
}
- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%d" , section];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *playBackViewCtl = [self fetchStoryboardViewController:@"PlayBackViewController"];
    [self.navigationController pushViewController:playBackViewCtl animated:YES];
}
#pragma mark
#pragma mark-Action
- (void)showLeftViewController:(id)sender {
    [self.sideMenuViewController presentLeftViewController];

    
    
}
- (void)clickRightButtonItem{
   // [self.sideMenuViewController presentRightViewController];
    
}
- (IBAction)addDeviceAction:(UIButton *)sender {
}

#pragma mark
#pragma mark- Note
- (void)showAccountManagerViewCtl:(NSNotification*)note
{
    
    NSString *identifier ;
    if (self.appDelegate.loginType == Normal) {
        identifier = @"AccountCtl" ;
    }
    else{
        identifier = @"ShareSDKLoginAccountCtl" ;
    }
    
    UIViewController *accountViewCtl = [self fetchStoryboardViewController:identifier];
    [self.navigationController pushViewController:accountViewCtl animated:YES];
}
@end
