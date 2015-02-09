//
//  UIView+firstResponder.m
//  Babycamera
//
//  Created by bear on 15/1/22.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import "UIView+firstResponder.h"

@implementation UIView (firstResponder)
- (UIView*)firstResponder{
    
    for(UIView *v in self.subviews){
        if([v isFirstResponder]){
            return v;
        }else{
            UIView *vf = [v firstResponder];
            if(vf){
                return vf;
            }
        }
    }
    return nil;

}
@end
