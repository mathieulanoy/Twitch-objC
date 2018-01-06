//
//  TTHTTPSessionManager.m
//  TwitchSDK
//
//  Created by Mathieu LANOY on 13/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "TTHTTPSessionManager.h"

static NSString * const TwitchBaseUrl = @"https://api.twitch.tv/";
NSString * const TwitchUsherUrl = @"http://usher.twitch.tv/api/";

static NSString *const  TwitchApiVersion = @"v3";

#define HEADER_X_API_CLIENT_ID      @"Client-ID"
#define HEADER_X_API_AUTHORIZATION  @"Authorization"
#define HEADER_X_API_ACCEPT         @"Accept"

@implementation TTHTTPSessionManager

+ (instancetype)sharedClient {
    static TTHTTPSessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[TTHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@kraken", TwitchBaseUrl]]];
        _sharedClient.apiClientId = @"";
        _sharedClient.user_token = @"";
        [_sharedClient setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey]];
    });
    
    return _sharedClient;
}

+ (instancetype)sharedStreamClient {
    static TTHTTPSessionManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[TTHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:TwitchBaseUrl]];
        _sharedClient.apiClientId = @"";
        _sharedClient.user_token = @"";
        [_sharedClient setSecurityPolicy:[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey]];
    });
    
    return _sharedClient;
}

- (NSString *)generateParamsStringFromDictionary:(NSDictionary *)params{
    NSMutableString *result = [[NSMutableString alloc] init];
    
    NSArray *sortedKeys = [[params allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    for (NSString *key in sortedKeys){
        if ([[params objectForKey:key] isKindOfClass:[NSString class]]){
            NSString *str = [self encodeString:[params objectForKey:key]];
            [result appendFormat:@"%@=%@&", key, str];
        }
        else {
            [result appendFormat:@"%@=%@&", key, [params objectForKey:key]];
        }
    }
    return result;
}

- (NSString *)encodeString:(NSString *)str{
    if (![str isKindOfClass:[NSString class]]){
        return str;
    }
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    str = [str stringByReplacingOccurrencesOfString:@"!" withString:@"%21"];
    str = [str stringByReplacingOccurrencesOfString:@"'" withString:@"%27"];
    str = [str stringByReplacingOccurrencesOfString:@"(" withString:@"%28"];
    str = [str stringByReplacingOccurrencesOfString:@")" withString:@"%29"];
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@"%22"];
    str = [str stringByReplacingOccurrencesOfString:@";" withString:@"%3B"];
    str = [str stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
    str = [str stringByReplacingOccurrencesOfString:@"@" withString:@"%40"];
    str = [str stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    str = [str stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    str = [str stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    str = [str stringByReplacingOccurrencesOfString:@"$" withString:@"%24"];
    str = [str stringByReplacingOccurrencesOfString:@"," withString:@"%2C"];
    str = [str stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    str = [str stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"];
    str = [str stringByReplacingOccurrencesOfString:@"#" withString:@"%23"];
    str = [str stringByReplacingOccurrencesOfString:@"[" withString:@"%5B"];
    str = [str stringByReplacingOccurrencesOfString:@"]" withString:@"%5D"];
    str = [str stringByReplacingOccurrencesOfString:@"<" withString:@"%3C"];
    str = [str stringByReplacingOccurrencesOfString:@">" withString:@"%3E"];
    str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@"%09"];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@"%0A"];
    
    return str;
}

- (NSString *)calculateSHA1FromString:(NSString *)value{
    NSMutableString *result = [[NSMutableString alloc] init];
    
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    NSData *stringBytes = [value dataUsingEncoding:NSUTF8StringEncoding];
    if (CC_SHA1([stringBytes bytes], (CC_LONG)[stringBytes length], digest)){
        for (int i = 0 ; i < CC_SHA1_DIGEST_LENGTH ; ++i){
            [result appendFormat:@"%02x", digest[i]];
        }
    }
    
    return [result lowercaseString];
}

- (NSDictionary *) generateHeaders {
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    if (self.apiClientId && [self.apiClientId length] > 0){
        [headers setObject:self.apiClientId forKey:HEADER_X_API_CLIENT_ID];
    }
    if (self.user_token && [self.user_token length] > 0){
        [headers setObject:[NSString stringWithFormat:@"OAuth %@", self.user_token] forKey:HEADER_X_API_AUTHORIZATION];
    }
    NSString *accept_version = [NSString stringWithFormat:@"application/vnd.twitchtv.%@+json", TwitchApiVersion];
    [headers setObject:accept_version forKey:HEADER_X_API_ACCEPT];
    
    return headers;
}

// ****************************************************************************
#pragma mark - Override of regular method to inject the signature

- (NSURLSessionDataTask *)GET:(NSString *)path
                   parameters:(id)parameters
                        cache:(BOOL)cache
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSString *URLString = [NSString stringWithFormat:@"%@%@", [self.baseURL absoluteString], path];
    NSLog(@"GET => %@", URLString);
    NSDictionary *headerFields = [self generateHeaders];
    
    self.securityPolicy = [AFSecurityPolicy defaultPolicy];
    
    // ----------------------------------------------------------------------
    // Cache
    // ----------------------------------------------------------------------
    NSString *cacheFilePath = nil;
    
    if (cache) {
        NSMutableString *fullURLString = [NSMutableString stringWithString:URLString];
        if (((NSDictionary *)parameters).count) {
            [fullURLString appendString:@"?"];
            [fullURLString appendString:[self generateParamsStringFromDictionary:parameters]];
        }
        
        NSString *cacheKey = [self calculateSHA1FromString:fullURLString];
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        cacheFilePath = [NSString stringWithFormat:@"%@/%@", cachePath, cacheKey];
        
        BOOL isDirectory = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:cacheFilePath isDirectory:&isDirectory]) {
            NSLog(@"Cache response for URL : %@", fullURLString);
            success(nil, [NSKeyedUnarchiver unarchiveObjectWithFile:cacheFilePath]);
        }
    }
    
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    
    // ----------------------------------------------------------------------
    // We add the Headers
    // ----------------------------------------------------------------------
    NSMutableURLRequest *signedRequest = [request mutableCopy];
    for (NSString *headerField in headerFields) {
        [signedRequest setValue:[headerFields objectForKey:headerField] forHTTPHeaderField:headerField];
    }
    
    __block NSURLSessionDataTask *task = [self dataTaskWithRequest:signedRequest completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(task, error);
            }
        } else {
            if (success) {
                
                // We save it to the cache
                if (cache && responseObject && cacheFilePath) {
                    [NSKeyedArchiver archiveRootObject:responseObject toFile:cacheFilePath];
                }
                success(task, responseObject);
            }
        }
    }];
    
    [task resume];
    
    return task;
}

- (NSURLSessionDataTask *)executeRequestAtPath:(NSString *)path
                                        method:(NSString *)method
                                    parameters:(id)parameters
                                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *URLString = [NSString stringWithFormat:@"%@://%@%@/%@", [self.baseURL scheme], [self.baseURL host], [self.baseURL path], path];
    NSLog(@"%@ => %@", method, URLString);
    
    NSDictionary *headerFields = [self generateHeaders];
    
    self.securityPolicy = [AFSecurityPolicy defaultPolicy];
    
    // ----------------------------------------------------------------------
    // We do the job of the super class here except the fact that we override
    // ----------------------------------------------------------------------
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    
    // ----------------------------------------------------------------------
    // We add the Headers
    // ----------------------------------------------------------------------
    NSMutableURLRequest *signedRequest = [request mutableCopy];
    for (NSString *headerField in headerFields) {
        [signedRequest setValue:[headerFields objectForKey:headerField] forHTTPHeaderField:headerField];
    }
    
    __block NSURLSessionDataTask *task = [self dataTaskWithRequest:signedRequest completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        if (error) {
            if (failure) {
                failure(task, error);
            }
        } else {
            if (success) {
                success(task, responseObject);
            }
        }
    }];
    
    [task resume];
    
    return task;
}

- (NSURLSessionDataTask *)GET:(NSString *)path
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    return [self GET:path parameters:parameters cache:YES success:success failure:failure];
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [self executeRequestAtPath:URLString method:@"POST" parameters:parameters success:success failure:failure];
}

- (NSURLSessionDataTask *)PUT:(NSString *)URLString
                   parameters:(id)parameters
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [self executeRequestAtPath:URLString method:@"PUT" parameters:parameters success:success failure:failure];
}

- (NSURLSessionDataTask *)DELETE:(NSString *)URLString
                      parameters:(id)parameters
                         success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    return [self executeRequestAtPath:URLString method:@"DELETE" parameters:parameters success:success failure:failure];
}


@end
