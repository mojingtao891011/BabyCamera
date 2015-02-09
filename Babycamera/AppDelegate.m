//
//  AppDelegate.m
//  Babycamera
//
//  Created by bear on 15/1/22.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "Macro.h"
#import "NetworksRequest.h"
#import "NSString+Extension.h"
#import "XTSideMenu.h"
#import "SVProgressHUD.h"
#import "LoginService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //第三方登陆
    
    [ShareSDK registerApp:SHARE_APPID];//字符串api20为您的ShareSDK的AppKey
    
    [ShareSDK connectWeChatWithAppId:WEIXIN_APP_ID   //微信APPID
                           appSecret:WEIXIN_APP_SECRECT  //微信APPSecret
                           wechatCls:[WXApi class]];
    
    [ShareSDK connectSinaWeiboWithAppKey:WEIBO_APP_KEY
                               appSecret:WEIBO_APP_SECRECT
                             redirectUri:@"http://www.momoda.com"];
    
    [ShareSDK connectQZoneWithAppKey:QQ_APP_ID
                           appSecret:QQ_APP_KEY
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
     
    //
    
    __weak AppDelegate *safeSelf = self ;
    self.loginIsSuccessBlock = ^(BOOL isLoginSuccess ){
        
        if (isLoginSuccess) {
             [safeSelf setCenterViewWithLeftViewWithRightView:isLoginSuccess];
            
        }
        else{
            UIViewController *ctl = safeSelf.window.rootViewController ;
            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController*loginViewCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginCtl"];
             loginViewCtl.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal ;
            [ctl presentViewController:loginViewCtl animated:YES completion:nil];

        }

    };
    self.autoLoginIsSuccess = ^(BOOL isAutoLoginsuccess){
            [safeSelf setCenterViewWithLeftViewWithRightView:isAutoLoginsuccess];
        
    };
    
   // [self autoLogin];
    
    [self setCenterViewWithLeftViewWithRightView:YES];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark-ShareSDK
- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}
#pragma mark
#pragma mark-AutoLogin
- (void)autoLogin
{
    
    //4：qq 5：微信  6：微博 7：淘宝
    if (USER_NAME  && USER_PASSWORD)
    {
        self.loginType = Normal ;
        [LoginService handleAutoLoginRequest:USER_NAME anduserPassword:USER_PASSWORD andLoginType:@"1" andShareSDkLogin:NO];
        
    }
    else if ([ShareSDK hasAuthorizedWithType:ShareTypeWeixiSession])
    {
        self.loginType = weixinLogin ;
        [LoginService handleAutoLoginRequest:SHARESDK_UID anduserPassword:@" " andLoginType:@"5" andShareSDkLogin:YES];
    }
    else if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo])
    {
        self.loginType = weiboLogin;
        [LoginService handleAutoLoginRequest:SHARESDK_UID anduserPassword:@" " andLoginType:@"6" andShareSDkLogin:YES];
    }
    else if ([ShareSDK hasAuthorizedWithType:ShareTypeQQSpace])
    {
        self.loginType = QQLogin ;
        [LoginService handleAutoLoginRequest:SHARESDK_UID anduserPassword:@" " andLoginType:@"4" andShareSDkLogin:YES];
    }
    else if ([ShareSDK hasAuthorizedWithType:ShareTypeQQSpace])
    {
        self.loginType = taobaoLogin ;
    }
    else
    {
        [self setCenterViewWithLeftViewWithRightView:NO ];
    }
    
}
- (void)setCenterViewWithLeftViewWithRightView:(BOOL)isLoginSuccess
{
    self.window.backgroundColor = [UIColor whiteColor];
    if (isLoginSuccess) {
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController*center = [mainStoryboard instantiateInitialViewController];
        UIViewController *left = [mainStoryboard instantiateViewControllerWithIdentifier:@"LeftViewCtl"];
        
        XTSideMenu *root = [[XTSideMenu alloc] initWithContentViewController:center leftMenuViewController:left rightMenuViewController:nil];
        root.leftMenuViewVisibleWidth = LEFTCTLWIDTH;
        self.window.rootViewController = root ;
        
    }
    else{
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController*loginViewCtl = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginCtl"];
        self.window.rootViewController = loginViewCtl ;
        
    }
    
    [SVProgressHUD dismiss];
    
}

@end
