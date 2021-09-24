#import <Cordova/CDV.h>
#import "AppDelegate.h"

@interface ACPCore_Cordova : CDVPlugin
- (void) extensionVersion:(CDVInvokedUrlCommand*)command;
- (void) registerDevice:(CDVInvokedUrlCommand*)command;
@end
