#import "AppDelegate+ACC_Cordova.h"
#import "ACPCore.h"
#import "ACPCampaignClassic.h"
#import "ACPLifecycle.h"
#import "ACPUserProfile.h"
#import "ACPIdentity.h"
#import "ACPSignal.h"

@implementation AppDelegate (ACC_Cordova)

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [ACPCore setLogLevel:ACPMobileLogLevelDebug];
    [ACPCore configureWithAppId:@"36817ad82b35/ff9a58fd45ca/launch-b54585ec721d"];
    [ACPCampaignClassic registerExtension];
    [ACPUserProfile registerExtension];
    [ACPIdentity registerExtension];
    [ACPLifecycle registerExtension];
    [ACPSignal registerExtension];
    [ACPCore start:^{
        [ACPCore lifecycleStart:nil];
        
    }];
    
    return YES;
}

@end