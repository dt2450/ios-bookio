//
//  MyBooksViewController.m
//  Bookio
//
//  Created by Pooja Jain on 4/20/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "MyBooksViewController.h"
#import "SWRevealViewController.h"

@implementation MyBooksViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    
    self.myBooksTableView.dataSource = self;
    self.myBooksTableView.delegate = self;
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    //for testing
    self.CourseList = @[@"CSEE 4121", @"CSOR 4151", @"COMS E6198"];
    self.BookCount = @[@2,@1,@3];
    self.Books1 = @[@"Book 1", @"Book 2", @"Book 3"];
    self.Books2 = @[@"Book 4", @"Book 5", @"Book 6"];
    self.Books3 = @[@"Book 7", @"Book 8", @"Book 9"];
    self.BooksList = @[self.Books1, self.Books2, self.Books3];
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.CourseList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.BookCount objectAtIndex:section] intValue];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    return [self.CourseList objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"myBooksCell";
    
    MyBooksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(cell == nil) {
        cell = [[MyBooksTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.MyBookName.text = [[self.BooksList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.MyBookAuthors.text = [NSString stringWithFormat:@"Author: %ld", (long)indexPath.row];
    
    cell.clipsToBounds = YES;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}


-(void) viewWillAppear:(BOOL)animated{
    
    [self.tableView reloadData];
    
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.00f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}

@end

