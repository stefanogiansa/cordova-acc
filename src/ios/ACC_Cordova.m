/*
 Copyright 2020 Adobe. All rights reserved.
 This file is licensed to you under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License. You may obtain a copy
 of the License at http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software distributed under
 the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
 OF ANY KIND, either express or implied. See the License for the specific language
 governing permissions and limitations under the License.
 */

#import "ACPCore.h"
#import "ACPCampaignClassic.h"
#import "ACPLifecycle.h"
#import "ACPUserProfile.h"
#import "ACPIdentity.h"
#import "ACPSignal.h"
#import <Cordova/CDV.h>
#import <Foundation/Foundation.h>

@interface ACPCore_Cordova : CDVPlugin
- (void) extensionVersion:(CDVInvokedUrlCommand*)command;
- (void) registerDevice:(CDVInvokedUrlCommand*)command;
@end

@implementation ACPCore_Cordova

- (void)pluginInitialize
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
}

- (void)finishLaunching:(NSNotification *)notification {
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
}

- (void) extensionVersion:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        NSString *version = [ACPCampaignClassic extensionVersion];

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:version];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void) registerDevice:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        NSData *deviceToken=[[[self getCommandArg:command.arguments[0]] stringValue] dataUsingEncoding:NSUTF8StringEncoding];
        NSString *userKey = [[self getCommandArg:command.arguments[1]] stringValue];

        [ACPCampaignClassic registerDevice:deviceToken userKey:userKey additionalParams:NULL callback:^(BOOL success) {
            NSLog(@"Registration Status: %d", success);
            CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
        }];
    }];
}

- (id) getCommandArg:(id) argument {
    return argument == (id)[NSNull null] ? nil : argument;
}
@end
