//
//  LogInContainer.h
//  Confess
//
//  Created by Noga badhav on 26/09/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface LogInContainer : UIViewController

@property (strong, nonatomic) ViewController *logInViewController;
-(void)initProperties:(ViewController*)viewController;

@end
