//
//  SettingsTab.h
//  Confess
//
//  Created by Noga badhav on 03/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface SettingsTab : UIViewController

@property (strong, nonatomic) IBOutlet FBLoginView *loginView;
-(void)initProperties;
@property (weak, nonatomic) IBOutlet UITableView *settingsTable;

@end
