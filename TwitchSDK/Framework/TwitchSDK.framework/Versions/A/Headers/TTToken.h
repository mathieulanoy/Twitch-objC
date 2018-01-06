//
//  TTToken.h
//  TwitchSDK
//
//  Created by Mathieu LANOY on 15/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTModel.h"

@interface TTToken : TTModel

@property (strong, nonatomic) NSArray   *scopes;
@property (strong, nonatomic) NSDate    *created_at;
@property (strong, nonatomic) NSDate    *updated_at;
@property (strong, nonatomic) NSString  *user_name;
@property (assign, nonatomic) BOOL      valid;

@end
