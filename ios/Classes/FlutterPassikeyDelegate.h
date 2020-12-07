//
//  FlutterPassikeyDelegate.h
//  passikey_flutter_sdk
//
//  Created by 권혁 on 2020/12/07.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FlutterPassikeyDelegate <NSObject>
- (void)onCallback:(NSMutableDictionary *)successAuthValue withErrInfo:(NSMutableDictionary *)errInfo;
@end

NS_ASSUME_NONNULL_END
