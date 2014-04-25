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
    
    self.PhoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    
    self.PhoneNumber.delegate = self;
    
    [self.SubmitPhoneNumber setEnabled:YES];
}

- (IBAction)checkEmptyString:(id)sender {
    /*
     Checks for empty string in the textField box
     if the String is empty then the update button will remain dissabled
     the search button will be enabled only if the some text is entered in the text field
     */
    if([self.PhoneNumber.text length] != 0)
    {
        [self.SubmitPhoneNumber setEnabled:YES];
    }
    else
    {
        [self.SubmitPhoneNumber setEnabled:NO];
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

        delegateApp.userData = receivedData;

        [self.PhoneNumber resignFirstResponder];
    }
}

- (IBAction)screenTapped:(UITapGestureRecognizer *)sender {
    
    //The textfield has a property called first responder. The keyboard is this textfields accessory view. When the textfield is in first responder mode, it means it is the primary focus on the screen (the textfield cursor is blinking, keyboard is up). To dismiss the keyboard, we tell it to resignFirstResponder status
    if (self.PhoneNumber.isFirstResponder) {
        [self.PhoneNumber resignFirstResponder];
    }
}

@end
