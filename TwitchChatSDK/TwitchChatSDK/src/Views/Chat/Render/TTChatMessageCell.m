//
//  TTChatMessageCell.m
//  TwitchChatSDK
//
//  Created by Mathieu LANOY on 21/01/2015.
//  Copyright (c) 2015 Mathieu LANOY. All rights reserved.
//

#import "TTChatMessageCell.h"
#import "NSBundle+TwitchChatSDK.h"
#import <TwitchSDK/TwitchSDK.h>

@interface TTChatMessageCell()

@property (assign, nonatomic) CGFloat           height;

@property (strong, nonatomic) NSDictionary      *datas;

@property (strong, nonatomic) UIWebView         *webView;

@property (strong, nonatomic) NSIndexPath       *indexPath;

@end

@implementation TTChatMessageCell

- (void)layoutSubviews{
    [super layoutSubviews];
    
    BOOL contentViewIsAutoresized = CGSizeEqualToSize(self.frame.size, self.contentView.frame.size);
    
    if( !contentViewIsAutoresized) {
        CGRect contentViewFrame = self.contentView.frame;
        contentViewFrame.size = self.frame.size;
        self.contentView.frame = contentViewFrame;
    }
}


+ (NSString *) cellIdentifier {
    return NSStringFromClass(self);
}

+ (CGSize) sizeForMessage:(NSDictionary *) datas
           referenceWidth:(CGFloat) width {
    NSString *height_str = datas[@"height"];
    CGFloat height = 0.0f;
    if (height_str){
        height = [height_str floatValue];
    }
    if (height == 0.0f){
        return CGSizeMake(width, height);
    }
    return CGSizeMake(width, height + 10.0f);
}

- (void) displayMessage: (NSDictionary *) datas
              emoticons:(NSArray *) emoticons
                 badges:(TTChatBadges *) badges
                   room:(TTRoom *) room
              indexpath:(NSIndexPath *) indexpath{
    if (indexpath.item % 2 == 0){
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.4f];
    }
    else {
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6f];
    }
    
    self.datas = datas;
    
    self.indexPath = indexpath;
    
    if (self.webView){
        self.webView.delegate = nil;
        [self.webView removeFromSuperview];
    }
    self.webView = [[UIWebView alloc] init];
    self.webView.userInteractionEnabled = NO;
    self.webView.delegate = self;
    self.webView.frame = CGRectMake(25.0f, 5.0f, self.frame.size.width - 50.0f, self.frame.size.height - 10.0f);
    [self addSubview:self.webView];
    
    NSDateFormatter *df = [NSDateFormatter new];
    df.dateFormat = @"HH:mm";
    NSString *date_str = [df stringFromDate:datas[@"time"]];
    TTChatUser *user = datas[@"user"];
    
    NSString *user_name = @"";
    if (room && badges){
        NSArray *moderators = [room getModerators];
        for (TTChatUser *moderator in moderators){
            if ([[moderator getDisplayName] isEqualToString:[user getDisplayName]]){
                user_name = [user_name stringByAppendingFormat:@"<img src=\"%@\" style=\"width: 15px; height: 15px;\"/> ", badges.mod.image];
                break;
            }
        }
    }
    user_name = [user_name stringByAppendingString:[user getDisplayName]];
    NSDictionary *dict = @{@"__DATE__" : date_str,
                           @"__AUTHOR__" : user_name,
                           @"__MESSAGE__" : datas[@"message"]};
    
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    
    NSString *path = [[NSBundle TwitchChatResourcesBundle] pathForResource:@"chatMessage" ofType:@"html"];
    NSString *htmlTemplate = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSMutableString *htmlContent = [NSMutableString stringWithString:htmlTemplate];
    for (NSString *key in [dict allKeys]) {
        [htmlContent replaceOccurrencesOfString:key
                                     withString:[dict objectForKey:key]
                                        options:NSCaseInsensitiveSearch
                                          range:NSMakeRange(0, [htmlContent length])];
    }

    NSMutableString *mut_htmlContent = [NSMutableString stringWithString:htmlContent];
    for (TTChatEmoticon *emoticon in emoticons){
        [mut_htmlContent replaceOccurrencesOfString:emoticon.regex
                                         withString:[NSString stringWithFormat:@"<img src=\"%@\" style=\"width: 20px; height: 20px;\"/>", emoticon.url]
                                            options:NSLiteralSearch
                                              range:NSMakeRange(0, [htmlContent length])];
    }
    [self.webView loadHTMLString:mut_htmlContent baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat contentHeight = webView.scrollView.contentSize.height;
    self.height = contentHeight;
    
    if (!self.datas)
        return;
    NSString *height_str = self.datas[@"height"];
    CGFloat height = 0.0f;
    if (height_str){
        height = [height_str floatValue];
    }
    if (height != contentHeight){
        if (self.delegate && [self.delegate respondsToSelector:@selector(reloadCellAtIndexPath:height:)]){
            [self.delegate reloadCellAtIndexPath:self.indexPath height:self.height];
        }
    }
}

@end
