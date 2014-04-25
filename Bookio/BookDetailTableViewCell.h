//
//  BookDetailTableViewCell.h
//  Bookio
//
//  Created by Pooja Jain on 4/25/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookDetailTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *BookName;
@property (strong, nonatomic) IBOutlet UILabel *BookAuthor;
@property (strong, nonatomic) NSString *isbn;
@end
