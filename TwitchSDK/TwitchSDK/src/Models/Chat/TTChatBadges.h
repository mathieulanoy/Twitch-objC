//
//  TTChatBadges.h
//  TwitchSDK
//
//  Created by Mathieu LANOY on 21/01/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TTModel.h"
#import "TTPicture.h"

@interface TTChatBadges : TTModel

@property (strong, nonatomic) TTPicture *global_mod;

@property (strong, nonatomic) TTPicture *admin;

@property (strong, nonatomic) TTPicture *broadcaster;

@property (strong, nonatomic) TTPicture *mod;

@property (strong, nonatomic) TTPicture *staff;

@property (strong, nonatomic) TTPicture *turbo;

@property (strong, nonatomic) TTPicture *subscriber;

@end
