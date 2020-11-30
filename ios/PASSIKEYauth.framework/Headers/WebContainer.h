//
//  WebContainer.h
//  BSWebFramework
//
//  Created by 이상현 on 2016. 8. 19..
//
//


#import "JSIController.h"

@interface WebContainer : UIViewController <WKScriptMessageHandler, WKUIDelegate, WKNavigationDelegate>

@property(nonatomic, strong) WKWebView* webView;
@property(nonatomic, strong) JSIController* controller;

-(void) attachWebView:(UIView*) parent;
@end

