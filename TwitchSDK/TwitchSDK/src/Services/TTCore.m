//
//  TTCore.m
//  TwitchSDK
//
//  Created by Mathieu LANOY on 13/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTCore.h"
#import "TTSession.h"
#import "TTHTTPSessionManager.h"
#import "NSDictionary+JSON.h"
#import "TTChannelToken.h"
#import "TTStreamFormat.h"
#import "TTChatEmoticon.h"
#import "NSString+m3u8.h"

NSString *const TTCoreDidFetchUserNotification = @"TTCoreDidFetchUserNotification";

@interface TTCore ()

/*!
 * \brief   This method parses an array of dictionary representing objects and creates the array
 * \param   array               array of objects to parse
 * \param   class               Class of generated object
 * \param   createFromJsonDict  selector to use on the class in order to parse the object
 * \return  Array of objects from Class param parsed with createFromJsonDict selector
 */
+ (NSArray *)parseArray:(NSArray *)array ofObjectType:(Class)class withSelector:(SEL)createFromJSONDict;

/*!
 * \brief   Returns an access token for :channel
 * \param   name    channel name
 * \param   success block called on success
 * \param   failure block called on failure
 * \return  void
 */
+ (void)getAccessTokenForChannel:(NSString *) channel
                         success:(void (^)(TTChannelToken *token))success
                         failure:(void (^)(NSError *error))failure;

@end

@implementation TTCore

// ****************************************************************************
#pragma mark - Global methods

+ (NSArray *)parseArray:(NSArray *)array ofObjectType:(Class)class withSelector:(SEL)createFromJSONDict {
    NSMutableArray *resultArray = nil;
    
    if (array) {
        resultArray = [NSMutableArray array];
        id tmpObject = nil;
        
        for (id dict in array) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                _Pragma("clang diagnostic push")
                _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")
                tmpObject = [class performSelector:createFromJSONDict withObject:dict];
                _Pragma("clang diagnostic pop")
                if (tmpObject) {
                    [resultArray addObject:tmpObject];
                }
            }
        }
    }
    return resultArray;
}

// ****************************************************************************
#pragma mark - Setup

+ (void) setClientID:(NSString *) clientID {
    [TTHTTPSessionManager sharedClient].apiClientId = clientID;
    [[TTSession sharedSession] setClientID:clientID];
}

// ****************************************************************************
#pragma mark - General Status and top level links

+ (void)getAuthorizationStatusWithSuccess:(void (^)(TTToken *, TTLink *))success
                                  failure:(void (^)(NSError *error))failure{
    [[TTHTTPSessionManager sharedClient] GET:@"" parameters:nil cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            TTToken *token = [TTToken generateModelFromDictionary:[jsonDict getDictionaryAtPath:@"token"]];
            TTLink *links = [TTLink generateModelFromDictionary:[jsonDict getDictionaryAtPath:@"_links"]];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(token, links);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}


// ****************************************************************************
#pragma mark - User

+ (void)getUserWithSuccess:(void (^)(TTUser *))success
                   failure:(void (^)(NSError *error))failure{
    [[TTHTTPSessionManager sharedClient] GET:@"user" parameters:nil cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            TTUser *user = [TTUser generateModelFromDictionary:jsonDict];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [[TTSession sharedSession] setUser:user];
                [[NSNotificationCenter defaultCenter] postNotificationName:TTCoreDidFetchUserNotification object:nil];
                if (success)
                    success(user);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getUser:(NSString *) user
        success:(void (^)(TTUser *))success
        failure:(void (^)(NSError *error))failure{
    [[TTHTTPSessionManager sharedClient] GET:[NSString stringWithFormat:@"users/%@", user] parameters:nil cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            TTUser *user = [TTUser generateModelFromDictionary:jsonDict];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(user);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getStreamsFollowedWithLimit:(NSInteger) limit
                             offset:(NSInteger) offset
                                HLS:(BOOL) hls
                            success:(void (^)(NSInteger total, TTLink *link, NSArray *streams))success
                            failure:(void (^)(NSError *error))failure {
    NSDictionary *parameters = @{@"limit": @(limit > 100 ? 100 : limit),
                                 @"offset":@(offset),
                                 @"hls":(hls ? @"true" : @"false")};
    [[TTHTTPSessionManager sharedClient] GET:@"streams/followed" parameters:parameters cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSArray *ar_streams = [self parseArray:[jsonDict getArrayAtPath:@"streams"] ofObjectType:[TTStream class] withSelector:@selector(generateModelFromDictionary:)];
            NSInteger total = [jsonDict getIntFromNumberAtPath:@"_total" defaultValue:0];
            TTLink *link = [TTLink generateModelFromDictionary:[jsonDict getDictionaryAtPath:@"_links"]];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(total, link, ar_streams);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getVideosFollowedWithLimit:(NSInteger) limit
                            offset:(NSInteger) offset
                           success:(void (^)(TTLink *link, NSArray *videos))success
                           failure:(void (^)(NSError *error))failure {
    NSDictionary *parameters = @{@"limit": @(limit > 100 ? 100 : limit),
                                 @"offset":@(offset)};
    [[TTHTTPSessionManager sharedClient] GET:@"videos/followed" parameters:parameters cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSArray *ar_videos = [self parseArray:[jsonDict getArrayAtPath:@"videos"] ofObjectType:[TTVideo class] withSelector:@selector(generateModelFromDictionary:)];
            TTLink *link = [TTLink generateModelFromDictionary:[jsonDict getDictionaryAtPath:@"_links"]];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(link, ar_videos);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];

}


// ****************************************************************************
#pragma mark - Games

+ (void)getTopGamesWithLimit:(NSInteger) limit
                      offset:(NSInteger) offset
                         HLS:(BOOL) hls
                     success:(void (^)(NSInteger total, TTLink *link, NSArray *games))success
                     failure:(void (^)(NSError *error))failure{
    NSDictionary *parameters = @{@"limit": @(limit > 100 ? 100 : limit),
                                 @"offset":@(offset),
                                 @"hls":(hls ? @"true" : @"false")};
    [[TTHTTPSessionManager sharedClient] GET:@"games/top" parameters:parameters cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSArray *ar_games = [self parseArray:[jsonDict getArrayAtPath:@"top"] ofObjectType:[TTTopGame class] withSelector:@selector(generateModelFromDictionary:)];
            NSInteger total = [jsonDict getIntFromNumberAtPath:@"_total" defaultValue:0];
            TTLink *link = [TTLink generateModelFromDictionary:[jsonDict getDictionaryAtPath:@"_links"]];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(total, link, ar_games);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

// ****************************************************************************
#pragma mark - Teams

+ (void)getTeamsWithLimit:(NSInteger) limit
                   offset:(NSInteger) offset
                  success:(void (^)(TTLink *link, NSArray *teams))success
                  failure:(void (^)(NSError *error))failure {
    NSDictionary *parameters = @{@"limit": @(limit > 100 ? 100 : limit),
                                 @"offset":@(offset)};
    [[TTHTTPSessionManager sharedClient] GET:@"teams" parameters:parameters cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSArray *ar_teams = [self parseArray:[jsonDict getArrayAtPath:@"teams"] ofObjectType:[TTTeam class] withSelector:@selector(generateModelFromDictionary:)];
            TTLink *link = [TTLink generateModelFromDictionary:[jsonDict getDictionaryAtPath:@"_links"]];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(link, ar_teams);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getTeam:(NSString *) name
        success:(void (^)(TTTeam *team))success
        failure:(void (^)(NSError *error))failure {
    [[TTHTTPSessionManager sharedClient] GET:[NSString stringWithFormat:@"teams/%@", name] parameters:nil cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            TTTeam *team = [TTTeam generateModelFromDictionary:jsonDict];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(team);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

// ****************************************************************************
#pragma mark - Channels

+ (void)getChannel:(NSString *) channel
           success:(void (^)(TTChannel *channel))success
           failure:(void (^)(NSError *error))failure{
    [[TTHTTPSessionManager sharedClient] GET:[NSString stringWithFormat:@"channels/%@", channel] parameters:nil cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            TTChannel *channel = [TTChannel generateModelFromDictionary:jsonDict];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(channel);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getChannelWithSuccess:(void (^)(TTChannel *channel))success
                      failure:(void (^)(NSError *error))failure {
    [[TTHTTPSessionManager sharedClient] GET:@"channel" parameters:nil cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            TTChannel *channel = [TTChannel generateModelFromDictionary:jsonDict];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(channel);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)updateChannel:(NSString *) channel
                Title:(NSString *) title
                 game:(NSString *) game
                delay:(NSInteger) delay
              success:(void (^)(TTChannel *channel))success
              failure:(void (^)(NSError *error))failure{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (title && [title length] > 0){
        parameters[@"status"] = title;
    }
    if (game && [game length] > 0){
        parameters[@"game"] = game;
    }
    parameters[@"delay"] = @(delay);
    [[TTHTTPSessionManager sharedClient] PUT:[NSString stringWithFormat:@"channels/%@", channel] parameters:@{@"channel":parameters} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            TTChannel *channel = [TTChannel generateModelFromDictionary:jsonDict];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(channel);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)resetChannelStreamKey:(NSString *) channel
                      success:(void (^)())success
                      failure:(void (^)(NSError *error))failure {
    [[TTHTTPSessionManager sharedClient] DELETE:[NSString stringWithFormat:@"channels/%@/stream_key", channel] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                if (success)
                    success();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)startCommercialOnChannel:(NSString *) channel
                          length:(TTCommercialLength) length
                         success:(void (^)())success
                         failure:(void (^)(NSError *error))failure {
    NSDictionary *parameter = nil;
    if (length != TTCommercialLengthNone){
        parameter = @{@"length": @(length)};
    }
    [[TTHTTPSessionManager sharedClient] POST:[NSString stringWithFormat:@"channels/%@/commercial", channel] parameters:parameter success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success)
            success();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getEditorsForChannel:(NSString *) channel
                     success:(void (^)(TTLink *link, NSArray *editors))success
                     failure:(void (^)(NSError *error))failure {
    [[TTHTTPSessionManager sharedClient] GET:[NSString stringWithFormat:@"channels/%@/editors", channel] parameters:nil cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            TTLink *link = [TTLink generateModelFromDictionary:[jsonDict getDictionaryAtPath:@"_links"]];
            NSArray *ar_users = [self parseArray:[jsonDict getArrayAtPath:@"users"] ofObjectType:[TTUser class] withSelector:@selector(generateModelFromDictionary:)];

            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(link, ar_users);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getTeamsForChannel:(NSString *) channel
                   success:(void (^)(TTLink *link, NSArray *teams))success
                   failure:(void (^)(NSError *error))failure {
    [[TTHTTPSessionManager sharedClient] GET:[NSString stringWithFormat:@"channels/%@/teams", channel] parameters:nil cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            TTLink *link = [TTLink generateModelFromDictionary:[jsonDict getDictionaryAtPath:@"_links"]];
            NSArray *ar_teams = [self parseArray:[jsonDict getArrayAtPath:@"teams"] ofObjectType:[TTTeam class] withSelector:@selector(generateModelFromDictionary:)];
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(link, ar_teams);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getAccessTokenForChannel:(NSString *) channel
                         success:(void (^)(TTChannelToken *))success
                         failure:(void (^)(NSError *error))failure {
    [[TTHTTPSessionManager sharedStreamClient] GET:[NSString stringWithFormat:@"channels/%@/access_token", channel] parameters:nil cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            TTChannelToken *token = [TTChannelToken generateModelFromDictionary:jsonDict];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(token);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getStreamPlaylistForChannel:(NSString *) channel
                            success:(void (^)(NSArray  *playlists)) success
                            failure:(void (^)(NSError *error)) failure {
    [self getAccessTokenForChannel:channel success:^(TTChannelToken *token) {
        NSString *letters = @"0123456789";
        NSMutableString *randomString = [NSMutableString stringWithCapacity: 6];
        for (int i=0; i<6; i++) {
            u_int32_t r = arc4random() % [letters length];
            unichar c = [letters characterAtIndex:r];
            [randomString appendFormat:@"%C", c];
        }
        
        NSString *encodedToken = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                     NULL,
                                                                                     (CFStringRef)token.token,
                                                                                     NULL,
                                                                                     (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                     kCFStringEncodingUTF8 ));


        NSString *auto_url = [NSString stringWithFormat:@"%@channel/hls/%@.m3u8?player=twitchweb&token=%@&sig=%@&allow_audio_only=true&allow_source=true&type=any&p=%@", TwitchUsherUrl, channel, encodedToken, token.sig, randomString];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"application/vnd.apple.mpegurl"]];
        
        [manager GET:auto_url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                NSString *m3u8_content = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                TTStreamFormat *auto_format = [TTStreamFormat new];
                auto_format.name = @"auto";
                auto_format.bandwidth = 0;
                auto_format.url = auto_url;
                NSMutableArray  *stream_formats = [NSMutableArray new];
                [stream_formats addObject:auto_format];
                [stream_formats addObjectsFromArray:[m3u8_content m3u8Segments]];
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    if (success)
                        success(stream_formats);
                });
            });
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (failure)
                failure(error);
        }];
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

// ****************************************************************************
#pragma mark - Follows

+ (void)getFollowersForChannel:(NSString *) channel
                         limit:(NSInteger) limit
                        offset:(NSInteger) offset
                     direction:(TTSortingDirection) direction
                       success:(void (^)(NSInteger total, TTLink *link, NSArray *follows))success
                       failure:(void (^)(NSError *error))failure {
    NSString *direction_str = @"desc";
    switch (direction) {
        case TTSortingDirectionDescendant:
            direction_str = @"desc";
            break;
        case TTSortingDirectionAscendant:
            direction_str = @"asc";
            break;
        default:
            break;
    }
    NSDictionary *parameters = @{@"limit": @(limit > 100 ? 100 : limit),
                                 @"offset":@(offset),
                                 @"direction":direction_str};
    [[TTHTTPSessionManager sharedClient] GET:[NSString stringWithFormat:@"channels/%@/follows", channel] parameters:parameters cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSArray *ar_follows = [self parseArray:[jsonDict getArrayAtPath:@"follows"] ofObjectType:[TTFollowUser class] withSelector:@selector(generateModelFromDictionary:)];
            NSInteger total = [jsonDict getIntFromNumberAtPath:@"_total" defaultValue:0];
            TTLink *link = [TTLink generateModelFromDictionary:[jsonDict getDictionaryAtPath:@"_links"]];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(total, link, ar_follows);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getChannelsFollowedByUser:(NSString *) user
                            limit:(NSInteger) limit
                           offset:(NSInteger) offset
                        direction:(TTSortingDirection) direction
                           sortby:(TTSortBy) sortby
                          success:(void (^)(NSInteger total, TTLink *link, NSArray *follows))success
                          failure:(void (^)(NSError *error))failure{
    NSString *direction_str = @"desc";
    switch (direction) {
        case TTSortingDirectionDescendant:
            direction_str = @"desc";
            break;
        case TTSortingDirectionAscendant:
            direction_str = @"asc";
            break;
        default:
            break;
    }
    
    NSString *sortby_str = @"created_at";
    switch (sortby) {
        case TTSortByCreatedAt:
            sortby_str = @"created_at";
            break;
        case TTSortByLastBroadcast:
            sortby_str = @"last_broadcast";
            break;
        default:
            break;
    }
    
    NSDictionary *parameters = @{@"limit": @(limit > 100 ? 100 : limit),
                                 @"offset":@(offset),
                                 @"direction":direction_str,
                                 @"sortby":sortby_str};
    [[TTHTTPSessionManager sharedClient] GET:[NSString stringWithFormat:@"users/%@/follows/channels", user] parameters:parameters cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSArray *ar_follows = [self parseArray:[jsonDict getArrayAtPath:@"follows"] ofObjectType:[TTFollowChannel class] withSelector:@selector(generateModelFromDictionary:)];
            TTLink *link = [TTLink generateModelFromDictionary:[jsonDict getDictionaryAtPath:@"_links"]];
            NSInteger total = [jsonDict getIntFromNumberAtPath:@"_total" defaultValue:0];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(total, link, ar_follows);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void) user:(NSString *) user isFollowingChannel:(NSString *) channel
      success:(void (^)(TTFollowChannel *follow_channel))success
      failure:(void (^)(NSError *error))failure{
    [[TTHTTPSessionManager sharedClient] GET:[NSString stringWithFormat:@"users/%@/follows/channels/%@", user, channel] parameters:nil cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            TTFollowChannel *follow_channel = [TTFollowChannel generateModelFromDictionary:jsonDict];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(follow_channel);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void) user:(NSString *) user followChannel:(NSString *) channel
      success:(void (^)(TTFollowChannel *follow_channel))success
      failure:(void (^)(NSError *error))failure{
    [[TTHTTPSessionManager sharedClient] PUT:[NSString stringWithFormat:@"users/%@/follows/channels/%@", user, channel] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            TTFollowChannel *follow_channel = [TTFollowChannel generateModelFromDictionary:jsonDict];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(follow_channel);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void) user:(NSString *) user unfollowChannel:(NSString *) channel
      success:(void (^)())success
      failure:(void (^)(NSError *error))failure{
    [[TTHTTPSessionManager sharedClient] DELETE:[NSString stringWithFormat:@"users/%@/follows/channels/%@", user, channel] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success)
            success();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

// ****************************************************************************
#pragma mark - Searchs

/*!
 * \brief   Returns a list of channel objects matching the search query
 * \param   query       query
 * \param   limit       Maximum number of objects in array. Maximum is 100
 * \param   offset      Object offset for pagination. Default is 0
 * \param   success     block called on success
 * \param   failure     block called on failure
 * \return  void
 */
+ (void)searchChannels:(NSString *) query
                 limit:(NSInteger) limit
                offset:(NSInteger) offset
               success:(void (^)(NSInteger total, TTLink *link, NSArray *channels))success
               failure:(void (^)(NSError *error))failure {
    
    NSDictionary *parameters = @{@"limit": @(limit > 100 ? 100 : limit),
                                 @"offset":@(offset),
                                 @"q":query};
    [[TTHTTPSessionManager sharedClient] GET:@"search/channels" parameters:parameters cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSArray *ar_channels = [self parseArray:[jsonDict getArrayAtPath:@"channels"] ofObjectType:[TTChannel class] withSelector:@selector(generateModelFromDictionary:)];
            NSInteger total = [jsonDict getIntFromNumberAtPath:@"_total" defaultValue:0];
            TTLink *link = [TTLink generateModelFromDictionary:[jsonDict getDictionaryAtPath:@"_links"]];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(total, link, ar_channels);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)searchStreams:(NSString *) query
                limit:(NSInteger) limit
               offset:(NSInteger) offset
                  hls:(BOOL) hls
              success:(void (^)(TTLink *link, NSArray *streams))success
              failure:(void (^)(NSError *error))failure {
    NSDictionary *parameters = @{@"limit": @(limit > 100 ? 100 : limit),
                                 @"offset":@(offset),
                                 @"q":query,
                                 @"hls": hls ? @"true" : @"false"};
    [[TTHTTPSessionManager sharedClient] GET:@"search/streams" parameters:parameters cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSArray *ar_streams = [self parseArray:[jsonDict getArrayAtPath:@"streams"] ofObjectType:[TTStream class] withSelector:@selector(generateModelFromDictionary:)];
            TTLink *link = [TTLink generateModelFromDictionary:[jsonDict getDictionaryAtPath:@"_links"]];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(link, ar_streams);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)searchGames:(NSString *) query
               live:(BOOL) live
            success:(void (^)(TTLink *link, NSArray *games))success
            failure:(void (^)(NSError *error))failure {
    
    NSDictionary *parameters = @{@"live": (live ? @"true" : @"false"),
                                 @"type":@"suggest",
                                 @"q":query};
    [[TTHTTPSessionManager sharedClient] GET:@"search/games" parameters:parameters cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
    
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSArray *ar_games = [self parseArray:[jsonDict getArrayAtPath:@"games"] ofObjectType:[TTGame class] withSelector:@selector(generateModelFromDictionary:)];
            TTLink *link = [TTLink generateModelFromDictionary:[jsonDict getDictionaryAtPath:@"_links"]];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(link, ar_games);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

// ****************************************************************************
#pragma mark - Streams

+ (void)getStream:(NSString *) channel
          success:(void (^)(TTLink *link, TTStream *stream))success
          failure:(void (^)(NSError *error))failure{
    [[TTHTTPSessionManager sharedClient] GET:[NSString stringWithFormat:@"streams/%@", channel] parameters:nil cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            TTStream *stream = [TTStream generateModelFromDictionary:[jsonDict getDictionaryAtPath:@"stream"]];
            TTLink *link = [TTLink generateModelFromDictionary:[jsonDict getDictionaryAtPath:@"_links"]];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(link, stream);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getStreamsForGame:(NSString *) game
                  channel:(NSString *) channel
                    limit:(NSInteger) limit
                   offset:(NSInteger) offset
               embeddable:(BOOL) embeddable
                      hls:(BOOL) hls
               currentApp:(BOOL) currentApp
                  success:(void (^)(NSInteger total, TTLink *link, NSArray *streams))success
                  failure:(void (^)(NSError *error))failure{
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (game && [game length] > 0)
        parameters[@"game"] = game;
    if (channel && [channel length] > 0)
        parameters[@"channel"] = channel;
    parameters[@"limit"] = @(limit > 100 ? 100 : limit);
    parameters[@"offset"] = @(offset);
    parameters[@"embeddable"] = embeddable ? @"true" : @"false";
    parameters[@"hls"] = hls ? @"true" : @"false";
    NSString *clientId = [TTHTTPSessionManager sharedClient].apiClientId;
    if (currentApp && clientId && [clientId length] > 0){
        parameters[@"client_id"] = clientId;
    }
    
    [[TTHTTPSessionManager sharedClient] GET:@"streams" parameters:parameters cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSArray *ar_streams = [self parseArray:[jsonDict getArrayAtPath:@"streams"] ofObjectType:[TTStream class] withSelector:@selector(generateModelFromDictionary:)];
            NSInteger total = [jsonDict getIntFromNumberAtPath:@"_total" defaultValue:0];
            TTLink *link = [TTLink generateModelFromDictionary:[jsonDict getDictionaryAtPath:@"_links"]];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(total, link, ar_streams);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getStreamsFeaturedWithLimit:(NSInteger) limit
                             offset:(NSInteger) offset
                                hls:(BOOL) hls
                            success:(void (^)(TTLink *link, NSArray *streams))success
                            failure:(void (^)(NSError *error))failure {
    NSDictionary *parameters = @{@"limit": @(limit > 100 ? 100 : limit),
                                 @"offset":@(offset),
                                 @"hls":(hls ? @"true" : @"false")};
    [[TTHTTPSessionManager sharedClient] GET:@"streams/featured" parameters:parameters cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSArray *ar_streams = [self parseArray:[jsonDict getArrayAtPath:@"featured"] ofObjectType:[TTFeaturedStream class] withSelector:@selector(generateModelFromDictionary:)];
            TTLink *link = [TTLink generateModelFromDictionary:[jsonDict getDictionaryAtPath:@"_links"]];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(link, ar_streams);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getStreamsSummaryUsingHLS:(BOOL) hls
                          success:(void (^)(TTLink *link, NSInteger viewers, NSInteger channel))success
                          failure:(void (^)(NSError *error))failure{
    NSDictionary *parameters = @{@"hls":(hls ? @"true" : @"false")};
    [[TTHTTPSessionManager sharedClient] GET:@"streams/summary" parameters:parameters cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            TTLink *link = [TTLink generateModelFromDictionary:[jsonDict getDictionaryAtPath:@"_links"]];
            NSInteger viewers = [jsonDict getIntFromNumberAtPath:@"viewers" defaultValue:0];
            NSInteger channels = [jsonDict getIntFromNumberAtPath:@"channels" defaultValue:0];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(link, viewers, channels);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

// ****************************************************************************
#pragma mark - Subscriptions

/*!
 * \brief   Returns a list of subscription objects sorted by subscription relationship creation date which contain users subscribed to :channel.
 * \param   channel     channel name
 * \param   limit       Maximum number of objects in array. Maximum is 100.
 * \param   offset      Object offset for pagination. Default is 0.
 * \param   direction   Creation date sorting direction. Default is asc. Valid values are asc and desc.
 * \param   success block called on success
 * \param   failure block called on failure
 * \return  void
 */
+ (void)getSubscriptionsForChannel:(NSString *) channel
                             limit:(NSInteger) limit
                            offset:(NSInteger) offset
                         direction:(TTSortingDirection) direction
                           success:(void (^)(NSInteger total, TTLink *link, NSArray *subscriptions))success
                           failure:(void (^)(NSError *error))failure {
    NSString *direction_str = @"desc";
    switch (direction) {
        case TTSortingDirectionDescendant:
            direction_str = @"desc";
            break;
        case TTSortingDirectionAscendant:
            direction_str = @"asc";
            break;
        default:
            break;
    }
    NSDictionary *parameters = @{@"limit": @(limit > 100 ? 100 : limit),
                                 @"offset":@(offset),
                                 @"direction":direction_str};
    [[TTHTTPSessionManager sharedClient] GET:[NSString stringWithFormat:@"channels/%@/subscriptions", channel] parameters:parameters cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSArray *ar_subcriptions = [self parseArray:[jsonDict getArrayAtPath:@"subscriptions"] ofObjectType:[TTSubscription class] withSelector:@selector(generateModelFromDictionary:)];
            TTLink *link = [TTLink generateModelFromDictionary:[jsonDict getDictionaryAtPath:@"_links"]];
            NSInteger total = [jsonDict getIntFromNumberAtPath:@"_total" defaultValue:0];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(total, link, ar_subcriptions);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void) channel:(NSString *) channel hasSubscriber:(NSString *) user
         success:(void (^)(TTSubscription *subscription))success
         failure:(void (^)(NSError *error))failure {
    [[TTHTTPSessionManager sharedClient] GET:[NSString stringWithFormat:@"channels/%@/subscriptions/%@", channel, user] parameters:nil cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            TTSubscription *subscription = [TTSubscription generateModelFromDictionary:jsonDict];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(subscription);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void) user:(NSString *) user hasSubscribedToChannel:(NSString *) channel
      success:(void (^)(TTLink *link, TTChannel *channel))success
      failure:(void (^)(NSError *error))failure {
    [[TTHTTPSessionManager sharedClient] GET:[NSString stringWithFormat:@"users/%@/subscriptions/%@", user, channel] parameters:nil cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            TTLink *link = [TTLink generateModelFromDictionary:[jsonDict getDictionaryAtPath:@"_links"]];
            TTChannel *channel = [TTChannel generateModelFromDictionary:[jsonDict getDictionaryAtPath:@"channel"]];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(link, channel);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

// ****************************************************************************
#pragma mark - Videos

+ (void)getVideo:(NSString *) video_id
         success:(void (^)(TTVideo *video))success
         failure:(void (^)(NSError *error))failure {
    [[TTHTTPSessionManager sharedClient] GET:[NSString stringWithFormat:@"videos/%@", video_id] parameters:nil cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            TTVideo *video = [TTVideo generateModelFromDictionary:jsonDict];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(video);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getTopVideosWithLimit:(NSInteger) limit
                       offset:(NSInteger) offset
                         game:(NSString *) game
                       period:(TTPeriod) period
                      success:(void (^)(TTLink *link, NSArray *videos))success
                      failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *parameters = [NSMutableDictionary new];
    if (game && [game length] > 0){
        parameters[@"game"] = game;
    }
    parameters[@"limit"] = @(limit > 100 ? 100 : limit);
    parameters[@"offset"] = @(offset);
    switch (period) {
        case TTPeriodWeek:
            parameters[@"period"] = @"week";
            break;
        case TTPeriodMonth:
            parameters[@"period"] = @"month";
            break;
        case TTPeriodAll:
            parameters[@"period"] = @"all";
            break;
        default:
            parameters[@"period"] = @"all";
            break;
    }
    [[TTHTTPSessionManager sharedClient] GET:@"videos/top" parameters:parameters cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSArray *ar_videos = [self parseArray:[jsonDict getArrayAtPath:@"videos"] ofObjectType:[TTVideo class] withSelector:@selector(generateModelFromDictionary:)];
            TTLink *link = [TTLink generateModelFromDictionary:[jsonDict getDictionaryAtPath:@"_links"]];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(link, ar_videos);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getVideosFromChannel:(NSString *) channel
                       limit:(NSInteger) limit
                      offset:(NSInteger) offset
                   broadcast:(BOOL) broadcast
                     success:(void (^)(TTLink *link, NSArray *videos))success
                     failure:(void (^)(NSError *error))failure {
    NSDictionary *parameters = @{@"limit": @(limit > 100 ? 100 : limit),
                                 @"offset":@(offset),
                                 @"broadcast":(broadcast ? @"true" : @"false")};
    [[TTHTTPSessionManager sharedClient] GET:[NSString stringWithFormat:@"channels/%@/videos", channel] parameters:parameters cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSArray *ar_videos = [self parseArray:[jsonDict getArrayAtPath:@"videos"] ofObjectType:[TTVideo class] withSelector:@selector(generateModelFromDictionary:)];
            TTLink *link = [TTLink generateModelFromDictionary:[jsonDict getDictionaryAtPath:@"_links"]];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(link, ar_videos);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

// ****************************************************************************
#pragma mark - Blocks

+ (void)getBlockListForUser:(NSString *) user
                      limit:(NSInteger) limit
                     offset:(NSInteger) offset
                    success:(void (^)(TTLink *link, NSArray *blocks))success
                    failure:(void (^)(NSError *error))failure {
    NSDictionary *parameters = @{@"limit": @(limit > 100 ? 100 : limit),
                                 @"offset":@(offset)};
    [[TTHTTPSessionManager sharedClient] GET:[NSString stringWithFormat:@"users/%@/blocks", user] parameters:parameters cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSArray *ar_blocks = [self parseArray:[jsonDict getArrayAtPath:@"blocks"] ofObjectType:[TTBlockUser class] withSelector:@selector(generateModelFromDictionary:)];
            TTLink *link = [TTLink generateModelFromDictionary:[jsonDict getDictionaryAtPath:@"_links"]];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(link, ar_blocks);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)user:(NSString *) user blockUser:(NSString*) userToBlock
     success:(void (^)(TTBlockUser *user))success
     failure:(void (^)(NSError *error))failure {
    [[TTHTTPSessionManager sharedClient] PUT:[NSString stringWithFormat:@"users/%@/blocks/%@", user, userToBlock] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            TTBlockUser *user = [TTBlockUser generateModelFromDictionary:jsonDict];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(user);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)user:(NSString *) user unblockUser:(NSString*) userToBlock
     success:(void (^)())success
     failure:(void (^)(NSError *error))failure {
    [[TTHTTPSessionManager sharedClient] DELETE:[NSString stringWithFormat:@"users/%@/blocks/%@", user, userToBlock] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success)
            success(user);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

// ****************************************************************************
#pragma mark - Chat

+ (void) getEmoticonsForChannel:(NSString *) channel
                        success:(void (^)(NSArray *emoticons))success
                        failure:(void (^)(NSError *error))failure {
    [[TTHTTPSessionManager sharedClient] GET:[NSString stringWithFormat:@"chat/%@/emoticons", channel] parameters:nil cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSArray *ar_emoticons = [self parseArray:[jsonDict getArrayAtPath:@"emoticons"] ofObjectType:[TTChatEmoticon class] withSelector:@selector(generateModelFromDictionary:)];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(ar_emoticons);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void) getBadgesForChannel:(NSString *) channel
                     success:(void (^)(TTChatBadges *))success
                     failure:(void (^)(NSError *error))failure{
    [[TTHTTPSessionManager sharedClient] GET:[NSString stringWithFormat:@"chat/%@/badges", channel] parameters:nil cache:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *jsonDict = (NSDictionary *)responseObject;
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            TTChatBadges *badges = [TTChatBadges generateModelFromDictionary:jsonDict];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                if (success)
                    success(badges);
            });
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

@end
