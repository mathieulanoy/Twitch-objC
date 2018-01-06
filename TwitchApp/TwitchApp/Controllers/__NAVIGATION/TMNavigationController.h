//
//  TMNavigationController.h
//  TwitchApp
//
//  Created by Mathieu LANOY on 28/04/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCVerticalMenu.h"

@interface TMNavigationController : UINavigationController<FCVerticalMenuDelegate>

@property (strong, readonly, nonatomic) FCVerticalMenu *verticalMenu;

-(IBAction) openVerticalMenu:(id)sender;

@end
