//
//  TTVideo.m
//  TwitchSDK
//
//  Created by Mathieu LANOY on 16/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTVideo.h"
#import "NSDictionary+JSON.h"
#import "TTDateManager.h"

@implementation TTVideo

+ (instancetype) generateModelFromDictionary:(NSDictionary *)dict{
    TTVideo *video = nil;
    if (dict){
        video = [[TTVideo alloc] initWithJSONDict:dict];
    }
    return video;
}

- (instancetype)initWithJSONDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.title = [dict getStringAtPath:@"title"];
        self.recorded_at = [[TTDateManager ISO8601Formatter] dateFromString:[dict getStringAtPath:@"recorded_at"]];
        self.links = [TTLink generateModelFromDictionary:[dict getDictionaryAtPath:@"_links"]];
        self.channel = [TTChannel generateModelFromDictionary:[dict getDictionaryAtPath:@"channel"]];
        self.video_id = [dict getStringAtPath:@"_id"];
        self.views = [dict getIntFromNumberAtPath:@"views" defaultValue:0];
        self.length = [dict getIntFromNumberAtPath:@"length" defaultValue:0];
        self.video_description = [dict getStringAtPath:@"description"];
        self.preview = [dict getStringAtPath:@"preview"];
        self.game = [dict getStringAtPath:@"game"];
        self.url = [dict getStringAtPath:@"url"];
        self.broadcast_id = [dict getIntFromNumberAtPath:@"broadcast_id" defaultValue:0];
        self.status = [dict getStringAtPath:@"status"];
        self.tag_list = [dict getStringAtPath:@"tag_list"];
    }
    return self;
}

@end
