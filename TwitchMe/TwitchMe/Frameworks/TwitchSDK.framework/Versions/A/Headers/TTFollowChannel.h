//
//  TTFollowChannel.h
//  TwitchSDK
//
//  Created by Mathieu LANOY on 14/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTModel.h"
#import "TTLink.h"
#import "TTChannel.h"

@interface TTFollowChannel : TTModel

/*!
 * \brief   date of creation
 */
@property (strong, nonatomic) NSDate    *created_at;

/*!
 * \brief   links
 */
@property (strong, nonatomic) TTLink    *links;

/*!
 * \brief   has notifications
 */
@property (assign, nonatomic) BOOL      notifications;

/*!
 * \brief   user model
 */
@property (strong, nonatomic) TTChannel *channel;


@end
