//
//  ConfessCell.h
//  Confess
//
//  Created by Noga badhav on 20/01/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfessEntity.h"
#import "FriendsTab.h"
#import "MeTab.h"

@interface ConfessCell : UITableViewCell

@property (nonatomic, strong) UITextView  *content;
@property (nonatomic, strong) UIButton     *name;
@property (nonatomic, strong) UIImageView *profileImage;
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) UIButton *exit;
@property (nonatomic, strong) UILabel *date;
@property (nonatomic, strong) ConfessEntity *confess;
+ (CGFloat)heightForCellWithConfess:(ConfessEntity *)message isMine:(BOOL)isMine;
- (void)configureCellWithConfess:(ConfessEntity *)message;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isMine:(BOOL)mine friendsTab:(FriendsTab*)friendsTab meTab:(MeTab*)meTab;

@end