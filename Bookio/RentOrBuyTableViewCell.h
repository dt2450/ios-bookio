//
//  RentOrBuyTableViewCell.h
//  Bookio
//
//  Created by Pooja Jain on 4/25/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RentOrBuyTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *UserId;
@property (strong, nonatomic) IBOutlet UILabel *Cost;
@property (strong, nonatomic) IBOutlet UIButton *sendTextMessage;
@property (strong, nonatomic) NSString *phoneNumber;
@end
