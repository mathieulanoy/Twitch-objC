//
//  TTStreamQualityCell.h
//  TwitchPlayerSDK
//
//  Created by Mathieu LANOY on 26/01/2015.
//  Copyright (c) 2015 Mathieu LANOY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwitchSDK/TwitchSDK.h>

@interface TTStreamQualityCell : UICollectionViewCell

+ (NSString *) cellIdentifier;

- (void) displayFormat:(TTStreamFormat *) format selected:(BOOL) selected;

@end
