//
//  Utils.m
//  Babycamera
//
//  Created by bear on 15/1/24.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import "Utils.h"

@implementation Utils
+(CGFloat)fetchVersionInfo
{
    UIDevice *device = [UIDevice currentDevice];
    CGFloat  version_f = device.systemVersion.floatValue ;
    return version_f ;
}
@end
