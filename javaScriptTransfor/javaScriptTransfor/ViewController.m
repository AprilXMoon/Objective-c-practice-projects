//
//  ViewController.m
//  javaScriptTransfor
//
//  Created by April Lee on 2016/10/4.
//  Copyright © 2016年 april. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *testWebView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    NSURL *testURL = [NSURL URLWithString:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:testURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30];
    
    _testWebView.delegate = self;
    [_testWebView loadRequest:request];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = request.URL.absoluteString;
    
    if ([urlString hasPrefix:@"js-call:"]) {
        [self runObjMethod];
        return NO;
    }
    
    return YES;
}

- (void)runObjMethod
{
    NSLog(@"this is objective-c method");
    
    NSString *value = @"this is from objective-c!";
    
    //method 1
//  NSString *jsMethod = [NSString stringWithFormat:@"%@%@%@", @"jsFunction('",value,@"')"];
//  [_testWebView stringByEvaluatingJavaScriptFromString:jsMethod];
    
    //method 2
    [_testWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"jsFunction('%@')",value]];
    
}

@end
