//
//  SearchFacebookContainer.h
//  Confess
//
//  Created by Noga badhav on 15/01/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsTab.h"

@interface SearchFacebookContainer : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) NSArray *currData;
@property (nonatomic, strong) NSArray *allFriends;
-(void) setDetailItem : (UIViewController*) view view : (NSMutableArray*) dialogs;

@end