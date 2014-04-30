//
//  AddRentedTableViewCell.h
//  Bookio
//
//  Created by Devashi Tandon on 4/30/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddRentedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthors;
@property (weak, nonatomic) IBOutlet UITextField *rentedTo;
@property (weak, nonatomic) IBOutlet UITextField *tillDate;
@property (weak, nonatomic) IBOutlet UIButton *addToRentals;
@property (strong, nonatomic) NSString *isbn;

@end
