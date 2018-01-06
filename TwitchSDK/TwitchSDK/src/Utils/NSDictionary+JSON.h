//
//  NSDictionary+JSON.h
//  Formation
//
//  Created by Marc FERRY on 8/26/13.
//  Copyright (c) 2013 Marc FERRY. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Checks wheteher or not a key has a value and is of the expected type*/
@interface NSDictionary (JSON)
{
}

/**
 * Checks if the value exists and is a NSString
 * @param aKey key corresponding to the value tested
 * @return The resulting string or nil
 */
- (NSString *)getStringForKey:(NSString *)aKey;

/**
 * Checks if the value exists and is a __NSCFBoolean
 * @param aKey key corresponding to the value tested
 * @param defaultVal Boolean returned if value is incorrect or nil
 * @return The resulting boolean or nil
 */
- (BOOL)getBoolForKey:(NSString *)aKey withDefaultValue:(BOOL)defaultVal;

/**
 * Checks if the value exists and is a NSNumber
 * @param aKey key corresponding to the value tested
 * @return The resulting number or nil
 */
- (NSNumber *)getNumberForKey:(NSString *)aKey;

/**
 * Checks if the value exists and is a NSDate
 * @param aKey key corresponding to the value tested
 * @param aFormat Format used to parse input date
 * @return The resulting date or nil
 */
- (NSDate *)getDateForKey:(NSString *)aKey withFormat:(NSString *)aFormat;

/**
 * Checks if the value exists and is a NSArray
 * @param aKey key corresponding to the value tested
 * @return The resulting array or nil
 */
- (NSArray *)getArrayForKey:(NSString *)aKey;

/**
 * Checks if the value exists and is a NSDictionary
 * @param aKey key corresponding to the value tested
 * @return The resulting dictionary or nil
 */
- (NSDictionary *)getDictionaryForKey:(NSString *)aKey;

/**
 * Checks if the value exists, is a NSDictionary and get its keys
 * @param aKey key corresponding to the value tested
 * @return The resulting array containing all keys or nil
 */
- (NSArray *)getDictionaryKeysForKey:(NSString *)aKey;

/**
 * Get an object from a JSON fragment from its path
 * @param aPath path corresponding to the value researched
 * @return The resulting object
 */
- (id)getObjectAtPath:(NSString *)aPath;

/**
 * Get a string from a JSON fragment from its path
 * @param aPath path corresponding to the value researched
 * @return The resulting string or nil
 */
- (NSString *)getStringAtPath:(NSString *)aPath;

/**
 * Get a string from a JSON fragment from its path
 * @param aPath path corresponding to the value researched
 * @return The resulting string or empty string
 */
- (NSString *)getEmptyStringAtPath:(NSString *)aPath;

/**
 * Get a dictionary from a JSON fragment from its path
 * @param aPath path corresponding to the value researched
 * @return The resulting dictionary
 */
- (NSDictionary *)getDictionaryAtPath:(NSString *)aPath;

/**
 * Get an array from a JSON fragment from its path
 * @param aPath path corresponding to the value researched
 * @return The resulting array
 */
- (NSArray *)getArrayAtPath:(NSString *)aPath;

/**
 * Get a number from a JSON fragment from its path
 * @param aPath path corresponding to the value researched
 * @return The resulting number
 */
- (NSNumber *)getNumberAtPath:(NSString *)aPath;

/**
 * Get an integer stored in a number from a JSON fragment from its path
 * @param aPath path corresponding to the value researched
 * @param defaultValue the value set if the result from query number is nil
 * @return The resulting number
 */
-(NSInteger) getIntFromNumberAtPath:(NSString *)aPath defaultValue:(NSInteger)defaultValue;

/**
 * Get an boolean stored in a number from a JSON fragment from its path
 * @param aPath path corresponding to the value researched
 * @param defaultValue the value set if the result from query number is nil
 * @return The resulting boolean
 */
-(int) getBoolAtPath:(NSString *)aPath defaultValue:(BOOL)defaultValue;

/**
 * Checks if the value exists and is a NSDate
 * @param aPath path corresponding to the value researched
 * @param aFormat Format used to parse input date
 * @return The resulting date or nil
 */
- (NSDate *)getDateAtPath:(NSString *)aPath withFormat:(NSString *)aFormat;

@end
