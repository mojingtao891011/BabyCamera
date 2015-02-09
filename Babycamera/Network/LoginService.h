//
//  LoginService.h
//  Babycamera
//
//  Created by bear on 15/1/30.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>

@interface LoginService : NSObject

+ (void)handleLoginRequest:(NSString*)userName
           anduserPassword:(NSString*)password
              andLoginType:(NSString*)type
          andShareSDkLogin:(BOOL)isShareSDKLogin andShareType:(ShareType)shareType;

+ (void)handleShareSDKLoginRequest:(ShareType)loginType ;

+ (void)handleAutoLoginRequest:(NSString*)userName
                       anduserPassword:(NSString*)password
                          andLoginType:(NSString*)type
                      andShareSDkLogin:(BOOL)isShareSDKLogin ;

+ (void)handleSignOutRequest:(ShareType)lastLoginType ;

@end
