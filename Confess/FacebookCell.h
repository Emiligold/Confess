//
//  FacebookCell.h
//  Confess
//
//  Created by Noga badhav on 24/01/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookCell : UITableViewCell

@property (nonatomic, strong) UIImageView *profileImage;
@property (nonatomic, strong) IBOutlet UIButton *name;
- (void)configureCellWithFriend:(NSDictionary<FBGraphUser> *)facebookFriend;
+(NSString*)getUserUrl:(NSDictionary<FBGraphUser>*)user;

@end