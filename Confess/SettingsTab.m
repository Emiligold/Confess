//
//  SettingsTab.m
//  Confess
//
//  Created by Noga badhav on 03/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import "SettingsTab.h"

@interface SettingsTab ()  <UITableViewDelegate, UITableViewDataSource>

@end

@implementation SettingsTab

NSMutableArray *settings;

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
    self.tabBarController.tabBar.hidden = NO;
    settings = [[NSMutableArray alloc] initWithObjects:@"Log out", nil ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initProperties
{
    self.loginView.hidden = false;
    [self.view addSubview:self.loginView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    cell.textLabel.text = settings[indexPath.row];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)deleteAccount:(id)sender
{
    [FBRequestConnection startWithGraphPath:@"/me/permissions"
                                 parameters:nil
                                 HTTPMethod:@"DELETE"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              )
     {
         if (error != nil)
         {
             //TODO: Throw Exception
         }
         else
         {
             [self clickLogOut];
         }
     }];
}

-(void)clickLogOut
{
    for (id obj in self.loginView.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton* loginButton = obj;
            [self performSelector:@selector(logOut:) withObject:loginButton afterDelay:0.5];
        }
    }
}

-(void)logOut:(UIButton*)loginButton
{
    [loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
