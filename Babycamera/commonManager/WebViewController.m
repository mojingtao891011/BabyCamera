//
//  WebViewController.m
//  Babycamera
//
//  Created by bear on 15/1/27.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import "WebViewController.h"
#import "SVProgressHUD.h"

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad] ;
    //- (void)loadRequest:(NSURLRequest *)request;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]];
    [_webView loadRequest:request];
}

#pragma mark
#pragma mark-UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
   
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
    [SVProgressHUD showWithStatus:nil maskType:SVProgressHUDMaskTypeBlack];
    
    return YES ;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
}

@end
