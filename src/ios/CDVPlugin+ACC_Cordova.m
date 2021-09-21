#import "ACC_CordovaAppDelegate.h"
#import "CDVPlugin+ACC_Cordova.h"
#import "AppDelegate+ACC_Cordova.h"

#import <objc/runtime.h>

#ifdef __CORDOVA_5_0_0
NSString* const CDVLocalNotification = @"CDVLocalNotification";
#endif

@implementation CDVPlugin (ACC_Cordova)

static IMP orig_pluginInitialize;

#pragma mark -
#pragma mark Life Cycle

/**
 * Its dangerous to override a method from within a category.
 * Instead we will use method swizzling.
 */
+ (void) initialize
{
    // To keep compatibility with local-notifiations v0.8.4
    if ([NSStringFromClass(self) isEqualToString:@"APPLocalNotification"]
        || [self conformsToProtocol:@protocol(ACC_CordovaAppDelegate)])
    {
        orig_pluginInitialize = [self exchange_init_methods];
    }
}

#pragma mark -
#pragma mark Delegate

/**
 * Registers obervers after plugin was initialized.
 */
void swizzled_pluginInitialize(id self, SEL _cmd)
{
    if (orig_pluginInitialize != NULL) {
        ((void(*)(id, SEL))orig_pluginInitialize)(self, _cmd);
        orig_pluginInitialize = NULL;
    }

    [self addObserver:NSSelectorFromString(@"didReceiveLocalNotification:")
                 name:CDVLocalNotification
               object:NULL];

    [self addObserver:NSSelectorFromString(@"didFinishLaunchingWithOptions:")
                 name:UIApplicationDidFinishLaunchingNotification
               object:NULL];

    [self addObserver:NSSelectorFromString(@"didRegisterUserNotificationSettings:")
                 name:UIApplicationRegisterUserNotificationSettings
               object:NULL];
}

#pragma mark -
#pragma mark Core

/**
 * Exchange the method implementations for pluginInitialize
 * and return the original implementation.
 */
+ (IMP) exchange_init_methods
{
    IMP swizzleImp = (IMP) swizzled_pluginInitialize;
    Method origImp = class_getInstanceMethod(self, @selector(pluginInitialize));

    if (method_getImplementation(origImp) != swizzleImp) {
        return method_setImplementation(origImp, swizzleImp);
    }

    return NULL;
}

/**
 * Register an observer if the caller responds to it.
 */
- (void) addObserver:(SEL)selector
                name:(NSString*)event
              object:(id)object
{
    if (![self respondsToSelector:selector])
        return;

    NSNotificationCenter* center = [NSNotificationCenter
                                    defaultCenter];

    [center addObserver:self
               selector:selector
                   name:event
                 object:object];
}

@end