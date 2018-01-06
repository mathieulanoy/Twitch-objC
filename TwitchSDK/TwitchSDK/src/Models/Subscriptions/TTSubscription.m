//
//  TTSubscription.m
//  TwitchSDK
//
//  Created by Mathieu LANOY on 15/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTSubscription.h"
#import "TTDateManager.h"
#import "NSDictionary+JSON.h"

@implementation TTSubscription

+ (instancetype) generateModelFromDictionary:(NSDictionary *)dict{
    TTSubscription *sub = nil;
    if (dict){
        sub = [[TTSubscription alloc] initWithJSONDict:dict];
    }
    return sub;
}

- (instancetype)initWithJSONDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.subscription_id = [dict getStringAtPath:@"_id"];
        self.created_at = [[TTDateManager ISO8601Formatter] dateFromString:[dict getStringAtPath:@"created_at"]];
        self.link = [TTLink generateModelFromDictionary:[dict getDictionaryAtPath:@"_links"]];
        self.user = [TTUser generateModelFromDictionary:[dict getDictionaryAtPath:@"user"]];
    }
    return self;
}

@end
