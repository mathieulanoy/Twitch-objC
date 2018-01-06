//
//  TTPicture.h
//  TwitchSDK
//
//  Created by Mathieu LANOY on 13/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTModel.h"

@interface TTPicture : TTModel

/*!
 * \brief   Large picture's url
 */
@property (strong, nonatomic) NSString      *large;

/*!
 * \brief   Medium picture's url
 */
@property (strong, nonatomic) NSString      *medium;

/*!
 * \brief   Small picture's url
 */
@property (strong, nonatomic) NSString      *small;

/*!
 * \brief   Thumb picture's url
 */
@property (strong, nonatomic) NSString      *thumb;

/*!
 * \brief   Tiny picture's url
 */
@property (strong, nonatomic) NSString      *tiny;

/*!
 * \brief   Super picture's url
 */
@property (strong, nonatomic) NSString      *picture_super;

/*!
 * \brief   Icon picture's url
 */
@property (strong, nonatomic) NSString      *icon;

/*!
 * \brief   Screen picture's url
 */
@property (strong, nonatomic) NSString      *screen;


/*!
 * \brief   template picture's url in order to get custom size picture.
 * \example http://static-cdn.jtvnw.net/ttv-logoart/League%20of%20Legends.jpg?w={width}&h={height}&fit=scale
 */
@property (strong, nonatomic) NSString      *picture_template;

/*!
 * \brief   alpha picture's url
 */
@property (strong, nonatomic) NSString      *alpha;

/*!
 * \brief   image picture's url
 */
@property (strong, nonatomic) NSString      *image;

/*!
 * \brief   svg picture's url
 */
@property (strong, nonatomic) NSString      *svg;


@end
