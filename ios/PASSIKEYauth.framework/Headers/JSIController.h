//
//  JSIController.h
//  BSWebFramework
//
//  Created by rowem on 2016. 7. 1..
//
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class WebContainer;
@class JSResponse;

@interface JSIController : NSObject

@property(nonatomic, strong) WKWebView* webView;
@property(nonatomic, strong) WebContainer* container;

-(id) initWithWebView:(WKWebView*)webView withContatiner:(WebContainer*)container;

/*
 * "Web->Native JavaScript호출
 * Android - 해당 함수 @JavascriptInterface "	*PlugIn (cateId) 찾을수 없는경우 오류처리
 */
-(void) callNative: (NSString* ) javaScript;

- (void) callWeb:(NSString*)arg;
/*
 * "Native->Web JavaScript 함수 호출
 * func - 함수명
 * arg - 인자값 (null : 인자값없음)"
 */
-(void) callFunc:(NSString*)funcName withArg:(NSString*)arg;

/*
 * "pool들 강제 종료 (WebView 종료시 사용) "
 * waitResp에 등록되여 있을 경우 삭제
 */
-(void) shutDown;

/*
 * "cid(JSCall ID)를 통해 waitResp에서 Response 객체 찾아 반환
 * 반환시 waitResp에서 제거"
 */
-(JSResponse*) findResponseFromWait:(NSInteger)cId;

@end
