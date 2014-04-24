//
//  UserBooks.h
//  Bookio
//
//  Created by Pooja Jain on 4/23/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserBooks : NSManagedObject

@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * isbn;
@property (nonatomic, retain) NSNumber * rent;
@property (nonatomic, retain) NSNumber * rent_cost;
@property (nonatomic, retain) NSNumber * sell;
@property (nonatomic, retain) NSNumber * sell_cost;

@end
