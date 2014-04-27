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
    
    [self.PhoneNumber setDelegate:self];
    
    // disables the search button initially, only enabled when something is entered in the textbox else disabled
    [self.SubmitPhoneNumber setEnabled:FALSE];
    
}

// this method is connected to the textfield -> editing changed segue

- (IBAction)DisableSubmitButtonTillTextFieldEmptyString:(id)sender {
    
    UITextField *phoneNumber = (UITextField*)sender;
    if(phoneNumber.text.length == 0)
    {
        [self.SubmitPhoneNumber setEnabled:FALSE];
    }
    else
    {
        [self.SubmitPhoneNumber setEnabled:TRUE];
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
    }
}

- (IBAction)screenTapped:(UITapGestureRecognizer *)sender {
    
    //The textfield has a property called first responder. The keyboard is this textfields accessory view. When the textfield is in first responder mode, it means it is the primary focus on the screen (the textfield cursor is blinking, keyboard is up). To dismiss the keyboard, we tell it to resignFirstResponder status
    if (self.PhoneNumber.isFirstResponder) {
        [self.PhoneNumber resignFirstResponder];
    }
}

@end
