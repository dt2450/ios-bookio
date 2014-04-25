//
//  MyAccountViewController.m
//  Bookio
//
//  Created by Pooja Jain on 4/21/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "MyAccountViewController.h"
#import "SWRevealViewController.h"

@implementation MyAccountViewController
@synthesize user_phone;
@synthesize user_fname;
@synthesize user_id;
@synthesize user_lname;

-(void) viewDidLoad {
    [super viewDidLoad];
    delegateApp = [[UIApplication sharedApplication]delegate];
    NSMutableDictionary *receivedUserData = [[NSMutableDictionary alloc]init];
    //receivedUserData = delegateApp.userData;
    /*
    NSLog(@"in myAcc page: %@",delegateApp.userData);
    
    self.user_fname.text = [receivedUserData objectForKey:@"user_fname"];
    self.user_lname.text = [receivedUserData objectForKey:@"user_lname"];
    self.user_id.text = [receivedUserData objectForKey:@"user_id"];
    self.user_phone.text = [receivedUserData objectForKey:@"user_phone"];
    */
    
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    self.userDetailsPassed = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
}

-(void) viewWillAppear:(BOOL)animated{
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.00f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(rightRevealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [self.tabBarController.tabBar setAlpha:0.0];
    
    // Testing querying the api
    [self displayDetails];
    
}


// test method
- (void) displayDetails
{
    BookioApi *apiCall= [[ BookioApi alloc] init];
    // just create the needed quest in the url and then call the method as below.. the response will be returned in the block only. parse it accordingly
    NSString *url = @"http://bookio-env.elasticbeanstalk.com/database?query=getMyAccount&userid=ssb2171";
    // make the api call by calling the function below which is implemented in the MyGoogleMapManager class
   
    [apiCall urlOfQuery:url queryCompletion:^(NSMutableDictionary *results)
    {
        NSArray *value = [results objectForKey:@"results"];
        NSDictionary *keys = [value objectAtIndex:0];
       // NSString *user_fname = [keys objectForKey:@"user_fname"];
       // NSLog(@"%@",user_fname);
      //  self.user_fname.text = user_fname;
    }];

}


- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

@end
