//
//  RentalsViewController.m
//  Bookio
//
//  Created by Devashi Tandon on 4/20/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "RentalsViewController.h"
#import "SWRevealViewController.h"

@implementation RentalsViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    self.RentedFromView.hidden = NO;
    self.RentedToView.hidden = YES;
    
}

-(void) viewWillAppear:(BOOL)animated{
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.00f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

}

- (IBAction)rentalSegmentChanged:(id)sender {
    
    UISegmentedControl *seg = sender;
    
    if (seg.selectedSegmentIndex == 0) {
        self.RentedFromView.hidden = NO;
        self.RentedToView.hidden = YES;
    }
    else if (seg.selectedSegmentIndex == 1) {
        self.RentedFromView.hidden = YES;
        self.RentedToView.hidden = NO;
    }
}

@end
