//
//  TTHTTPSessionManager.h
//  TwitchSDK
//
//  Created by Mathieu LANOY on 13/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface TTHTTPSessionManager : AFHTTPSessionManager

+ (instancetype)sharedClient;
+ (instancetype)sharedStreamClient;

@property (strong, nonatomic) NSString  *apiClientId;

@property (strong, nonatomic) NSString  *user_token;

- (NSURLSessionDataTask *)GET:(NSString *)path
                   parameters:(id)parameters
                        cache:(BOOL)cache
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end

extern NSString * const TwitchUsherUrl;
