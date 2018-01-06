//
//  TTBlockUser.m
//  TwitchSDK
//
//  Created by Mathieu LANOY on 16/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTBlockUser.h"
#import "NSDictionary+JSON.h"
#import "TTDateManager.h"


@implementation TTBlockUser

+ (instancetype) generateModelFromDictionary:(NSDictionary *)dict{
    TTBlockUser *user = nil;
    if (dict){
        user = [[TTBlockUser alloc] initWithJSONDict:dict];
    }
    return user;
}

- (instancetype)initWithJSONDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.updated_at = [[TTDateManager ISO8601Formatter] dateFromString:[dict getStringAtPath:@"updated_at"]];
        self.links = [TTLink generateModelFromDictionary:[dict getDictionaryAtPath:@"_links"]];
        self.block_id = [dict getIntFromNumberAtPath:@"_id" defaultValue:0];
        self.user = [TTUser generateModelFromDictionary:[dict getDictionaryAtPath:@"user"]];
    }
    return self;
};

@end
