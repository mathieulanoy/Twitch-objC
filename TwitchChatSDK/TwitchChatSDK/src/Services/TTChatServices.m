//
//  TTChatServices.m
//  TwitchChatSDK
//
//  Created by Mathieu LANOY on 19/01/2015.
//  Copyright (c) 2015 Mathieu LANOY. All rights reserved.
//

#import "TTChatServices.h"
#import "NSNotificationAdditions.h"
#import "MVIRCChatConnection.h"
#import "MVIRCChatRoom.h"
#import "UIView+Nib.h"
#import "NSBundle+TwitchChatSDK.h"

#define TWITCH_IRC_SERVER       @"irc.twitch.tv"
#define TWITCH_IRC_PORT         6667
#define TWITCH_IRC_ANONYMOUS    @"justinfan"

NSString *TTChatServicesGotSubscriberNotification = @"TTChatServicesGotSubscriberNotification";
NSString *TTChatServicesGotUserColorNotification = @"TTChatServicesGotUserColorNotification";

@interface TTChatServices()

@property (strong, nonatomic) MVIRCChatConnection   *connection;
@property (strong, nonatomic) NSMutableArray        *rooms_datas;
@property (strong, nonatomic) NSMutableArray        *rooms;

- (void) performConnectionToChannel:(NSDictionary *) room_data;

- (void) connectToServer;

@end

@implementation TTChatServices

// ****************************************************************************
#pragma mark - Session Singleton

+ (instancetype) sharedChat
{
    static TTChatServices *_sharedChat = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedChat = [[TTChatServices alloc] init];
        _sharedChat.rooms = [NSMutableArray new];
        _sharedChat.rooms_datas = [NSMutableArray new];
    });
    
    return _sharedChat;
}

// ****************************************************************************
#pragma mark - Server Connection

- (void) connectToServer {
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(nicknameAccepted:) name:MVChatConnectionNicknameAcceptedNotification object:nil];
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(nicknameRejected:) name:MVChatConnectionNicknameRejectedNotification object:nil];
    
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(connectionWillConnect:) name:MVChatConnectionWillConnectNotification object:nil];
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(connectionDidConnect:) name:MVChatConnectionDidConnectNotification object:nil];
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(connectionDidNotConnect:) name:MVChatConnectionDidNotConnectNotification object:nil];
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(connectionDidDisconnect:) name:MVChatConnectionDidDisconnectNotification object:nil];
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(connectionGotRawMessage:) name:MVChatConnectionGotRawMessageNotification object:nil];
    
    self.connection = [[MVIRCChatConnection alloc] init];
    self.connection.server = TWITCH_IRC_SERVER;
    self.connection.serverPort = TWITCH_IRC_PORT;
    
    if (!self.user || [self.user length] == 0){
        NSUInteger min = 1000;
        NSUInteger max = 99999999;
        NSUInteger randNum = arc4random() % (max - min) + min; //create the random number.
        
        NSString *user = [NSString stringWithFormat:@"%@%lu", TWITCH_IRC_ANONYMOUS, (unsigned long)randNum];
        self.user = user;
        self.token = @"";
    }
    NSString *password = @"";
    if (self.token){
        password = [NSString stringWithFormat:@"oauth:%@", self.token];
    }
    
    self.rooms = [NSMutableArray new];
    
    self.connection.username = self.user;
    self.connection.realName = self.user;
    self.connection.preferredNickname = self.user;
    self.connection.password = password;
    self.connection.secure = NO;
    
    [self.connection connect];
}

// ****************************************************************************
#pragma mark - Rooms

- (void) joinChatForChannel:(NSString *) channel
                   delegate:(id<TTRoomDelegate>) delegate{
    NSString *room_name = [NSString stringWithFormat:@"#%@", [channel lowercaseString]];
    NSDictionary *room_data = nil;
    for (NSDictionary *current_room_data in self.rooms_datas){
        NSString *current_room_name = current_room_data[@"name"];
        if ([room_name isEqualToString:current_room_name]){
            room_data = current_room_data;
            break;
        }
    }
    if (!room_data){
        if (delegate)
            room_data = @{@"name":room_name, @"delegate": delegate};
        else {
            room_data = @{@"name":room_name};
        }
        [self.rooms_datas addObject:room_data];
    }
    if (self.connection){
        [self performConnectionToChannel:room_data];
    } else {
        [self connectToServer];
    }
}

- (void) reconnect {
    if (self.connection){
        [[NSNotificationCenter chatCenter] removeObserver:self];
        [self.connection disconnect];
        self.connection = nil;
    }
    [self connectToServer];
}

- (void) leaveChatForChannel:(NSString *) channel
                      reason:(NSString *) reason{
    NSString *room_name = [NSString stringWithFormat:@"#%@", [channel lowercaseString]];
    for (TTRoom *current_room in self.rooms){
        if ([room_name isEqualToString:[current_room getName]]){
            [current_room partWithReason:reason];
            [self.rooms removeObject:current_room];
            break;
        }
    }
}

- (NSArray *) getChats{
    return self.rooms;
}

- (void) performConnectionToChannel:(NSDictionary *) room_data{
    NSString *channel = room_data[@"name"];
    id<TTRoomDelegate> delegate = room_data[@"delegate"];
    TTRoom *room = [[TTRoom alloc] initWithName:channel andConnection:self.connection];
    if (delegate){
        room.delegate = delegate;
    }
    [room join];
    [self.rooms addObject:room];
}

- (void) nicknameAccepted:(NSNotification *) notification{
    NSLog(@"NICKNAME ACCEPTED");
}

- (void) nicknameRejected:(NSNotification *) notification{
    NSLog(@"NICKNAME REJECTED");
}

- (void) connectionWillConnect:(NSNotification *) notification{
    NSLog(@"CONNECTION WILL CONNECT");
}

- (void) connectionDidConnect:(NSNotification *) notification{
    NSLog(@"CONNECTION DID CONNECT: %@", notification);
    for (NSDictionary *room_data in self.rooms_datas){
        [self performConnectionToChannel:room_data];
    }
    
    [self.connection sendRawMessage:@"TWITCHCLIENT 2" immediately:NO];
}

- (void) connectionDidNotConnect:(NSNotification *) notification{
    NSLog(@"CONNECTION DID NOT CONNECT");
}

- (void) connectionDidDisconnect:(NSNotification *) notification{
    NSLog(@"CONNECTION DID DISCONNECT");
}

- (void) connectionGotRawMessage:(NSNotification *) notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *sender = userInfo[@"sender"];
    NSString *command = userInfo[@"command"];
    if (sender && [sender isEqualToString:@"jtv"] &&
        command && [command isEqualToString:@"PRIVMSG"]){
        NSArray *parameters = userInfo[@"parameters"];
        if (parameters && [parameters count] > 1){
            NSData *messageData = parameters[1];
            NSString *message = [[NSMutableString alloc] initWithChatData:messageData encoding:NSISOLatin1StringEncoding];
            if (!message)
                message = [[NSMutableString alloc] initWithChatData:messageData encoding:NSASCIIStringEncoding];
            if (message) {
                NSArray *tokens = [message componentsSeparatedByString:@" "];
                if ([tokens count] >= 3){
                    NSString *key = tokens[0];
                    NSString *user = tokens[1];
                    NSString *value = tokens[2];
                    if (key && [key isEqualToString:@"SPECIALUSER"] &&
                        value && [value isEqualToString:@"subscriber"]){
                        [[NSNotificationCenter chatCenter] postNotificationOnMainThreadWithName:TTChatServicesGotSubscriberNotification object:nil userInfo:@{@"subscriber":user}];
//                        NSLog(@"%@ has subscribed", user);
                    }
                    else if (key && [key isEqualToString:@"USERCOLOR"]){
                        [[NSNotificationCenter chatCenter] postNotificationOnMainThreadWithName:TTChatServicesGotUserColorNotification object:nil userInfo:@{@"user": user, @"color":value}];
//                        NSLog(@"%@ has nick colored by: %@", user, value);
                    }

                }
            }
        }
    }
    
};



// ****************************************************************************
#pragma mark - UI

+ (TTChatView *) getViewForChat{
    NSBundle *bundle = [NSBundle TwitchChatResourcesBundle];
    if (!bundle)
        return nil;
    TTChatView *view = (TTChatView *)[UIView viewFromNibNamed:@"TTChatView" bundle:bundle];
    return view;
}

@end
