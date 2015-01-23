//
//  ConfessCell.h
//  Confess
//
//  Created by Noga badhav on 20/01/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfessEntity.h"

@interface ConfessCell : UITableViewCell

@property (nonatomic, strong) UITextView  *content;
@property (nonatomic, strong) UIButton     *name;
@property (nonatomic, strong) UIImageView *profileImage;
@property (nonatomic, strong) IBOutlet UILabel *date;
+ (CGFloat)heightForCellWithConfess:(ConfessEntity *)message;
- (void)configureCellWithConfess:(ConfessEntity *)message;

@end