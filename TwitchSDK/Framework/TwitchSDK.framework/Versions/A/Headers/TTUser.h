//
//  TTUser.h
//  TwitchSDK
//
//  Created by Mathieu LANOY on 14/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTModel.h"
#import "TTLink.h"

@interface TTUser : TTModel

/*!
 * \brief   type
 */
@property (strong, nonatomic) NSString      *type;

/*!
 * \brief   name
 */
@property (strong, nonatomic) NSString      *name;

/*!
 * \brief   date of creation
 */
@property (strong, nonatomic) NSDate        *created_at;


/*!
 * \brief   date of last update
 */
@property (strong, nonatomic) NSDate        *updated_at;

/*!
 * \brief   link to user's profile
 */
@property (strong, nonatomic) TTLink        *links;

/*!
 * \brief   user's logo
 */
@property (strong, nonatomic) NSString      *logo;

/*!
 * \brief   user id
 */
@property (assign, nonatomic) NSInteger     user_id;

/*!
 * \brief   display name
 */
@property (strong, nonatomic) NSString      *display_name;

/*!
 * \brief   email
 */
@property (strong, nonatomic) NSString      *email;

/*!
 * \brief   partnered
 */
@property (assign, nonatomic) BOOL          partened;

/*!
 * \brief   staff
 */
@property (assign, nonatomic) BOOL          staff;

/*!
 * \brief   bio
 */
@property (strong, nonatomic) NSString      *bio;

/*!
 * \brief   Notifications
 */
@property (strong, nonatomic) NSDictionary  *notifications;


@end
