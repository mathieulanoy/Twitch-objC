//
//  TTTopGame.m
//  TwitchSDK
//
//  Created by Mathieu LANOY on 14/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTTopGame.h"
#import "NSDictionary+JSON.h"

@implementation TTTopGame

+ (instancetype) generateModelFromDictionary:(NSDictionary *)dict{
    TTTopGame *game = nil;
    if (dict){
        game = [[TTTopGame alloc] initWithJSONDict:dict];
    }
    return game;
}

- (instancetype)initWithJSONDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.viewers = [dict getIntFromNumberAtPath:@"viewers" defaultValue:0];
        self.channels = [dict getIntFromNumberAtPath:@"channels" defaultValue:0];
        self.game = [TTGame generateModelFromDictionary:[dict getDictionaryAtPath:@"game"]];
    }
    return self;
}

@end
