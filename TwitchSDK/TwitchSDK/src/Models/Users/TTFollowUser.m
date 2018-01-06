//
//  TTFollowUser.m
//  TwitchSDK
//
//  Created by Mathieu LANOY on 14/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTFollowUser.h"
#import "NSDictionary+JSON.h"
#import "TTDateManager.h"

@implementation TTFollowUser

+ (instancetype) generateModelFromDictionary:(NSDictionary *)dict{
    TTFollowUser *user = nil;
    if (dict){
        user = [[TTFollowUser alloc] initWithJSONDict:dict];
    }
    return user;
}

- (instancetype)initWithJSONDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.created_at = [[TTDateManager ISO8601Formatter] dateFromString:[dict getStringAtPath:@"created_at"]];
        self.links = [TTLink generateModelFromDictionary:[dict getDictionaryAtPath:@"_links"]];
        self.notifications = [dict getBoolAtPath:@"notifications" defaultValue:NO];
        self.user = [TTUser generateModelFromDictionary:[dict getDictionaryAtPath:@"user"]];
    }
    return self;
};

@end
