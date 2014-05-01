//
//  AddRentedTableViewController.m
//  Bookio
//
//  Created by Devashi Tandon on 4/30/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "AddRentedTableViewController.h"
#import "AddRentedTableViewCell.h"
#import "UserBooks.h"

@interface AddRentedTableViewController ()

@end

@implementation AddRentedTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) fetchMyBooksDataFromLocalDB {
    self.CourseList = [[NSMutableArray alloc] init];
    self.BooksList = [[NSMutableArray alloc] init];
    self.AuthorsList = [[NSMutableArray alloc] init];
    self.ISBNList = [[NSMutableArray alloc] init];
    
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    NSArray *user = [[NSArray alloc]init];
    user = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    User *userInfo = [user objectAtIndex:0];
    
    self.userID = userInfo.user_id;
    
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"UserBooks" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    
    NSArray *userBooks = [[NSArray alloc]init];
    userBooks = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    //error if no books
    if([userBooks count] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Alert"
                                  message:@"You don't have any books to rent!!"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }

    for(UserBooks *userBookEntity in userBooks) {
        //NSUInteger courseIndex = NSNotFound;
        //NSUInteger courseCount = [self.CourseList count];
        
        //if(courseCount != 0) {
        NSUInteger courseIndex = [self.CourseList indexOfObject:userBookEntity.courseno];
        //}
        if (courseIndex == NSNotFound) {
            [self.CourseList addObject:userBookEntity.courseno];
            courseIndex = [self.CourseList count] - 1;
            
            [self.BooksList addObject:[[NSMutableArray alloc] init]];
            [self.AuthorsList addObject:[[NSMutableArray alloc] init]];
            [self.ISBNList addObject:[[NSMutableArray alloc] init]];
        }
        NSMutableArray *courseBooksList = [self.BooksList objectAtIndex:courseIndex];
        [courseBooksList addObject:userBookEntity.name];
        
        NSMutableArray *bookAuthorsList = [self.AuthorsList objectAtIndex:courseIndex];
        [bookAuthorsList addObject:userBookEntity.authors];
        
        NSMutableArray *bookISBNList = [self.ISBNList objectAtIndex:courseIndex];
        [bookISBNList addObject:userBookEntity.isbn];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.addRentalView.dataSource = self;
    self.addRentalView.delegate = self;
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    //[self fetchMyBooksDataFromLocalDB];
    
    //for resigning keyboard on tap on table view
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    [gestureRecognizer setCancelsTouchesInView:NO];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) hideKeyboard {
    [self.addRentalView endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.CourseList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *courseBooksList = [self.BooksList objectAtIndex:section];
    
    return [courseBooksList count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section

{
    return [self.CourseList objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(5, 2, 320, 20);
    myLabel.font = [UIFont boldSystemFontOfSize:16];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    
    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    headerView.backgroundColor = [UIColor lightGrayColor];
    
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"myRentalsCell";
    
    AddRentedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(cell == nil) {
        cell = [[AddRentedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.bookName.text = [[self.BooksList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.bookAuthors.text = [[self.AuthorsList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.isbn = [[self.ISBNList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.rentedTo.text = @"";
    cell.tillDate.text = @"";
    
    [cell.addToRentals.layer setBorderWidth:1];
    [cell.addToRentals.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [cell.addToRentals.layer setCornerRadius:5];
    
    cell.clipsToBounds = YES;
    
    cell.delegate = self;
    cell.path = indexPath;
    
    //for numeric keyboard only
    cell.tillDate.keyboardType = UIKeyboardTypeNumberPad;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self fetchMyBooksDataFromLocalDB];
    [self.tableView reloadData];
    
    //trick for making the cell scroll up when the keyboard appears and then scroll back when it disappears
    [super viewWillAppear:animated];
}

/* Returns true if the string has valid ID */
-(BOOL)hasValidUserId:(NSString *)inputString
{
    NSCharacterSet *validChars = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_."];
    NSCharacterSet *invalidChars = [validChars invertedSet];
    
    NSRange r = [inputString rangeOfCharacterFromSet:invalidChars];
    if ((r.location != NSNotFound) || [inputString length] == 0) {
        NSLog(@"the string contains illegal characters or is empty");
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Alert"
                                  message:@"The user ID is invalid!!"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    return YES;
}

/* Returns true if the string has valid date */
-(BOOL)hasValidDate:(NSString *)inputString
{
    NSCharacterSet *validChars = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
    NSCharacterSet *invalidChars = [validChars invertedSet];
    
    NSRange r = [inputString rangeOfCharacterFromSet:invalidChars];
    if (r.location != NSNotFound) {
        NSLog(@"the date contains illegal characters");
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Alert"
                                  message:@"The date is invalid!!"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    
    //validate date
    if([inputString length] != 0) {
        if([inputString length] != 8) {
            NSLog(@"date is not in format YYYYMMDD");
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Alert"
                                      message:@"The date is not in format YYYYMMDD"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
            return NO;
        }
        //Do proper validation for date
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd"];
        NSDate *date = [formatter dateFromString:inputString];
        NSDate *currentDate = [[NSDate alloc] init];
        
        if(date != NULL) {
            NSString *inputDateString = [formatter stringFromDate:date];
            NSString *currentDateString = [formatter stringFromDate:currentDate];
            
            NSComparisonResult dateCompare = [inputDateString compare:currentDateString];
            if ((dateCompare == NSOrderedAscending) || (dateCompare == NSOrderedSame)) {
                NSLog(@"input date is in the past");
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Alert"
                                          message:@"The date is in the past"
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
                return NO;
            }
            //NSLog(@"date is: %@", inputDateString);
            //NSLog(@"current date is: %@", currentDateString);
        } else {
            NSLog(@"date is not correct");
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Alert"
                                      message:@"The date is not correct"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
            return NO;
        }
    } else {
        NSLog(@"date is empty");
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Alert"
                                  message:@"The date is empty!!"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}

-(void)addRentalButtonPressedAtIndexpath:(NSIndexPath *)indexPath
{
    
    AddRentedTableViewCell *cell = (AddRentedTableViewCell *) [self.addRentalView cellForRowAtIndexPath:indexPath];
    
    if(([self hasValidUserId: cell.rentedTo.text] == YES) && ([self hasValidDate:cell.tillDate.text] == YES)) {
        //add the book to rental database
        BookioApi *apiCall= [[ BookioApi alloc] init];
        
        NSMutableString *formattedDate = [NSMutableString stringWithString: cell.tillDate.text];
        
        [formattedDate insertString:@"-" atIndex:4];
        [formattedDate insertString:@"-" atIndex:7];
        
        //NSLog(@"Date is: %@", formattedDate);
        
        // just create the needed quest in the url and then call the method as below.. the response will be returned in the block only. parse it accordingly
        NSString *url = [NSString stringWithFormat:@"http://bookio-env.elasticbeanstalk.com/database?query=insertRent&userid=%@&touserid=%@&isbn=%@&enddate=%@",self.userID, cell.rentedTo.text, cell.isbn, formattedDate];
        
        //NSLog(@"url is: %@", url);
        
        // make the api call by calling the function below which is implemented in the BookioApi class
        [apiCall urlOfQuery:url queryCompletion:^(NSMutableDictionary *results)
         {
             //Need to verify and delete from core data only when this query succeeds
             NSString *status = [results objectForKey:@"status"];
             if([status isEqualToString:@"OK"])
             {
                 NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                 NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserBooks" inManagedObjectContext:self.managedObjectContext];
                 [fetchRequest setEntity:entity];
                 [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isbn == %@", cell.isbn]];
                 
                 NSArray *booksToRemove = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
                 
                 for (NSManagedObject *book in booksToRemove) {
                     [self.managedObjectContext deleteObject:book];
                 }
                 
                 NSError *error;
                 if (![self.managedObjectContext save:&error]) {
                     NSLog(@"There was an error in deleting book %@", [error localizedDescription]);
                 }
                 [self fetchMyBooksDataFromLocalDB];
                 [self.tableView reloadData];
             } else {
                 UIAlertView *alertView = [[UIAlertView alloc]
                                           initWithTitle:@"Alert"
                                           message:@"Failed to insert into rented list. Maybe the user id is not valid or there is a connection problem!!"
                                           delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
                 [alertView show];
             }
         }];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
