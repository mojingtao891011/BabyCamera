//
//  BaseTableViewController.m
//  Babycamera
//
//  Created by CC on 15/2/3.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import "BaseTableViewController.h"
#import "UIView+firstResponder.h"
#import "Macro.h"


@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customBackAction];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidChangeAction:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    [[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent];
    
    [self setNavgationBar:YES];
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//监听键盘
- (void)keyboardDidChangeAction:(NSNotification*)note
{
    
    CGRect  keyboardRect = [[note userInfo][@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat keyboardRect_y = keyboardRect.origin.y ;
    
    
    UIView *responderView = [self.view firstResponder];
    CGFloat responderView_y = CGRectGetMaxY(responderView.frame);
    
    CGFloat moveHeight = keyboardRect_y   - ( responderView_y + responderView.bounds.size.height );
    
    [UIView animateWithDuration:0.2 animations:^{
        if ( moveHeight < 0) {
            self.view.center = CGPointMake(self.view.center.x, self.view.center.y + moveHeight);
        }
        else{
            self.view.center = CGPointMake(self.view.center.x, self.view.bounds.size.height / 2.0);
        }
        
    }];
    
}

//点击背景隐藏键盘
- (IBAction)clickbackgaundAction:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (void)setNavgationBar:(BOOL)isRedColor
{
    if (isRedColor) {
        if (Version < 7.0) {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBarItem_ios6"] forBarMetrics:UIBarMetricsDefault];
        }
        else
        {
            [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBarItem"] forBarMetrics:UIBarMetricsDefault];
        }
        
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                         [UIColor whiteColor], UITextAttributeTextColor,
                                                                         nil]];
    }
    else{
        [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                         [UIColor blackColor], UITextAttributeTextColor,
                                                                         nil]];
    }
    
    
}
//自定义导航栏图片
-(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


//返回按钮
- (void)customBackAction
{
    if (self.navigationController.viewControllers.count > 1 ) {
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(0, 0, 50, 44)];
        backButton.backgroundColor = [UIColor clearColor];
        [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        backButton.imageEdgeInsets = edgeInsets;
        [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barBrttonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = barBrttonItem ;
    }
    
}

//返回事件
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//获得AppDelegate
- (AppDelegate*)appDelegate
{
    AppDelegate *dele = [UIApplication sharedApplication].delegate ;
    return dele ;
}

//获得UIStoryboard指定的UIViewController
- (id)fetchStoryboardViewController:(NSString*)identifier
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    id viewController = nil ;
    if (identifier == nil) {
        viewController = [mainStoryboard instantiateInitialViewController];
    }
    else{
        viewController = [mainStoryboard instantiateViewControllerWithIdentifier:identifier];
    }
    
    return viewController ;
}

@end
