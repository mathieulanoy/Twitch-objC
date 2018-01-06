//
//  TTSession.m
//  TwitchSDK
//
//  Created by Mathieu LANOY on 14/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTSession.h"
#import "TTHTTPSessionManager.h"
#import "TTCore.h"

static NSString * const TwitchAuthorizeURL = @"https://api.twitch.tv/kraken/oauth2/authorize";

static NSString * const TwitchTokenKey = @"TWITCH_TOKEN_KEY";

NSString *const TTSessionDidLogInFailedNotification = @"TTSessionDidLogInFailedNotification";
NSString *const TTSessionDidLogInNotification = @"TTSessionDidLogInNotification";
NSString *const TTSessionDidLogOutNotification = @"TTSessionDidLogOutNotification";

@interface TTSession ()

@property (strong, nonatomic) NSString  *user_token;
@property (strong, nonatomic) NSString  *clientID;
@property (strong, nonatomic) TTUser    *user;

@end

@implementation TTSession

// ****************************************************************************
#pragma mark - Session Singleton

+ (instancetype) sharedSession
{
    static TTSession *_sharedSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSession = [[TTSession alloc] init];
        _sharedSession.user_token = [[NSUserDefaults standardUserDefaults] stringForKey:TwitchTokenKey];
        [TTHTTPSessionManager sharedClient].user_token = _sharedSession.user_token;
        if (_sharedSession.user_token && [_sharedSession.user_token length] > 0){
            [TTCore getUserWithSuccess:^(TTUser *user) {
            } failure:^(NSError *error) {
            }];
        }
    });
    
    return _sharedSession;
}

// ****************************************************************************
#pragma mark - Setup

- (void) setClientID:(NSString *) clientID {
    _clientID = clientID;
}

// ****************************************************************************
#pragma mark - User

- (void) setUser:(TTUser *) user{
    _user = user;
}

- (TTUser *) getUser{
    return _user;
}

// ****************************************************************************
#pragma mark - Token

- (NSString *) getToken{
    return _user_token;
}


// ****************************************************************************
#pragma mark - Login

- (void) loginWithScheme:(NSString *) scheme
                   scope:(NSArray *) scopes {
    NSString *login_url = [self generateLoginURLWithScheme:scheme scope:scopes];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:login_url]];
}

- (NSString *) generateLoginURLWithScheme:(NSString *) scheme
                                    scope:(NSArray *) scopes {
    NSString *login_url = TwitchAuthorizeURL;
    login_url = [login_url stringByAppendingFormat:@"?response_type=token&client_id=%@", self.clientID ? self.clientID : @""];
    login_url = [login_url stringByAppendingFormat:@"&redirect_uri=%@", scheme ? scheme : @""];
    
    NSString *scope_str = @"";
    for (NSString *scope in scopes){
        if ([scope_str length] > 0){
            scope_str = [scope_str stringByAppendingString:@"%20"];
        }
        scope_str = [scope_str stringByAppendingString:scope];
    }
    
    login_url = [login_url stringByAppendingFormat:@"&scope=%@", scope_str];
    return login_url;
}

- (BOOL) handleURL:(NSURL *) url {
    NSString *fragment = url.fragment;
    if (!fragment){
        [[NSNotificationCenter defaultCenter] postNotificationName:TTSessionDidLogInFailedNotification object:nil];
        return YES;
    }
    NSArray *pairs = [fragment componentsSeparatedByString:@"&"];
    for (NSString *pair in pairs){
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [elements[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *value = [elements[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if ([key isEqualToString:@"access_token"]){
            _user_token = value;
            [[NSUserDefaults standardUserDefaults] setObject:_user_token forKey:TwitchTokenKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [TTHTTPSessionManager sharedClient].user_token = _user_token;
            [[NSNotificationCenter defaultCenter] postNotificationName:TTSessionDidLogInNotification object:nil];
            [TTCore getUserWithSuccess:^(TTUser *user) {
            } failure:^(NSError *error) {
            }];
        }
    }
    
    return YES;
}

- (BOOL) isLogged {
    return _user_token && [_user_token length] > 0;
}

- (void) logout {
    _user_token = @"";
    [[NSUserDefaults standardUserDefaults] setObject:_user_token forKey:TwitchTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [TTHTTPSessionManager sharedClient].user_token = _user_token;
    
//    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    NSArray* twitchCookies = [cookies cookiesForURL:
//                                [NSURL URLWithString:@"http://www.twitch.tv"]];
//    for (NSHTTPCookie* cookie in twitchCookies) {
//        [cookies deleteCookie:cookie];
//    }
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
    [[NSNotificationCenter defaultCenter] postNotificationName:TTSessionDidLogOutNotification object:nil];
}

@end
