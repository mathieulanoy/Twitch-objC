//
//  TTGame.m
//  TwitchSDK
//
//  Created by Mathieu LANOY on 13/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTGame.h"
#import "NSDictionary+JSON.h"

@implementation TTGame

+ (instancetype) generateModelFromDictionary:(NSDictionary *)dict{
    TTGame *game = nil;
    if (dict){
        game = [[TTGame alloc] initWithJSONDict:dict];
    }
    return game;
}

- (instancetype)initWithJSONDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.name = [dict getStringAtPath:@"name"];
        self.game_id = [dict getIntFromNumberAtPath:@"_id" defaultValue:0];
        self.giantbomb_id = [dict getIntFromNumberAtPath:@"giantbomb_id" defaultValue:0];
        self.popularity = [dict getIntFromNumberAtPath:@"popularity" defaultValue:0];
        self.box = [TTPicture generateModelFromDictionary:[dict getDictionaryAtPath:@"box"]];
        self.logo = [TTPicture generateModelFromDictionary:[dict getDictionaryAtPath:@"logo"]];
        self.images = [TTPicture generateModelFromDictionary:[dict getDictionaryAtPath:@"images"]];
        self.link = [TTLink generateModelFromDictionary:[dict getDictionaryAtPath:@"_links"]];
    }
    return self;
}

@end
