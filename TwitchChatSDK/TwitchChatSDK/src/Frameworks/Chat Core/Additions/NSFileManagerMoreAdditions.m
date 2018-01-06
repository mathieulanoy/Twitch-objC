#import "NSFileManagerMoreAdditions.h"

@implementation NSFileManager (MoreAdditions)
// Image formats from https://developer.apple.com/library/ios/#documentation/uikit/reference/UIImage_Class/Reference/Reference.html
+ (BOOL) isValidImageFormat:(NSString *) extension {
	static NSArray *validExtensions = nil;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		validExtensions = @[ @"tiff", @"tif", @"jpg", @"jpeg", @"gif", @"png", @"bmp", @"bmpf", @"ico", @"cur", @"xbm", @"svg" ];
	});

	return [validExtensions containsObject:[extension lowercaseString]];
}

// Audio and video formats from http://developer.apple.com/library/ios/DOCUMENTATION/AppleApplications/Reference/SafariWebContent/SafariWebContent.pdf
+ (BOOL) isValidAudioFormat:(NSString *) extension {
	static NSArray *validExtensions = nil;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		validExtensions = @[ @"aac", @"aiff", @"aif", @"aifc", @"cdda", @"amr", @"mp3", @"swa", @"mpeg", @"mpg", @"mp3", @"m4a", @"m4b", @"m4p" ];
	});

	return [validExtensions containsObject:[extension lowercaseString]];
}

+ (BOOL) isValidVideoFormat:(NSString *) extension {
	static NSArray *validExtensions = nil;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		validExtensions = @[ @"3gp", @"3gpp", @"3g2", @"3gp2", @"mp4", @"mov", @"qt", @"mqv", @"m4v" ];
	});

	return [validExtensions containsObject:[extension lowercaseString]];
}

@end
