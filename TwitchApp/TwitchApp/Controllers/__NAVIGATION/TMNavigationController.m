//
//  TMNavigationController.m
//  TwitchApp
//
//  Created by Mathieu LANOY on 28/04/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TMNavigationController.h"
#import "TMViewController.h"

@interface TMNavigationController ()

@end

@implementation TMNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureVerticalMenu];
    self.verticalMenu.delegate = self;
    
//    self.navigationBar.barStyle = UIBarStyleBlack;
    
    self.navigationBar.barTintColor = [UIColor colorWithRed:38.0f/255.0f green:38.0f/255.0f blue:38.0f/255.0f alpha:1.0f];
    self.verticalMenu.liveBlurBackgroundStyle = UIBarStyleBlack;
//    self.navigationBar.tintColor = [UIColor whiteColor];

}

#pragma mark - FCVerticalMenu Configuration
- (void)configureVerticalMenu
{
    FCVerticalMenuItem *item1 = [[FCVerticalMenuItem alloc] initWithTitle:@"First Menu"
                                                             andIconImage:nil];
    
    FCVerticalMenuItem *item2 = [[FCVerticalMenuItem alloc] initWithTitle:@"Second Menu"
                                                             andIconImage:nil];
    
    FCVerticalMenuItem *item3 = [[FCVerticalMenuItem alloc] initWithTitle:@"Third Menu"
                                                             andIconImage:nil];
    
    item1.actionBlock = ^{
        NSLog(@"test element 1");
//        FCFirstViewController *vc = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"FirstViewController"];
        TMViewController *vc = [[TMViewController alloc] init];
        vc.view.backgroundColor = [UIColor redColor];
        if ([self.viewControllers[0] isEqual:vc])
            return;
        
        [self setViewControllers:@[vc] animated:NO];
    };
    item2.actionBlock = ^{
        NSLog(@"test element 2");
        TMViewController *vc = [[TMViewController alloc] init];
        vc.view.backgroundColor = [UIColor greenColor];
        if ([self.viewControllers[0] isEqual:vc])
            return;
        
        [self setViewControllers:@[vc] animated:NO];
        
    };
    item3.actionBlock = ^{
        NSLog(@"test element 3");
        
        TMViewController *vc = [[TMViewController alloc] init];
        vc.view.backgroundColor = [UIColor grayColor];
        if ([self.viewControllers[0] isEqual:vc])
            return;
        
        [self setViewControllers:@[vc] animated:NO];
    };
    _verticalMenu = [[FCVerticalMenu alloc] initWithItems:@[item1, item2, item3]];
    _verticalMenu.appearsBehindNavigationBar = YES;
    
}

-(IBAction)openVerticalMenu:(id)sender
{
    if (_verticalMenu.isOpen)
        return [_verticalMenu dismissWithCompletionBlock:nil];
    
    [_verticalMenu showFromNavigationBar:self.navigationBar inView:self.view];
}


#pragma mark - FCVerticalMenu Delegate Methods

-(void)menuWillOpen:(FCVerticalMenu *)menu
{
    NSLog(@"menuWillOpen hook");
}

-(void)menuDidOpen:(FCVerticalMenu *)menu
{
    NSLog(@"menuDidOpen hook");
}

-(void)menuWillClose:(FCVerticalMenu *)menu
{
    NSLog(@"menuWillClose hook");
}

-(void)menuDidClose:(FCVerticalMenu *)menu
{
    NSLog(@"menuDidClose hook");
}

@end
