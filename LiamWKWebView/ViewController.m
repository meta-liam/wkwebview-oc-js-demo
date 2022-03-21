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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JS调用WKWebView";
    // Do any additional setup after loading the view from its nib.
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.userContentController = [[WKUserContentController alloc] init];
    // 注入JS对象Native，
    [config.userContentController addScriptMessageHandler:self name:@"LinkNative"];
    // 声明WKScriptMessageHandler 协议
    //[config.userContentController addScriptMessageHandler:self name:@"Native"];
    //本人喜欢只定义一个MessageHandler协议 当然可以定义其他MessageHandler协议
    //[config.userContentController addScriptMessageHandler:self name:@"Pay"];

    self.myWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    self.myWebView.UIDelegate = self;
    [self.view addSubview:self.myWebView];
    //[self loadTouched:nil];
    [self loadHtml:@"www/site/index"];
    //[self loadHtml:@"www/site/JSWKWebView"];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    NSDictionary *bodyParam = (NSDictionary*)message.body;
    NSString *func = [bodyParam objectForKey:@"function"];
    
    NSLog(@"MessageHandler Name:%@", message.name);
    NSLog(@"MessageHandler Body:%@", message.body);
    NSLog(@"MessageHandler Function:%@",func);

    // 定义一个MessageHandler协议 当然可以定义其他MessageHandler协议
    //{"jsonrpc":"2.0","method":"say","params":"liam","id":1,"service":"hello-world"}
    if ([message.name isEqualToString:@"LinkNative"]){
        if([func isEqualToString:@"jsonrpc"]){
            NSDictionary *parameters = [self dictionaryWithJsonString: [bodyParam objectForKey:@"parameters"]];
            NSLog(@"LinkNative:处理逻辑:%@",[parameters description]);
            NSLog(@"LinkNative:service:%@",[parameters objectForKey:@"service"]);
            NSLog(@"LinkNative:method:%@",[parameters objectForKey:@"method"]);
            
            //NSString * back = [NSString stringWithFormat: @"linkNativeCallBack('%@')", [parameters description]];
            NSString * back = [NSString stringWithFormat: @"linkNativeCallBack('%@')", [bodyParam objectForKey:@"parameters"]];
            NSLog(@"LinkNative:处理逻辑-back:%@",back);//回音功能
            [self.myWebView evaluateJavaScript:back completionHandler:^(id item, NSError * _Nullable error) {
            }];//back: @"linkNativeCallBack('hi,liam,i ok.')"
        }
        return;
    }
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"JSON解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(void)loadHtml:(NSString*)name{
    NSString *filePath = [[NSBundle mainBundle]pathForResource:name ofType:@"html"];
    
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [self.myWebView loadRequest:request];
}

-(void)showMessage:(NSString *)title message:(NSString *)message;
{
    if (message == nil)
    {
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:[message description]
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
    
}

#pragma mark - WKUIDelegate
- (void)webViewDidClose:(WKWebView *)webView {
    NSLog(@"%s", __FUNCTION__);
}
//uiwebview 中这个方法是私有方法 通过category可以拦截alert
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {

    NSLog(@"%s", __FUNCTION__);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

@end
