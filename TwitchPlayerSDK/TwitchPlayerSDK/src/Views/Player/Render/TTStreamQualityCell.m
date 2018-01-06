//
//  TTStreamQualityCell.m
//  TwitchPlayerSDK
//
//  Created by Mathieu LANOY on 26/01/2015.
//  Copyright (c) 2015 Mathieu LANOY. All rights reserved.
//

#import "TTStreamQualityCell.h"

@interface TTStreamQualityCell()
@property (unsafe_unretained, nonatomic) IBOutlet UILabel   *lb_title;
@property (strong, nonatomic) TTStreamFormat                *stream_format;
@end

@implementation TTStreamQualityCell

- (void)layoutSubviews{
    [super layoutSubviews];
    
    BOOL contentViewIsAutoresized = CGSizeEqualToSize(self.frame.size, self.contentView.frame.size);
    
    if( !contentViewIsAutoresized) {
        CGRect contentViewFrame = self.contentView.frame;
        contentViewFrame.size = self.frame.size;
        self.contentView.frame = contentViewFrame;
    }
}

+ (NSString *) cellIdentifier{
    return NSStringFromClass(self);
}

- (void) displayFormat:(TTStreamFormat *) format selected:(BOOL) selected{
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    self.lb_title.text = format.name;
    if (!selected){
        self.lb_title.textColor = [UIColor whiteColor];
    }
    else {
        self.lb_title.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
    }
}

@end
