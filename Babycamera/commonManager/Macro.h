//
//  Macro.h
//  Babycamera
//
//  Created by bear on 15/1/26.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#ifndef Babycamera_Macro_h
#define Babycamera_Macro_h

#define LEFTCTLWIDTH              245.0f
#define RIGHTCTLWIDTH           245.0f

#define Version                                 [[[UIDevice currentDevice]systemVersion]floatValue]

#define REQUSET_URL                 @"http://192.168.17.23:31000/iSpaceSvr/ios"

#define AGREEMENT_URL           @"http://www.momoda.com/help/html/termsAndPrivacy.html"

#define SHARE_APPID                             @"57f4167c9d1a"

#define QQ_APP_ID                                   @"1103841112"
#define QQ_APP_KEY                              @"XaHpp8DGDrjOSBST"

#define WEIBO_APP_KEY                       @"2484540825"
#define WEIBO_APP_SECRECT             @"bf2104f30e6e3939ec17cfb51069b46c"

#define WEIXIN_APP_ID                         @"wx5dad3e85501dc15c"
#define WEIXIN_APP_SECRECT              @"dfd309cde15b1c0e52f5ea2888b2239d"

#define USERNAME                         @"userName"
#define USERPASSWORD                 @"md5Password"
#define  USER_NAME                   [[NSUserDefaults standardUserDefaults]objectForKey:USERNAME]
#define USER_PASSWORD           [[NSUserDefaults standardUserDefaults]objectForKey:USERPASSWORD]

#define USERID                                  @"userid"
#define USER_ID                             [[NSUserDefaults standardUserDefaults]objectForKey:USERID]
#define USERIMG                                 @"userimg"
#define USER_IMG                             [[NSUserDefaults standardUserDefaults]objectForKey:USERIMG]

#define SHARESDKUID                     @"shareSDKuid"
#define SHARESDK_UID                    [[NSUserDefaults standardUserDefaults]objectForKey:SHARESDKUID]

#endif
