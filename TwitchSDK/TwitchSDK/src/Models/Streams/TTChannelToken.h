//
//  TTChannelToken.h
//  TwitchSDK
//
//  Created by Mathieu LANOY on 16/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTModel.h"

@interface TTChannelToken : TTModel

/*!
 * \brief   should be NO, might restrict the stream to non mobile devices
 */
@property (assign, nonatomic) BOOL      mobile_restricted;

/*!
 * \brief   The 20 bytes hex-string representing the signature
 */
@property (strong, nonatomic) NSString  *sig;

/*!
 * \brief   should be null since we are making anonymous API calls
 */
@property (strong, nonatomic) NSString  *user_id;

/*!
 * \brief   should echo the requested channel name
 */
@property (strong, nonatomic) NSString  *channel;

/*!
 * \brief   a UNIX time stamp giving the expiry date of the token. Tokens seem to be valid 15 minutes. (You only need the token to get the stream url, once you have to url, you don’t have to send the token again for the entire duration of the live broadcast.)
 */
@property (assign, nonatomic) NSInteger expires;

/*!
 * \brief   Unix timestamp, usually set to December 31, 2030
 */
@property (assign, nonatomic) NSInteger view_until;

/*!
 * \brief   The token can probably be restricted to certain bitrates, but should be an empty array in general.
 */
@property (strong, nonatomic) NSArray   *restricted_bitrates;

/*!
 * \brief   should be YES
 */
@property (assign, nonatomic) BOOL      allowed_to_view;

/*!
 * \brief   usually NO, might be related to you subscription status.
 */
@property (assign, nonatomic) BOOL      privileged;

/*!
 * \brief   should be NO, if YES then the source quality might be unavailable
 */
@property (assign, nonatomic) BOOL      source_restricted;

@property (strong, nonatomic) NSString  *token;

@end
