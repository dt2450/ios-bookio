//
//  SearchViewController.h
//  Bookio
//
//  Created by Pooja Jain on 4/20/14.
//  Copyright (c) 2014 Columbia University. All rights reserved.
//


@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UITableView *SearchResultsTableView;
@property (strong, nonatomic) IBOutlet UIButton *SearchButton;
@property (strong, nonatomic) IBOutlet UITextField *courseNumber;
@property (nonatomic, strong) NSArray *ResultBooks;
@end
