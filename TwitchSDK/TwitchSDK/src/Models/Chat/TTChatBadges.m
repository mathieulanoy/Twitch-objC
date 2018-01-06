//
//  TTChatBadges.m
//  TwitchSDK
//
//  Created by Mathieu LANOY on 21/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTChatBadges.h"
#import "NSDictionary+JSON.h"

@implementation TTChatBadges

+ (instancetype) generateModelFromDictionary:(NSDictionary *)dict{
    TTChatBadges *badges = nil;
    if (dict){
        badges = [[TTChatBadges alloc] initWithJSONDict:dict];
    }
    return badges;
}

- (instancetype)initWithJSONDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.global_mod = [TTPicture generateModelFromDictionary:[dict getDictionaryAtPath:@"global_mod"]];
        self.admin = [TTPicture generateModelFromDictionary:[dict getDictionaryAtPath:@"admin"]];
        self.broadcaster = [TTPicture generateModelFromDictionary:[dict getDictionaryAtPath:@"broadcaster"]];
        self.mod = [TTPicture generateModelFromDictionary:[dict getDictionaryAtPath:@"mod"]];
        self.staff = [TTPicture generateModelFromDictionary:[dict getDictionaryAtPath:@"staff"]];
        self.turbo = [TTPicture generateModelFromDictionary:[dict getDictionaryAtPath:@"turbo"]];
        self.subscriber = [TTPicture generateModelFromDictionary:[dict getDictionaryAtPath:@"subscriber"]];

    }
    return self;
}

@end
