//
//  UIView+Nib.m
//  TwitchChatSDK
//
//  Created by Mathieu LANOY on 21/01/2015.
//  Copyright (c) 2015 Mathieu LANOY. All rights reserved.
//

#import "UIView+Nib.h"

#define IS_IPAD() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE() (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

@implementation UIView (Nib)

/**
 * This method returns a view from a NIB file
 */

+ (UIView *)viewFromNib {
    
    NSString *className = NSStringFromClass([self class]);
    
    if (IS_IPAD()) {
        NSString *deviceNibName = [NSString stringWithFormat:@"%@_iPad", className];
        if ([[NSBundle mainBundle] pathForResource:deviceNibName
                                            ofType:@"nib"]) {
            return [self viewFromNibNamed:deviceNibName];
        }
    }
    
    if (IS_IPHONE()) {
        NSString *deviceNibName = [NSString stringWithFormat:@"%@_iPhone", className];
        if ([[NSBundle mainBundle] pathForResource:deviceNibName
                                            ofType:@"nib"]) {
            return [self viewFromNibNamed:deviceNibName];
        }
    }
    
    return [self viewFromNibNamed:className];
}


+ (UIView *)viewFromNibNamed:(NSString *)nibName
{
    NSArray *topLevelsObjects = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    for (id currentObject in topLevelsObjects)  {
        if ([currentObject isKindOfClass:[self class]]) {
            return currentObject;
        }
    }
    return nil;
}

+ (UIView *)viewFromNibNamed:(NSString *)nibName bundle:(NSBundle *)bundle
{
    if (!bundle) {
        bundle = [NSBundle mainBundle];
    }
    
    NSArray *topLevelsObjects = [bundle loadNibNamed:nibName owner:nil options:nil];
    for (id currentObject in topLevelsObjects)  {
        if ([currentObject isKindOfClass:[self class]]) {
            return currentObject;
        }
    }
    return nil;
}

@end
