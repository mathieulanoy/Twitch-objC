//
//  TTChatUser.m
//  TwitchChatSDK
//
//  Created by Mathieu LANOY on 20/01/2015.
//  Copyright (c) 2015 Mathieu LANOY. All rights reserved.
//

#import "TTChatUser.h"
#import "MVIRCChatUser.h"

@interface TTChatUser()
@property (strong, nonatomic) MVIRCChatUser *irc_user;
@property (strong, nonatomic) NSString      *nickname_color;
@end

@implementation TTChatUser

- (instancetype) initWithDatas:(id) userData {
    if((self = [super init])) {
        if ([userData isKindOfClass:[MVIRCChatUser class]]){
            _irc_user = userData;
            _nickname_color = @"#32323E";
        }
    }
    return self;
}

- (void) setNicknameColor:(NSString *) color {
    _nickname_color = color;
}

- (NSString *) getNicknameColor{
    return _nickname_color;
}


- (NSString *) getDisplayName {
    if (self.irc_user)
        return self.irc_user.displayName;
    return @"";
}

- (NSString *) getNickName {
    if (self.irc_user)
        return self.irc_user.nickname;
    return @"";
}

- (NSString *) getRealName{
    if (self.irc_user)
        return self.irc_user.realName;
    return @"";
}

- (NSString *) getUserName{
    if (self.irc_user)
        return self.irc_user.username;
    return @"";
}

- (NSString *) getAccount {
    if (self.irc_user)
        return self.irc_user.account;
    return @"";
}

- (NSString *) getAddress {
    if (self.irc_user)
        return self.irc_user.address;
    return @"";
}

- (NSString *) getServerAddress {
    if (self.irc_user)
        return self.irc_user.serverAddress;
    return @"";
}

- (NSDate *) getDateConnected {
    if (self.irc_user)
        return self.irc_user.dateConnected;
    return nil;
}

- (NSDate *) getDateDisconnected {
    if (self.irc_user)
        return self.irc_user.dateDisconnected;
    return nil;
}

- (NSDate *) getDateUpdated {
    if (self.irc_user)
        return self.irc_user.dateUpdated;
    return nil;
}

- (NSData *) getAwayStatusMessage {
    if (self.irc_user)
        return self.irc_user.awayStatusMessage;
    return nil;
}

- (void) getTwitchUserWithSuccess:(void (^)(TTUser *))success
                          failure:(void (^)(NSError *error))failure {
    [TTCore getUser:self.irc_user.displayName success:^(TTUser *user) {
        if (success)
            success(user);
    } failure:^(NSError *error) {
        if (failure)
            return failure(error);
    }];
}


@end
