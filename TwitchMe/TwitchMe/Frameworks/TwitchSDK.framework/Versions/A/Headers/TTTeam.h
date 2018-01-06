//
//  TTTeam.h
//  TwitchSDK
//
//  Created by Mathieu LANOY on 14/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTModel.h"
#import "TTLink.h"

@interface TTTeam : TTModel

/*!
 * \brief   Team id
 */
@property (assign, nonatomic) NSInteger team_id;

/*!
 * \brief   date of creation
 */
@property (strong, nonatomic) NSDate    *created_at;

/*!
 * \brief   Info
 */
@property (strong, nonatomic) NSString  *info;

/*!
 * \brief   date of last update
 */
@property (strong, nonatomic) NSDate    *updated_at;

/*!
 * \brief   background url
 */
@property (strong, nonatomic) NSString  *background;

/*!
 * \brief   banner url
 */
@property (strong, nonatomic) NSString  *banner;

/*!
 * \brief   logo url
 */
@property (strong, nonatomic) NSString  *logo;

/*!
 * \brief   links
 */
@property (strong, nonatomic) TTLink    *link;

/*!
 * \brief   display name
 */
@property (strong, nonatomic) NSString  *display_name;

/*!
 * \brief   name
 */
@property (strong, nonatomic) NSString  *name;
@end
