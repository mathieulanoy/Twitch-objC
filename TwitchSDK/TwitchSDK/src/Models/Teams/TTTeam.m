//
//  TTTeam.m
//  TwitchSDK
//
//  Created by Mathieu LANOY on 14/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTTeam.h"
#import "TTDateManager.h"
#import "NSDictionary+JSON.h"

@implementation TTTeam

+ (instancetype) generateModelFromDictionary:(NSDictionary *)dict{
    TTTeam *team = nil;
    if (dict){
        team = [[TTTeam alloc] initWithJSONDict:dict];
    }
    return team;
}

- (instancetype)initWithJSONDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.team_id = [dict getIntFromNumberAtPath:@"_id" defaultValue:0];
        
        self.created_at = [[TTDateManager ISO8601Formatter] dateFromString:[dict getStringAtPath:@"created_at"]];
        self.info = [dict getStringAtPath:@"info"];
        self.updated_at = [[TTDateManager ISO8601Formatter] dateFromString:[dict getStringAtPath:@"updated_at"]];
        self.background = [dict getStringAtPath:@"background"];
        self.banner = [dict getStringAtPath:@"banner"];
        self.logo = [dict getStringAtPath:@"logo"];
        self.link = [TTLink generateModelFromDictionary:[dict getDictionaryAtPath:@"_links"]];
        self.display_name = [dict getStringAtPath:@"display_name"];
        self.name = [dict getStringAtPath:@"name"];
    }
    return self;
}

@end
