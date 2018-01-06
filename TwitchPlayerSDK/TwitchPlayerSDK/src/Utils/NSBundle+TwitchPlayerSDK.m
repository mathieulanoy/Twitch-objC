//
//  NSBundle+TwitchPlayerSDK.m
//  TwitchPlayerSDK
//
//  Created by Mathieu LANOY on 22/01/2015.
//  Copyright (c) 2015 Mathieu LANOY. All rights reserved.
//

#import "NSBundle+TwitchPlayerSDK.h"

#define TWITCH_PLAYER_BUNDLE  @"TwitchPlayerSDK"

@implementation NSBundle (TwitchPlayerSDK)

+ (NSBundle*) TwitchPlayerResourcesBundle {
    static dispatch_once_t onceToken;
    static NSBundle *twitchPlayerResourcesBundle = nil;
    dispatch_once(&onceToken, ^{
        NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:TWITCH_PLAYER_BUNDLE withExtension:@"bundle"];
        if (!bundleURL){
            twitchPlayerResourcesBundle = nil;
        }
        else
            twitchPlayerResourcesBundle = [NSBundle bundleWithURL:bundleURL];
    });
    return twitchPlayerResourcesBundle;
}

@end
