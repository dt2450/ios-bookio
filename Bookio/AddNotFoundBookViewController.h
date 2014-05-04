//
//  AddNotFoundBookViewController.h
//  Bookio
//
//  Created by Pooja Jain on 4/27/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import "UserBooks.h"

@interface AddNotFoundBookViewController : UIViewController <MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UITextField *isbnText;
@property (strong, nonatomic) IBOutlet UITextField *bookNameText;
@property (strong, nonatomic) IBOutlet UITextField *bookAuthorText;
@property (strong, nonatomic) IBOutlet UITextField *courseNoText;
@property (strong, nonatomic) IBOutlet UIButton *addBookButton;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@end
