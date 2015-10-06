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
    self.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hideFacebookAction
{
    UINavigationController *navigationController = (UINavigationController*)[[self viewControllers] objectAtIndex:1];
    FriendsTab *view = (FriendsTab*)[navigationController.viewControllers objectAtIndex:0];
    //FriendsTab *view = ((FriendsTab*)[[self viewControllers] objectAtIndex:1]);
    view.hideFacebook = self.hideFacebook;
    [view hideFacebookAction];
    
}

-(void)initProperties
{
    UINavigationController *settingsTabNavigationController = (UINavigationController*)[[self viewControllers] objectAtIndex:2];
    SettingsTab *settingsTab = (SettingsTab*)[settingsTabNavigationController.viewControllers objectAtIndex:0];
    settingsTab.loginView = self.loginView;
    [settingsTab initProperties];
    UINavigationController *meTabNavigationController = (UINavigationController*)[[self viewControllers] objectAtIndex:0];
    MeTab *meTab = (MeTab*)[meTabNavigationController.viewControllers objectAtIndex:0];
    meTab.profileID = self.profileID;
    meTab.nameText = self.nameText;
    [meTab initProperties];
    UINavigationController *friendsTabNavigationController = (UINavigationController*)[[self viewControllers] objectAtIndex:1];
    FriendsTab *friendsTab = (FriendsTab*)[friendsTabNavigationController.viewControllers objectAtIndex:0];
    friendsTab.profileID = self.profileID;
    friendsTab.nameText = self.nameText;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    //((FriendsTab*)[[self viewControllers] objectAtIndex:1]).hideFacebook = self.hideFacebook;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    static UIViewController *previousController = nil;
    
    // the same tab was tapped a second time
    if (previousController == viewController)
    {
        if ([((UINavigationController*)viewController).tabBarItem.title isEqualToString:@"Friends"])
        {
            [((FriendsTab*)[((UINavigationController*)viewController).viewControllers objectAtIndex:0]) scrollUp];
        }
        else if ([((UINavigationController*)viewController).tabBarItem.title isEqualToString:@"Me"])
        {
            [((MeTab*)[((UINavigationController*)viewController).viewControllers objectAtIndex:0]) scrollUp];
        }
    }
    previousController = viewController;
}

@end
