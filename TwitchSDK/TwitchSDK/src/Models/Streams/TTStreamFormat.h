//
//  TTStreamFormat.h
//  TwitchSDK
//
//  Created by Mathieu LANOY on 17/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTStreamFormat : NSObject

/*!
 *  \brief stream format name
 */
@property (strong, nonatomic) NSString  *name;

/*!
 *  \brief stream bandwidth
 */
@property (assign, nonatomic) NSInteger bandwidth;

/*!
 *  \brief m3u8 url
 */
@property (strong, nonatomic) NSString  *url;

@end
