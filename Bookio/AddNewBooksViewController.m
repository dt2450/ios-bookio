//
//  AddNewBooksViewController.m
//  Bookio
//
//  Created by Pooja Jain on 4/21/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "AddNewBooksViewController.h"
#import "SWRevealViewController.h"
#import "AddNewBooksTableViewCell.h"

NSString *courseno;

@implementation AddNewBooksViewController


-(void) viewDidLoad {
    [super viewDidLoad];

    self.searchButton.layer.borderWidth = 0.5f;
    self.searchButton.layer.cornerRadius = 5;
    
    // As the datasource will be provided by this view controller
    self.addNewBooksView.dataSource=self;
    // Any change in the table view must be informed to this view controller
    self.addNewBooksView.delegate=self;
    
    [self.searchButton setEnabled:false];
    
    [self.courseNo setDelegate:self];
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    //for resigning keyboard on tap on table view
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.addNewBooksView addGestureRecognizer:gestureRecognizer];
}

- (void) hideKeyboard {
    [self.courseNo resignFirstResponder];
}

-(void) viewWillAppear:(BOOL)animated{
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.00f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [self.tabBarController.tabBar setAlpha:0.0];

}

- (IBAction)disableSearchButtonTillEmptyString:(id)sender
{
    UITextField *text = (UITextField*)sender;
    if(text.text.length == 0)
    {
        [self.searchButton setEnabled:false];
    }
    else
    {
        [self.searchButton setEnabled:true];
    }
}

- (IBAction)SearchButtonPressed:(UIButton *)sender {
    
    [self.courseNo resignFirstResponder];
    courseno=self.courseNo.text;
    NSString *formattedCourseNo = [courseno stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    BookioApi *apiCall= [[ BookioApi alloc] init];
    
    // just create the needed quest in the url and then call the method as below.. the response will be returned in the block only. parse it accordingly
    NSString *url = [NSString stringWithFormat:@"http://bookio-env.elasticbeanstalk.com/database?query=getBooksOfCourse&courseno=%@",formattedCourseNo];
    
    // make the api call by calling the function below which is implemented in the MyGoogleMapManager class
    [apiCall urlOfQuery:url queryCompletion:^(NSMutableDictionary *results)
     {
         NSArray *books = [results objectForKey:@"results"];
         
         if([books count] == 0)
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!!" message:@"No Books found for this course." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
         }
         
         self.ResultBooks = books;
         [self.addNewBooksView reloadData];
         
     }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return [self.ResultBooks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Books";
    
    AddNewBooksTableViewCell *cell=(AddNewBooksTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // this initializes the cell with the custom table cell created in the class COMSTableViewCell
    if (cell == nil) {
        cell = [[AddNewBooksTableViewCell  alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *eachBook = [self.ResultBooks objectAtIndex:indexPath.row];
    
    cell.bookName.text = [eachBook objectForKey:@"book_name"];
    cell.bookAuthor.text = [eachBook objectForKey:@"book_author"];
    cell.isbn = [[eachBook objectForKey:@"ISBN"] stringValue];
    [cell.addButton setEnabled:YES];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserBooks" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSArray *userBooks = [[NSArray alloc]init];
    userBooks = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    for(UserBooks *userBookEntity in userBooks) {
        if([cell.isbn isEqualToString:userBookEntity.isbn]) {
            [cell.addButton setEnabled:NO];
            break;
        }
    }
    
    [cell.addButton addTarget:self action:@selector(checkAddButtonStatus:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)checkAddButtonStatus:(id)sender {
    // recogize the location fo the button pressed
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.addNewBooksView];
    // based on the co-ordinates find the row for which the fav button was pressed
    NSIndexPath *indexPath = [self.addNewBooksView indexPathForRowAtPoint:buttonPosition];
    // get the cell from the index path so that we hav all information for this corresponding cell
    AddNewBooksTableViewCell *cell  = (AddNewBooksTableViewCell *)[self.addNewBooksView cellForRowAtIndexPath:indexPath];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSArray *user = [[NSArray alloc]init];
    user = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    User *userInfo = [user objectAtIndex:0];
 
    BookioApi *apiCall= [[BookioApi alloc] init];
    // just create the needed quest in the url and then call the method as below.. the response will be returned in the block only. parse it accordingly
    NSString *url = [NSString stringWithFormat:@"http://bookio-env.elasticbeanstalk.com/database?query=insertMyBook&userid=%@&isbn=%@", userInfo.user_id, cell.isbn];
    
    // make the api call by calling the function below which is implemented in the MyGoogleMapManager class
    [apiCall urlOfQuery:url queryCompletion:^(NSMutableDictionary *results)
     {
         //Verify the query succeeded
         NSString *status = [results objectForKey:@"status"];
         
         NSLog(@"STATUS IS: %@", status);
         
         if([status isEqualToString:@"OK"])
         {
             UserBooks *addMyBook = [NSEntityDescription insertNewObjectForEntityForName:@"UserBooks"
                                                                  inManagedObjectContext:self.managedObjectContext];
             addMyBook.user_id = userInfo.user_id;
             addMyBook.isbn = cell.isbn;
             addMyBook.name = cell.bookName.text;
             addMyBook.authors = cell.bookAuthor.text;
             addMyBook.courseno = courseno;
             addMyBook.rent = [NSNumber numberWithInt:0];
             addMyBook.rent_cost = [NSNumber numberWithInt:0];
             addMyBook.sell = [NSNumber numberWithInt:0];
             addMyBook.sell_cost = [NSNumber numberWithInt:0];
             
             NSError *error;
             // save this insert query, so that the persistant store is updated
             if (![self.managedObjectContext save:&error]) {
                 NSLog(@"entry not saved to database due to error: %@", [error localizedDescription]);
             }
             [cell.addButton setEnabled:NO];
         } else if([status isEqualToString:@"exists"]){
             UIAlertView *alertView = [[UIAlertView alloc]
                                       initWithTitle:@"Alert"
                                       message:@"The book is already present in your list. Maybe you have rented it."
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
             [alertView show];
         } else {
             UIAlertView *alertView = [[UIAlertView alloc]
                                       initWithTitle:@"Alert"
                                       message:@"Failed to update global My Books database."
                                       delegate:nil
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil];
             [alertView show];

         }
     }];
}

@end
