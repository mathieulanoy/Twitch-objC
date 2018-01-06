//
//  TTChatMessageCell.h
//  TwitchChatSDK
//
//  Created by Mathieu LANOY on 21/01/2015.
//  Copyright (c) 2015 Mathieu LANOY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTChatUser.h"
#import "TTRoom.h"

@protocol TTChatMessageCellDelegate;

@interface TTChatMessageCell : UICollectionViewCell<UIWebViewDelegate>

@property (assign, nonatomic) id<TTChatMessageCellDelegate>    delegate;

+ (NSString *) cellIdentifier;

+ (CGSize) sizeForMessage:(NSDictionary *) datas
           referenceWidth:(CGFloat) width;

- (void) displayMessage: (NSDictionary *) datas
              emoticons:(NSArray *) emoticons
                 badges:(TTChatBadges *) badges
                   room:(TTRoom *) room
              indexpath:(NSIndexPath *) indexpath;

@end

@protocol TTChatMessageCellDelegate <NSObject>

@optional

- (void) reloadCellAtIndexPath:(NSIndexPath *) indexPath
                        height:(CGFloat) height;

@end
