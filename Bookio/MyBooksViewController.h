//
//  MyBooksViewController.h
//  Bookio
//
//  Created by Pooja Jain on 4/20/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "MyBooksTableViewCell.h"


@interface MyBooksViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UITableView *myBooksTableView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSMutableArray *CourseList;
@property (strong, nonatomic) NSMutableArray *BooksList;
@property (strong, nonatomic) NSMutableArray *AuthorsList;
@property (strong, nonatomic) NSMutableArray *ISBNList;
@property (strong, nonatomic) NSMutableArray *rentSelectList;
@property (strong, nonatomic) NSMutableArray *sellSelectList;
@property (strong, nonatomic) NSMutableArray *rentPriceList;
@property (strong, nonatomic) NSMutableArray *sellPriceList;
@property (strong, nonatomic) NSString *userID;

@end
