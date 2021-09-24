#import <Cordova/CDV.h>
#import "AppDelegate.h"

@interface ACC_Cordova : CDVPlugin
- (void) extensionVersion:(CDVInvokedUrlCommand*)command;
- (void) registerDevice:(CDVInvokedUrlCommand*)command;
@end
