//
//  TTChannelToken.m
//  TwitchSDK
//
//  Created by Mathieu LANOY on 16/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTChannelToken.h"
#import "NSDictionary+JSON.h"

@implementation TTChannelToken

+ (instancetype) generateModelFromDictionary:(NSDictionary *)dict{
    TTChannelToken *token = nil;
    if (dict){
        token = [[TTChannelToken alloc] initWithJSONDict:dict];
    }
    return token;
}

- (instancetype)initWithJSONDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.mobile_restricted = [dict getBoolAtPath:@"mobile_restricted" defaultValue:NO];
        self.sig = [dict getEmptyStringAtPath:@"sig"];
        
        self.token = [dict getStringAtPath:@"token"];
        NSData* data = [self.token dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *token = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (token){
            self.user_id = [token getEmptyStringAtPath:@"user_id"];
            self.channel = [token getEmptyStringAtPath:@"channel"];
            self.expires = [token getIntFromNumberAtPath:@"expires" defaultValue:0];
            self.privileged = [token getBoolAtPath:@"privileged" defaultValue:NO];
            self.source_restricted = [token getBoolAtPath:@"source_restricted" defaultValue:NO];
            self.view_until = [token getIntFromNumberAtPath:@"chansub/view_until" defaultValue:0];
            self.restricted_bitrates = [token getArrayAtPath:@"chansub/restricted_bitrates"];
            self.allowed_to_view = [token getBoolAtPath:@"private/allowed_to_view" defaultValue:NO];
        }
    }
    return self;
};

@end
