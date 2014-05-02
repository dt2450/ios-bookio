//
//  GetPhoneNoViewController.m
//  Bookio
//
//  Created by Pooja Jain on 4/23/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "GetPhoneNoViewController.h"
#import "SWRevealViewController.h"

@interface GetPhoneNoViewController ()

@end

@implementation GetPhoneNoViewController
@synthesize PhoneNumber;
@synthesize SubmitPhoneNumber;
@synthesize managedObjectContext;

NSMutableDictionary *receivedData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    appDelegateCore = [[UIApplication sharedApplication]delegate];
    self.managedObjectContext =appDelegateCore.managedObjectContext;
    
    self.PhoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    
    self.SubmitPhoneNumber.layer.borderWidth = 0.5f;
    self.SubmitPhoneNumber.layer.cornerRadius = 5;
    
    // this viewcontroller will be notified when any changes are made in the search box
    [self.PhoneNumber setDelegate:self];
    
    //for resigning keyboard on tap on table view
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    [gestureRecognizer setCancelsTouchesInView:NO];
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    
    [self.SubmitPhoneNumber setEnabled:false];
    
}


- (void) hideKeyboard {
    [self.PhoneNumber resignFirstResponder];
}

/*
 keeps the search button disabled until soemthing is entered in the search query
 */
- (IBAction)DisableSubmitButtonTillEmptyString:(id)sender
{
    UITextField *phoneNumber = (UITextField*)sender;
    if(phoneNumber.text.length == 0)
    {
        [self.SubmitPhoneNumber setEnabled:false];
    }
    else
    {
        [self.SubmitPhoneNumber setEnabled:true];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)SubmitPhoneNumber:(UIButton *)sender {
   
    delegateApp = [[UIApplication sharedApplication] delegate];
    receivedData = [[NSMutableDictionary alloc] init];
    
    receivedData = delegateApp.userData;
    
    NSString *user_phone = self.PhoneNumber.text;
    
    if(([self.PhoneNumber.text length] > 10 )|| ([self.PhoneNumber.text length] <10))
    {
        
        [[[UIAlertView alloc] initWithTitle:@"Wrong Input"
                                    message:@"Enter Valid Phone Number."
                                   delegate:self
                          cancelButtonTitle:@"OK!"
                          otherButtonTitles:nil] show];
    
    }
    else
    {
        [receivedData setObject:user_phone forKey:@"user_phone"];
        NSLog(@"%@",receivedData);
        [self.PhoneNumber resignFirstResponder];
                
        BookioApi *apiCall= [[ BookioApi alloc] init];
        // just create the needed quest in the url and then call the method as below.. the response will be returned in the block only. parse it accordingly
        NSString *url = [NSString stringWithFormat:@"http://bookio-env.elasticbeanstalk.com/database?query=insertUser&userid=%@&fname=%@&lname=%@&phone=%@", [receivedData objectForKey:@"user_id"],[receivedData objectForKey:@"user_fname"], [receivedData objectForKey:@"user_lname"], [receivedData objectForKey:@"user_phone"]];
        
        
        [apiCall urlOfQuery:url queryCompletion:^(NSMutableDictionary *results)
         {
             NSString *value = [results objectForKey:@"status"];
             if([value isEqualToString:@"Change Phone"])
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to update your phone number?" message:@"" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES", nil];
                 [alert show];
                 [alert setTag:11];
             }
             else if([value isEqualToString:@"User Exists"] || [value isEqualToString:@"OK"])
             {
                 [self updateLocalData];
             }
         }];
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 11)
    {
        if(buttonIndex == 1)
        {
            BookioApi *apiCall= [[ BookioApi alloc] init];
            // just create the needed quest in the url and then call the method as below.. the response will be returned in the block only. parse it accordingly
            NSString *url = [NSString stringWithFormat:@"http://bookio-env.elasticbeanstalk.com/database?query=updateUserPhone&userid=%@&phone=%@", [receivedData objectForKey:@"user_id"],[receivedData objectForKey:@"user_phone"]];
            
            // make the api call by calling the function below which is implemented in the MyGoogleMapManager class
            [apiCall urlOfQuery:url queryCompletion:^(NSMutableDictionary *results)
             {
                 [self updateLocalData];
            }];

        }
        if(buttonIndex == 0)
        {
            BookioApi *apiCall= [[ BookioApi alloc] init];
            // just create the needed quest in the url and then call the method as below.. the response will be returned in the block only. parse it accordingly
            NSString *url = [NSString stringWithFormat:@"http://bookio-env.elasticbeanstalk.com/database?query=getMyAccount&userid=%@", [receivedData objectForKey:@"user_id"]];
            
            // make the api call by calling the function below which is implemented in the MyGoogleMapManager class
            [apiCall urlOfQuery:url queryCompletion:^(NSMutableDictionary *results)
             {
                 NSArray *result = [results objectForKey:@"results"];
                 NSDictionary *user = [result objectAtIndex:0];
                 NSString *userPhone = [user objectForKey:@"user_phone"];
                 [receivedData setObject:userPhone forKey:@"user_phone"];
                 NSLog(@"%@",[receivedData objectForKey:@"user_phone"]);
                 [self updateLocalData];
             }];
            
        }
       
    }
   
}

-(void)updateLocalData
{
    
     User *userDetails = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
     
     userDetails.user_id= [receivedData objectForKey:@"user_id"];
     userDetails.user_fname= [receivedData objectForKey:@"user_fname"];
     userDetails.user_lname= [receivedData objectForKey:@"user_lname"];
     userDetails.user_phone =[receivedData objectForKey:@"user_phone"];
    
     NSError *error;
     if(![self.managedObjectContext save:&error])
     {
         NSLog(@"saving error: %@",[error localizedDescription]);
     }
        
     UIStoryboard *storyboard =[ UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
     UIViewController *swrevealViewController  = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];

    
    // Load the user books table
    BookioApi *apiCall= [[ BookioApi alloc] init];
    // just create the needed quest in the url and then call the method as below.. the response will be returned in the block only. parse it accordingly
    NSString *url = [NSString stringWithFormat:@"http://bookio-env.elasticbeanstalk.com/database?query=getBooksOfUser&userid=%@", [receivedData objectForKey:@"user_id"]];
    
    // make the api call by calling the function below which is implemented in the MyGoogleMapManager class
    [apiCall urlOfQuery:url queryCompletion:^(NSMutableDictionary *results)
     {
         NSArray *value = [results objectForKey:@"results"];
         // check if retrival is successful
         if([results count] != 0)
         {
             //TODO: Verify this is at the right place
             NSError *error;
             NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"UserBooks"];
             NSArray *deleteAllArray =[self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
             
             for(NSManagedObject *obj in deleteAllArray)
             {
                 [self.managedObjectContext deleteObject:obj];
             }
             
             if (![self.managedObjectContext save:&error]) {
                 NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
                 return;
             }

             for(NSDictionary *book in value)
             {
                 
                 UserBooks *userBooks = [NSEntityDescription insertNewObjectForEntityForName:@"UserBooks" inManagedObjectContext:self.managedObjectContext];
                 
                 userBooks.isbn = [[book objectForKey:@"ISBN"] stringValue];
                 userBooks.rent = [NSNumber numberWithInt:[[book objectForKey:@"rent"] intValue]];
                 userBooks.rent_cost = [NSNumber numberWithInt:[[book objectForKey:@"rent_cost"] intValue]];
                 userBooks.sell = [NSNumber numberWithInt:[[book objectForKey:@"sell"] intValue]];
                 userBooks.sell_cost = [NSNumber numberWithInt:[[book objectForKey:@"sell_cost"] intValue]];
                 userBooks.user_id = [book objectForKey:@"user_id"];
                 
                 userBooks.courseno= [book objectForKey:@"course_no"];
                 userBooks.name = [book objectForKey:@"book_name"];
                 userBooks.authors= [book objectForKey:@"book_author"];
                 
                 NSError *error;
                 if(![self.managedObjectContext save:&error])
                 {
                     NSLog(@"saving error: %@",[error localizedDescription]);
                 }
                 
             }
         }
     }];
    [self presentViewController:swrevealViewController animated:TRUE completion:nil];
    
}

-(IBAction)screenTapped:(UITapGestureRecognizer *)sender
{
    if (self.PhoneNumber.isFirstResponder) {
        [self.PhoneNumber resignFirstResponder];
    }
}

@end
