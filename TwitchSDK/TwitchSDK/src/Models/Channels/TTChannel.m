//
//  TTChannel.m
//  TwitchSDK
//
//  Created by Mathieu LANOY on 14/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTChannel.h"
#import "NSDictionary+JSON.h"
#import "TTDateManager.h"

@implementation TTChannel

+ (instancetype) generateModelFromDictionary:(NSDictionary *)dict{
    TTChannel *channel = nil;
    if (dict){
        channel = [[TTChannel alloc] initWithJSONDict:dict];
    }
    return channel;
}

- (instancetype)initWithJSONDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.name = [dict getStringAtPath:@"name"];
        self.game = [dict getStringAtPath:@"game"];
        self.created_at = [[TTDateManager ISO8601Formatter] dateFromString:[dict getStringAtPath:@"created_at"]];
        self.delay = [dict getIntFromNumberAtPath:@"delay" defaultValue:0];
        
        NSArray *ar_teams = [dict getArrayAtPath:@"teams"];
        NSMutableArray *ar_mut_teams = [NSMutableArray new];
        for (NSDictionary *dic_team in ar_teams){
            TTTeam *team_model = [TTTeam generateModelFromDictionary:dic_team];
            [ar_mut_teams addObject:team_model];
        }
        self.teams = ar_mut_teams;
        
        self.status = [dict getStringAtPath:@"status"];
        self.updated_at = [[TTDateManager ISO8601Formatter] dateFromString:[dict getStringAtPath:@"updated_at"]];
        self.banner = [dict getStringAtPath:@"banner"];
        self.video_banner = [dict getStringAtPath:@"video_banner"];
        self.background = [dict getStringAtPath:@"background"];
        self.link = [TTLink generateModelFromDictionary:[dict getDictionaryAtPath:@"_links"]];
        self.logo = [dict getStringAtPath:@"logo"];
        self.channel_id = [dict getIntFromNumberAtPath:@"_id" defaultValue:0];
        self.mature = [dict getBoolAtPath:@"mature" defaultValue:NO];
        self.url = [dict getStringAtPath:@"url"];
        self.display_name = [dict getStringAtPath:@"display_name"];
        self.followers = [dict getIntFromNumberAtPath:@"followers" defaultValue:0];
        self.views = [dict getIntFromNumberAtPath:@"views" defaultValue:0];
        self.partner = [dict getIntFromNumberAtPath:@"partner" defaultValue:0];
        self.language = [dict getStringAtPath:@"language"];
        self.broadcaster_language = [dict getStringAtPath:@"broadcaster_language"];
        self.email = [dict getStringAtPath:@"email"];
        self.profile_banner = [dict getStringAtPath:@"profile_banner"];
        self.profile_banner_background_color = [dict getStringAtPath:@"profile_banner_background_color"];
        self.stream_key = [dict getStringAtPath:@"stream_key"];
        self.primary_team_name = [dict getStringAtPath:@"primary_team_name"];
        self.primary_team_display_name = [dict getStringAtPath:@"primary_team_display_name"];
        self.abuse_reported = [dict getBoolAtPath:@"abuse_reported" defaultValue:NO];
    }
    return self;
}

@end
