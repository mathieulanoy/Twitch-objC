//
//  TTRoom.m
//  TwitchChatSDK
//
//  Created by Mathieu LANOY on 20/01/2015.
//  Copyright (c) 2015 Mathieu LANOY. All rights reserved.
//

#import "TTRoom.h"
#import "MVIRCChatRoom.h"
#import "MVIRCChatConnection.h"
#import "NSNotificationAdditions.h"
#import "MVIRCChatUser.h"
#import "TTChatServices.h"

@interface TTRoom()

@property (strong, nonatomic) MVIRCChatRoom *irc_room;

@property (strong, nonatomic) NSString      *name;

@property (strong, nonatomic) NSDictionary  *subscriber_event;

@property (strong, nonatomic) NSDictionary  *color_event;

- (void) addObservers;

- (void) removeObservers;

- (NSString *) generateDefaultColorForUser:(NSString *) name;

@end

@implementation TTRoom

- (instancetype) initWithName:(NSString *) roomName andConnection:(id) roomConnection {
    if((self = [super init])) {
        if ([roomConnection isKindOfClass:[MVIRCChatConnection class]]){
            [self addObservers];
            _name = roomName;
            _irc_room = [[MVIRCChatRoom alloc] initWithName:roomName andConnection:roomConnection];
            _subscriber_event = nil;
            _color_event = nil;
        }
    }
    return self;
}

- (void) addObservers {
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(chatRoomJoined:) name:MVChatRoomJoinedNotification object:nil];
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(chatRoomParted:) name:MVChatRoomPartedNotification object:nil];
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(chatRoomKicked:) name:MVChatRoomKickedNotification object:nil];
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(chatRoomInvited:) name:MVChatRoomInvitedNotification object:nil];
    
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(chatRoomUserJoined:) name:MVChatRoomUserJoinedNotification object:nil];
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(chatRoomUserParted:) name:MVChatRoomUserPartedNotification object:nil];
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(chatRoomUserKicked:) name:MVChatRoomUserKickedNotification object:nil];
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(chatRoomUserBanned:) name:MVChatRoomUserBannedNotification object:nil];
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(chatRoomUserBanRemoved:) name:MVChatRoomUserBanRemovedNotification object:nil];
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(chatRoomUserModeChanged:) name:MVChatRoomUserModeChangedNotification object:nil];
    
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(chatRoomGotMessage:) name:MVChatRoomGotMessageNotification object:nil];
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(chatRoomTopicChanged:) name:MVChatRoomTopicChangedNotification object:nil];
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(chatRoomModesChanged:) name:MVChatRoomModesChangedNotification object:nil];
    
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(chatServiceGotSubscriber:) name:TTChatServicesGotSubscriberNotification object:nil];
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(chatServiceGotUserColor:) name:TTChatServicesGotUserColorNotification object:nil];
}

- (void) removeObservers {
    [[NSNotificationCenter chatCenter] removeObserver:self];
}

- (TTChatUser *) getUserByName:(NSString *) name {
    if (self.irc_room){
        MVChatUser *user = [[self.irc_room memberUsersWithNickname:name] anyObject];
        TTChatUser *chatUser = [[TTChatUser alloc] initWithDatas:user];
        return chatUser;
    }
    return nil;
}

- (NSString *) getName {
    if (self.irc_room)
        return self.irc_room.name;
    return @"";
}

- (NSDate *) getDateJoined{
    if (self.irc_room)
        return self.irc_room.dateJoined;
    return nil;
}

- (NSDate *) getDateParted{
    if (self.irc_room)
        return self.irc_room.dateParted;
    return nil;
}

- (NSData *) getTopic{
    if (self.irc_room)
        return self.irc_room.topic;
    return nil;
}

- (NSArray *) getModerators {
    NSMutableArray *ar_users = [NSMutableArray new];
    if (self.irc_room){
        for (MVChatUser *user in [self.irc_room memberUsersWithModes:MVChatRoomMemberOperatorMode]){
            TTChatUser *chatUser = [[TTChatUser alloc] initWithDatas:user];
            [ar_users addObject:chatUser];
        }
    }
    return ar_users;
}

- (NSArray *) getUsers{
    NSMutableArray *ar_users = [NSMutableArray new];
    if (self.irc_room){
        for (MVChatUser *user in [self.irc_room memberUsers]){
            if (user.isServerOperator)
                NSLog(@"%@", user.displayName);
            TTChatUser *chatUser = [[TTChatUser alloc] initWithDatas:user];
            [ar_users addObject:chatUser];
        }
    }
    return ar_users;
}
- (NSArray *) getBannedUsers{
    NSMutableArray *ar_users = [NSMutableArray new];
    if (self.irc_room){
        for (MVChatUser *user in [self.irc_room bannedUsers]){
            TTChatUser *chatUser = [[TTChatUser alloc] initWithDatas:user];
            [ar_users addObject:chatUser];
        }
    }
    return ar_users;
}

- (void) partWithReason:(NSString *) reason{
    if (self.irc_room){
        if (!reason || [reason length] == 0){
            [self.irc_room part];
        }
        else {
            [self.irc_room partWithReason:[[NSAttributedString alloc] initWithString:reason]];
        }
    }
}

- (void) changeTopic:(NSString *) topic {
    if (self.irc_room && topic){
        [self.irc_room changeTopic:[[NSAttributedString alloc] initWithString:topic]];
    }
}

- (void) sendMessage:(NSString *) message{
    if (self.irc_room && message && [message length]){
        [self.irc_room sendMessage:[[NSAttributedString alloc] initWithString:message] asAction:NO];
    }
}

- (void) join {
    if (self.irc_room)
        [self.irc_room join];
}

- (void) dealloc {
    [self removeObservers];
}

#pragma mark - TTRoomDelegate
- (void) chatRoomJoined:(NSNotification *) notification{
    MVIRCChatRoom *room = notification.object;
    if (!room)
        return;

    self.irc_room = room;
    if ([self.name isEqualToString:room.name] && self.delegate && [self.delegate respondsToSelector:@selector(roomJoined:)])
        [self.delegate roomJoined:self];
}

- (void) chatRoomParted:(NSNotification *) notification{
    MVIRCChatRoom *room = notification.object;
    if (!room)
        return;

    self.irc_room = room;
    NSDictionary *userInfo = notification.userInfo;
    NSData *reasonData = userInfo[@"reason"];
    NSString *reason = [[NSMutableString alloc] initWithChatData:reasonData encoding:NSISOLatin1StringEncoding];
    if (!reason)
        reason = [[NSMutableString alloc] initWithChatData:reasonData encoding:NSASCIIStringEncoding];

    [self removeObservers];
    if ([self.name isEqualToString:room.name] && self.delegate && [self.delegate respondsToSelector:@selector(roomParted:reason:)])
        [self.delegate roomParted:self reason:reason];
}

- (void) chatRoomKicked:(NSNotification *) notification{
    MVIRCChatRoom *room = notification.object;
    
    if (!room)
        return;
    self.irc_room = room;
    NSDictionary *userInfo = notification.userInfo;
    MVIRCChatUser *user = userInfo[@"byUser"];
    TTChatUser *chatUser = [[TTChatUser alloc] initWithDatas:user];
    
    NSData *reasonData = userInfo[@"reason"];
    NSString *reason = [[NSMutableString alloc] initWithChatData:reasonData encoding:NSISOLatin1StringEncoding];
    if (!reason)
        reason = [[NSMutableString alloc] initWithChatData:reasonData encoding:NSASCIIStringEncoding];
    
    if ([self.name isEqualToString:room.name] && self.delegate && [self.delegate respondsToSelector:@selector(roomKicked:byUser:reason:)])
        [self.delegate roomKicked:self byUser:chatUser reason:reason];
}

- (void) chatRoomInvited:(NSNotification *) notification{
    NSDictionary *userInfo = notification.userInfo;
    if (!userInfo)
        return;
    MVIRCChatRoom *room = userInfo[@"room"];
    if (room)
        self.irc_room = room;
    MVIRCChatUser *user = userInfo[@"user"];    
    TTChatUser *chatUser = [[TTChatUser alloc] initWithDatas:user];
    if ([self.name isEqualToString:room.name] && self.delegate && [self.delegate respondsToSelector:@selector(room:invitedUser:)])
        [self.delegate room:self invitedUser:chatUser];
}

- (void) chatRoomUserJoined:(NSNotification *) notification{
    MVIRCChatRoom *room = notification.object;
    if (!room)
        return;
    self.irc_room = room;
    NSDictionary *userInfo = notification.userInfo;
    MVIRCChatUser *user = userInfo[@"user"];
    TTChatUser *chatUser = [[TTChatUser alloc] initWithDatas:user];
    if ([self.name isEqualToString:room.name] && self.delegate && [self.delegate respondsToSelector:@selector(room:joinedByUser:)])
        [self.delegate room:self joinedByUser:chatUser];
}

- (void) chatRoomUserParted:(NSNotification *) notification{
    MVIRCChatRoom *room = notification.object;
    if (!room)
        return;
    self.irc_room = room;
    NSDictionary *userInfo = notification.userInfo;
    MVIRCChatUser *user = userInfo[@"user"];
    TTChatUser *chatUser = [[TTChatUser alloc] initWithDatas:user];
    
    NSData *reasonData = userInfo[@"reason"];
    NSString *reason = [[NSMutableString alloc] initWithChatData:reasonData encoding:NSISOLatin1StringEncoding];
    if (!reason)
        reason = [[NSMutableString alloc] initWithChatData:reasonData encoding:NSASCIIStringEncoding];
    if ([self.name isEqualToString:room.name] && self.delegate && [self.delegate respondsToSelector:@selector(room:partedByUser:reason:)])
        [self.delegate room:self partedByUser:chatUser reason:reason];
}

- (void) chatRoomUserKicked:(NSNotification *) notification{
    MVIRCChatRoom *room = notification.object;
    if (!room)
        return;
    self.irc_room = room;
    NSDictionary *userInfo = notification.userInfo;
    MVIRCChatUser *user = userInfo[@"user"];
    TTChatUser *chatUser = [[TTChatUser alloc] initWithDatas:user];
    
    
    MVIRCChatUser *byuser = userInfo[@"byUser"];
    TTChatUser *chatByUser = [[TTChatUser alloc] initWithDatas:byuser];
    
    NSData *reasonData = userInfo[@"reason"];
    NSString *reason = [[NSMutableString alloc] initWithChatData:reasonData encoding:NSISOLatin1StringEncoding];
    if (!reason)
        reason = [[NSMutableString alloc] initWithChatData:reasonData encoding:NSASCIIStringEncoding];
    
    if ([self.name isEqualToString:room.name] && self.delegate && [self.delegate respondsToSelector:@selector(room:user:hasKickedUser:reason:)])
        [self.delegate room:self user:chatByUser hasKickedUser:chatUser reason:reason];
}

- (void) chatRoomUserBanned:(NSNotification *) notification{
    MVIRCChatRoom *room = notification.object;
    if (!room)
        return;
    self.irc_room = room;
    NSDictionary *userInfo = notification.userInfo;
    MVIRCChatUser *user = userInfo[@"user"];
    TTChatUser *chatUser = [[TTChatUser alloc] initWithDatas:user];
    
    
    MVIRCChatUser *byuser = userInfo[@"byUser"];
    TTChatUser *chatByUser = [[TTChatUser alloc] initWithDatas:byuser];
    
    if ([self.name isEqualToString:room.name] && self.delegate && [self.delegate respondsToSelector:@selector(room:user:hasBannedUser:)])
        [self.delegate room:self user:chatByUser hasBannedUser:chatUser];
}

- (void) chatRoomUserBanRemoved:(NSNotification *) notification{
    MVIRCChatRoom *room = notification.object;
    if (!room)
        return;
    self.irc_room = room;
    NSDictionary *userInfo = notification.userInfo;
    MVIRCChatUser *user = userInfo[@"user"];
    TTChatUser *chatUser = [[TTChatUser alloc] initWithDatas:user];
    
    
    MVIRCChatUser *byuser = userInfo[@"byUser"];
    TTChatUser *chatByUser = [[TTChatUser alloc] initWithDatas:byuser];
    
    if ([self.name isEqualToString:room.name] && self.delegate && [self.delegate respondsToSelector:@selector(room:user:hasRemovedBanForUser:)])
        [self.delegate room:self user:chatByUser hasRemovedBanForUser:chatUser];
}

- (void) chatRoomUserModeChanged:(NSNotification *) notification{
    MVIRCChatRoom *room = notification.object;
    if (!room)
        return;
    self.irc_room = room;
    NSDictionary *userInfo = notification.userInfo;
    MVIRCChatUser *user = userInfo[@"who"];
    TTChatUser *chatUser = [[TTChatUser alloc] initWithDatas:user];
    
    
    MVIRCChatUser *byuser = userInfo[@"by"];
    TTChatUser *chatByUser = [[TTChatUser alloc] initWithDatas:byuser];
    
    if ([self.name isEqualToString:room.name] && self.delegate && [self.delegate respondsToSelector:@selector(room:user:hasChangedModeForUser:)])
        [self.delegate room:self user:chatByUser hasChangedModeForUser:chatUser];
}

- (void) chatServiceGotSubscriber:(NSNotification *) notification{
    self.subscriber_event = notification.userInfo;
}

- (void) chatServiceGotUserColor:(NSNotification *) notification{
    self.color_event = notification.userInfo;
}


- (void) chatRoomGotMessage:(NSNotification *) notification{
    NSDictionary *userInfo = notification.userInfo;
    if (!userInfo)
        return;
    MVIRCChatRoom *room = userInfo[@"room"];
    if (room)
        self.irc_room = room;
    MVIRCChatUser *user = userInfo[@"user"];
    NSData *messageData = userInfo[@"message"];
    NSString *message = [[NSMutableString alloc] initWithChatData:messageData encoding:NSISOLatin1StringEncoding];
    if (!message)
        message = [[NSMutableString alloc] initWithChatData:messageData encoding:NSASCIIStringEncoding];
    
    BOOL isSubscriber = NO;
    NSString *nickColor = @"#32323E";
    
    if (self.subscriber_event){
        NSString *subscribe_user = self.subscriber_event[@"subscriber"];
        if ([subscribe_user isEqualToString:user.nickname]){
            isSubscriber = YES;
        }
    }
    if (self.color_event){
        NSString *color_user = self.color_event[@"user"];
        if ([color_user isEqualToString:user.nickname]){
            nickColor = self.color_event[@"color"];
        }
    }
    else {
        nickColor = [self generateDefaultColorForUser:[user.nickname capitalizedString]];
    }
    TTChatUser *chatUser = [[TTChatUser alloc] initWithDatas:user];
    [chatUser setNicknameColor:nickColor];
    if ([self.name isEqualToString:room.name] && self.delegate && [self.delegate respondsToSelector:@selector(room:hasMessage:fromUser:isSubscriber:)]){
        [self.delegate room:self hasMessage:message fromUser:chatUser isSubscriber:isSubscriber];
    }
    self.subscriber_event = nil;
    self.color_event = nil;
}

- (NSString *) generateDefaultColorForUser:(NSString *) name {
    NSArray *default_colors = @[@"#FF0000",
                                @"#0000FF",
                                @"#00FF00",
                                @"#B22222",
                                @"#FF7F50",
                                @"#9ACD32",
                                @"#FF4500",
                                @"#2E8B57",
                                @"#DAA520",
                                @"#D2691E",
                                @"#5F9EA0",
                                @"#1E90FF",
                                @"#FF69B4",
                                @"#8A2BE2",
                                @"#00FF7F"];
    if (name && [name length] > 1){
        unichar n = [name characterAtIndex:0] + [name characterAtIndex:[name length] - 1];
        NSString *color = default_colors[n % [default_colors count]];
        return color;
    }
    return @"#000000";
}

- (void) chatRoomTopicChanged:(NSNotification *) notification{
    MVIRCChatRoom *room = notification.object;
    if (!room)
        return;
    self.irc_room = room;
    if ([self.name isEqualToString:room.name] && self.delegate && [self.delegate respondsToSelector:@selector(roomHasChangedTopic:)])
        [self.delegate roomHasChangedTopic:self];
}

- (void) chatRoomModesChanged:(NSNotification *) notification{
    MVIRCChatRoom *room = notification.object;
    if (!room)
        return;
    self.irc_room = room;
    if ([self.name isEqualToString:room.name] && self.delegate && [self.delegate respondsToSelector:@selector(roomHasChangedModes:)])
        [self.delegate roomHasChangedModes:self];
}


@end
