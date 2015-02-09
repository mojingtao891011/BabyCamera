//
//  WebViewController.h
//  Babycamera
//
//  Created by bear on 15/1/27.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import "BaseViewController.h"


@interface WebViewController : BaseViewController<UIWebViewDelegate>

@property(nonatomic , copy)NSString *urlStr ;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
