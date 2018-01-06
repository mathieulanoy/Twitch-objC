//
//  AppDelegate.m
//  TwitchApp
//
//  Created by Mathieu LANOY on 13/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "AppDelegate.h"
#import <TwitchSDK/TwitchSDK.h>
#import <TwitchChatSDK/TwitchChatSDK.h>
#import "TMViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSString *clientID = @"bpc4c5348yjv40c2erg01ey1b0esucl";
    [TTCore setClientID:clientID];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:TTSessionDidLogInNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userFailToLogin:) name:TTSessionDidLogInFailedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout:) name:TTSessionDidLogOutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userFetched:) name:TTCoreDidFetchUserNotification object:nil];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    TMViewController *cr_controller = [[TMViewController alloc] init];
    cr_controller.view.backgroundColor = [UIColor yellowColor];
    self.cr_navigation = [[TMNavigationController alloc] initWithRootViewController:cr_controller];
    self.window.rootViewController = self.cr_navigation;
    [self.window makeKeyAndVisible];
    
    
//    if (![[TTSession sharedSession] isLogged]){
//        NSString *scheme = @"twitchSDK://authorize";
//        [[TTSession sharedSession] loginWithScheme:scheme
//                                            scope:@[@"user_read", @"user_follows_edit", @"channel_read", @"channel_editor", @"channel_subscriptions", @"channel_check_subscription", @"user_subscriptions", @"user_blocks_read", @"user_blocks_edit", @"chat_login"]];
//    } else {
//        [self TwitchTest];
//    }
    
    return YES;
}

- (void) TwitchTest {
//    [TTCore getTopGamesWithLimit:10 offset:0 HLS:NO success:^(NSInteger total, TTLink *link, NSArray *games) {
//    } failure:^(NSError *error) {
//    }];
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[TTSession sharedSession] handleURL:url];
}

- (void) userDidLogin:(NSNotification *) notification {
    [self TwitchTest];
}

- (void) userFailToLogin:(NSNotification *) notification {
    NSLog(@"user login failed");
}

- (void) userDidLogout:(NSNotification *) notification {
    NSLog(@"user did logout");
}

- (void) userFetched:(NSNotification *) notification {
//    [[TTSession sharedSession] logout];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
