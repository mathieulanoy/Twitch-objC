//
//  NSString+RegEx.h
//  Formation
//
//  Created by Marc FERRY on 9/5/13.
//  Copyright (c) 2013 Marc FERRY. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Checks pattern matching */
@interface NSString (RegEx)

/**
 * Checks if a string matches a pattern
 * @param pattern pattern to match the string with
 * @return Boolean indicating the match result
 */
- (BOOL)checkStringForPattern:(NSString *)pattern;

@end
