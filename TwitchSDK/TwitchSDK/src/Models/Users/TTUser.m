//
//  TTUser.m
//  TwitchSDK
//
//  Created by Mathieu LANOY on 14/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTUser.h"
#import "TTDateManager.h"
#import "NSDictionary+JSON.h"

@implementation TTUser

+ (instancetype) generateModelFromDictionary:(NSDictionary *)dict{
    TTUser *user = nil;
    if (dict){
        user = [[TTUser alloc] initWithJSONDict:dict];
    }
    return user;
}

- (instancetype)initWithJSONDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.type = [dict getStringAtPath:@"type"];
        self.name = [dict getStringAtPath:@"name"];
        self.created_at = [[TTDateManager ISO8601Formatter] dateFromString:[dict getStringAtPath:@"created_at"]];
        self.updated_at = [[TTDateManager ISO8601Formatter] dateFromString:[dict getStringAtPath:@"updated_at"]];
        self.links = [TTLink generateModelFromDictionary:[dict getDictionaryAtPath:@"_links"]];
        self.logo = [dict getStringAtPath:@"logo"];
        self.user_id = [dict getIntFromNumberAtPath:@"_id" defaultValue:0];
        self.display_name = [dict getStringAtPath:@"display_name"];
        self.email = [dict getStringAtPath:@"email"];
        self.bio = [dict getStringAtPath:@"bio"];
        self.partened = [dict getBoolAtPath:@"partened" defaultValue:NO];
        self.staff = [dict getBoolAtPath:@"staff" defaultValue:NO];
        self.notifications = [dict getDictionaryAtPath:@"notifications"];
    }
    return self;
}

@end
