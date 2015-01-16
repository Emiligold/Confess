//
//  SearchFacebook.h
//  Confess
//
//  Created by Noga badhav on 04/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfessView.h"
#import "FriendsTab.h"

@interface SearchFacebook : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISearchBar *searchField;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) NSArray *currData;
@property (nonatomic, strong) NSArray *allFriends;
-(void) setDetailItem : (FriendsTab*) view : (NSMutableArray*) dialogs;

@end
