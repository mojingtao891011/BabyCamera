//
//  NSString+Extension.h
//  Babycamera
//
//  Created by bear on 15/1/24.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

//Md5加密
+(NSString*)MD5EncodedString:(NSString*)sourceString ;
//base64编码
+(NSString*)BASE64EncodedString:(NSString*)soucresString;
//base64解码
+ (NSString*)BASE64Decode:(NSString*)sourceString;
//判断输入的号码是否为手机号码
+(BOOL)checkTelNumber:(NSString*)numberStr;

@end
