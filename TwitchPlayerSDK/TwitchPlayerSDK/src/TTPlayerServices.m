//
//  TTPlayerServices.m
//  TwitchPlayerSDK
//
//  Created by Mathieu LANOY on 22/01/2015.
//  Copyright (c) 2015 Mathieu LANOY. All rights reserved.
//

#import "TTPlayerServices.h"
#import "NSBundle+TwitchPlayerSDK.h"

@implementation TTPlayerServices

// ****************************************************************************
#pragma mark - Player Singleton

+ (instancetype) sharedPlayer {
    static TTPlayerServices *_sharedPlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPlayer = [[TTPlayerServices alloc] init];
    });
    
    return _sharedPlayer;
}

// ****************************************************************************
#pragma mark - UI

+ (TTStreamPlayerView *) getViewforPlayer {
    NSBundle *bundle = [NSBundle TwitchPlayerResourcesBundle];
    if (!bundle)
        return nil;
    
    NSArray *topLevelsObjects = [bundle loadNibNamed:@"TTStreamPlayerView" owner:nil options:nil];
    for (id currentObject in topLevelsObjects)  {
        if ([currentObject isKindOfClass:[TTStreamPlayerView class]]) {
            return currentObject;
        }
    }
    return nil;
}

@end
