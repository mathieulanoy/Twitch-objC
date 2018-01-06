//
//  TTFollowChannel.m
//  TwitchSDK
//
//  Created by Mathieu LANOY on 14/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTFollowChannel.h"
#import "NSDictionary+JSON.h"
#import "TTDateManager.h"

@implementation TTFollowChannel

+ (instancetype) generateModelFromDictionary:(NSDictionary *)dict{
    TTFollowChannel *channel = nil;
    if (dict){
        channel = [[TTFollowChannel alloc] initWithJSONDict:dict];
    }
    return channel;
}

- (instancetype)initWithJSONDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.created_at = [[TTDateManager ISO8601Formatter] dateFromString:[dict getStringAtPath:@"created_at"]];
        self.links = [TTLink generateModelFromDictionary:[dict getDictionaryAtPath:@"_links"]];
        self.notifications = [dict getBoolAtPath:@"notifications" defaultValue:NO];
        self.channel = [TTChannel generateModelFromDictionary:[dict getDictionaryAtPath:@"channel"]];
    }
    return self;
};

@end
