//
//  TTSubscription.h
//  TwitchSDK
//
//  Created by Mathieu LANOY on 15/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTModel.h"
#import "TTLink.h"
#import "TTUser.h"

@interface TTSubscription : TTModel

/*!
 * \brief   subscription id
 */
@property (strong, nonatomic) NSString  *subscription_id;

/*!
 * \brief   link
 */
@property (strong, nonatomic) TTLink    *link;

/*!
 * \brief   user
 */
@property (strong, nonatomic) TTUser    *user;

/*!
 * \brief   date of creation
 */
@property (strong, nonatomic) NSDate    *created_at;

@end
