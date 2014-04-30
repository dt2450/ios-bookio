//
//  AddRentedTableViewCell.m
//  Bookio
//
//  Created by Devashi Tandon on 4/30/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "AddRentedTableViewCell.h"

@implementation AddRentedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/* Returns true if the string has valid ID */
-(BOOL)hasValidUserId:(NSString *)inputString
{
    NSCharacterSet *validChars = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890_."];
    NSCharacterSet *invalidChars = [validChars invertedSet];
    
    NSRange r = [inputString rangeOfCharacterFromSet:invalidChars];
    if (r.location != NSNotFound) {
        NSLog(@"the string contains illegal characters");
        return NO;
    }
    return YES;
}

- (IBAction)finishedUserIdEdit:(id)sender {
    if (self.addToRentals.isFirstResponder) {
        [self.addToRentals resignFirstResponder];
    }
    if ([self hasValidUserId: self.rentedTo.text] == NO) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Alert"
                                  message:@"The user ID is invalid!!"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

@end
