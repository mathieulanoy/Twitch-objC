//
//  TTToken.m
//  TwitchSDK
//
//  Created by Mathieu LANOY on 15/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTToken.h"
#import "NSDictionary+JSON.h"
#import "TTDateManager.h"

@implementation TTToken

+ (instancetype) generateModelFromDictionary:(NSDictionary *)dict{
    TTToken *token = nil;
    if (dict){
        token = [[TTToken alloc] initWithJSONDict:dict];
    }
    return token;
}

- (instancetype)initWithJSONDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.user_name = [dict getStringAtPath:@"user_name"];
        self.created_at = [[TTDateManager fullISO8601Formatter] dateFromString:[dict getStringAtPath:@"authorization/created_at"]];
        self.updated_at = [[TTDateManager fullISO8601Formatter] dateFromString:[dict getStringAtPath:@"authorization/updated_at"]];
        self.scopes = [dict getArrayAtPath:@"authorization/scopes"];
        self.valid = [dict getBoolAtPath:@"valid" defaultValue:NO];
    }
    return self;
}

@end
