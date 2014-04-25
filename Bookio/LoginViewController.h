//
//  LoginViewController.h
//  Bookio
//
//  Created by Shrutika Dasgupta on 4/20/14.
//  Copyright (c) 2014 Shrutika Dasgupta. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"

@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end