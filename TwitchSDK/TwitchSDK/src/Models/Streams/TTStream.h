//
//  TTStream.h
//  TwitchSDK
//
//  Created by Mathieu LANOY on 15/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTModel.h"
#import "TTLink.h"
#import "TTChannel.h"
#import "TTPicture.h"

@interface TTStream : TTModel

@property (strong, nonatomic) TTLink    *link;
@property (strong, nonatomic) TTPicture *preview;
@property (assign, nonatomic) NSUInteger stream_id;
@property (assign, nonatomic) NSUInteger viewers;
@property (strong, nonatomic) NSDate    *created_at;
@property (strong, nonatomic) TTChannel *channel;
@property (strong, nonatomic) NSString  *game;

@end
