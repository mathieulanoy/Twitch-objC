//
//  TTFeaturedStream.h
//  TwitchSDK
//
//  Created by Mathieu LANOY on 15/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTModel.h"
#import "TTStream.h"

@interface TTFeaturedStream : NSObject

/*!
 * \brief   image
 */
@property (strong, nonatomic) NSString  *image;

/*!
 * \brief   text
 */
@property (strong, nonatomic) NSString  *text;

/*!
 * \brief   stream object
 */
@property (strong, nonatomic) TTStream  *stream;

@end
