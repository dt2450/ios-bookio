//
//  MyBooksTableViewCell.m
//  Bookio
//
//  Created by Devashi Tandon on 4/28/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "MyBooksTableViewCell.h"

@implementation MyBooksTableViewCell

- (IBAction)RentCheckButton:(id)sender {
    if (self.RentSelect.selected == NO) {
        self.RentSelect.selected = YES;
        self.RentPrice.enabled = YES;
        [self.RentSelect setImage:[UIImage imageNamed:@"checkbox-ticked.png"] forState:UIControlStateNormal];
    } else {
        self.RentSelect.selected = NO;
        self.RentPrice.enabled = NO;
        [self.RentSelect setImage:[UIImage imageNamed:@"checkbox-unticked.png"] forState:UIControlStateNormal];
    }
}
- (IBAction)SellCheckButton:(id)sender {
    if (self.SellSelect.selected == NO) {
        self.SellSelect.selected = YES;
        self.SellPrice.enabled = YES;
        [self.SellSelect setImage:[UIImage imageNamed:@"checkbox-ticked.png"] forState:UIControlStateNormal];
    } else {
        self.SellSelect.selected = NO;
        self.SellPrice.enabled = NO;
        [self.SellSelect setImage:[UIImage imageNamed:@"checkbox-unticked.png"] forState:UIControlStateNormal];
    }
}

/* Returns true if the string has valid price */
-(BOOL)hasValidPrice:(NSString *)inputString
{
    NSCharacterSet *validChars = [NSCharacterSet characterSetWithCharactersInString:@"1234567890."];
    NSCharacterSet *invalidChars = [validChars invertedSet];
    
    NSRange r = [inputString rangeOfCharacterFromSet:invalidChars];
    if (r.location != NSNotFound) {
        NSLog(@"the string contains illegal characters");
        return NO;
    }
    
    unsigned long dotOccurences = [[inputString componentsSeparatedByString:@"."] count] - 1;
    if (dotOccurences != 0 && dotOccurences != 1) {
        NSLog(@"string has too many periods");
        return NO;
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.RentPrice isFirstResponder] && (self.RentPrice != touch.view))
    {
        if (self.RentPrice.isFirstResponder) {
            [self.RentPrice resignFirstResponder];
        }
        if ([self hasValidPrice: self.RentPrice.text] == NO) {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Alert"
                                      message:@"The rent price is invalid!!"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
    
    if ([self.SellPrice isFirstResponder] && (self.SellPrice != touch.view))
    {
        if (self.SellPrice.isFirstResponder) {
            [self.SellPrice resignFirstResponder];
        }
        if ([self hasValidPrice: self.SellPrice.text] == NO) {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Alert"
                                      message:@"The sell price is invalid!!"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
}


- (IBAction)finishedRentPriceEdit:(id)sender {
    if (self.RentPrice.isFirstResponder) {
        [self.RentPrice resignFirstResponder];
    }
    if ([self hasValidPrice: self.RentPrice.text] == NO) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                    initWithTitle:@"Alert"
                                    message:@"The rent price is invalid!!"
                                    delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)finishedSellPriceEdit:(id)sender {    
    if (self.SellPrice.isFirstResponder) {
        [self.SellPrice resignFirstResponder];
    }
    if ([self hasValidPrice: self.SellPrice.text] == NO) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Alert"
                                  message:@"The sell price is invalid!!"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }

}

@end
