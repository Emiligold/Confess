//
//  ChatCell.m
//  Confess
//
//  Created by Noga badhav on 11/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import "ChatCell.h"

@implementation ChatCell
@synthesize userName, userProfile;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
