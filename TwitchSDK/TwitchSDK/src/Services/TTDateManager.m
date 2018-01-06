//
//  TTDateManager.m
//  TwitchSDK
//
//  Created by Mathieu LANOY on 14/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTDateManager.h"

@implementation TTDateManager

static NSDateFormatter  *webServiceDateFormatter = nil;
static NSDateFormatter  *hourFormatter = nil;
static NSDateFormatter  *dayFormatter = nil;
static NSDateFormatter  *iso8601Formatter = nil;
static NSDateFormatter  *fullIso8601Formatter = nil;
static NSDateFormatter  *dayMonthPickerFormatter = nil;
static NSDateFormatter  *birthdayFormatter = nil;
static NSDateFormatter  *dayMonthFormatter = nil;
static NSDateFormatter  *fullDateFormatter = nil;

+ (NSDateFormatter *)webServiceDateFormatter
{
    if (!webServiceDateFormatter) {
        webServiceDateFormatter = [[NSDateFormatter alloc] init];
        [webServiceDateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    return webServiceDateFormatter;
}

+ (NSDateFormatter *)hourFormatter
{
    if (!hourFormatter) {
        hourFormatter = [[NSDateFormatter alloc] init];
        [hourFormatter setDateFormat:@"HH:mm"];
    }
    return hourFormatter;
}

+ (NSDateFormatter *)dayFormatter
{
    if (!dayFormatter) {
        dayFormatter = [[NSDateFormatter alloc] init];
        [dayFormatter setDateFormat:@"d MMMM"];
    }
    return dayFormatter;
}

// Parse date like : 2013-11-18T23:00:00Z
+ (NSDateFormatter *)ISO8601Formatter
{
    if (!iso8601Formatter) {
        iso8601Formatter = [[NSDateFormatter alloc] init];
        [iso8601Formatter setTimeZone:[NSTimeZone localTimeZone]];
        iso8601Formatter.locale = [NSLocale systemLocale];
        [iso8601Formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    }
    return iso8601Formatter;
}

// Parse date like : 2013-11-18T23:00:00Z
+ (NSDateFormatter *)fullISO8601Formatter
{
    if (!fullIso8601Formatter) {
        fullIso8601Formatter = [[NSDateFormatter alloc] init];
        [fullIso8601Formatter setTimeZone:[NSTimeZone localTimeZone]];
        fullIso8601Formatter.locale = [NSLocale systemLocale];
        [fullIso8601Formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"];
    }
    return fullIso8601Formatter;
}

+ (NSDateFormatter *)dayMonthPickerFormatter {
    if (!dayMonthPickerFormatter) {
        dayMonthPickerFormatter = [[NSDateFormatter alloc] init];
        [dayMonthPickerFormatter setDateFormat:@"ccc\ndd/MM"];
    }
    return dayMonthPickerFormatter;
}

+ (NSDateFormatter *)birthdayFormatter {
    if (!birthdayFormatter) {
        birthdayFormatter = [[NSDateFormatter alloc] init];
        [birthdayFormatter setDateFormat:@"MMM d, yyyy"];
    }
    return birthdayFormatter;
}

+ (NSDateFormatter *)dayMonthFormatter {
    if (!dayMonthFormatter) {
        dayMonthFormatter = [[NSDateFormatter alloc] init];
        [dayMonthFormatter setDateFormat:@"dd/MM"];
    }
    return dayMonthFormatter;
}

+ (NSDateFormatter *)dayMonthFormatterUS {
    if (!dayMonthFormatter) {
        dayMonthFormatter = [[NSDateFormatter alloc] init];
        [dayMonthFormatter setDateFormat:@"MM/dd"];
    }
    return dayMonthFormatter;
}

+ (NSDateFormatter *)fullDateFormatter {
    if (!fullDateFormatter) {
        fullDateFormatter = [[NSDateFormatter alloc] init];
        [fullDateFormatter setDateFormat:@"EEEE dd MMMM yyyy, HH'h'mm"];
    }
    return fullDateFormatter;
}

@end
