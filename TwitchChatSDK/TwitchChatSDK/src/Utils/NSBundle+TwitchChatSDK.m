//
//  NSBundle+TwitchChatSDK.m
//  TwitchChatSDK
//
//  Created by Mathieu LANOY on 21/01/2015.
//  Copyright (c) 2015 Mathieu LANOY. All rights reserved.
//

#import "NSBundle+TwitchChatSDK.h"

#define TWITCH_CHAT_BUNDLE  @"TwitchChatSDK"

@implementation NSBundle (TwitchChatSDK)

+ (NSBundle*) TwitchChatResourcesBundle {
    static dispatch_once_t onceToken;
    static NSBundle *twitchChatResourcesBundle = nil;
    dispatch_once(&onceToken, ^{
        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:TWITCH_CHAT_BUNDLE withExtension:@"bundle"];
        if (!bundleURL){
            twitchChatResourcesBundle = nil;
        }
        else
            twitchChatResourcesBundle = [NSBundle bundleWithURL:bundleURL];
    });
    return twitchChatResourcesBundle;
}

@end
