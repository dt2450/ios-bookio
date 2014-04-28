//
//  AddNewBooksTableViewCell.h
//  Bookio
//
//  Created by Pooja Jain on 4/27/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewBooksTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *bookName;
@property (strong, nonatomic) IBOutlet UILabel *bookAuthor;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) NSString *isbn;
@end
