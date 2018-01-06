//
//  TTChannel.h
//  TwitchSDK
//
//  Created by Mathieu LANOY on 14/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTModel.h"
#import "TTLink.h"
#import "TTTeam.h"

@interface TTChannel : TTModel

/*!
 * \brief   name
 */
@property (strong, nonatomic) NSString  *name;

/*!
 * \brief   game
 */
@property (strong, nonatomic) NSString  *game;

/*!
 * \brief   date of creation
 */
@property (strong, nonatomic) NSDate    *created_at;

/*!
 * \brief   name
 */
@property (assign, nonatomic) NSInteger delay;

/*!
 * \brief   array of teams
 */
@property (strong, nonatomic) NSArray   *teams;

/*!
 * \brief   status
 */
@property (strong, nonatomic) NSString  *status;

/*!
 * \brief   date of last update
 */
@property (strong, nonatomic) NSDate    *updated_at;

/*!
 * \brief   banner
 */
@property (strong, nonatomic) NSString  *banner;

/*!
 * \brief   video banner
 */
@property (strong, nonatomic) NSString  *video_banner;

/*!
 * \brief   background
 */
@property (strong, nonatomic) NSString  *background;

/*!
 * \brief   links
 */
@property (strong, nonatomic) TTLink    *link;

/*!
 * \brief   logo
 */
@property (strong, nonatomic) NSString  *logo;

/*!
 * \brief   channel id
 */
@property (assign, nonatomic) NSInteger channel_id;

/*!
 * \brief   mature channel
 */
@property (assign, nonatomic) BOOL      mature;

/*!
 * \brief   url
 */
@property (strong, nonatomic) NSString  *url;

/*!
 * \brief   display name
 */
@property (strong, nonatomic) NSString  *display_name;

/*!
 * \brief   followers
 */
@property (assign, nonatomic) NSInteger followers;

/*!
 * \brief   views
 */
@property (assign, nonatomic) NSInteger views;

/*!
 * \brief   partner
 */
@property (assign, nonatomic) NSInteger partner;

/*!
 * \brief   language
 */
@property (strong, nonatomic) NSString  *language;

/*!
 * \brief   broadcaster language
 */
@property (strong, nonatomic) NSString  *broadcaster_language;

/*!
 * \brief   email
 */
@property (strong, nonatomic) NSString  *email;

/*!
 * \brief   profile banner
 */
@property (strong, nonatomic) NSString  *profile_banner;

/*!
 * \brief   profile banner background color
 */
@property (strong, nonatomic) NSString  *profile_banner_background_color;

/*!
 * \brief   stream key
 */
@property (strong, nonatomic) NSString  *stream_key;

/*!
 * \brief   primary team name
 */
@property (strong, nonatomic) NSString  *primary_team_name;

/*!
 * \brief   primary team display name
 */
@property (strong, nonatomic) NSString  *primary_team_display_name;

/*!
 * \brief   abuse reported
 */
@property (assign, nonatomic) BOOL      abuse_reported;

@end
