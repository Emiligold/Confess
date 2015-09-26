//
//  ViewController.h
//  Confess
//
//  Created by Noga badhav on 30/09/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "TabController.h"
#import <Foundation/Foundation.h>
//#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface ViewController : UIViewController <FBLoginViewDelegate, QBChatDelegate>

@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (strong, nonatomic) IBOutlet FBLoginView *loginView;
@property (strong, nonatomic) IBOutlet UIButton *continueNoFacebook;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet TabController *tbc;
@property (weak, nonatomic) IBOutlet NSString *nameText;
@property (weak, nonatomic) IBOutlet NSString *profileID;
@property (weak, nonatomic) IBOutlet UIButton *logInFacebookButton;

@end
