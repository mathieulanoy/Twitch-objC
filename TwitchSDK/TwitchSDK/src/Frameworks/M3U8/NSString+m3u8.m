//
//  NSString+m3u8.m
//  M3U8Kit
//
//  Created by Oneday on 13-1-11.
//  Copyright (c) 2013年 0day. All rights reserved.
//

#import "NSString+m3u8.h"
#import "M3U8TagsAndAttributes.h"
#import "TTStreamFormat.h"

@implementation NSString (m3u8)


- (NSArray *) m3u8Segments {
    if (0 == self.length)
        return @[];
    
    NSRange rangeOfEXTM3U = [self rangeOfString:M3U8_EXTM3U];
    if (rangeOfEXTM3U.location == NSNotFound ||
        rangeOfEXTM3U.location != 0) {
        return @[];
    }
    
    NSMutableArray  *ar_stream_format = [NSMutableArray new];
    
    NSRange lineRange = [self rangeOfString:@"\n"];
    NSString *remainingSegments = self;
    TTStreamFormat  *stream_format = [TTStreamFormat new];
    while (NSNotFound != lineRange.location){
        NSString *line = [remainingSegments substringWithRange:NSMakeRange(0, lineRange.location)];
        NSRange mediaRange = [line rangeOfString:M3U8_EXT_X_MEDIA];
        NSRange streamRange = [line rangeOfString:M3U8_EXT_X_STREAM_INF];
        if (NSNotFound != mediaRange.location && mediaRange.location == 0){
            /*!
             *  \brief fetch name
             */
            NSRange nameRange = [line rangeOfString:M3U8_EXT_X_MEDIA_NAME];
            if (NSNotFound != nameRange.location) {
                line = [line substringFromIndex:(nameRange.location + nameRange.length + 2)];
                NSRange quoteRange = [line rangeOfString:@"\""];
                if (NSNotFound != quoteRange.location) {
                    NSString *name = [line substringToIndex:quoteRange.location];
                    if (stream_format){
                        stream_format.name = name;
                    }
                }
            }
            remainingSegments = [self goToNextLine:remainingSegments];
            lineRange = [remainingSegments rangeOfString:@"\n"];
        }
        else if (NSNotFound != streamRange.location && streamRange.location == 0){
            /*!
             *  \brief fetch bandwidth
             */
            NSRange bandwidthRange = [line rangeOfString:M3U8_EXT_X_STREAM_INF_BANDWIDTH];
            if (NSNotFound != bandwidthRange.location) {
                NSString *bandwith_line = [line substringFromIndex:(bandwidthRange.location + bandwidthRange.length + 1)];
                NSRange comaRange = [bandwith_line rangeOfString:@","];
                if (NSNotFound != comaRange.location) {
                    NSString *bandwidth_str = [bandwith_line substringToIndex:comaRange.location];
                    NSInteger bandwidth = [bandwidth_str integerValue];
                    if (stream_format){
                        stream_format.bandwidth = bandwidth;
                    }
                }
            }
            
            remainingSegments = [self goToNextLine:remainingSegments];
            lineRange = [remainingSegments rangeOfString:@"\n"];
        }
        else { //ignore line
            NSRange httpRange = [line rangeOfString:@"http"];
            /*!
             *  \brief fetch stream url
             */
            if (NSNotFound != httpRange.location){
                NSString *url = line;
                if (stream_format){
                    stream_format.url = url;
                    [ar_stream_format addObject:stream_format];
                    stream_format = [TTStreamFormat new];
                } else {
                    stream_format = [TTStreamFormat new];
                    stream_format.url = url;
                    stream_format.name = @"unknown";
                    [ar_stream_format addObject:stream_format];
                    stream_format = [TTStreamFormat new];
                }
            }
            remainingSegments = [self goToNextLine:remainingSegments];
            lineRange = [remainingSegments rangeOfString:@"\n"];
        }
    }
    
    return ar_stream_format;
}

    
- (NSString *) goToNextLine:(NSString *) content {
    NSRange lfRange = [content rangeOfString:@"\n"];
    NSString *line = [content substringWithRange:NSMakeRange(0, lfRange.location)];
    line = [line stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    content = [content substringFromIndex:lfRange.location + 1];
    
    if (0 != line.length) {
        // remove the CR character '\r'
        unichar lastChar = [line characterAtIndex:line.length - 1];
        if (lastChar == '\r') {
            line = [line substringToIndex:line.length - 1];
        }
    }
    return content;
}

@end
