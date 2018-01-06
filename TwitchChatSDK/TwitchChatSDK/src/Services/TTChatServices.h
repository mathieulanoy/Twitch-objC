//
//  TTChatServices.h
//  TwitchChatSDK
//
//  Created by Mathieu LANOY on 19/01/2015.
//  Copyright (c) 2015 Mathieu LANOY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTRoom.h"
#import "TTChatView.h"

@interface TTChatServices : NSObject

/*!
 * \brief   Current user name
 */
@property (strong, nonatomic) NSString  *user;

/*!
 * \brief   Current user session token
 * \brief   required scope: chat_login
 */
@property (strong, nonatomic) NSString  *token;

// ****************************************************************************
#pragma mark - Session Singleton

/*!
 * \brief   Get instance of chat service model
 * \return  instancetype    service instanciated
 */
+ (instancetype) sharedChat;


// ****************************************************************************
#pragma mark - Rooms


- (void) joinChatForChannel:(NSString *) channel
                   delegate:(id<TTRoomDelegate>) delegate;

- (void) leaveChatForChannel:(NSString *) channel
                      reason:(NSString *) reason;

- (NSArray *) getChats;

- (void) reconnect;

// ****************************************************************************
#pragma mark - UI

+ (TTChatView *) getViewForChat;

extern NSString *TTChatServicesGotSubscriberNotification;
extern NSString *TTChatServicesGotUserColorNotification;


@end
