//
//  AddRentedTableViewController.h
//  Bookio
//
//  Created by Devashi Tandon on 4/30/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddRentedTableViewCell.h"

@interface AddRentedTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, AddRentalCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *addRentalView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray *CourseList;
@property (strong, nonatomic) NSMutableArray *BooksList;
@property (strong, nonatomic) NSMutableArray *AuthorsList;
@property (strong, nonatomic) NSMutableArray *ISBNList;
@property (strong, nonatomic) NSString *userID;

@end
