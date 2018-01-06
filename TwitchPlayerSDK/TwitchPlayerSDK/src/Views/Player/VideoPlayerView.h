//
//  VideoPlayerView.h
//  TwitchPlayerSDK
//
//  Created by Mathieu LANOY on 22/01/2015.
//  Copyright (c) 2015 Mathieu LANOY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoPlayerView : UIView

+ (Class)layerClass;
- (AVPlayer*)player;
- (void)setPlayer:(AVPlayer*)player;
- (void)setVideoFillMode:(NSString *)fillMode;

@end
