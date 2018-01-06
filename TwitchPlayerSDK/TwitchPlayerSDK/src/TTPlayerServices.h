//
//  TTPlayerServices.h
//  TwitchPlayerSDK
//
//  Created by Mathieu LANOY on 22/01/2015.
//  Copyright (c) 2015 Mathieu LANOY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTStreamPlayerView.h"

@interface TTPlayerServices : NSObject

// ****************************************************************************
#pragma mark - Player Singleton

/*!
 * \brief   Get instance of chat service model
 * \return  instancetype    service instanciated
 */
+ (instancetype) sharedPlayer;

// ****************************************************************************
#pragma mark - UI

+ (TTStreamPlayerView *) getViewforPlayer;

@end
