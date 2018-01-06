//
//  ViewController.h
//  TwitchIRCTest
//
//  Created by Mathieu LANOY on 18/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVIRCChatConnection.h"
#import "MVIRCChatRoom.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) MVIRCChatConnection   *connection;
@property (strong, nonatomic) MVIRCChatRoom         *room;

@end

