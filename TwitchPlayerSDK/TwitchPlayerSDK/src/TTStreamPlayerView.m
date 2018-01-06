//
//  TTStreamPlayerView.m
//  TwitchPlayerSDK
//
//  Created by Mathieu LANOY on 22/01/2015.
//  Copyright (c) 2015 Mathieu LANOY. All rights reserved.
//

#import "TTStreamPlayerView.h"
#import <TwitchSDK/TwitchSDK.h>
#import "VideoPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "NSBundle+TwitchPlayerSDK.h"
#import "TTStreamQualityCell.h"

#define kTwitchAutoKey                          @"auto"
#define kTracksKey                              @"tracks"
#define kStatusKey                              @"status"
#define kCurrentItemKey                         @"currentItem"
#define AVPlayerStatusObservationContext        @"AVPlayerStatusObservationContext"
#define AVPlayerCurrentItemObservationContext   @"AVPlayerCurrentItemObservationContext"

@interface TTStreamPlayerView()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSTimer             *control_timer;
}
@property (strong, nonatomic) NSArray                   *stream_formats;
@property (assign, nonatomic) NSUInteger                format_selected;

#pragma mark - AVFoundation
@property (weak, nonatomic) IBOutlet VideoPlayerView    *playerView;
@property (strong, nonatomic) AVPlayer                  *player;
@property (strong, nonatomic) AVPlayerItem              *playerItem;

#pragma mark - Controls
@property (weak, nonatomic) IBOutlet UIView             *v_controls;
@property (weak, nonatomic) IBOutlet UIButton           *bt_fullscreen;
@property (weak, nonatomic) IBOutlet UIButton           *bt_sound;
@property (strong, nonatomic) MPVolumeView              *sound_slider;

#pragma mark - Quality
@property (weak, nonatomic) IBOutlet UIButton           *bt_quality;
@property (weak, nonatomic) IBOutlet UICollectionView   *cv_quality;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *quality_height;

- (IBAction)sound_click:(id)sender;
- (IBAction)fullscreen_click:(id)sender;
- (IBAction)quality_click:(id)sender;

#pragma mark - Quality View
@property (weak, nonatomic) IBOutlet UIView *v_quality;

#pragma mark - Gesture
- (IBAction)video_tapped:(UITapGestureRecognizer *)sender;

@end

@implementation TTStreamPlayerView

- (void) createPlayerForChannel:(NSString *) channel {
    self.v_quality.alpha = 0.0f;
    self.v_controls.alpha = 0.0f;
    [self initControls];
    TTStreamPlayerView __weak *this = self;
    [TTCore getStreamPlaylistForChannel:channel success:^(NSArray *playlists) {
        this.stream_formats = playlists;
        NSUInteger n = 0;
        for (; n < [this.stream_formats count]; n++){
            TTStreamFormat *format = this.stream_formats[n];
            if ([format.name isEqualToString:kTwitchAutoKey]){
                break;
            }
        }
        if (n >= [this.stream_formats count]){
            this.format_selected = 0;
        }
        else {
            this.format_selected = n;
        }
        [this loadStream];
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerView:didLoadChannel:)]){
            [self.delegate playerView:self didLoadChannel:channel];
        }
    } failure:^(NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(playerView:failedToLoadChannel:)]){
            [self.delegate playerView:self failedToLoadChannel:channel];
        }
    }];
}

- (void) loadStream {
    [self.cv_quality reloadData];
    self.quality_height.constant = [self.stream_formats count] * 25.0f;
    [self.cv_quality layoutIfNeeded];
    TTStreamFormat  *stream_format = _stream_formats[_format_selected];
    [self.bt_quality setTitle:[stream_format.name capitalizedString] forState:UIControlStateNormal];
    self.bt_quality.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.bt_quality.titleLabel.minimumScaleFactor = .5;
    [self playURL:[NSURL URLWithString:stream_format.url]];
    if (self.v_controls.alpha == 0.0f){
        [self toggleControls];
    }
}

#pragma mark - Controls
- (void) initControls {
    self.cv_quality.delegate = self;
    self.cv_quality.dataSource = self;
    NSString *identifier = [TTStreamQualityCell cellIdentifier];
    [self.cv_quality registerNib:[UINib nibWithNibName:identifier bundle:[NSBundle TwitchPlayerResourcesBundle]] forCellWithReuseIdentifier:identifier];
    self.v_quality.backgroundColor = [UIColor clearColor];
    self.v_quality.layer.borderColor = [UIColor colorWithRed:119.0f/255.0f green:119.0f/255.0f blue:119.0f/255.0f alpha:1.0f].CGColor;
    self.v_quality.layer.borderWidth = 1.0f;
    if (!self.sound_slider){
        self.sound_slider = [[MPVolumeView alloc] init];
        self.sound_slider.showsRouteButton = NO;
        [self.sound_slider setVolumeThumbImage:[UIImage imageNamed:@"img_ttplayer_slider_selector" inBundle:[NSBundle TwitchPlayerResourcesBundle] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [self.sound_slider setMinimumVolumeSliderImage:[[UIImage imageNamed:@"img_ttplayer_slider_on" inBundle:[NSBundle TwitchPlayerResourcesBundle] compatibleWithTraitCollection:nil] stretchableImageWithLeftCapWidth:1.0f topCapHeight:0.0] forState:UIControlStateNormal];
        [self.sound_slider setMaximumVolumeSliderImage:[[UIImage imageNamed:@"img_ttplayer_slider_off" inBundle:[NSBundle TwitchPlayerResourcesBundle] compatibleWithTraitCollection:nil] stretchableImageWithLeftCapWidth:1.0f topCapHeight:0.0] forState:UIControlStateNormal];
        [self.v_controls addSubview:self.sound_slider];
        [self.sound_slider setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSArray *vertical_constraint = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]-|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:@{@"view":self.sound_slider}];
        
        NSArray *horizontal_constraint = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[mute]-[view(90)]"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:@{@"mute":self.bt_sound, @"view":self.sound_slider}];
        [self.v_controls addConstraints:vertical_constraint];
        [self.v_controls addConstraints:horizontal_constraint];
    }
}

- (void) toggleControls {
    if (control_timer){
        [control_timer invalidate];
        control_timer = nil;
    }
    if (self.v_controls.alpha == 0.0f){
        [UIView animateWithDuration:0.5f animations:^{
            self.v_controls.alpha = 1.0f;
        } completion:^(BOOL finished) {
            control_timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(toggleControls) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:control_timer forMode:NSDefaultRunLoopMode];
        }];
    }
    else {
        [UIView animateWithDuration:0.5f animations:^{
            self.v_controls.alpha = 0.0f;
        }];
    }
}

#pragma mark - AVFoundation
- (void)playURL:(NSURL*) url {
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerViewWillBeginLoadingVideo:)]){
        [self.delegate playerViewWillBeginLoadingVideo:self];
    }
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
    NSArray *requestedKeys = [NSArray arrayWithObjects:kTracksKey, nil];
    [asset loadValuesAsynchronouslyForKeys:requestedKeys
                         completionHandler: ^{
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [self prepareToPlayAsset:asset
                                                 withKeys:requestedKeys];
                             });
                         }];
}

- (void)prepareToPlayAsset: (AVURLAsset *)asset
                  withKeys: (NSArray *)requestedKeys {
    for (NSString *thisKey in requestedKeys) {
        NSError *error = nil;
        AVKeyValueStatus keyStatus = [asset
                                      statusOfValueForKey:thisKey
                                      error:&error];
        if (keyStatus == AVKeyValueStatusFailed) {
            return;
        }
        else if (keyStatus == AVKeyValueStatusCancelled) {
            return;
        }
        else if (keyStatus == AVKeyValueStatusLoading) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(playerViewWillBeginLoadingVideo:)]){
                [self.delegate playerViewWillBeginLoadingVideo:self];
            }
            return;
        }
        else if (keyStatus == AVKeyValueStatusUnknown) {
            return;
        }
        else if (keyStatus == AVKeyValueStatusLoaded) {
            if (self.playerItem) {
                [self.playerItem removeObserver:self forKeyPath:kStatusKey];
                [[NSNotificationCenter defaultCenter] removeObserver:self
                                                                name:AVPlayerItemDidPlayToEndTimeNotification
                                                              object:self.playerItem];
            }
            self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
            [self.playerItem addObserver:self forKeyPath:kStatusKey
                                 options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                                 context:AVPlayerStatusObservationContext];
            if (![self player]) {
                [self setPlayer:[AVPlayer playerWithPlayerItem:self.playerItem]];
                [self.player addObserver:self forKeyPath:kCurrentItemKey
                                 options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                                 context:AVPlayerCurrentItemObservationContext];
            }
            
            if (self.player.currentItem != self.playerItem) {
                [[self player] replaceCurrentItemWithPlayerItem:self.playerItem];
            }
        }
    }
}

#pragma mark - Key Valye Observing

- (void)observeValueForKeyPath: (NSString*) path
                      ofObject: (id)object
                        change: (NSDictionary*)change
                       context: (void*)context {
    if (context == AVPlayerStatusObservationContext) {
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        if (status == AVPlayerStatusReadyToPlay) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(playerViewDidFinishLoadingVideo:)]){
                [self.delegate playerViewDidFinishLoadingVideo:self];
            }
            [self.player play];
        }
    }
    else if (context == AVPlayerCurrentItemObservationContext) {
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        
        if (newPlayerItem) {
            [self.playerView setPlayer:self.player];
            [self.playerView setVideoFillMode:AVLayerVideoGravityResizeAspect];
        }
    } else {
        [super observeValueForKeyPath:path
                             ofObject:object
                               change:change
                              context:context];
    }
}

- (IBAction)fullscreen_click:(id)sender {
}

- (IBAction)quality_click:(id)sender {
    if (self.v_quality.alpha == 0.0f){ // SHOW QUALITY
        if (control_timer){
            [control_timer invalidate];
            control_timer = nil;
        }
        [UIView animateWithDuration:0.5 animations:^{
            self.v_quality.alpha = 1.0f;
        }];
    }
    else { // HIDE QUALITY
        [UIView animateWithDuration:0.5 animations:^{
            self.v_quality.alpha = 0.0f;
        } completion:^(BOOL finished) {
            control_timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(toggleControls) userInfo:nil repeats:NO];
            [[NSRunLoop mainRunLoop] addTimer:control_timer forMode:NSDefaultRunLoopMode];
        }];
    }
}

- (IBAction)sound_click:(id)sender {
    if (self.player){
        self.player.muted = !self.player.muted;
        self.bt_sound.selected = self.player.muted;
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.stream_formats)
        return [self.stream_formats count];
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [TTStreamQualityCell cellIdentifier];
    TTStreamQualityCell *cell = [self.cv_quality dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    TTStreamFormat *format = self.stream_formats[indexPath.item];
    TTStreamFormat *current_format = self.stream_formats[self.format_selected];
    [cell displayFormat:format selected:[format.name isEqualToString:current_format.name]];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item >= [self.stream_formats count]){
        return;
    }
    TTStreamFormat *current_format = self.stream_formats[self.format_selected];
    TTStreamFormat *stream_format = self.stream_formats[indexPath.item];
    if ([stream_format.name isEqualToString:current_format.name]){
        [self quality_click:nil];
        return;
    }
    self.format_selected = indexPath.item;
    [self loadStream];
    [self.cv_quality reloadData];
    [self quality_click:nil];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.cv_quality.frame.size.width, 25.0f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0f;
}


#pragma mark - TapGestureRecognizer
- (IBAction)video_tapped:(UITapGestureRecognizer *)sender {
    if (self.v_quality.alpha == 1.0f){
        [self quality_click:nil];
    }
    else {
        [self toggleControls];
    }
}

@end
