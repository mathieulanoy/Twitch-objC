//
//  TTRoom.h
//  TwitchChatSDK
//
//  Created by Mathieu LANOY on 20/01/2015.
//  Copyright (c) 2015 Mathieu LANOY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTChatUser.h"

@protocol TTRoomDelegate;

@interface TTRoom : NSObject
{
    
}

@property (assign, nonatomic) id<TTRoomDelegate>    delegate;

- (NSString *) getName;

- (NSDate *) getDateJoined;

- (NSDate *) getDateParted;

- (NSData *) getTopic;

- (NSArray *) getUsers;

- (NSArray *) getBannedUsers;

- (NSArray *) getModerators;

- (TTChatUser *) getUserByName:(NSString *) name;

- (void) partWithReason:(NSString *) reason;

- (void) changeTopic:(NSString *) topic;

- (void) sendMessage:(NSString *) message;

- (instancetype) initWithName:(NSString *) roomName andConnection:(id) roomConnection;

- (void) join;

@end

#pragma mark - TTRoomDelegate
@protocol TTRoomDelegate <NSObject>

@optional

- (void) roomJoined:(TTRoom *) room;

- (void) roomParted:(TTRoom *) room
             reason:(NSString *) reason;

- (void) roomKicked:(TTRoom *) room
             byUser:(TTChatUser *) user
             reason:(NSString *) reason;

- (void) room:(TTRoom *) room
  invitedUser:(TTChatUser *) user;

- (void) room:(TTRoom *) room joinedByUser:(TTChatUser *) user;

- (void) room:(TTRoom *) room
 partedByUser:(TTChatUser *) user
       reason:(NSString *) reason;

- (void) room:(TTRoom *) room
         user:(TTChatUser *) byUser
hasKickedUser:(TTChatUser *) user
       reason:(NSString *) reason;

- (void) room:(TTRoom *) room
         user:(TTChatUser *) byUser
hasBannedUser:(TTChatUser *) user;

- (void) room:(TTRoom *) room
         user:(TTChatUser *) byUser
hasRemovedBanForUser:(TTChatUser *) user;

- (void) room:(TTRoom *) room
         user:(TTChatUser *) byUser
hasChangedModeForUser:(TTChatUser *) user;

- (void) room:(TTRoom *) room
   hasMessage:(NSString *) message
     fromUser:(TTChatUser *) user;

- (void) roomHasChangedTopic:(TTRoom *) room;

- (void) roomHasChangedModes:(TTRoom *) room;

@end
