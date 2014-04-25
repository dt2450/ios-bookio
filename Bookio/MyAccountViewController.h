//
//  MyAccountViewController.h
//  Bookio
//
//  Created by Shrutika Dasgupta on 4/21/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

@interface MyAccountViewController : UIViewController
{
    AppDelegate *delegateApp;
}
@property (strong, nonatomic) IBOutlet UILabel *user_fname;
@property (strong, nonatomic) IBOutlet UILabel *user_lname;
@property (strong, nonatomic) IBOutlet UILabel *user_id;
@property (strong, nonatomic) IBOutlet UILabel *user_phone;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic,strong)NSArray* userDetailsPassed;

@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;
@end
