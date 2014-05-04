//
//  AddNotFoundBookViewController.m
//  Bookio
//
//  Created by Pooja Jain on 4/27/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "AddNotFoundBookViewController.h"
#import "SWRevealViewController.h"

@interface AddNotFoundBookViewController ()

@end

@implementation AddNotFoundBookViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isbnText.keyboardType = UIKeyboardTypeNumberPad;
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
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

-(IBAction)addButtonPressed:(id)sender {
    NSMutableString *errorMessage = [[NSMutableString alloc] init];
    if(self.isbnText.text.length != 13) {
        [errorMessage appendString:@"\n- ISBN should be 13 digits long."];
    }
    if(self.bookNameText.text.length == 0) {
        [errorMessage appendString:@"\n- Enter a book name."];
    }
    if(self.bookAuthorText.text.length == 0) {
        [errorMessage appendString:@"\n- Enter a book author."];
    }
    if(self.courseNoText.text.length == 0) {
        [errorMessage appendString:@"\n- Enter a course no. of the book."];
    }
    if(errorMessage.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!!" message:errorMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        NSString *formattedBookName = [self.bookNameText.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        NSString *formattedBookAuthor = [self.bookAuthorText.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        NSString *formattedCourseNo = [self.courseNoText.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        [fetchRequest setReturnsObjectsAsFaults:NO];
        NSArray *user = [[NSArray alloc]init];
        user = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        
        User *userInfo = [user objectAtIndex:0];
        
        BookioApi *apiCall= [[ BookioApi alloc] init];
        // just create the needed quest in the url and then call the method as below.. the response will be returned in the block only. parse it accordingly
        NSString *url = [NSString stringWithFormat:@"http://bookio-env.elasticbeanstalk.com/database?query=insertBook&userid=%@&isbn=%@&bookname=%@&bookauthor=%@&courseno=%@", userInfo.user_id,self.isbnText.text,formattedBookName,formattedBookAuthor,formattedCourseNo];
        
        // make the api call by calling the function below which is implemented in the MyGoogleMapManager class
        [apiCall urlOfQuery:url queryCompletion:^(NSMutableDictionary *results)
         {
             NSString *value = [results objectForKey:@"status"];
             if([value isEqualToString:@"OK"])
             {
                 // send message to admin
                 if(![MFMessageComposeViewController canSendText]) {
                     UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     [warningAlert show];
                     return;
                 }
                 
                 NSArray *recipents = @[@"9177050153"];   //Admin phone number
                 
                 // Fetch the devices from persistent data store
                 NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                 NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
                 [fetchRequest setEntity:entity];
                 [fetchRequest setReturnsObjectsAsFaults:NO];
                 NSArray *user = [[NSArray alloc]init];
                 user = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
                 
                 
                 User *userInfo = [user objectAtIndex:0];
                 
                 // extract user id from core data and pass it in the message so that the user can add the rental for the user
                 NSString *message = [NSString stringWithFormat:@"Hey, My user id is %@ and I request you to add the book:\n ISBN = %@ \n Book Name = %@ \n Book Author = %@ \n Course No. = %@ ",userInfo.user_id, self.isbnText.text, self.bookNameText.text , self.bookAuthorText.text , self.courseNoText.text];
                 
                 MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
                 messageController.messageComposeDelegate = self;
                 [messageController setRecipients:recipents];
                 [messageController setBody:message];
                 
                 // Present message view controller on screen
                 [self presentViewController:messageController animated:YES completion:nil];
                 
                 
             }
             else
             {
                 NSString *exists =  [NSString stringWithFormat:@"The book already exists for the course %@",value];
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:exists delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alert show];
                 [alert setTag:5];
             }
         }];
    }
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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"A request has been sent to the admin. You will receive a message when the book is added." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    [alert setTag:5];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 5 && buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
