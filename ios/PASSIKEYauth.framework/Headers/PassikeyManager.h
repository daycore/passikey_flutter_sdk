//
//  PassikeyManager.h
//  PASSIKEYauth
//
//  Created by Kim Min joung on 26/03/2020.
//  Copyright © 2020 ROWEM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PassikeyErrorCode.h"

NS_ASSUME_NONNULL_BEGIN


//@protocol PassikeyManagerDelegate<NSObject>
//@optional
//@required
//- (void) didPassikeyAuthError:(passikeyRespCode) errorCode;
//- (void) didPassikeyAuthSuccess;
//@end




@interface PassikeyManager : NSObject




#pragma mark - Initialize

+ (PassikeyManager *)getInstance;

//URL Type 설정
- (void) setAppScheme:(NSString *)strScheme;
- (NSString *)getAppScheme;

- (BOOL) isOpen;
- (void) close;
- (void) closeAuthResult;

//패시키 앱 설치 체크
- (BOOL) isInstalledPassikey;
//제휴사 자신 스키마 체크
- (BOOL) isSelfCheckSchema;

//웹뷰 화면 생성
- (void) login:(UIViewController *)parent withStateToken:(NSString *)stateToken;

//패시키 앱에서 제휴사 앱으로 호출 시 처리
- (NSDictionary *) passikeyResultParsing:(NSURL *)url;

// 제휴사 로그인 시 필요한 값
- (NSString *)getPartnerToken;
- (NSString *)getReciveStateToken;

// 패시키 앱 스토어 이동
- (void) startStore;

- (void ) updateRequestToken:(NSString *)requestToken;
- (NSString *) getRequestToken;
- (NSString *) getStateToken;

- (NSString *) getClientId;
- (NSString *) getSecretKey;

- (void) setPartnerAuthInfo:(NSString *)ptnToken withReciveStatToken:(NSString *)reciveStateToken;

- (int) requestJoinCheck;

- (void) partnerLoginCheck:(NSMutableDictionary*)dic withCompletion:(void(^)(NSDictionary* result, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
