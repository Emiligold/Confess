//
//  ConfessMessageViewCell.h
//  Confess
//
//  Created by Noga badhav on 21/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfessEntity.h"

@interface ConfessMessageViewCell : UITableViewCell

@property (nonatomic, strong) UITextView  *messageTextView;
@property (nonatomic, strong) UILabel     *dateLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;

+ (CGFloat)heightForCellWithMessage:(QBChatAbstractMessage *)message;
+ (CGFloat)heightForCellWithConfess:(ConfessEntity *)message;
- (void)configureCellWithMessage:(QBChatAbstractMessage *)message;
- (void)configureCellWithConfess:(ConfessEntity *)message;

@end
