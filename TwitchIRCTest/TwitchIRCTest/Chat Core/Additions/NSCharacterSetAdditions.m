#import "NSCharacterSetAdditions.h"

@implementation NSCharacterSet (Additions)
+ (NSCharacterSet *) illegalXMLCharacterSet {
	static NSMutableCharacterSet *illegalSet = nil;
	if (!illegalSet) {
		illegalSet = [[NSCharacterSet characterSetWithRange:NSMakeRange( 0, 0x1f )] mutableCopy];

		[illegalSet removeCharactersInRange:NSMakeRange( 0x09, 1 )];

		[illegalSet addCharactersInRange:NSMakeRange( 0x7f, 1 )];
		[illegalSet addCharactersInRange:NSMakeRange( 0xfffe, 1 )];
		[illegalSet addCharactersInRange:NSMakeRange( 0xffff, 1 )];

		illegalSet = [illegalSet copy];
	}

	return [illegalSet copy];
}
@end
