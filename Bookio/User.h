//
//  User.h
//  Bookio
//
//  Created by Pooja Jain on 4/23/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * user_fname;
@property (nonatomic, retain) NSString * user_lname;
@property (nonatomic, retain) NSString * user_phone;

@end
