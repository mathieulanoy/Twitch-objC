//
//  VideoPlayerView.m
//  TwitchPlayerSDK
//
//  Created by Mathieu LANOY on 22/01/2015.
//  Copyright (c) 2015 Mathieu LANOY. All rights reserved.
//

#import "VideoPlayerView.h"

@implementation VideoPlayerView

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayer*)player {
    return [(AVPlayerLayer*)[self layer] player];
}

- (void)setPlayer: (AVPlayer*)player {
    [(AVPlayerLayer*)[self layer] setPlayer:player];
}

- (void)setVideoFillMode: (NSString *)fillMode {
    AVPlayerLayer *playerLayer = (AVPlayerLayer*)[self layer];
    playerLayer.videoGravity = fillMode;
}

@end
