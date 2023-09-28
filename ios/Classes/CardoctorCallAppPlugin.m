#import "CardoctorCallAppPlugin.h"
#if __has_include(<cardoctor_call_app/cardoctor_call_app-Swift.h>)
#import <cardoctor_call_app/cardoctor_call_app-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "cardoctor_call_app-Swift.h"
#endif

@implementation CardoctorCallAppPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCardoctorCallAppPlugin registerWithRegistrar:registrar];
}
@end
