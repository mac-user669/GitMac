//
//  ViewController.h
//  GitMac
//
//  Created by mac-user668 on 06/02/2019.
//  Copyright © 2019 mac-user668. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface ViewController : NSViewController <WKNavigationDelegate, WKUIDelegate>

@property (strong) IBOutlet WKWebView *webView;
@property (strong) IBOutlet NSProgressIndicator *progressBar;

@end
