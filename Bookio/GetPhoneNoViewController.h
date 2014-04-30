//
//  GetPhoneNoViewController.h
//  Bookio
//
//  Created by Pooja Jain on 4/23/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "LoginViewController.h"

@interface GetPhoneNoViewController : UIViewController<UITextFieldDelegate>
{
    AppDelegate *delegateApp;
    AppDelegate *appDelegateCore;
}
@property (strong, nonatomic) IBOutlet UITextField *PhoneNumber;
@property (strong, nonatomic) IBOutlet UIButton *SubmitPhoneNumber;
@property (strong, nonatomic) NSString *user_id;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
