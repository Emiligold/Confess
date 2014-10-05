//
//  TabController.m
//  Confess
//
//  Created by Noga badhav on 03/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import "TabController.h"
#import "FriendsTab.h"
#import "SettingsTab.h"
#import "MeTab.h"

@interface TabController ()

@end

@implementation TabController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hideFacebookAction
{
    FriendsTab *view = ((FriendsTab*)[[self viewControllers] objectAtIndex:1]);
    view.hideFacebook = self.hideFacebook;
    [view hideFacebookAction];
    
}

-(void)initProperties
{
    SettingsTab *settingsTab = ((SettingsTab*)[[self viewControllers] objectAtIndex:2]);
    settingsTab.loginView = self.loginView;
    [settingsTab initProperties];
    MeTab *meTab = ((MeTab*)[[self viewControllers] objectAtIndex:0]);
    meTab.profileID = self.profileID;
    meTab.nameText = self.nameText;
    [meTab initProperties];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //((FriendsTab*)[[self viewControllers] objectAtIndex:1]).hideFacebook = self.hideFacebook;
}


@end
