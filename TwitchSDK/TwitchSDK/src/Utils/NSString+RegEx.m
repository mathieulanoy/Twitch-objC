//
//  NSString+RegEx.m
//  Formation
//
//  Created by Marc FERRY on 9/5/13.
//  Copyright (c) 2013 Marc FERRY. All rights reserved.
//

#import "NSString+RegEx.h"

@implementation NSString (RegEx)

- (BOOL)checkStringForPattern:(NSString *)pattern
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
 
    NSRange textRange = NSMakeRange(0, self.length);
    NSRange matchRange = [regex rangeOfFirstMatchInString:self options:NSMatchingReportProgress range:textRange];

    if (matchRange.length != [self length])
        return NO;
    else
        return YES;
}

@end
