//
//  MyBooksViewController.m
//  Bookio
//
//  Created by Pooja Jain on 4/20/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "MyBooksViewController.h"
#import "SWRevealViewController.h"
#import "UserBooks.h"

@implementation MyBooksViewController

-(void) fetchMyBooksDataFromLocalDB {
    self.CourseList = [[NSMutableArray alloc] init];
    self.BooksList = [[NSMutableArray alloc] init];
    self.AuthorsList = [[NSMutableArray alloc] init];
    self.ISBNList = [[NSMutableArray alloc] init];
    self.rentSelectList = [[NSMutableArray alloc] init];
    self.rentPriceList = [[NSMutableArray alloc] init];
    self.sellSelectList = [[NSMutableArray alloc] init];
    self.sellPriceList = [[NSMutableArray alloc] init];
    
    
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
            [self.rentPriceList addObject:[[NSMutableArray alloc] init]];
            [self.rentSelectList addObject:[[NSMutableArray alloc] init]];
            [self.sellPriceList addObject:[[NSMutableArray alloc] init]];
            [self.sellSelectList addObject:[[NSMutableArray alloc] init]];
        }
        NSMutableArray *courseBooksList = [self.BooksList objectAtIndex:courseIndex];
        [courseBooksList addObject:userBookEntity.name];
        
        NSMutableArray *bookAuthorsList = [self.AuthorsList objectAtIndex:courseIndex];
        [bookAuthorsList addObject:userBookEntity.authors];
        
        NSMutableArray *bookISBNList = [self.ISBNList objectAtIndex:courseIndex];
        [bookISBNList addObject:userBookEntity.isbn];
        
        NSMutableArray *bookRentSelectList = [self.rentSelectList objectAtIndex:courseIndex];
        [bookRentSelectList addObject:[NSNumber numberWithInteger:[userBookEntity.rent intValue]]];
        
        NSMutableArray *bookSellSelectList = [self.sellSelectList objectAtIndex:courseIndex];
        [bookSellSelectList addObject: [NSNumber numberWithInteger:[userBookEntity.sell intValue]]];
        
        NSMutableArray *bookRentPriceList = [self.rentPriceList objectAtIndex:courseIndex];
        [bookRentPriceList addObject:[NSNumber numberWithInteger:[userBookEntity.rent_cost intValue]]];
        
        NSMutableArray *bookSellPriceList = [self.sellPriceList objectAtIndex:courseIndex];
        [bookSellPriceList addObject:[NSNumber numberWithInteger:[userBookEntity.sell_cost intValue]]];
    }
}

-(void) viewDidLoad {
    [super viewDidLoad];
    
    self.myBooksTableView.dataSource = self;
    self.myBooksTableView.delegate = self;
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    //[self fetchMyBooksDataFromLocalDB];
    
    //for resigning keyboard on tap on table view
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    [gestureRecognizer setCancelsTouchesInView:NO];
}


- (void) hideKeyboard {
        [self.myBooksTableView endEditing:YES];
        
        //[cell.RentPrice resignFirstResponder];
        //[cell.SellPrice resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:( UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Check if it's a delete button or edit button...
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Update the array and table view.
        //[eventsArray removeObjectAtIndex:indexPath.row];
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        
        // Update the database
        NSString *bookISBN = [[self.ISBNList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        BookioApi *apiCall= [[ BookioApi alloc] init];
        
        // just create the needed quest in the url and then call the method as below.. the response will be returned in the block only. parse it accordingly
        NSString *url = [NSString stringWithFormat:@"http://bookio-env.elasticbeanstalk.com/database?query=deleteMyBook&userid=%@&isbn=%@",self.userID, bookISBN];
        
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
                 [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isbn == %@", bookISBN]];
                 
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
                                           message:@"Failed to delete book. There may be a connection problem with the database!!"
                                           delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
                 [alertView show];
             }
         }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.CourseList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
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

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if(editing == YES)
    {
        for (int section = 0; section < [self.myBooksTableView numberOfSections]; section++) {
            for (int row = 0; row < [self.myBooksTableView numberOfRowsInSection:section]; row++) {
                NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
                MyBooksTableViewCell* cell = (MyBooksTableViewCell* )[self.myBooksTableView cellForRowAtIndexPath:cellPath];
                //do stuff with 'cell'
                cell.RentSelect.enabled = YES;
                cell.SellSelect.enabled = YES;
                if(cell.RentSelect.selected == YES) {
                    cell.RentPrice.enabled = YES;
                }
                if(cell.SellSelect.selected == YES) {
                    cell.SellPrice.enabled = YES;
                }
            }
        }
    } else {
    // Your code for exiting edit mode goes here
        for (int section = 0; section < [self.myBooksTableView numberOfSections]; section++) {
            for (int row = 0; row < [self.myBooksTableView numberOfRowsInSection:section]; row++) {
                NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
                MyBooksTableViewCell* cell = (MyBooksTableViewCell* )[self.myBooksTableView cellForRowAtIndexPath:cellPath];
                //do stuff with 'cell'
                
                cell.RentSelect.enabled = NO;
                cell.SellSelect.enabled = NO;
                cell.RentPrice.enabled = NO;
                cell.SellPrice.enabled = NO;
                
                Boolean oldRentSelect = [[[self.rentSelectList objectAtIndex:section] objectAtIndex:row] intValue];
                Boolean oldSellSelect = [[[self.sellSelectList objectAtIndex:section] objectAtIndex:row] intValue];
                int oldRentPrice = [[[self.rentPriceList objectAtIndex:section] objectAtIndex:row] intValue];
                int oldSellPrice = [[[self.sellPriceList objectAtIndex:section] objectAtIndex:row] intValue];
                NSString *bookISBN = [[self.ISBNList objectAtIndex:section] objectAtIndex:row];
                
                //NSLog(@"isbn=%@ section=%d row=%d", bookISBN, section, row);
                
                BookioApi *apiCall= [[ BookioApi alloc] init];
                
                if((oldRentSelect != cell.RentSelect.selected) || (oldRentPrice != cell.RentPrice.text.intValue)) {
                    //update the rent price and state
                    NSString *url = [NSString stringWithFormat:@"http://bookio-env.elasticbeanstalk.com/database?query=updateRent&userid=%@&isbn=%@&rent=%d&cost=%@",self.userID, bookISBN, cell.RentSelect.selected, cell.RentPrice.text];
                    // make the api call by calling the function below which is implemented in the MyGoogleMapManager class
                    /*[apiCall urlOfQuery:url queryCompletion:^(NSMutableDictionary *results)
                     {
                         //update in core data
                         //PS: We can't update core data in asynchronous code since we are running a loop here and the last updated ISBN is getting picked when this block is called.
                         //Hence we have to update core data outside this block. Need to see if something better can be done.
                     }];*/
                    
                    NSMutableDictionary *results = [apiCall asyncurlOfQuery:url];
                    
                    //This needs to be fixed once server returns something
                    if(results != NULL) {
                        NSString *status = [results objectForKey:@"status"];
                        if([status isEqualToString:@"OK"])
                        {
                            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                            NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserBooks" inManagedObjectContext:self.managedObjectContext];
                            [fetchRequest setEntity:entity];
                            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isbn == %@", bookISBN]];
                            
                            //NSLog(@"isbn rent here=%@", bookISBN);
                            
                            NSArray *booksToUpdate = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
                            
                            for (UserBooks *book in booksToUpdate) {
                                book.rent = [NSNumber numberWithInt:cell.RentSelect.selected];
                                book.rent_cost = [NSNumber numberWithInt:cell.RentPrice.text.intValue];
                                //NSLog(@"rent = %@ cost = %@", book.rent, book.rent_cost);
                            }
                            
                            NSError *error;
                            if (![self.managedObjectContext save:&error]) {
                                NSLog(@"There was an error in updating my books (rent): %@", [error localizedDescription]);
                                UIAlertView *alertView = [[UIAlertView alloc]
                                                          initWithTitle:@"Alert"
                                                          message:@"There was a problem updating local cache of My Books database"
                                                          delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                                [alertView show];

                            }
                        } else {
                            UIAlertView *alertView = [[UIAlertView alloc]
                                                      initWithTitle:@"Alert"
                                                      message:@"There was a problem in updating Rent in My Books global database"
                                                      delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                            [alertView show];
                        }
                    } else {
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:@"Alert"
                                                  message:@"There was a problem in updating Rent in My Books global database"
                                                  delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                        [alertView show];

                    }
                }
                if((oldSellSelect != cell.SellSelect.selected) || (oldSellPrice != cell.SellPrice.text.intValue)) {
                    //update the sell price and state
                    NSString *url = [NSString stringWithFormat:@"http://bookio-env.elasticbeanstalk.com/database?query=updateSell&userid=%@&isbn=%@&sell=%d&cost=%@",self.userID, bookISBN, cell.SellSelect.selected, cell.SellPrice.text];
                    // make the api call by calling the function below which is implemented in the MyGoogleMapManager class
                    /*[apiCall urlOfQuery:url queryCompletion:^(NSMutableDictionary *results)
                     {
                         //update in core data
                         //PS: We can't update core data in asynchronous code since we are running a loop here and the last updated ISBN is getting picked when this block is called.
                         //Hence we have to update core data outside this block. Need to see if something better can be done.
                    }];*/
                    
                    NSMutableDictionary *results = [apiCall asyncurlOfQuery:url];
                    
                    //This needs to be fixed once server returns something
                    if(results != NULL) {
                        NSString *status = [results objectForKey:@"status"];
                        if([status isEqualToString:@"OK"])
                        {
                            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                            NSEntityDescription *entity = [NSEntityDescription entityForName:@"UserBooks" inManagedObjectContext:self.managedObjectContext];
                            [fetchRequest setEntity:entity];
                            [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isbn == %@", bookISBN]];
                            //NSLog(@"isbn sell here=%@", bookISBN);
                            
                            NSArray *booksToUpdate = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
                            
                            for (UserBooks *book in booksToUpdate) {
                                book.sell = [NSNumber numberWithInt:cell.SellSelect.selected];
                                book.sell_cost = [NSNumber numberWithInt:cell.SellPrice.text.intValue];
                                //NSLog(@"sell = %@ cost = %@", book.sell, book.sell_cost);
                            }
                            
                            NSError *error;
                            if (![self.managedObjectContext save:&error]) {
                                NSLog(@"There was an error in updating my books (sell): %@", [error localizedDescription]);
                                UIAlertView *alertView = [[UIAlertView alloc]
                                                          initWithTitle:@"Alert"
                                                          message:@"There was a problem in updating local cache of My Books database"
                                                          delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                                [alertView show];

                            }
                        } else {
                            UIAlertView *alertView = [[UIAlertView alloc]
                                                      initWithTitle:@"Alert"
                                                      message:@"There was a problem in updating Sell in My Books global database"
                                                      delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                            [alertView show];
                        }
                    } else {
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:@"Alert"
                                                  message:@"There was a problem in updating Sell in My Books global database"
                                                  delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
                        [alertView show];

                    }
                }
            }
        }
        [self fetchMyBooksDataFromLocalDB];
        [self.tableView reloadData];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"myBooksCell";
    
    MyBooksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(cell == nil) {
        cell = [[MyBooksTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.MyBookName.text = [[self.BooksList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.MyBookAuthors.text = [[self.AuthorsList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.isbn = [[self.ISBNList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.RentSelect.enabled = NO;
    cell.SellSelect.enabled = NO;
    cell.RentPrice.enabled = NO;
    cell.SellPrice.enabled = NO;
    
    cell.RentPrice.keyboardType = UIKeyboardTypeNumberPad;
    cell.SellPrice.keyboardType = UIKeyboardTypeNumberPad;
    

    if ([[[self.rentSelectList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] intValue] == 1) {
        cell.RentSelect.selected = YES;
        [cell.RentSelect setImage:[UIImage imageNamed:@"checkbox-ticked.png"] forState:UIControlStateNormal];
        
        NSString *currentRentPrice = [NSString stringWithFormat:@"%@", [[self.rentPriceList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        cell.RentPrice.text = currentRentPrice;
    } else {
        cell.RentSelect.selected = NO;
        [cell.RentSelect setImage:[UIImage imageNamed:@"checkbox-unticked.png"] forState:UIControlStateNormal];
    }

    if ([[[self.sellSelectList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] intValue] == 1) {
        cell.SellSelect.selected = YES;
        [cell.SellSelect setImage:[UIImage imageNamed:@"checkbox-ticked.png"] forState:UIControlStateNormal];
        
        NSString *currentSellPrice = [NSString stringWithFormat:@"%@", [[self.sellPriceList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
        cell.SellPrice.text = currentSellPrice;
    } else {
        cell.SellSelect.selected = NO;
        [cell.SellSelect setImage:[UIImage imageNamed:@"checkbox-unticked.png"] forState:UIControlStateNormal];
    }
    
    cell.clipsToBounds = YES;
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(void) viewWillAppear:(BOOL)animated{
    
    [self fetchMyBooksDataFromLocalDB];
    [self.tableView reloadData];
    
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.00f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    //trick for making the cell scroll up when the keyboard appears and then scroll back when it disappears
    [super viewWillAppear:animated];
}

@end

