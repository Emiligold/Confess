//
//  ConfessButtonContainer.h
//  Confess
//
//  Created by Noga badhav on 14/02/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfessFriend.h"

@interface ConfessButtonContainer : UIViewController

@property(nonatomic, strong) ConfessFriend *confessFriend;
- (IBAction)confessClicked:(UIButton*)sender;
- (IBAction)confessTouchDown:(UIButton*)sender;
@property (weak, nonatomic) IBOutlet UIButton *confessButton;
- (IBAction)confessTouchOut:(id)sender;

@end
