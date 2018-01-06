//
//  AppDelegate.h
//  TwitchApp
//
//  Created by Mathieu LANOY on 13/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwitchChatSDK/TwitchChatSDK.h>
#import "TMNavigationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, TTRoomDelegate>

@property (strong, nonatomic) TTChatServices            *chatService;

@property (strong, nonatomic) UIWindow                  *window;

@property (strong, nonatomic) TMNavigationController    *cr_navigation;

@end

