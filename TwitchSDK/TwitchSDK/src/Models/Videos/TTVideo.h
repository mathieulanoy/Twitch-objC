//
//  TTVideo.h
//  TwitchSDK
//
//  Created by Mathieu LANOY on 16/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTModel.h"
#import "TTLink.h"
#import "TTChannel.h"

@interface TTVideo : TTModel

/*!
 * \brief   title
 */
@property (strong, nonatomic) NSString  *title;

/*!
 * \brief   recorded_at
 */
@property (strong, nonatomic) NSDate    *recorded_at;

/*!
 * \brief   url
 */
@property (strong, nonatomic) NSString  *url;

/*!
 * \brief   video's id
 */
@property (strong, nonatomic) NSString  *video_id;

/*!
 * \brief   links
 */
@property (strong, nonatomic) TTLink    *links;

/*!
 * \brief   channel
 */
@property (strong, nonatomic) TTChannel *channel;

/*!
 * \brief   views
 */
@property (assign, nonatomic) NSInteger views;

/*!
 * \brief   description
 */
@property (strong, nonatomic) NSString  *video_description;

/*!
 * \brief   length
 */
@property (assign, nonatomic) NSInteger length;

/*!
 * \brief   game
 */
@property (strong, nonatomic) NSString  *game;

/*!
 * \brief   preview
 */
@property (strong, nonatomic) NSString  *preview;

/*!
 * \brief   broadcast's id
 */
@property (assign, nonatomic) NSInteger  broadcast_id;

/*!
 * \brief   status
 */
@property (strong, nonatomic) NSString  *status;

/*!
 * \brief   tag_list
 */
@property (strong, nonatomic) NSString  *tag_list;

@end
