//
//  TabController.h
//  Confess
//
//  Created by Noga badhav on 03/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendsTab.h"
#import <FacebookSDK/FacebookSDK.h>

@interface TabController : UITabBarController <UITabBarControllerDelegate>

@property (nonatomic, assign) BOOL hideFacebook;
@property (strong, nonatomic) IBOutlet FBLoginView *loginView;
@property (weak, nonatomic) IBOutlet NSString *nameText;
@property (weak, nonatomic) IBOutlet NSString *profileID;
-(void)hideFacebookAction;
-(void)initProperties;

@end
