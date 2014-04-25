//
//  GetPhoneNoViewController.h
//  Bookio
//
//  Created by Pooja Jain on 4/23/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface GetPhoneNoViewController : UIViewController<UITextFieldDelegate>
{
    AppDelegate *delegateApp;
}
@property (strong, nonatomic) IBOutlet UITextField *PhoneNumber;
@property (strong, nonatomic) IBOutlet UIButton *SubmitPhoneNumber;

@end
