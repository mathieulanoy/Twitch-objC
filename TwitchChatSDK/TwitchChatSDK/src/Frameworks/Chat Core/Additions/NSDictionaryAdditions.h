#import <Foundation/NSDictionary.h>

@interface NSDictionary (NSDictionaryAdditions)
+ (NSDictionary *) dictionaryWithKeys:(NSArray *) keys fromDictionary:(NSDictionary *) dictionary;

@property (readonly, copy) NSData *postDataRepresentation; // doesn't support form data
@end

@interface NSMutableDictionary (NSDictionaryAdditions)
- (instancetype) initWithKeys:(NSArray *) keys fromDictionary:(NSDictionary *) dictionary;
- (void) setObjectsForKeys:(NSArray *) keys fromDictionary:(NSDictionary *) dictionary;;
@end
