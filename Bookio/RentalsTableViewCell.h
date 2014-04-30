//
//  RentalsTableViewCell.h
//  Bookio
//
//  Created by Devashi Tandon on 4/29/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RentalsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *bookAuthors;
@property (weak, nonatomic) IBOutlet UILabel *userId;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) NSString *isbn;
@property (strong, nonatomic) NSString *courseno;

@end
