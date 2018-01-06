//
//  ViewController.m
//  TwitchIRCTest
//
//  Created by Mathieu LANOY on 18/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "ViewController.h"
#import "NSNotificationAdditions.h"
#import "MVIRCChatUser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initializeIRCConnection];
}

#pragma mark - IRC CONNECTION
- (void) initializeIRCConnection {
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(nicknameAccepted:) name:MVChatConnectionNicknameAcceptedNotification object:nil];
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(nicknameRejected:) name:MVChatConnectionNicknameRejectedNotification object:nil];
    
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(connectionWillConnect:) name:MVChatConnectionWillConnectNotification object:nil];
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(connectionDidConnect:) name:MVChatConnectionDidConnectNotification object:nil];
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(connectionDidNotConnect:) name:MVChatConnectionDidNotConnectNotification object:nil];
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(connectionDidDisconnect:) name:MVChatConnectionDidDisconnectNotification object:nil];
    
    self.connection = [[MVIRCChatConnection alloc] init];
    self.connection.server = @"irc.twitch.tv";
    self.connection.serverPort = 6667;
    self.connection.username = @"justinfan123234";
    self.connection.realName = @"justinfan123234";
    self.connection.preferredNickname = @"justinfan123234";
    self.connection.password = @"";
    self.connection.secure = NO;
    
    [self.connection connect];
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
    [self connectToRoom];
    
}

- (void) connectionDidNotConnect:(NSNotification *) notification{
    NSLog(@"CONNECTION DID NOT CONNECT");
}

- (void) connectionDidDisconnect:(NSNotification *) notification{
    NSLog(@"CONNECTION DID DISCONNECT");
}

#pragma mark - IRC ROOM
- (void) connectToRoom {
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
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(chatRoomUserBricked:) name:MVChatRoomUserBrickedNotification object:nil];
    
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(chatRoomGotMessage:) name:MVChatRoomGotMessageNotification object:nil];
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(chatRoomTopicChanged:) name:MVChatRoomTopicChangedNotification object:nil];
    [[NSNotificationCenter chatCenter] addObserver:self selector:@selector(chatRoomModesChanged:) name:MVChatRoomModesChangedNotification object:nil];
    
    self.room = [[MVIRCChatRoom alloc] initWithName:@"#jodenstone" andConnection:self.connection];
    [self.room join];
}

- (void) chatRoomJoined:(NSNotification *) notification{
    NSLog(@"CHAT ROOM JOINED");
    NSLog(@"ROOM USER: %@", self.room.memberUsers);
}

- (void) chatRoomParted:(NSNotification *) notification{
    NSLog(@"CHAT ROOM PARTED");
}

- (void) chatRoomKicked:(NSNotification *) notification{
    NSLog(@"CHAT ROOM KICKED");
}

- (void) chatRoomInvited:(NSNotification *) notification{
    NSLog(@"CHAT ROOM INVITED");
}

- (void) chatRoomUserJoined:(NSNotification *) notification{
    NSLog(@"CHAT ROOM USER JOINED: %@", notification.userInfo);
}

- (void) chatRoomUserParted:(NSNotification *) notification{
    NSLog(@"CHAT ROOM USER PARTED: %@", notification.userInfo);
}

- (void) chatRoomUserKicked:(NSNotification *) notification{
    NSLog(@"CHAT ROOM USER KICKED: %@", notification.userInfo);
}

- (void) chatRoomUserBanned:(NSNotification *) notification{
    NSLog(@"CHAT ROOM USER BANNED: %@", notification.userInfo);
}

- (void) chatRoomUserBanRemoved:(NSNotification *) notification{
    NSLog(@"CHAT ROOM USER BAN REMOVED: %@", notification.userInfo);
}

- (void) chatRoomUserModeChanged:(NSNotification *) notification{
    NSLog(@"CHAT ROOM USER MODE CHANGED");
}

- (void) chatRoomUserBricked:(NSNotification *) notification{
    NSLog(@"CHAT ROOM USER BRICKED");
}

- (void) chatRoomGotMessage:(NSNotification *) notification{
    NSDictionary *userInfo = notification.userInfo;
    if (!userInfo)
        return;
    MVIRCChatUser *user = userInfo[@"user"];
    NSData *messageData = userInfo[@"message"];
    NSString *message = [[NSMutableString alloc] initWithChatData:messageData encoding:NSISOLatin1StringEncoding];
    if (!message)
        message = [[NSMutableString alloc] initWithChatData:messageData encoding:NSASCIIStringEncoding];
    NSLog(@"MESSAGE: %@:%@", user.displayName, message);
}

- (void) chatRoomTopicChanged:(NSNotification *) notification{
    NSLog(@"TOPIC: %@", notification.userInfo);
}

- (void) chatRoomModesChanged:(NSNotification *) notification{
    NSLog(@"CHAT ROOM MODES CHANGED");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
