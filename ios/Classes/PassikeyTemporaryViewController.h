//
//  PassikeyTemporaryViewController.h
//  Pods
//
//  Created by 권혁 on 2020/12/07.
//
#import <UIKit/UIKit.h>
#import <PASSIKEYauth/PassikeyWebViewController.h>
#import "FlutterPassikeyDelegate.h"

#ifndef PassikeyTemporaryViewController_h
#define PassikeyTemporaryViewController_h

@interface PassikeyTemporaryViewController : UIViewController<PassikeyWebViewControllerDelegate>
    @property (nonatomic, assign) id <FlutterPassikeyDelegate> passikeyDelegate;
@end

#endif /* PassikeyTemporaryViewController_h */
