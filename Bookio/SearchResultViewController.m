//
//  SearchResultViewController.m
//  Bookio
//
//  Created by Pooja Jain on 4/22/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "SearchResultViewController.h"
#import "SWRevealViewController.h"
#import "RentOrBuyTableViewCell.h"

int selectedView;

@implementation SearchResultViewController
-(void) viewDidLoad
{
    
    [super viewDidLoad];
    
    self.RentOrBuyTableView.delegate=self;
    self.RentOrBuyTableView.dataSource=self;
    
    self.RentUsers = [[NSMutableArray alloc] init];
    self.BuyUsers = [[NSMutableArray alloc] init];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.00f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    selectedView = 0;
    
    NSString *isbn = [self.isbn description];
    
    BookioApi *apiCall= [[ BookioApi alloc] init];
    
    // just create the needed quest in the url and then call the method as below.. the response will be returned in the block only. parse it accordingly
    NSString *url = [NSString stringWithFormat:@"http://bookio-env.elasticbeanstalk.com/database?query=getRentAndSellDetails&isbn=%@",isbn];
    
    // make the api call by calling the function below which is implemented in the MyGoogleMapManager class
    [apiCall urlOfQuery:url queryCompletion:^(NSMutableDictionary *results)
    {
         NSArray *users = [results objectForKey:@"results"];
         if([users count] != 0)
         {
             for(NSDictionary *eachUser in users)
             {
                 if([[eachUser objectForKey:@"rent"] intValue] == 1)
                 {
                     [self.RentUsers addObject:eachUser];
                 }
                 if([[eachUser objectForKey:@"sell"] intValue] == 1)
                 {
                     [self.BuyUsers addObject:eachUser];
                 }
             }
             [self.RentOrBuyTableView reloadData];
         }
        
         if([self.RentUsers count] == 0)
         {
            
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!!" message:@"No User is renting this book." delegate: self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
         }
    }];

}

- (IBAction)SegmentChanged:(id)sender
{
    
    UISegmentedControl *seg = sender;
    if (seg.selectedSegmentIndex == 0)
    {
        selectedView = 0;
        [self.RentOrBuyTableView reloadData];
        
        if([self.RentUsers count] == 0)
        {
           
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!!" message:@"No User is renting this book." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else if (seg.selectedSegmentIndex == 1)
    {
        selectedView = 1;
        [self.RentOrBuyTableView reloadData];

        if([self.BuyUsers count] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry!!" message:@"No User is selling this book." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];

        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(selectedView == 0)
    {
        return [self.RentUsers count];
    }
    return [self.BuyUsers count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"RentBuyCell";
    RentOrBuyTableViewCell *cell=(RentOrBuyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil)
    {
        cell = [[RentOrBuyTableViewCell  alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if(selectedView == 0)
    {
        NSDictionary *eachUser = [self.RentUsers objectAtIndex:indexPath.row];
        cell.UserId.text = [eachUser objectForKey:@"user_id"];
        cell.Cost.text = [NSString stringWithFormat:@"%@$",[[eachUser objectForKey:@"rent_cost"] stringValue]];
        cell.phoneNumber = [eachUser objectForKey:@"user_phone"];
    }
    else if (selectedView == 1)
    {
  
        NSDictionary *eachUser = [self.BuyUsers objectAtIndex:indexPath.row];
        cell.UserId.text = [eachUser objectForKey:@"user_id"];
        cell.Cost.text = [NSString stringWithFormat:@"%@$",[[eachUser objectForKey:@"sell_cost"] stringValue]];
        cell.phoneNumber = [eachUser objectForKey:@"user_phone"];
    }
    
    return cell;
}

- (IBAction)SendMessageButtonPressed:(UIButton *)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.RentOrBuyTableView];
    NSIndexPath *indexPath = [[self RentOrBuyTableView] indexPathForRowAtPoint:buttonPosition];
    
    // get the cell from the index path so that we hav all information for this corresponding cell
    RentOrBuyTableViewCell *cell  = (RentOrBuyTableViewCell *)[self.RentOrBuyTableView cellForRowAtIndexPath:indexPath];
    
    NSString *status;
    
    if(selectedView == 0)
    {
        status = @"renting";
    }
    else if (selectedView == 1)
    {
        status = @"buying";
    }
        
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = @[cell.phoneNumber];
    NSString *message = [NSString stringWithFormat:@"Hey, My user id is prj2113 and I am interested in %@ the %@ book",status, [self.book_name description]];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
