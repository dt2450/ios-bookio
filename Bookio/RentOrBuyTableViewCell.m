//
//  RentOrBuyTableViewCell.m
//  Bookio
//
//  Created by Pooja Jain on 4/25/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import "RentOrBuyTableViewCell.h"

@implementation RentOrBuyTableViewCell

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

@end
