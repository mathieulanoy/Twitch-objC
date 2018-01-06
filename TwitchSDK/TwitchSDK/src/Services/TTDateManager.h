//
//  TTDateManager.h
//  TwitchSDK
//
//  Created by Mathieu LANOY on 14/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTDateManager : NSObject

+ (NSDateFormatter *)webServiceDateFormatter;
+ (NSDateFormatter *)hourFormatter;
+ (NSDateFormatter *)dayFormatter;
+ (NSDateFormatter *)ISO8601Formatter;
+ (NSDateFormatter *)fullISO8601Formatter;
+ (NSDateFormatter *)dayMonthPickerFormatter;
+ (NSDateFormatter *)birthdayFormatter;
+ (NSDateFormatter *)dayMonthFormatter;
+ (NSDateFormatter *)dayMonthFormatterUS;
+ (NSDateFormatter *)fullDateFormatter;

@end
