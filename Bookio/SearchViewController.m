//
//  SearchViewController.m
//  Bookio
//
//  Created by Pooja Jain on 4/20/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultViewController.h"
#import "SWRevealViewController.h"
#import "BookDetailTableViewCell.h"

@implementation SearchViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    
    self.SearchButton.layer.borderWidth = 0.5f;
    self.SearchButton.layer.cornerRadius = 5;
    
    // As the datasource will be provided by this view controller
    self.SearchResultsTableView.dataSource=self;
    // Any change in the table view must be informed to this view controller
    self.SearchResultsTableView.delegate=self;
    
    [self.SearchButton setEnabled:false];
    
    //for resigning keyboard on tap on table view
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.SearchResultsTableView addGestureRecognizer:gestureRecognizer];
    
}

- (void) hideKeyboard {
    [self.courseNumber resignFirstResponder];
}

/*
 This method is called just before the view is going to appear i.e. added to the view hierarchy
 */

-(void) viewWillAppear:(BOOL)animated{
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.00f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    // this viewcontroller will be notified when any changes are made in the search box
    [self.courseNumber setDelegate:self];

    
}

- (IBAction)SearchButtonPressed:(UIButton *)sender {
    
    [self.courseNumber resignFirstResponder];
    NSString *courseno=self.courseNumber.text;
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
        [self.SearchResultsTableView reloadData];
         
     }];

}

- (IBAction)disableSearchButtonTillEmptyString:(id)sender
{
    UITextField *text = (UITextField*)sender;
    if(text.text.length == 0)
    {
        [self.SearchButton setEnabled:false];
    }
    else
    {
        [self.SearchButton setEnabled:true];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return [self.ResultBooks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"BookDetails";
    
    BookDetailTableViewCell *cell=(BookDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // this initializes the cell with the custom table cell created in the class COMSTableViewCell
    if (cell == nil) {
        cell = [[BookDetailTableViewCell  alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *eachBook = [self.ResultBooks objectAtIndex:indexPath.row];
    cell.Bname = [eachBook objectForKey:@"book_name"];
    cell.BookName.text = cell.Bname;
    cell.BookAuthor.text = [eachBook objectForKey:@"book_author"];
    cell.isbn = [eachBook objectForKey:@"ISBN"];
    return cell;
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender{
    [super prepareForSegue:segue sender:sender];
    // based on the cell clicked get the index no.
    NSIndexPath *indexPath = [[self SearchResultsTableView] indexPathForCell:sender];
    // get the cell from the index path so that we hav all information for this corresponding cell
    BookDetailTableViewCell *cell  = (BookDetailTableViewCell *)[self.SearchResultsTableView cellForRowAtIndexPath:indexPath];
    SearchResultViewController *searchResultViewController = [segue destinationViewController];
    
    // passes the input query to the capturedQuery object of type id in the destination view
    searchResultViewController.isbn=cell.isbn;
    searchResultViewController.book_name = cell.Bname;
}

@end
