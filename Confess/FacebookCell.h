//
//  FacebookCell.h
//  Confess
//
//  Created by Noga badhav on 24/01/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FriendsTab.h"
#import "ConfessEntity.h"

@interface FacebookCell : UITableViewCell

@property (nonatomic, strong) UITextView  *content;
@property (nonatomic, strong) UIImageView *profileImage;
@property (nonatomic, strong) IBOutlet UIButton *name;
- (void)configureCellWithFriend:(NSDictionary<FBGraphUser> *)facebookFriend;
+(NSString*)getUserUrl:(NSDictionary<FBGraphUser>*)user;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:
    (NSString *)reuseIdentifier friendsTab:(FriendsTab*)friendsTab;

@end