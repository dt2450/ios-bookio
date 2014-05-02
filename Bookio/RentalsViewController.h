//
//  RentalsViewController.h
//  Bookio
//
//  Created by Devashi Tandon on 4/20/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

@interface RentalsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *rentedFromToTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UIButton *addRentalsButton;
@property (nonatomic, strong) NSMutableArray *RentedToUsers;
@property (nonatomic, strong) NSMutableArray *RentedFromUsers;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSString *userID;
@end
