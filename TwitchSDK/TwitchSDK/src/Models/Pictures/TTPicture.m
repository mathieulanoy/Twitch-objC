//
//  TTPicture.m
//  TwitchSDK
//
//  Created by Mathieu LANOY on 13/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTPicture.h"
#import "NSDictionary+JSON.h"

@implementation TTPicture

+ (instancetype) generateModelFromDictionary:(NSDictionary *)dict{
    TTPicture *picture = nil;
    if (dict){
        picture = [[TTPicture alloc] initWithJSONDict:dict];
    }
    return picture;
}

- (instancetype)initWithJSONDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.large = [dict getStringAtPath:@"large"];
        self.medium = [dict getStringAtPath:@"medium"];
        self.small = [dict getStringAtPath:@"small"];
        self.picture_template = [dict getStringAtPath:@"template"];
        self.thumb = [dict getStringAtPath:@"thumb"];
        self.tiny = [dict getStringAtPath:@"tiny"];
        self.picture_super = [dict getStringAtPath:@"super"];
        self.icon = [dict getStringAtPath:@"icon"];
        self.screen = [dict getStringAtPath:@"screen"];
        self.alpha = [dict getStringAtPath:@"alpha"];
        self.image = [dict getStringAtPath:@"image"];
        self.svg = [dict getStringAtPath:@"svg"];
    }
    return self;
}

@end
