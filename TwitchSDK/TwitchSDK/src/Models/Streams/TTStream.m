//
//  TTStream.m
//  TwitchSDK
//
//  Created by Mathieu LANOY on 15/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTStream.h"
#import "TTDateManager.h"
#import "NSDictionary+JSON.h"

@implementation TTStream

+ (instancetype) generateModelFromDictionary:(NSDictionary *)dict{
    TTStream *stream = nil;
    if (dict){
        stream = [[TTStream alloc] initWithJSONDict:dict];
    }
    return stream;
}

- (instancetype)initWithJSONDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.stream_id = [dict getIntFromNumberAtPath:@"_id" defaultValue:0];
        self.created_at = [[TTDateManager ISO8601Formatter] dateFromString:[dict getStringAtPath:@"created_at"]];
        self.link = [TTLink generateModelFromDictionary:[dict getDictionaryAtPath:@"_links"]];
        self.preview = [TTPicture generateModelFromDictionary:[dict getDictionaryAtPath:@"preview"]];
        self.viewers = [dict getIntFromNumberAtPath:@"viewers" defaultValue:0];
        self.channel = [TTChannel generateModelFromDictionary:[dict getDictionaryAtPath:@"channel"]];
        self.game = [dict getStringAtPath:@"game"];
    }
    return self;
}


@end
