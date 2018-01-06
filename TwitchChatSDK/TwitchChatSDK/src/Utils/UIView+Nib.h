//
//  UIView+Nib.h
//  TwitchChatSDK
//
//  Created by Mathieu LANOY on 21/01/2015.
//  Copyright (c) 2015 Mathieu LANOY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (Nib)

+ (UIView *)viewFromNib;
+ (UIView *)viewFromNibNamed:(NSString *)nibName;
+ (UIView *)viewFromNibNamed:(NSString *)nibName bundle:(NSBundle *)bundle;

@end
