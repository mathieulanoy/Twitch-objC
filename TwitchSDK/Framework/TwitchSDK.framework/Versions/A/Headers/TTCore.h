//
//  TTCore.h
//  TwitchSDK
//
//  Created by Mathieu LANOY on 13/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTLink.h"
#import "TTTopGame.h"
#import "TTUser.h"
#import "TTTeam.h"
#import "TTChannel.h"
#import "TTFollowUser.h"
#import "TTFollowChannel.h"
#import "TTToken.h"
#import "TTStream.h"
#import "TTFeaturedStream.h"
#import "TTSubscription.h"
#import "TTVideo.h"
#import "TTBlockUser.h"

/*!
 * /brief enum used for sort direction
 */
typedef NS_ENUM(NSInteger, TTSortingDirection) {
    TTSortingDirectionDescendant    = 0,
    TTSortingDirectionAscendant     = 1,
};

/*!
 * /brief enum used for sortby key
 */
typedef NS_ENUM(NSInteger, TTSortBy) {
    TTSortByCreatedAt       = 0,
    TTSortByLastBroadcast   = 1,
};

/*!
 * /brief enum used for commercial length
 */
typedef NS_ENUM(NSInteger, TTCommercialLength) {
    TTCommercialLengthNone  = 0,
    TTCommercialLength30    = 30,
    TTCommercialLength60    = 60,
    TTCommercialLength90    = 90,
    TTCommercialLength120    = 120,
    TTCommercialLength150    = 150,
    TTCommercialLength180    = 180,
};

/*!
 * /brief enum used for commercial length
 */
typedef NS_ENUM(NSInteger, TTPeriod) {
    TTPeriodWeek    = 0,
    TTPeriodMonth   = 1,
    TTPeriodAll     = 2,
};

@interface TTCore : NSObject

// ****************************************************************************
#pragma mark - Setup

/*!
 * \brief   setup TTCore with a Client ID in order to ensure that your application is not rate limited
 * \param   clientID    your client ID
 */
+ (void) setClientID:(NSString *) clientID;

// ****************************************************************************
#pragma mark - General Status and top level links

/*!
 * \brief   Get top level links object and authorization status
 * \param   success block called on success
 * \param   failure block called on failure
 * \return  void
 */
+ (void)getAuthorizationStatusWithSuccess:(void (^)(TTToken *, TTLink *))success
                                  failure:(void (^)(NSError *error))failure;



// ****************************************************************************
#pragma mark - User

/*!
 * \brief   fetch current user
 * \brief   required scope: user_read
 * \param   success block called on success
 * \param   failure block called on failure
 * \return  void
 */
+ (void)getUserWithSuccess:(void (^)(TTUser *))success
                   failure:(void (^)(NSError *error))failure;

/*!
 * \brief   fetch a user from name
 * \param   user    user name
 * \param   success block called on success
 * \param   failure block called on failure
 * \return  void
 */
+ (void)getUser:(NSString *) user
        success:(void (^)(TTUser *))success
        failure:(void (^)(NSError *error))failure;

/*!
 * \brief   Returns a list of stream objects that the authenticated user is following.
 * \brief   required scope: user_read
 * \param   limit   Maximum number of objects in array. Maximum is 100
 * \param   offset  Object offset for pagination. Default is 0
 * \param   hls     If set to YES, only returns game objects with streams using HLS
 * \param   success block called on success
 * \param   failure block called on failure
 * \return  void
 */
+ (void)getStreamsFollowedWithLimit:(NSInteger) limit
                             offset:(NSInteger) offset
                                HLS:(BOOL) hls
                            success:(void (^)(NSInteger total, TTLink *link, NSArray *streams))success
                            failure:(void (^)(NSError *error))failure;

/*!
 * \brief   Returns a list of video objects from channels that the authenticated user is following.
 * \brief   required scope: user_read
 * \param   limit   Maximum number of objects in array. Maximum is 100
 * \param   offset  Object offset for pagination. Default is 0
 * \param   success block called on success
 * \param   failure block called on failure
 * \return  void
 */
+ (void)getVideosFollowedWithLimit:(NSInteger) limit
                            offset:(NSInteger) offset
                           success:(void (^)(TTLink *link, NSArray *videos))success
                           failure:(void (^)(NSError *error))failure;


// ****************************************************************************
#pragma mark - Games

/*!
 * \brief   fetch list of top Games
 * \param   limit   Maximum number of objects in array. Maximum is 100
 * \param   offset  Object offset for pagination. Default is 0
 * \param   hls     If set to YES, only returns game objects with streams using HLS
 * \param   success block called on success
 * \param   failure block called on failure
 * \return  void
 */
+ (void)getTopGamesWithLimit:(NSInteger) limit
                      offset:(NSInteger) offset
                         HLS:(BOOL) hls
                     success:(void (^)(NSInteger total, TTLink *link, NSArray *games))success
                     failure:(void (^)(NSError *error))failure;


// ****************************************************************************
#pragma mark - Teams

/*!
 * \brief   fetch list of teams
 * \param   limit   Maximum number of objects in array. Maximum is 100
 * \param   offset  Object offset for pagination. Default is 0
 * \param   success block called on success
 * \param   failure block called on failure
 * \return  void
 */
+ (void)getTeamsWithLimit:(NSInteger) limit
                   offset:(NSInteger) offset
                  success:(void (^)(TTLink *link, NSArray *teams))success
                  failure:(void (^)(NSError *error))failure;

/*!
 * \brief   fetch team model
 * \param   name    team name to fetch
 * \param   success block called on success
 * \param   failure block called on failure
 * \return  void
 */
+ (void)getTeam:(NSString *) name
        success:(void (^)(TTTeam *team))success
        failure:(void (^)(NSError *error))failure;

// ****************************************************************************
#pragma mark - Channels

/*!
 * \brief   fetch channel model
 * \param   name    channel name to fetch
 * \param   success block called on success
 * \param   failure block called on failure
 * \return  void
 */
+ (void)getChannel:(NSString *) channel
           success:(void (^)(TTChannel *channel))success
           failure:(void (^)(NSError *error))failure;

/*!
 * \brief   fetch user channel
 * \brief   required scope: channel_read
 * \param   success block called on success
 * \param   failure block called on failure
 * \return  void
 */
+ (void)getChannelWithSuccess:(void (^)(TTChannel *channel))success
                      failure:(void (^)(NSError *error))failure;

/*!
 * \brief   Update channel's status or game.
 * \brief   required scope: channel_editor
 * \param   channel Channel's name
 * \param   title   Channel's title
 * \param   game    Game category to be classified as
 * \param   Channel delay in seconds
 * \param   success block called on success
 * \param   failure block called on failure
 * \return  void
 */
+ (void)updateChannel:(NSString *) channel
                Title:(NSString *) title
                 game:(NSString *) game
                delay:(NSInteger) delay
              success:(void (^)(TTChannel *channel))success
              failure:(void (^)(NSError *error))failure;

/*!
 * \brief   Resets channel's stream key.
 * \brief   required scope: channel_stream
 * \param   channel Channel's name
 * \param   success block called on success
 * \param   failure block called on failure
 * \return  void
 */
+ (void)resetChannelStreamKey:(NSString *) channel
                      success:(void (^)())success
                      failure:(void (^)(NSError *error))failure;

/*!
 * \brief   Start commercial on channel.
 * \brief   required scope: channel_commercial
 * \param   channel Channel's name
 * \param   length  Length of commercial break in seconds. Default value is 30. Valid values are 30, 60, 90, 120, 150 or 180. You can only trigger a commercial once every 8 minutes.
 * \param   success block called on success
 * \param   failure block called on failure
 * \return  void
 */
+ (void)startCommercialOnChannel:(NSString *) channel
                          length:(TTCommercialLength) length
                         success:(void (^)())success
                         failure:(void (^)(NSError *error))failure;

/*!
 * \brief   Returns a list of user objects who are editors of :channel.
 * \brief   required scope: channel_read
 * \param   name    channel name
 * \param   success block called on success
 * \param   failure block called on failure
 * \return  void
 */
+ (void)getEditorsForChannel:(NSString *) channel
                     success:(void (^)(TTLink *link, NSArray *editors))success
                     failure:(void (^)(NSError *error))failure;

/*!
 * \brief   Returns a list of team objects :channel belongs to.
 * \param   name    channel name
 * \param   success block called on success
 * \param   failure block called on failure
 * \return  void
 */
+ (void)getTeamsForChannel:(NSString *) channel
                   success:(void (^)(TTLink *link, NSArray *teams))success
                   failure:(void (^)(NSError *error))failure;

// ****************************************************************************
#pragma mark - Follows

/*!
 * \brief   Get channel's list of following users
 * \param   channel     channel name
 * \param   limit       Maximum number of objects in array. Maximum is 100
 * \param   offset      Object offset for pagination. Default is 0
 * \param   direction   Creation date sorting direction. Default is desc. Valid values are asc and desc
 * \param   success     block called on success
 * \param   failure     block called on failure
 * \return  void
 */
+ (void)getFollowersForChannel:(NSString *) channel
                         limit:(NSInteger) limit
                        offset:(NSInteger) offset
                     direction:(TTSortingDirection) direction
                       success:(void (^)(NSInteger total, TTLink *link, NSArray *follows))success
                       failure:(void (^)(NSError *error))failure;

/*!
 * \brief   Get a user's list of followed channels
 * \param   channel     user name
 * \param   limit       Maximum number of objects in array. Maximum is 100
 * \param   offset      Object offset for pagination. Default is 0
 * \param   direction   Creation date sorting direction. Default is desc. Valid values are asc and desc
 * \param   sortby      Sort key. Default is created_at. Valid values are created_at and last_broadcast
 * \param   success     block called on success
 * \param   failure     block called on failure
 * \return  void
 */
+ (void) getChannelsFollowedByUser:(NSString *) user
                             limit:(NSInteger) limit
                            offset:(NSInteger) offset
                         direction:(TTSortingDirection) direction
                            sortby:(TTSortBy) sortby
                           success:(void (^)(NSInteger total, TTLink *link, NSArray *follows))success
                           failure:(void (^)(NSError *error))failure;


/*!
 * \brief   Get status of follow relationship between user and target channel
 * \param   user        user name
 * \param   channel     channel name
 * \param   success     block called if user is following channel
 * \param   failure     block called if user is not following
 * \return  void
 */
+ (void) user:(NSString *) user isFollowingChannel:(NSString *) channel
      success:(void (^)(TTFollowChannel *follow_channel))success
      failure:(void (^)(NSError *error))failure;

/*!
 * \brief   Follow a channel
 * \param   user        user name
 * \param   channel     channel name
 * \param   success     block called if user is now following channel
 * \param   failure     block called if failed to follow
 * \return  void
 */
+ (void) user:(NSString *) user followChannel:(NSString *) channel
      success:(void (^)(TTFollowChannel *follow_channel))success
      failure:(void (^)(NSError *error))failure;

/*!
 * \brief   Unfollow a channel
 * \param   user        user name
 * \param   channel     channel name
 * \param   success     block called if user is now unfollowing channel
 * \param   failure     block called if failed to unfollow
 * \return  void
 */
+ (void) user:(NSString *) user unfollowChannel:(NSString *) channel
      success:(void (^)())success
      failure:(void (^)(NSError *error))failure;

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
               failure:(void (^)(NSError *error))failure;


/*!
 * \brief   Returns a list of stream objects matching the search query
 * \param   query       query
 * \param   limit       Maximum number of objects in array. Maximum is 100
 * \param   offset      Object offset for pagination. Default is 0
 * \param   hls         If set to YES, only returns streams using HLS. If set to NO, only returns streams that are non-HLS.
 * \param   success     block called on success
 * \param   failure     block called on failure
 * \return  void
 */
+ (void)searchStreams:(NSString *) query
                limit:(NSInteger) limit
               offset:(NSInteger) offset
                  hls:(BOOL) hls
              success:(void (^)(TTLink *link, NSArray *streams))success
              failure:(void (^)(NSError *error))failure;

/*!
 * \brief   Returns a list of game objects matching the search query
 * \param   query       query
 * \param   live        If YES, only returns games that are live on at least one channel
 * \param   success     block called on success
 * \param   failure     block called on failure
 * \return  void
 */
+ (void)searchGames:(NSString *) query
               live:(BOOL) live
            success:(void (^)(TTLink *link, NSArray *games))success
            failure:(void (^)(NSError *error))failure;

// ****************************************************************************
#pragma mark - Streams

/*!
 * \brief   Returns a stream object if live
 * \param   name    channel name to fetch
 * \param   success block called on success
 * \param   failure block called on failure
 * \return  void
 */
+ (void)getStream:(NSString *) channel
          success:(void (^)(TTLink *link, TTStream *stream))success
          failure:(void (^)(NSError *error))failure;

/*!
 * \brief   Returns a list of stream objects that are queried by a number of parameters sorted by number of viewers descending
 * \param   game        Streams categorized under game (Optional)
 * \param   channel     Streams from a comma separated list of channels (Optional)
 * \param   limit       Maximum number of objects in array. Maximum is 100.
 * \param   offset      Object offset for pagination. Default is 0.
 * \param   embeddable  If set to YES, only returns streams that can be embedded.
 * \param   hls         If set to YES, only returns streams using HLS.
 * \param   currentApp  Only shows streams from applications of client_id.
 * \param   success block called on success
 * \param   failure block called on failure
 * \return  void
 */
+ (void)getStreamsForGame:(NSString *) game
                  channel:(NSString *) channel
                    limit:(NSInteger) limit
                   offset:(NSInteger) offset
               embeddable:(BOOL) embeddable
                      hls:(BOOL) hls
               currentApp:(BOOL) currentApp
                  success:(void (^)(NSInteger total, TTLink *link, NSArray *streams))success
                  failure:(void (^)(NSError *error))failure;

/*!
 * \brief   Returns a list of featured (promoted) stream objects.
 * \param   limit       Maximum number of objects in array. Maximum is 100.
 * \param   offset      Object offset for pagination. Default is 0.
 * \param   hls
 * \param   success block called on success
 * \param   failure block called on failure
 * \return  void
 */
+ (void)getStreamsFeaturedWithLimit:(NSInteger) limit
                             offset:(NSInteger) offset
                                hls:(BOOL) hls
                            success:(void (^)(TTLink *link, NSArray *streams))success
                            failure:(void (^)(NSError *error))failure;

/*!
 * \brief   Returns a summary of current streams.
 * \param   hls
 * \param   success block called on success
 * \param   failure block called on failure
 * \return  void
 */
+ (void)getStreamsSummaryUsingHLS:(BOOL) hls
                          success:(void (^)(TTLink *link, NSInteger viewers, NSInteger channel))success
                          failure:(void (^)(NSError *error))failure;

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
                           failure:(void (^)(NSError *error))failure;

/*!
 * \brief   Returns a subscription object which includes the user if that user is subscribed.
 * \param   channel     channel name
 * \param   user        user name
 * \param   success     block called if user has subscribed to channel
 * \param   failure     block called if user has not subscribed
 * \return  void
 */
+ (void) channel:(NSString *) channel hasSubscriber:(NSString *) user
         success:(void (^)(TTSubscription *subscription))success
         failure:(void (^)(NSError *error))failure;

/*!
 * \brief   Returns a channel object that user subscribes to.
 * \param   user        user name
 * \param   channel     channel name
 * \param   success     block called if user has subscribed to channel
 * \param   failure     block called if user has not subscribed
 * \return  void
 */
+ (void) user:(NSString *) user hasSubscribedToChannel:(NSString *) channel
      success:(void (^)(TTLink *link, TTChannel *channel))success
      failure:(void (^)(NSError *error))failure;

// ****************************************************************************
#pragma mark - Videos

/*!
 * \brief   Returns a video object.
 * \param   video_id    video's id
 * \param   success block called on success
 * \param   failure block called on failure
 * \return  void
 */
+ (void)getVideo:(NSString *) video_id
         success:(void (^)(TTVideo *video))success
         failure:(void (^)(NSError *error))failure;

/*!
 * \brief   Returns a list of videos created in a given time period sorted by number of views, most popular first.
 * \param   limit   Maximum number of objects in array. Maximum is 100
 * \param   offset  Object offset for pagination. Default is 0
 * \param   game    Returns only videos from game (Optional)
 * \param   period  Returns only videos created in time period. Valid values are week, month, or all
 * \param   success block called on success
 * \param   failure block called on failure
 * \return  void
 */
+ (void)getTopVideosWithLimit:(NSInteger) limit
                       offset:(NSInteger) offset
                         game:(NSString *) game
                       period:(TTPeriod) period
                      success:(void (^)(TTLink *link, NSArray *videos))success
                      failure:(void (^)(NSError *error))failure;

/*!
 * \brief   Returns a list of videos ordered by time of creation, starting with the most recent from :channel.
 * \param   limit       Channel's name
 * \param   limit       Maximum number of objects in array. Maximum is 100
 * \param   offset      Object offset for pagination. Default is 0
 * \param   broadcast   Returns only broadcasts when YES. Otherwise only highlights are returned.
 * \param   success     block called on success
 * \param   failure     block called on failure
 * \return  void
 */
+ (void)getVideosFromChannel:(NSString *) channel
                       limit:(NSInteger) limit
                      offset:(NSInteger) offset
                   broadcast:(BOOL) broadcast
                      success:(void (^)(TTLink *link, NSArray *videos))success
                      failure:(void (^)(NSError *error))failure;


// ****************************************************************************
#pragma mark - Blocks

/*!
 * \brief   Returns a list of blocks objects on :user block list. List sorted by recency, newest first.
 * \brief   required scope: user_blocks_read
 * \param   user        user's name
 * \param   limit       Maximum number of objects in array. Maximum is 100
 * \param   offset      Object offset for pagination. Default is 0
 * \param   success     block called on success
 * \param   failure     block called on failure
 * \return  void
 */
+ (void)getBlockListForUser:(NSString *) user
                      limit:(NSInteger) limit
                     offset:(NSInteger) offset
                    success:(void (^)(TTLink *link, NSArray *blocks))success
                    failure:(void (^)(NSError *error))failure;

/*!
 * \brief   Adds :userToBlock to :user's block list. :user is the authenticated user and :target is user to be blocked. Returns a blocks object.
 * \brief   required scope: user_blocks_read
 * \param   user            user's name
 * \param   userToBlock     user to be blocked
 * \param   success         block called on success
 * \param   failure         block called on failure
 * \return  void
 */
+ (void)user:(NSString *) user blockUser:(NSString*) userToBlock
     success:(void (^)(TTBlockUser *user))success
     failure:(void (^)(NSError *error))failure;

/*!
 * \brief   Removes :target from :user's block list. :user is the authenticated user and :target is user to be unblocked.
 * \brief   required scope: user_blocks_read
 * \param   user            user's name
 * \param   userToBlock     user to be blocked
 * \param   success         block called on success
 * \param   failure         block called on failure
 * \return  void
 */
+ (void)user:(NSString *) user unblockUser:(NSString*) userToBlock
     success:(void (^)())success
     failure:(void (^)(NSError *error))failure;

@end


// ****************************************************************************
#pragma mark - Notifications

extern NSString *const TTCoreDidFetchUserNotification;