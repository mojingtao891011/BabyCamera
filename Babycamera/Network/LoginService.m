//
//  LoginService.m
//  Babycamera
//
//  Created by bear on 15/1/30.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import "LoginService.h"
#import "NetworksRequest.h"
#import "NSString+Extension.h"
#import "SVProgressHUD.h"
#import "Macro.h"
#import "AppDelegate.h"

@implementation LoginService

+ (void)handleLoginRequest:(NSString*)userName  anduserPassword:(NSString*)password andLoginType:(NSString*)type andShareSDkLogin:(BOOL)isShareSDKLogin andShareType:(ShareType)shareType
{
    
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeBlack];
    
    NSString *nameBase64Str = nil;
    NSString *passwordMD5Str = nil;
    if (isShareSDKLogin) {
        nameBase64Str = userName;
        passwordMD5Str = password;
    }
    else{
        nameBase64Str = [NSString BASE64EncodedString:userName];
        passwordMD5Str = [NSString MD5EncodedString:password];
    }
    
    
    //__weak LoginService *safeSelf = self ;
    
    [NetworksRequest requestWithCommand:loginCommand andNeedUserId:@"-1" AndNeedBobyArrKey:@[@"account" , @"pwd",  @"atype" , @"pbrand" , @"ostype" , @"osver" , @"imei" , @"ip"   ,@"etype"]  andNeedBobyArrValue:@[nameBase64Str , passwordMD5Str,  type , @" " , @"-1" , @" " , @" " , @" "   ,@"1"]  completeBlock:^(id results)
     {
         if ([results isKindOfClass:[NSArray class]]) {
             NSArray *resultArr = (NSArray*)results ;
             NSString *stautTitle = nil ;
             if ([resultArr[0] isEqualToString:@"726"] && [resultArr[1] isEqualToString:@"0"])
             {
                 //保存用户名、密码、用户ID
                 if (!isShareSDKLogin) {
                     [[NSUserDefaults standardUserDefaults]setObject:userName forKey:USERNAME];
                     [[NSUserDefaults standardUserDefaults]synchronize];
                     
                     [[NSUserDefaults standardUserDefaults]setObject:password forKey:USERPASSWORD];
                     [[NSUserDefaults standardUserDefaults]synchronize];
                 }
                
                 [[NSUserDefaults standardUserDefaults]setObject:[results lastObject] forKey:USERID];
                 [[NSUserDefaults standardUserDefaults]synchronize];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                    AppDelegate *dele = [UIApplication sharedApplication].delegate ;
                     dele.loginIsSuccessBlock(YES );
                 });
             }
             else
             {
                 if([resultArr[0] isEqualToString:@"726"] && [resultArr[1] isEqualToString:@"-100"])
                 {
                     stautTitle = @"用户不存在";
                 }
                 else if([resultArr[0] isEqualToString:@"726"] && [resultArr[1] isEqualToString:@"-101"])
                 {
                     stautTitle = @"密码错误";
                 }
                 else if([resultArr[0] isEqualToString:@"726"] && [resultArr[1] isEqualToString:@"-102"])
                 {
                     stautTitle = @"用户已经登陆";
                 }
                 else if([resultArr[0] isEqualToString:@"726"] && [resultArr[1] isEqualToString:@"-103"])
                 {
                     stautTitle = @"用户已经被冻结";
                 }
                 else if([resultArr[0] isEqualToString:@"726"] && [resultArr[1] isEqualToString:@"-104"])
                 {
                     stautTitle = @"账号异常，需要启用确认机制";
                 }
                 else if([resultArr[0] isEqualToString:@"726"] && [resultArr[1] isEqualToString:@"-105"])
                 {
                     stautTitle = @"账号长期不使用，需要重新激活";
                 }
                 
                 if (stautTitle) {
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:stautTitle delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
                     });
                     if (isShareSDKLogin) {
                          [ShareSDK cancelAuthWithType:shareType];
                     }
                 }
                 
             }
             
         }
         
         [SVProgressHUD dismiss];
     }
                           netFailBlock:^(id fail)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请求超时" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
         });
         
         [SVProgressHUD dismiss];
         
         if (isShareSDKLogin) {
             [ShareSDK cancelAuthWithType:shareType];
         }
     }];
    
    
}

+ (void)handleShareSDKLoginRequest:(ShareType)loginType
{
    
    [ShareSDK getUserInfoWithType:loginType
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               
                               if (result) {
                                   //4：qq 、5：微信  、6：微博 、7：淘宝
                                   NSDictionary *dict = userInfo.sourceData ;
                                
                                   //昵称
                                   [[NSUserDefaults standardUserDefaults]setObject:dict[@"nickname"] forKey:USERNAME];
                                   [[NSUserDefaults standardUserDefaults]synchronize];
                                   
                                    //头像
                                   [[NSUserDefaults standardUserDefaults]setObject:dict[@"headimgurl"] forKey:USERIMG];
                                   [[NSUserDefaults standardUserDefaults]synchronize];
                                   
                                    //uid
                                   [[NSUserDefaults standardUserDefaults]setObject:[userInfo uid] forKey:SHARESDKUID];
                                   [[NSUserDefaults standardUserDefaults]synchronize];
                                   
                                   NSString *loginTypeInt = nil ;
                                   
                                   AppDelegate *dele = [UIApplication sharedApplication].delegate ;
                                   
                                   if (loginType == ShareTypeWeixiSession) {
                                       loginTypeInt = @"5";
                                       dele.loginType = weixinLogin ;
                                   }
                                   else if (loginType == ShareTypeSinaWeibo ){
                                       loginTypeInt = @"6";
                                       dele.loginType = weiboLogin ;
                                   }
                                   else if (loginType == ShareTypeQQSpace){
                                       loginTypeInt = @"4";
                                       dele.loginType = QQLogin ;
                                   }
                                   
                                   //授权成功告诉自己服务器
                                   [self handleLoginRequest:[userInfo uid] anduserPassword:@"" andLoginType:loginTypeInt andShareSDkLogin:YES andShareType:loginType];
                                   
                               }
                               else{
                                    [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"授权失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
                                   
                               }
                           }];
    

}

+ (void)handleAutoLoginRequest:(NSString*)userName  anduserPassword:(NSString*)password andLoginType:(NSString*)type andShareSDkLogin:(BOOL)isShareSDKLogin
{
    
    /*
     账号	字符串                 account	Y	账号
     密码	字符串                 pwd
     登陆账户类型                atype(Int)		1：用户名 2：邮箱 3：手机 4：qq 5：微信  6：微博 7：淘宝
     手机品牌                        pbrand
     操作系统类型                ostype(Int)
     操作系统版本                string	osver
     Imei	字符串                 imei		登陆终端的唯一识别号
     ip地址	string                ip
     终端类型	Int                 etype		登陆终端类型  1：手机
     
     
     -100		宝贝看看的用户不存在
     -101		密码错误
     -102		用户已经登陆
     -103		用户已经被冻结
     -104		账号异常，需要启用确认机制
     -105		账号长期不使用，需要重新激活
     
     */
    
    AppDelegate *dele = [UIApplication sharedApplication].delegate ;
    
    NSString *nameBase64Str = nil;
    NSString *passwordMD5Str = nil;
    if (isShareSDKLogin) {
        nameBase64Str = userName;
        passwordMD5Str = password;
    }
    else{
        nameBase64Str = [NSString BASE64EncodedString:userName];
        passwordMD5Str = [NSString MD5EncodedString:password];
    }

    
    id returnData = [NetworksRequest syncRequestCommand:loginCommand andUserID:USER_ID andNeedBobyArrKey:@[@"account" , @"pwd",  @"atype" , @"pbrand" , @"ostype" , @"osver" , @"imei" , @"ip"   ,@"etype"] andNeedBobyArrValue:@[nameBase64Str , passwordMD5Str,  type , @" " , @"-1" , @" " , @" " , @" "   ,@"1"]];
    
    if ([returnData isKindOfClass:[NSError class]]) {
        dele.autoLoginIsSuccess(NO);
    }
    else{
        if ([returnData isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)returnData ;
            NSInteger errorInt = [dict[@"message_body"][@"error"] integerValue];
            if (errorInt == 0) {
                dele.autoLoginIsSuccess(YES);
            }
            else {
                dele.autoLoginIsSuccess(NO);
            }
        }
        else{
            dele.autoLoginIsSuccess(NO);
        }
    }
    
    
}

+ (void)handleSignOutRequest:(ShareType)lastLoginType
{
    
    /*
     退出原因	Int	cause	Y
     0:正常退出
     1：因升级应用程序而退出
     2：因收到服务器指定而退出
     3：用户强制退出
     */
    
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeBlack];
    
    //__weak LeftViewController *safeSelf = (LeftViewController*)self ;
    [NetworksRequest requestWithCommand:SignOutCommand andNeedUserId:USER_ID AndNeedBobyArrKey:@[@"cause"] andNeedBobyArrValue:@[@"0"] completeBlock:^(id result){
        
        if ([result isKindOfClass:[NSArray class]]) {
            NSArray *arr = (NSArray*)result ;
            if ([arr[0] integerValue] == SignOutCommand) {
                if ([arr[1] integerValue] == 0) {
                    
                    if (lastLoginType != ShareTypeAny) {
                        
                        [ShareSDK cancelAuthWithType:lastLoginType];
                    }
                    
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:USERNAME];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:USERPASSWORD];
                    [[NSUserDefaults standardUserDefaults]removeObjectForKey:USERID];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        AppDelegate *dele = [UIApplication sharedApplication].delegate ;
                        dele.loginIsSuccessBlock(NO);
                        
                    });
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"退出失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
                    });
                }
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"退出失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
                });
            }
        }
        [SVProgressHUD dismiss];
    }netFailBlock:^(id fail){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"退出失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil]show ];
        });
        [SVProgressHUD dismiss];
    }];

}

@end
