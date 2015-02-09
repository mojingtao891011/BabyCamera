//
//  BaseloginViewController.h
//  
//
//  Created by bear on 15/1/22.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface BaseViewController : UIViewController


- (void)backAction ;

- (AppDelegate*)appDelegate ;

- (UIViewController*)fetchStoryboardViewController:(NSString*)identifier;

- (void)setNavgationBar:(BOOL)isRedColor ;

@end
