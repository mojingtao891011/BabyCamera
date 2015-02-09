//
//  NSString+Extension.m
//  Babycamera
//
//  Created by bear on 15/1/24.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>
#import "Utils.h"
#import "GTMBase64.h"

@implementation NSString (Extension)
+(NSString*)MD5EncodedString:(NSString*)sourceString
{
    //转换成utf-8
    const char *cStr = [sourceString UTF8String];
    //开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    unsigned char result[16];
    //官方封装好的加密方法
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    // 把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
    NSMutableString *Mstr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        //x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
        [Mstr appendFormat:@"%02x",result[i]];
        
    }
    return Mstr;
}
+(NSString*)BASE64EncodedString:(NSString*)sourceString
{
    NSString * _base64Str = nil ;
    CGFloat versionInfo = [Utils fetchVersionInfo];
    if (versionInfo < 7.0) {
        //加密：
         _base64Str = [[NSString alloc]initWithData:[GTMBase64 encodeData:[sourceString dataUsingEncoding:NSUTF8StringEncoding]] encoding:NSUTF8StringEncoding];
    }
    else{
        _base64Str =  [[sourceString dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        
    }
   return _base64Str ;
}
+ (NSString*)BASE64Decode:(NSString*)sourceString
{
    NSString *decodeStr = nil ;
    CGFloat versionInfo = [Utils fetchVersionInfo];
    if (versionInfo < 7.0)
    {
        decodeStr = [[NSString alloc]initWithData:[GTMBase64 decodeString:sourceString] encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData* decodeData = [[NSData alloc] initWithBase64EncodedString:sourceString options:0];
        decodeStr = [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
    }
    
    return decodeStr ;
}
+(BOOL)checkTelNumber:(NSString*)numberStr
{
    
    if ([numberStr length] == 0) {
        return NO;
    }
    //1[0-9]{10}
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    //    NSString *regex = @"[0-9]{11}";
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:numberStr];
    return isMatch ;
}
@end
