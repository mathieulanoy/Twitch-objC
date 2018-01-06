//
//  TTBlockUser.h
//  TwitchSDK
//
//  Created by Mathieu LANOY on 16/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTModel.h"
#import "TTLink.h"
#import "TTUser.h"

@interface TTBlockUser : TTModel

/*!
 * \brief   date of last update
 */
@property (strong, nonatomic) NSDate    *updated_at;

/*!
 * \brief   links
 */
@property (strong, nonatomic) TTLink    *links;

/*!
 * \brief   has notifications
 */
@property (assign, nonatomic) NSInteger block_id;

/*!
 * \brief   user model
 */
@property (strong, nonatomic) TTUser    *user;


@end
