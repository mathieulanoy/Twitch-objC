//
//  TTTopGame.h
//  TwitchSDK
//
//  Created by Mathieu LANOY on 14/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTModel.h"
#import "TTGame.h"

@interface TTTopGame : TTModel

/*!
 * \brief   Total number of viewers
 */
@property (assign, nonatomic) NSInteger         viewers;

/*!
 * \brief   Total number of channels
 */
@property (assign, nonatomic) NSInteger         channels;

/*!
 * \brief   current game 
 */
@property (strong, nonatomic) TTGame            *game;

@end
