//
//  ChatCell.h
//  Confess
//
//  Created by Noga badhav on 11/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatCell : UITableViewCell

@property (nonatomic,retain) IBOutlet UILabel *userName;
@property (strong,nonatomic) IBOutlet UIImageView *userProfile;

@end
