//
//  PassikeyTemporaryViewController.m
//  passikey_flutter_sdk
//
//  Created by 권혁 on 2020/12/07.
//

#import "PassikeyTemporaryViewController.h"

@implementation PassikeyTemporaryViewController

- (void)onCallback:(NSMutableDictionary *)successAuthValue withErrInfo:(NSMutableDictionary *)errInfo {
    [[self passikeyDelegate] onCallback:successAuthValue withErrInfo:errInfo];
}

@end
