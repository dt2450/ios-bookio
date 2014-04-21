//
//  SideBarMenuViewController.m
//  Bookio
//
//  Created by Pooja Jain on 4/20/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "SideBarMenuViewController.h"
#import "SWRevealViewController.h"

//Reference: http://www.appcoda.com/ios-programming-sidebar-navigation-menu/

@interface SideBarMenuViewController()
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation SideBarMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _menuItems = @[@"Title", @"MyAccount", @"AddNewBooks", @"Logout"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    [super prepareForSegue:segue sender:sender];
    /*if( [[segue identifier] isEqualToString:@"showBookio"] )
    {
        // try to reveal the tab bar controller
    }
    else
    {*/
        // Set the title of navigation bar by using the menu items
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
        destViewController.title = [[_menuItems objectAtIndex:indexPath.row] capitalizedString];
        
        if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
            SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
            
            swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
                
                UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
                [navController setViewControllers: @[dvc] animated: NO ];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            };
            
        }
    //}
    
}

@end
