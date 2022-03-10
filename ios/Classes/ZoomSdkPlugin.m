#import "ZoomSdkPlugin.h"
#if __has_include(<zoom_sdk_plugin/zoom_sdk_plugin-Swift.h>)
#import <zoom_sdk_plugin/zoom_sdk_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "zoom_sdk_plugin-Swift.h"
#endif

@implementation ZoomSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftZoomSdkPlugin registerWithRegistrar:registrar];
}
@end
