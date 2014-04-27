//
//  SideBarMenuViewController.h
//  Bookio
//
//  Created by Pooja Jain on 4/20/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//
#import "AppDelegate.h"

@interface SideBarMenuViewController : UITableViewController
{
    AppDelegate *appDelegate;
}
@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;

@end
