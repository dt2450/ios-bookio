//
//  SearchViewController.m
//  Bookio
//
//  Created by Pooja Jain on 4/20/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "SearchViewController.h"
#import "SWRevealViewController.h"

@implementation SearchViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    
    // Testing content
    self.Items = @[@"item1"];
}

-(void) viewWillAppear:(BOOL)animated{
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.00f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return [self.Items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *CellIdentifier = [self.Items objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender{
    [super prepareForSegue:segue sender:sender];
    
}

@end
