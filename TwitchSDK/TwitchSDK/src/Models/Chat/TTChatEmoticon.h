//
//  TTChatEmoticon.h
//  TwitchSDK
//
//  Created by Mathieu LANOY on 21/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTModel.h"

@interface TTChatEmoticon : TTModel

/*!
 * \brief   width
 */
@property (assign, nonatomic) NSUInteger    width;

/*!
 * \brief   height
 */
@property (assign, nonatomic) NSUInteger    height;

/*!
 * \brief   regex
 */
@property (strong, nonatomic) NSString      *regex;

/*!
 * \brief   state
 */
@property (strong, nonatomic) NSString      *state;

/*!
 * \brief   subscriber only
 */
@property (assign, nonatomic) BOOL          subscriber_only;

/*!
 * \brief   url
 */
@property (strong, nonatomic) NSString      *url;

@end
