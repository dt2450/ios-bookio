//
//  MyAccountViewController.h
//  Bookio
//
//  Created by Pooja Jain on 4/21/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

@interface MyAccountViewController : UIViewController
{
    AppDelegate *appDelegateSend;
}
@property (strong, nonatomic) IBOutlet UILabel *user_fname;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@end
