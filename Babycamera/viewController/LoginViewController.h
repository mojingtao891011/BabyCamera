//
//  LoginViewController.h
//  Babycamera
//
//  Created by bear on 15/1/22.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//


#import "BaseViewController.h"

typedef void (^ShareSDKAutoLogin)();

@interface LoginViewController : BaseViewController

@property (nonatomic ,copy)ShareSDKAutoLogin  shareSDKAutoLogin ;

@end
