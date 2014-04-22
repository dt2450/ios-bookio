//
//  RentalsViewController.m
//  Bookio
//
//  Created by Devashi Tandon on 4/20/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "RentalsViewController.h"

@implementation RentalsViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    self.RentedFromView.hidden = NO;
    self.RentedToView.hidden = YES;
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
