//
//  ViewController.m
//  TwitchApp
//
//  Created by Mathieu LANOY on 13/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "ViewController.h"
#import <TwitchSDK/TwitchSDK.h>
#import "PXAlertView.h"
#import "PXAlertView+Customization.h"

#define TWITCH_USER @"kinggothalion"

@interface ViewController ()<TTStreamPlayerViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userFetched:) name:TTCoreDidFetchUserNotification object:nil];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self createPlayer];
    [self createChatView];
}

- (void) createPlayer {
    self.v_player = [TTPlayerServices getViewforPlayer];
    if (self.v_player){
        self.v_player.delegate = self;
        [self.v_player_container addSubview:self.v_player];
        [self.v_player setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSArray *vertical_constraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[playerView]-(-7)-|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:@{@"playerView":self.v_player}];
        
        NSArray *horizontal_constraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-5)-[playerView]-(-5)-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:@{@"playerView":self.v_player}];
        [self.v_player_container addConstraints:vertical_constraint];
        [self.v_player_container addConstraints:horizontal_constraint];
    }
    [self.v_player createPlayerForChannel:TWITCH_USER];
}

- (void) createChatView {
    self.v_chat = [TTChatServices getViewForChat];
    if (self.v_chat){
        [self.v_chat_container addSubview:self.v_chat];
        [self.v_chat setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSArray *vertical_constraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[chatView]-|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:@{@"chatView":self.v_chat}];
        
        NSArray *horizontal_constraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-20)-[chatView]-(-20)-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:@{@"chatView":self.v_chat}];
        [self.v_chat_container addConstraints:vertical_constraint];
        [self.v_chat_container addConstraints:horizontal_constraint];
    }

    TTUser *user = [[TTSession sharedSession] getUser];
    NSString *token = [[TTSession sharedSession] getToken];
    [self.v_chat connectToChat:TWITCH_USER user:user.display_name token:token];
}

- (void) userFetched:(NSNotification *) notification {
    TTUser *user = [[TTSession sharedSession] getUser];
    NSLog(@"%@", user.name);
    NSString *token = [[TTSession sharedSession] getToken];
    NSLog(@"token: %@", token);
}

- (void) playerView:(TTStreamPlayerView *) view didLoadChannel:(NSString *) channel {
}

- (void) playerView:(TTStreamPlayerView *) view failedToLoadChannel:(NSString *) channel {
    NSLog(@"CHANNEL: %@ IS NOT LIVE", channel);
    
    PXAlertView *alert = [PXAlertView showAlertWithTitle:@"Informations"
                                                 message:[NSString stringWithFormat:@"%@ is currently not live", channel]
                                             cancelTitle:@"Ok"
                                              otherTitle:nil
                                              completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                  if (cancelled) {
                                                      NSLog(@"Cancel");
                                                  } else {
                                                      NSLog(@"Ok");
                                                  }
                                              }];
    UIColor *twitchColor = [UIColor colorWithRed:185.0f/255.0f green:163.0f/255.0f blue:227.0f/255.0f alpha:1.0f];
    [alert setAllButtonsTextColor:twitchColor];
    [alert setTitleColor:twitchColor];
    [alert setMessageColor:twitchColor];
    twitchColor = [UIColor colorWithRed:70.0f/255.0f green:35.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
    [alert setAllButtonsBackgroundColor:twitchColor];
    twitchColor = [UIColor colorWithRed:100.0f/255.0f green:65.0f/255.0f blue:165.0f/255.0f alpha:1.0f];
    [alert setBackgroundColor:twitchColor];
}

- (void) playerViewWillBeginLoadingVideo:(TTStreamPlayerView *) view {
}

- (void) playerViewDidFinishLoadingVideo:(TTStreamPlayerView *) view {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
