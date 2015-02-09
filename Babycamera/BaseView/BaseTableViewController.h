//
//  BaseTableViewController.h
//  Babycamera
//
//  Created by CC on 15/2/3.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface BaseTableViewController : UITableViewController

- (void)backAction ;

- (AppDelegate*)appDelegate ;

- (UIViewController*)fetchStoryboardViewController:(NSString*)identifier;

- (void)setNavgationBar:(BOOL)isRedColor ;

@end
