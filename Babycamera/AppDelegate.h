//
//  AppDelegate.h
//  Babycamera
//
//  Created by bear on 15/1/22.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    weixinLogin = 1,
    weiboLogin = 2,
    QQLogin = 3,
    taobaoLogin = 4,
    Normal  = 5
}LoginType;

typedef void(^LoginIsSuccess)(BOOL);
typedef void(^AutoLoginIsSuccess)(BOOL);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic , copy)LoginIsSuccess  loginIsSuccessBlock ;
@property (nonatomic , copy)AutoLoginIsSuccess autoLoginIsSuccess ;
@property (nonatomic , assign)LoginType     loginType ;

@end

