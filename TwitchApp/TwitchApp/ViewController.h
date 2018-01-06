//
//  ViewController.h
//  TwitchApp
//
//  Created by Mathieu LANOY on 13/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <TwitchChatSDK/TwitchChatSDK.h>
#import <TwitchPlayerSDK/TwitchPlayerSDK.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) MPMoviePlayerController   *cr_player;
@property (strong, nonatomic) TTChatView                *v_chat;
@property (strong, nonatomic) TTStreamPlayerView        *v_player;
@property (weak, nonatomic) IBOutlet UIView             *v_player_container;
@property (weak, nonatomic) IBOutlet UIView             *v_chat_container;

@end

