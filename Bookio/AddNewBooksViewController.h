//
//  AddNewBooksViewController.h
//  Bookio
//
//  Created by Pooja Jain on 4/21/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "UserBooks.h"

@interface AddNewBooksViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UITableView *addNewBooksView;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UITextField *courseNo;
@property (strong, nonatomic) IBOutlet UIButton *addNewBookButton;
@property (nonatomic, strong) NSArray *ResultBooks;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@end
