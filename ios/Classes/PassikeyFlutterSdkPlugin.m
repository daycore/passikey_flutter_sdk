#import "PassikeyFlutterSdkPlugin.h"
#if __has_include(<passikey_flutter_sdk/passikey_flutter_sdk-Swift.h>)
#import <passikey_flutter_sdk/passikey_flutter_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "passikey_flutter_sdk-Swift.h"
#endif

@implementation PassikeyFlutterSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPassikeyFlutterSdkPlugin registerWithRegistrar:registrar];
}
@end
