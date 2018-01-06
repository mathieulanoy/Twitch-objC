//
//  ViewController.m
//  TwitchMe
//
//  Created by Mathieu LANOY on 16/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userFetched:) name:TTCoreDidFetchUserNotification object:nil];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self createChatView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createChatView {
    self.v_chat = [TTChatServices getViewForChat];
    if (self.v_chat){
        [self.view addSubview:self.v_chat];
        [self.v_chat setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSArray *vertical_constraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(28)-[chatView]-|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:@{@"chatView":self.v_chat}];
        
        NSArray *horizontal_constraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(-20)-[chatView]-(-20)-|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:@{@"chatView":self.v_chat}];
        [self.view addConstraints:vertical_constraint];
        [self.view addConstraints:horizontal_constraint];
    }
    
    TTUser *user = [[TTSession sharedSession] getUser];
    NSString *token = [[TTSession sharedSession] getToken];
    [self.v_chat connectToChat:@"cereth" user:user.display_name token:token];
}

- (void) userFetched:(NSNotification *) notification {
    TTUser *user = [[TTSession sharedSession] getUser];
    NSLog(@"%@", user.name);
    NSString *token = [[TTSession sharedSession] getToken];
    NSLog(@"token: %@", token);
}

@end
