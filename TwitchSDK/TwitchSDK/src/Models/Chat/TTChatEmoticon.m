//
//  TTChatEmoticon.m
//  TwitchSDK
//
//  Created by Mathieu LANOY on 21/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTChatEmoticon.h"
#import "NSDictionary+JSON.h"

@implementation TTChatEmoticon

+ (instancetype) generateModelFromDictionary:(NSDictionary *)dict{
    TTChatEmoticon *emoticon = nil;
    if (dict){
        emoticon = [[TTChatEmoticon alloc] initWithJSONDict:dict];
    }
    return emoticon;
}

- (instancetype)initWithJSONDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.width = [dict getIntFromNumberAtPath:@"width" defaultValue:0];
        self.height = [dict getIntFromNumberAtPath:@"height" defaultValue:0];
        self.regex = [dict getStringAtPath:@"regex"];
        self.state = [dict getStringAtPath:@"state"];
        self.url = [dict getStringAtPath:@"url"];
        self.subscriber_only = [dict getBoolAtPath:@"subscriber_only" defaultValue:YES];
    }
    return self;
}

@end
