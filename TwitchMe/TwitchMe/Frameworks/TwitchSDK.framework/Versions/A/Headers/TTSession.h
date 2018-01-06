//
//  TTSession.h
//  TwitchSDK
//
//  Created by Mathieu LANOY on 14/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTUser.h"

@interface TTSession : NSObject

// ****************************************************************************
#pragma mark - Session Singleton

/*!
 * \brief   Get instance of session model
 * \return  instancetype    Session instanciated
 */
+ (instancetype) sharedSession;

// ****************************************************************************
#pragma mark - Setup

/*!
 * \brief   setup TTCore with a Client ID in order to ensure that your application is not rate limited
 * \param   clientID    your client ID
 */
- (void) setClientID:(NSString *) clientID;

// ****************************************************************************
#pragma mark - User

/*!
 * \brief   setup User Object
 * \param   User
 */
- (void) setUser:(TTUser *) user;

/*!
 * \brief   fetch user
 * \return  TTUser
 */
- (TTUser *) getUser;

// ****************************************************************************
#pragma mark - Token

/*!
 * \brief   fetch user connection token
 * \return  NSString
 */
- (NSString *) getToken;

// ****************************************************************************
#pragma mark - Login

/*!
 * \brief   Open Safari to log the user in and get back to your application thanks to your scheme.
 * \param   scheme  Your application scheme for the login callback
 * \param   scopes  array of scopes to use for user to log (here the list of scopes available: user_read, user_blocks_edit, user_blocks_read, user_follows_edit, channel_read, channel_editor, channel_commercial, channel_stream, channel_subscriptions, user_subscriptions, channel_check_subscription, chat_login
 * \return  void
 */
- (void) loginWithScheme:(NSString *) scheme
                   scope:(NSArray *) scopes;

/*!
 * \brief   Generate the login url to use.
 * \param   scheme  Your application scheme for the login callback
 * \param   scopes  array of scopes to use for user to log (here the list of scopes available: user_read, user_blocks_edit, user_blocks_read, user_follows_edit, channel_read, channel_editor, channel_commercial, channel_stream, channel_subscriptions, user_subscriptions, channel_check_subscription, chat_login
 * \return  NSString*   url to call for the login process
 */
- (NSString *) generateLoginURLWithScheme:(NSString *) scheme
                                    scope:(NSArray *) scopes;


/*!
 * \brief   Method to call in application:openURL:sourceApplication:annotation: method to handle login process.
 * \param   url     URL which open your application from login page, typically the scheme specified.
 * \return  BOOL    YES
 */
- (BOOL) handleURL:(NSURL *) url;

/*!
 * \brief   Check if current user is logged
 * \return  BOOL    is logged or not
 */
- (BOOL) isLogged;

/*!
 * \brief   Logout current user
 * \return  void
 */
- (void) logout;

@end

// ****************************************************************************
#pragma mark - Notifications

extern NSString *const TTSessionDidLogInFailedNotification;
extern NSString *const TTSessionDidLogInNotification;
extern NSString *const TTSessionDidLogOutNotification;
