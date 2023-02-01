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

#import "ACC_Cordova.h"
#import <Cordova/CDV.h>
#import <Foundation/Foundation.h>

#import "ACPCore.h"
#import "ACPCampaignClassic.h"
#import "ACPLifecycle.h"
#import "ACPUserProfile.h"
#import "ACPIdentity.h"
#import "ACPSignal.h"

@interface ACC_Cordova ()
@end

@implementation ACC_Cordova

- (void) pluginInitialize {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidFinishLaunching:)
                                                 name:UIApplicationDidFinishLaunchingNotification object:nil];
}

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    NSString *appId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"accAppId"];

    [ACPCore setLogLevel:ACPMobileLogLevelDebug];
    [ACPCore configureWithAppId:appId];
    [ACPCampaignClassic registerExtension];
    [ACPUserProfile registerExtension];
    [ACPIdentity registerExtension];
    [ACPLifecycle registerExtension];
    [ACPSignal registerExtension];
    [ACPCore start:^{
        [ACPCore lifecycleStart:nil];
    }];
}

#pragma mark - Cordova commands
- (void) extensionVersion:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        NSString *version = [ACPCampaignClassic extensionVersion];

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:version];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (NSData *)dataFromHexString:(NSString *)string
{
    NSMutableData *stringData = [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [string length] / 2; i++) {
        byte_chars[0] = [string characterAtIndex:i*2];
        byte_chars[1] = [string characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [stringData appendBytes:&whole_byte length:1];
    }
    return stringData;
}

- (void) registerDevice:(CDVInvokedUrlCommand*)command {
    [self.commandDelegate runInBackground:^{
        NSData *deviceToken = [self dataFromHexString:[[self getCommandArg:command.arguments[0]] stringValue]];
        NSString *userKey = NULL;

        NSUInteger argumentSize = [command.arguments count];
        if (argumentSize > 1) {
            userKey = [[self getCommandArg:command.arguments[1]] stringValue];
        }

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
