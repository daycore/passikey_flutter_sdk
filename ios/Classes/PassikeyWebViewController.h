//
//  PassikeyWebViewController.h
//  PASSIKEYauth
//
//  Created by heejun on 07/05/2020.
//  Copyright © 2020 ROWEM. All rights reserved.
//

#import <PASSIKEYauth/PASSIKEYauth.h>
#import <PASSIKEYauth/WebContainer.h>
NS_ASSUME_NONNULL_BEGIN

@protocol PassikeyWebViewControllerDelegate <NSObject>

- (void)onCallback:(NSMutableDictionary *)successAuthValue withErrInfo:(NSMutableDictionary *)errInfo;

@end

@interface PassikeyWebViewController : WebContainer
@property (nonatomic, assign) NSObject<PassikeyWebViewControllerDelegate> *delegate;

-(void) resultProcess:(NSDictionary *)resultValue;
-(void) onCallback:(NSMutableDictionary *)resultValue;
@end

NS_ASSUME_NONNULL_END
