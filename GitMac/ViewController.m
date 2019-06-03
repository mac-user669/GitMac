//
//  ViewController.m
//  GitMac
//
//  Created by mac-user668 on 06/02/2019.
//  Copyright © 2019 mac-user668. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface WKWebView(SynchronousEvaluateJavaScript)
- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script;
@end

@implementation WKWebView(SynchronousEvaluateJavaScript)

- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script
{
    __block NSString *resultString = nil;
    __block BOOL finished = NO;
    
    [self evaluateJavaScript:script completionHandler:^(id result, NSError *error) {
        if (error == nil) {
            if (result != nil) {
                resultString = [NSString stringWithFormat:@"%@", result];
            }
        } else {
            NSLog(@"evaluateJavaScript error : %@", error.localizedDescription);
        }
        finished = YES;
    }];
    
    while (!finished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    return resultString;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    NSURL *nsurl=[NSURL URLWithString:@"https://github.com/login/"];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [_webView loadRequest:nsrequest];
    
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
        self.progressBar.doubleValue = self.webView.estimatedProgress * 100;
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.progressBar.hidden = YES;
    NSLog(@"Color: %@", [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('BODY')[0].style.color"]);
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.progressBar.hidden = NO;
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if(!([[navigationAction.request.URL host] isEqual:@"github.com"])) {
        [[NSWorkspace sharedWorkspace] openURL:navigationAction.request.URL];
    }
    decisionHandler(YES);
    
}

- (void)dealloc {
    
    if ([self isViewLoaded]) {
        [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    }
    
    // if you have set either WKWebView delegate also set these to nil here
    [self.webView setNavigationDelegate:nil];
    [self.webView setUIDelegate:nil];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}


@end
