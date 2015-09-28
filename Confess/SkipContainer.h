//
//  SkipContainer.h
//  Confess
//
//  Created by Noga badhav on 28/09/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface SkipContainer : UIViewController

@property (nonatomic, strong) ViewController *logInViewController;

-(void)initProperties:(ViewController*)viewController;

@end
