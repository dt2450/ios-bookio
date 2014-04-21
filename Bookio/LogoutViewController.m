//
//  LogoutViewController.m
//  Bookio
//
//  Created by Pooja Jain on 4/21/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "LogoutViewController.h"
#import "SWRevealViewController.h"

@implementation LogoutViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void) viewWillAppear:(BOOL)animated{
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.00f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}
@end
