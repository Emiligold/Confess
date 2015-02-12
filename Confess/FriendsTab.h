//
//  FriendsTab.h
//  Confess
//
//  Created by Noga badhav on 02/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import <FacebookSDK/FacebookSDK.h>
#import "DBManager.h"

@interface FriendsTab : UIViewController <ABPeoplePickerNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *phoneImage;
@property (nonatomic, assign) BOOL hideFacebook;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *facebookButton;
@property (weak, nonatomic) IBOutlet UIToolbar *confessTab;
-(void)hideFacebookAction;
- (IBAction)showPicker:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *facebookImage;
- (IBAction)facebookClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *container;
-(void)facebookLoadCompleted;
-(void)friendClicked:(NSUInteger)index;

@end