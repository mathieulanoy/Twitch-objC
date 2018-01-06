//
//  TTLink.m
//  TwitchSDK
//
//  Created by Mathieu LANOY on 13/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTLink.h"
#import "NSDictionary+JSON.h"

@implementation TTLink

+ (instancetype) generateModelFromDictionary:(NSDictionary *)dict{
    TTLink *link = nil;
    if (dict){
        link = [[TTLink alloc] initWithJSONDict:dict];
    }
    return link;
}

- (instancetype)initWithJSONDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.current_link = [dict getStringAtPath:@"self"];
        self.next_link = [dict getStringAtPath:@"next"];
        self.previous_link = [dict getStringAtPath:@"prev"];
        self.owner = [dict getStringAtPath:@"owner"];
        self.chat = [dict getStringAtPath:@"chat"];
        self.videos = [dict getStringAtPath:@"videos"];
        self.video_status = [dict getStringAtPath:@"video_status"];
        self.commercial = [dict getStringAtPath:@"commercial"];
        self.editors = [dict getStringAtPath:@"editors"];
        self.features = [dict getStringAtPath:@"features"];
        self.follows = [dict getStringAtPath:@"follows"];
        self.stream_key = [dict getStringAtPath:@"stream_key"];
        self.subscriptions = [dict getStringAtPath:@"subscriptions"];
        self.teams = [dict getStringAtPath:@"teams"];
        self.channel = [dict getStringAtPath:@"channel"];
        self.channels = [dict getStringAtPath:@"channels"];
        self.ingests = [dict getStringAtPath:@"ingests"];
        self.search = [dict getStringAtPath:@"search"];
        self.streams = [dict getStringAtPath:@"streams"];
        self.user = [dict getStringAtPath:@"user"];
        self.users = [dict getStringAtPath:@"users"];
    }
    return self;
}

@end
