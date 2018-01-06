//
//  NSDictionary+JSON.m
//  Formation
//
//  Created by Marc FERRY on 8/26/13.
//  Copyright (c) 2013 Marc FERRY. All rights reserved.
//

#import "NSDictionary+JSON.h"
#import "NSString+RegEx.h"

@implementation NSDictionary (JSON)

- (NSString *)getStringForKey:(NSString *)aKey
{
    if ([[self objectForKey:aKey] isKindOfClass:[NSString class]])
    {
        return [self objectForKey:aKey];
    }

    return nil;
}

- (BOOL)getBoolForKey:(NSString *)aKey withDefaultValue:(BOOL)defaultVal
{
    if ([[self objectForKey:aKey] isKindOfClass:[NSNumber class]])
    {
        return [[self objectForKey:aKey] boolValue];
    }

    return defaultVal;
}

- (NSNumber *)getNumberForKey:(NSString *)aKey
{
    if ([[self objectForKey:aKey] isKindOfClass:[NSNumber class]])
    {
        return [self objectForKey:aKey];
    }

    return nil;
}

- (NSDate *)getDateForKey:(NSString *)aKey withFormat:(NSString *)aFormat
{
    if ([[self objectForKey:aKey] isKindOfClass:[NSString class]])
    {

        NSDateFormatter *parser = [[NSDateFormatter alloc] init];
        [parser setDateFormat:aFormat];
        NSDate *date = [parser dateFromString:[self objectForKey:aKey]];

        return date;
    }

    return nil;
}

- (NSArray *)getArrayForKey:(NSString *)aKey
{
    if ([[self objectForKey:aKey] isKindOfClass:[NSArray class]])
    {
        return [self objectForKey:aKey];
    }

    return nil;
}

- (NSDictionary *)getDictionaryForKey:(NSString *)aKey
{
    if ([[self objectForKey:aKey] isKindOfClass:[NSDictionary class]])
    {
        return [self objectForKey:aKey];
    }

    return nil;
}

- (NSArray *)getDictionaryKeysForKey:(NSString *)aKey
{
    if ([[self objectForKey:aKey] isKindOfClass:[NSDictionary class]])
    {
        return [[self objectForKey:aKey] allKeys];;
    }

    return nil;
}

- (id)getObjectAtPath:(NSString *)aPath
{
    NSMutableArray *myWords = [[NSMutableArray alloc] initWithArray:[aPath componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/[]"]]];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSMutableArray *aggArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *aggDic = [[NSMutableDictionary alloc] initWithDictionary:self];
    NSString *pattern = @"/?(\\w|-| )+(\\[\\d+\\])*(/\\w+(\\[\\d+\\])*)*";
    id obj;
 
    // Is the path valid ?
    if (![aPath checkStringForPattern:pattern])
        return nil;

    for (int i = 0; i+1 < [myWords count]; i++)
    {
        if ([myWords[i+1] isEqualToString:@""] && [formatter numberFromString:myWords[i]])
            myWords[i] = [formatter numberFromString:myWords[i]];
    }

    [myWords removeObject:@""];

    for (int i = 0; i < [myWords count]; i++)
    {
        id value = myWords[i];

        if ([value isKindOfClass:[NSNumber class]] || [value length] > 0)
        {
            if ([value isKindOfClass:[NSNumber class]])
            {
                if ([aggArray count] == 0)
                    break;
                obj = [aggArray objectAtIndex:[value integerValue]];
            }
            else
            {
                if ([aggDic count] == 0)
                    break;
                obj = [aggDic objectForKey:value];
            }

            if (obj == nil)
                break;
            if ((i+1 < [myWords count]) && [obj isKindOfClass:[NSDictionary class]])
            {
                aggDic = [[NSMutableDictionary alloc] initWithDictionary:obj];
                [aggArray removeAllObjects];
            }
            else if ((i+1 < [myWords count]) && [obj isKindOfClass:[NSArray class]])
            {
                aggArray = [[NSMutableArray alloc] initWithArray:obj];
                [aggDic removeAllObjects];
            }
            else
                return obj;
        }
    }

    return nil;
}

-(NSString *) getStringAtPath:(NSString *)aPath
{
    id result = [self getObjectAtPath:aPath];

    if ([result isKindOfClass:[NSString class]])
    {
        return result;
    }

    return nil;
}

-(NSString *) getEmptyStringAtPath:(NSString *)aPath
{
    id result = [self getObjectAtPath:aPath];
    
    if ([result isKindOfClass:[NSString class]])
    {
        return result;
    }
    
    return @"";
}

-(NSDictionary *) getDictionaryAtPath:(NSString *)aPath
{
    id result = [self getObjectAtPath:aPath];

    if ([result isKindOfClass:[NSDictionary class]])
    {
        return result;
    }

    return nil;
}

-(NSArray *) getArrayAtPath:(NSString *)aPath
{
    id result = [self getObjectAtPath:aPath];

    if ([result isKindOfClass:[NSArray class]])
    {
        return result;
    }

    return nil;
}

-(NSNumber *) getNumberAtPath:(NSString *)aPath
{
    id result = [self getObjectAtPath:aPath];

    if ([result isKindOfClass:[NSNumber class]])
    {
        return result;
    }

    return nil;
}

-(NSInteger) getIntFromNumberAtPath:(NSString *)aPath defaultValue:(NSInteger)defaultValue
{
    id result = [self getObjectAtPath:aPath];
    
    if ([result isKindOfClass:[NSNumber class]])
    {
        return [result integerValue];
    }
    
    return defaultValue;
}

-(int) getBoolAtPath:(NSString *)aPath defaultValue:(BOOL)defaultValue
{
    id result = [self getObjectAtPath:aPath];
    
    if ([result isKindOfClass:[NSNumber class]])
    {
        return [result boolValue];
    }
    
    return defaultValue;
}

- (NSDate *)getDateAtPath:(NSString *)aPath withFormat:(NSString *)aFormat
{
    id result = [self getObjectAtPath:aPath];

    if ([result isKindOfClass:[NSString class]])
    {
        NSDateFormatter *parser = [[NSDateFormatter alloc] init];
        [parser setDateFormat:aFormat];
        NSDate *date = [parser dateFromString:result];

        return date;
    }

    return nil;
}

@end
