//
//  TTLink.h
//  TwitchSDK
//
//  Created by Mathieu LANOY on 13/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTModel.h"

@interface TTLink : TTModel

/*!
 * \brief   current link
 */
@property (strong, nonatomic) NSString  *current_link;

/*!
 * \brief   link to next results
 */
@property (strong, nonatomic) NSString  *previous_link;

/*!
 * \brief   get link to previous results
 */
@property (strong, nonatomic) NSString  *next_link;

/*!
 * \brief   get link to owner
 */
@property (strong, nonatomic) NSString  *owner;


/*!
 * \brief   get link to chat
 */
@property (strong, nonatomic) NSString  *chat;

/*!
 * \brief   get link to videos
 */
@property (strong, nonatomic) NSString  *videos;

/*!
 * \brief   get link to video_status
 */
@property (strong, nonatomic) NSString  *video_status;

/*!
 * \brief   get link to commercial
 */
@property (strong, nonatomic) NSString  *commercial;

/*!
 * \brief   get link to editors
 */
@property (strong, nonatomic) NSString  *editors;

/*!
 * \brief   get link to features
 */
@property (strong, nonatomic) NSString  *features;

/*!
 * \brief   get link to follows
 */
@property (strong, nonatomic) NSString  *follows;

/*!
 * \brief   get link to stream key
 */
@property (strong, nonatomic) NSString  *stream_key;

/*!
 * \brief   get link to subscriptions
 */
@property (strong, nonatomic) NSString  *subscriptions;

/*!
 * \brief   get link to teams
 */
@property (strong, nonatomic) NSString  *teams;

/*!
 * \brief   get link to channel
 */
@property (strong, nonatomic) NSString  *channel;

/*!
 * \brief   get link to channels
 */
@property (strong, nonatomic) NSString  *channels;

/*!
 * \brief   get link to ingests
 */
@property (strong, nonatomic) NSString  *ingests;

/*!
 * \brief   get link to search
 */
@property (strong, nonatomic) NSString  *search;

/*!
 * \brief   get link to streams
 */
@property (strong, nonatomic) NSString  *streams;

/*!
 * \brief   get link to user
 */
@property (strong, nonatomic) NSString  *user;

/*!
 * \brief   get link to users
 */
@property (strong, nonatomic) NSString  *users;

@end
