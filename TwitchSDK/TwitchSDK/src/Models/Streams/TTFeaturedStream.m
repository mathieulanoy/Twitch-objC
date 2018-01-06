//
//  TTFeaturedStream.m
//  TwitchSDK
//
//  Created by Mathieu LANOY on 15/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTFeaturedStream.h"
#import "NSDictionary+JSON.h"

@implementation TTFeaturedStream

+ (instancetype) generateModelFromDictionary:(NSDictionary *)dict{
    TTFeaturedStream *stream = nil;
    if (dict){
        stream = [[TTFeaturedStream alloc] initWithJSONDict:dict];
    }
    return stream;
}

- (instancetype)initWithJSONDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.image = [dict getStringAtPath:@"image"];
        self.text = [dict getStringAtPath:@"text"];
        self.stream = [TTStream generateModelFromDictionary:[dict getDictionaryAtPath:@"stream"]];
    }
    return self;
}

@end
