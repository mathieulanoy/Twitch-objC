//
//  TTStreamPlayerView.h
//  TwitchPlayerSDK
//
//  Created by Mathieu LANOY on 22/01/2015.
//  Copyright (c) 2015 Mathieu LANOY. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTStreamPlayerViewDelegate;

@interface TTStreamPlayerView : UIView

@property (assign, nonatomic) id<TTStreamPlayerViewDelegate>    delegate;

/*!
 * \brief   create player and play for channel
 * \param   channel user twitch channel to stream
 * \return  void
 */
- (void) createPlayerForChannel:(NSString *) channel;

@end

@protocol TTStreamPlayerViewDelegate <NSObject>

@optional

- (void) playerView:(TTStreamPlayerView *) view didLoadChannel:(NSString *) channel;

- (void) playerView:(TTStreamPlayerView *) view failedToLoadChannel:(NSString *) channel;

- (void) playerViewWillBeginLoadingVideo:(TTStreamPlayerView *) view;

- (void) playerViewDidFinishLoadingVideo:(TTStreamPlayerView *) view;

@end