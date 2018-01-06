//
//  NSString+M3U8.m
//  TwitchSDK
//
//  Created by Mathieu LANOY on 16/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "NSString+M3U8.h"

@implementation NSString (M3U8)

- (NSArray *) parseM3U8 {
    NSLog(@"%@", self);
    
    if ([self length] == 0)
        return nil;
    
    /**
     The Extended M3U file format defines two tags: EXTM3U and EXTINF.  An
     Extended M3U file is distinguished from a basic M3U file by its first
     line, which MUST be #EXTM3U.
     
     reference url:http://tools.ietf.org/html/draft-pantos-http-live-streaming-00
     */
    NSRange rangeOfEXTM3U = [self rangeOfString:M3U8_EXTM3U];
    if (rangeOfEXTM3U.location == NSNotFound ||
        rangeOfEXTM3U.location != 0) {
        return nil;
    }

    NSRange segmentRange = [self rangeOfString:M3U8_EXTINF];
    NSString *remainingSegments = self;
    
    while (NSNotFound != segmentRange.location) {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        
        // Read the EXTINF number between #EXTINF: and the comma
        NSRange commaRange = [remainingSegments rangeOfString:@","];
        NSRange valueRange = NSMakeRange(segmentRange.location + 8, commaRange.location - (segmentRange.location + 8));
        if (commaRange.location == NSNotFound || valueRange.location > remainingSegments.length -1)
            break;
        
        NSString *value = [remainingSegments substringWithRange:valueRange];
        [params setValue:value forKey:M3U8_EXTINF_DURATION];
        
        // ignore the #EXTINF line
        remainingSegments = [remainingSegments substringFromIndex:segmentRange.location];
        NSRange extinfoLFRange = [remainingSegments rangeOfString:@"\n"];
        remainingSegments = [remainingSegments substringFromIndex:extinfoLFRange.location + 1];
        
        // Read the segment link, and ignore line start with # && blank line
        while (1) {
            NSRange lfRange = [remainingSegments rangeOfString:@"\n"];
            NSString *line = [remainingSegments substringWithRange:NSMakeRange(0, lfRange.location)];
            line = [line stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            remainingSegments = [remainingSegments substringFromIndex:lfRange.location + 1];
            
            if ([line characterAtIndex:0] != '#' && 0 != line.length) {
                // remove the CR character '\r'
                unichar lastChar = [line characterAtIndex:line.length - 1];
                if (lastChar == '\r') {
                    line = [line substringToIndex:line.length - 1];
                }
                
                [params setValue:line forKey:M3U8_EXTINF_URI];
                break;
            }
        }
        
        M3U8SegmentInfo *segment = [[M3U8SegmentInfo alloc] initWithDictionary:params];
        if (segment) {
            [segmentInfoList addSegementInfo:segment];
        }
        
        segmentRange = [remainingSegments rangeOfString:M3U8_EXTINF];
    }

    return nil;
}

@end
