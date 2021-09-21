#import "AppDelegate+ACC_Cordova.h"
#import "CDVPlugin+ACC_Cordova.h"

#import <Availability.h>
#import <objc/runtime.h>

NSString* const UIApplicationRegisterUserNotificationSettings = @"UIApplicationRegisterUserNotificationSettings";

@implementation AppDelegate (ACC_Cordova)

#pragma mark -
#pragma mark Life Cycle

/**
 * Its dangerous to override a method from within a category.
 * Instead we will use method swizzling.
 */
+ (void) load
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    [self exchange_methods:@selector(application:didRegisterUserNotificationSettings:)
                  swizzled:@selector(swizzled_application:didRegisterUserNotificationSettings:)];
#endif

#if CORDOVA_VERSION_MIN_REQUIRED >= 40000
    [self exchange_methods:@selector(application:didReceiveLocalNotification:)
                  swizzled:@selector(swizzled_application:didReceiveLocalNotification:)];
#endif
}

#pragma mark -
#pragma mark Delegate

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
/**
 * Tells the delegate what types of notifications may be used
 * to get the user’s attention.
 */
- (void)           swizzled_application:(UIApplication*)application
    didRegisterUserNotificationSettings:(UIUserNotificationSettings*)settings
{
    // re-post (broadcast)
    [self postNotificationName:UIApplicationRegisterUserNotificationSettings object:settings];
    // This actually calls the original method over in AppDelegate
    [self swizzled_application:application didRegisterUserNotificationSettings:settings];
}
#endif

#if CORDOVA_VERSION_MIN_REQUIRED >= 40000
/**
 * Repost all local notification using the default NSNotificationCenter so
 * multiple plugins may respond.
 */
- (void)   swizzled_application:(UIApplication*)application
    didReceiveLocalNotification:(UILocalNotification*)notification
{
    // re-post (broadcast)
    [self postNotificationName:CDVLocalNotification object:notification];
    // This actually calls the original method over in AppDelegate
    [self swizzled_application:application didReceiveLocalNotification:notification];
}
#endif

#pragma mark -
#pragma mark Core

/**
 * Exchange the method implementations.
 */
+ (void) exchange_methods:(SEL)original swizzled:(SEL)swizzled
{
    class_addMethod(self, original, (IMP) defaultMethodIMP, "v@:");

    Method original_method = class_getInstanceMethod(self, original);
    Method swizzled_method = class_getInstanceMethod(self, swizzled);

    method_exchangeImplementations(original_method, swizzled_method);
}

#pragma mark -
#pragma mark Helper

void defaultMethodIMP (id self, SEL _cmd) { /* nothing to do here */ }

/**
 * Broadcasts the notification to all listeners.
 */
- (void) postNotificationName:(NSString*)aName object:(id)anObject
{
    [[NSNotificationCenter defaultCenter] postNotificationName:aName
                                                        object:anObject];
}

@end