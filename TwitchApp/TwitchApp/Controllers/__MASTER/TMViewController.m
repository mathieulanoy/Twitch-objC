//
//  TMViewController.m
//  TwitchApp
//
//  Created by Mathieu LANOY on 28/04/2015.
//  Copyright (c) 2015 mathieu.lanoy. All rights reserved.
//

#import "TMViewController.h"
#import "TMNavigationController.h"

@interface TMViewController ()

@end

@implementation TMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    [negativeSpacer setWidth:-10];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, [self menuBarItem], nil];

}

- (UIBarButtonItem *)menuBarItem
{
    CGFloat width = 44.0f;
    CGFloat height = 44.0f;
    UIImage *image = [[UIImage imageNamed:@"menu_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImageView *i = [[UIImageView alloc] initWithImage:image];
    
    UIButton *b = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [b setBackgroundColor:[UIColor clearColor]];
    [b setImage:i.image forState:UIControlStateNormal];
    b.contentMode = UIViewContentModeScaleAspectFit;
    b.frame = CGRectMake(0, (44 - height) / 2, width, height);
    b.tintColor = [UIColor colorWithRed:241.0f/255.0f green:241.0f/255.0f blue:241.0f/255.0f alpha:1.0f];
    [b addTarget:self.navigationController action:@selector(openVerticalMenu:) forControlEvents:(UIControlEventTouchUpInside)];
    
    UIBarButtonItem *btit = [[UIBarButtonItem alloc] initWithCustomView:b];
    btit.isAccessibilityElement = YES;
    btit.accessibilityLabel = @"MenuSlideBt";
    return btit;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
