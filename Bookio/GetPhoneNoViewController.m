//
//  GetPhoneNoViewController.m
//  Bookio
//
//  Created by Pooja Jain on 4/23/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "GetPhoneNoViewController.h"

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
    
    [self.SubmitPhoneNumber setEnabled:false];
    // this viewcontroller will be notified when any changes are made in the search box
    [self.PhoneNumber setDelegate:self];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    
    // disables the search button initially, only enabled when something is entered in the textbox else disabled
    self.SubmitPhoneNumber.enabled=NO;
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
/*
- (IBAction)checkEmptyString:(id)sender {
    
     Checks for empty string in the textField box
     if the String is empty then the update button will remain dissabled
     the search button will be enabled only if the some text is entered in the text field
 
    if(([self.PhoneNumber.text length] != 10) || ([self.PhoneNumber.text length] == 0 ) )
    {
        [self.SubmitPhoneNumber setEnabled:NO];
    }
    else
    {
        [self.SubmitPhoneNumber setEnabled:YES];
    }
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)SubmitPhoneNumber:(UIButton *)sender {
   
    delegateApp = [[UIApplication sharedApplication] delegate];
    receivedData = [[NSMutableDictionary alloc] init];
    
    receivedData = delegateApp.userData;
    
    NSString *user_phone = [[NSString alloc]init];
    user_phone = self.PhoneNumber.text;
    
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

        //delegateApp.userData = receivedData;

        [self.PhoneNumber resignFirstResponder];
        
        
        User *userDetails = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        
        userDetails.user_id= [receivedData objectForKey:@"user_id"];
        userDetails.user_fname= [receivedData objectForKey:@"user_fname"];
        userDetails.user_lname= [receivedData objectForKey:@"user_lname"];
        userDetails.user_phone =[receivedData objectForKey:@"user_phone"];
        
        NSLog(@"-----------%@",userDetails);
        
        NSError *error;
        if(![self.managedObjectContext save:&error])
        {
            NSLog(@"saving error: %@",[error localizedDescription]);
        }
    }
}
-(IBAction)screenTapped:(UITapGestureRecognizer *)sender
{
    if (self.PhoneNumber.isFirstResponder) {
        [self.PhoneNumber resignFirstResponder];
    }
}

@end
