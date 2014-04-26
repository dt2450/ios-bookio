//
//  LoginViewController.h
//  Bookio
//
//  Created by Shrutika Dasgupta on 4/20/14.
//  Copyright (c) 2014 Shrutika Dasgupta. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

@interface LoginViewController : UIViewController <FBLoginViewDelegate>

@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@end