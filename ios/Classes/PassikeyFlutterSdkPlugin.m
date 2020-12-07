#import "PassikeyFlutterSdkPlugin.h"
#import <PASSIKEYauth/PASSIKEYauth.h>
#import <PASSIKEYauth/PassikeyWebViewController.h>
#import "FlutterPassikeyDelegate.h"
#import "PassikeyTemporaryViewController.h"

@interface PassikeyFlutterSdkPlugin() <FlutterPassikeyDelegate>
@end

@implementation PassikeyFlutterSdkPlugin

FlutterMethodCall *loginMethodCall;
FlutterResult loginResult;

-(instancetype) init {
    self = [super init];
    return self;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"passikey_flutter_sdk" binaryMessenger:[registrar messenger]];
    PassikeyFlutterSdkPlugin* instance = [[PassikeyFlutterSdkPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    [registrar addApplicationDelegate:instance];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if([call.method isEqualToString:@"Passikey#init"]) {
        NSString *appScheme = [NSString stringWithFormat:@"pk%@", PassikeyManager.getInstance.getClientId];
        [[PassikeyManager getInstance] setAppScheme: appScheme];
    } else if ([call.method isEqualToString:@"Passikey#login"]) {
        NSDictionary* arguments = call.arguments;
        NSString* stateToken = [arguments objectForKey: @"stateToken"];
        UINavigationController *controller;
        
        if(stateToken == nil) {
            result([FlutterError errorWithCode:@"passikey_sdk" message:@"stateToken을 설정해주세요" details:nil]);
            return;
        }
        
        for(id window in [[UIApplication sharedApplication] windows]) {
            if([window isHidden] == FALSE && [window rootViewController] != nil && [[window rootViewController] isKindOfClass:[UINavigationController class]]) {
                controller = (UINavigationController*) [window rootViewController];
            }
        }
        
        if(controller == NULL) {
            result([FlutterError errorWithCode:@"passikey_sdk" message:@"rootViewController가 UINavigationController로 설정해주세요" details:nil]);
            return;
        }
        
        loginMethodCall = call;
        loginResult = result;
        
        PassikeyTemporaryViewController* newController = [[PassikeyTemporaryViewController alloc] init];
        newController.passikeyDelegate = self;
        [controller pushViewController:newController animated:false];
        
        [[PassikeyManager getInstance] login:newController withStateToken: stateToken];
    } else if ([call.method isEqualToString:@"Passikey#getClientId"]) {
        result(PassikeyManager.getInstance.getClientId);
    } else if ([call.method isEqualToString:@"Passikey#getSecretKey"]) {
        result(PassikeyManager.getInstance.getSecretKey);
    } else if ([call.method isEqualToString:@"Passikey#startStore"]) {
        [PassikeyManager.getInstance startStore];
        result(@(TRUE));
    } else if ([call.method isEqualToString:@"Passikey#isInstalledPassikey"]) {
        result(@(PassikeyManager.getInstance.isInstalledPassikey));
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([url.scheme isEqualToString: [[PassikeyManager getInstance] getAppScheme]]) {
        UIViewController *presentedController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        if(presentedController != NULL) {
            if ([presentedController isKindOfClass:[PassikeyWebViewController class]]) {
                PassikeyWebViewController *passikeyWebViewController = (PassikeyWebViewController*) presentedController;
                
                NSDictionary *result = [[PassikeyManager getInstance] passikeyResultParsing:url];
                if(result != nil) {
                    [passikeyWebViewController resultProcess:result];
                    return true;
                }
            }
        }
    }
    
    return FALSE;
}

- (void)onCallback:(nonnull NSMutableDictionary *)successAuthValue withErrInfo:(nonnull NSMutableDictionary *)errInfo {
    UINavigationController *controller;
    
    for(id window in [[UIApplication sharedApplication] windows]) {
        if([window isHidden] == FALSE && [window rootViewController] != nil && [[window rootViewController] isKindOfClass:[UINavigationController class]]) {
            controller = (UINavigationController*) [window rootViewController];
        }
    }
    
    if(controller != nil) [controller popToRootViewControllerAnimated:false];
    if(loginResult == nil) return;
    
    NSString *stateToken = [[PassikeyManager getInstance] getStateToken];
    NSString *receiveStateToken = [[PassikeyManager getInstance] getReciveStateToken];
    NSString *partnerToken = [[PassikeyManager getInstance] getPartnerToken];
    
    if(successAuthValue != nil) {
        if(![stateToken isEqualToString: receiveStateToken]) {
            loginResult([FlutterError errorWithCode:@"passikey_sdk" message:@"로그인 요청시 전달한 상태토큰 불일치" details:nil]);
            return;
        } else if(partnerToken == nil) {
            loginResult([FlutterError errorWithCode:@"passikey_sdk" message:@"파트너 토큰이 비어있습니다" details:nil]);
            return;
        }
        
        NSDictionary *result = @{@"statToken":stateToken, @"ptnToken":partnerToken};
        loginResult(result);
    } else {
        NSDictionary *details = @{
            @"errorCode": [errInfo objectForKey:@"result_code"],
            @"errorName": [self getErrorName:[errInfo objectForKey:@"result_code"]]
        };
        loginResult([FlutterError errorWithCode:@"passikey_sdk" message:@"로그인에 실패했습니다" details: details]);
    }
}

- (NSString*)getErrorName:(nonnull NSString *) errorCode {
    if([errorCode isEqualToString:@"0000"]) {
        return @"SUCCESS";
    } else if([errorCode isEqualToString:@"8000"]) {
        return @"USER_CANCEL";
    } else if([errorCode isEqualToString:@"8001"]) {
        return @"CLIENT_ERROR";
    } else if([errorCode isEqualToString:@"8002"]) {
        return @"SERVER_ERROR";
    } else if([errorCode isEqualToString:@"8003"]) {
        return @"NETWORK_ERROR";
    } else if([errorCode isEqualToString:@"8004"]) {
        return @"INITIALIZED_ERROR";
    } else if([errorCode isEqualToString:@"8010"]) {
        return @"INVALID_CONFIG_INFO";
    } else if([errorCode isEqualToString:@"8011"]) {
        return @"INVALID_APPLICATION_INFO";
    } else if([errorCode isEqualToString:@"8012"]) {
        return @"INVALID_STATE_TOKEN";
    } else if([errorCode isEqualToString:@"8013"]) {
        return @"NOT_SUPPORT_LOGIN";
    } else if([errorCode isEqualToString:@"8014"]) {
        return @"INVALID_SCHEME";
    } else if([errorCode isEqualToString:@"8020"]) {
        return @"LOGIN_FAILED";
    }
      
    return @"UNKNOWN";
}

@end
