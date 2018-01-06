//
//  TTChatUser.h
//  TwitchChatSDK
//
//  Created by Mathieu LANOY on 20/01/2015.
//  Copyright (c) 2015 Mathieu LANOY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TwitchSDK/TwitchSDK.h>

@interface TTChatUser : NSObject

- (instancetype) initWithDatas:(id) userData;

- (void) setNicknameColor:(NSString *) color;

- (NSString *) getNicknameColor;

- (NSString *) getDisplayName;

- (NSString *) getNickName;

- (NSString *) getRealName;

- (NSString *) getUserName;

- (NSString *) getAccount;

- (NSString *) getAddress;

- (NSString *) getServerAddress;

- (NSDate *) getDateConnected;

- (NSDate *) getDateDisconnected;

- (NSDate *) getDateUpdated;

- (NSData *) getAwayStatusMessage;

- (void) getTwitchUserWithSuccess:(void (^)(TTUser *))success
                          failure:(void (^)(NSError *error))failure;

@end
