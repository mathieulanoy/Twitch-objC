//
//  TTGame.h
//  TwitchSDK
//
//  Created by Mathieu LANOY on 13/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTModel.h"
#import "TTPicture.h"
#import "TTLink.h"

@interface TTGame : TTModel

/*!
 * \brief   Name of the game
 */
@property (strong, nonatomic) NSString          *name;

/*!
 * \brief   Id of the game
 */
@property (assign, nonatomic) NSInteger         game_id;

/*!
 * \brief   Giantbomb id of the game ("http://www.giantbomb.com")
 */
@property (assign, nonatomic) NSInteger         giantbomb_id;

/*!
 * \brief   game's popularity
 */
@property (assign, nonatomic) NSInteger         popularity;

/*!
 * \brief   Box picture
 */
@property (strong, nonatomic) TTPicture         *box;

/*!
 * \brief   Game's logo
 */
@property (strong, nonatomic) TTPicture         *logo;

/*!
 * \brief   Game's images
 */
@property (strong, nonatomic) TTPicture         *images;

/*!
 * \brief   Links
 */
@property (strong, nonatomic) TTLink            *link;


@end
