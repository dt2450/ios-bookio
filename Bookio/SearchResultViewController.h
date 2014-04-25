//
//  SearchResultViewController.h
//  Bookio
//
//  Created by Pooja Jain on 4/22/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//


@interface SearchResultViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UITableView *RentOrBuyTableView;
@property (nonatomic, strong) NSMutableArray *RentUsers;
@property (nonatomic, strong) NSMutableArray *BuyUsers;
@property (strong,nonatomic) id isbn;

@end
