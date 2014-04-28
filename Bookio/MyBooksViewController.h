//
//  MyBooksViewController.h
//  Bookio
//
//  Created by Pooja Jain on 4/20/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "MyBooksTableViewCell.h"


@interface MyBooksViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UITableView *myBooksTableView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSArray *CourseList;
@property (strong, nonatomic) NSArray *BookCount;
@property (strong, nonatomic) NSArray *BooksList;
@property (strong, nonatomic) NSArray *Books1;
@property (strong, nonatomic) NSArray *Books2;
@property (strong, nonatomic) NSArray *Books3;
@end
