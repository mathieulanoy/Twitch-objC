//
//  TTChatView.h
//  TwitchChatSDK
//
//  Created by Mathieu LANOY on 21/01/2015.
//  Copyright (c) 2015 Mathieu LANOY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTChatView : UIView


/*!
 * \brief   Connect to channel: chat
 * \param   channel user twitch channel to join
 * \param   user    user name if connected
 * \param   token   uer session token if connected
 * \return  void
 */
- (void) connectToChat:(NSString *) channel
                  user:(NSString *) user
                 token:(NSString *) token;

@end
