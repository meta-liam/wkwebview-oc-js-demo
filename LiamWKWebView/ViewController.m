//
//  ViewController.m
//  JLWebView1
//
//  Created by liamios on 14-6-21.
//  Copyright (c) 2014年 com.jl.wv. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    //[super viewDidLoad];
    [super viewDidLoad];

    webView = [[WKWebView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height)];
    // localfile
    NSString* path = [[NSBundle mainBundle] pathForResource:@"www/site/index" ofType:@"html"];
        NSURL* url = [NSURL fileURLWithPath:path];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    // http file
    //NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.jlwww.com/sh/"]];
    
    [self.view addSubview: webView];
    [webView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
