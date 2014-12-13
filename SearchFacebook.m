//
//  SearchFacebook.m
//  Confess
//
//  Created by Noga badhav on 04/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import "SearchFacebook.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ConfessView.h"

@interface SearchFacebook ()

@property (weak, nonatomic) IBOutlet FriendsTab *friendsView;
@property (nonatomic, strong) NSMutableArray *dialogs;

@end

@implementation SearchFacebook

static NSString *cellIdentifier;

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
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];

    [FBRequestConnection startWithGraphPath:@"/me/friends"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              )
     {
         NSArray* friends = [result objectForKey:@"data"];
         
         for (NSDictionary<FBGraphUser>* friend in friends)
         {
             [mutableArray addObject:friend];
         }
         
         self.currData = [NSArray arrayWithArray:mutableArray];
         self.allFriends = [NSArray arrayWithArray:mutableArray];
     }];
    
    [FBRequestConnection startWithGraphPath:@"/me/taggable_friends?fields=name,picture.type(normal)"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              )
    {
        NSArray* friends = [result objectForKey:@"data"];

        for (NSDictionary<FBGraphUser>* friend in friends)
        {
            if (![mutableArray containsObject:friend])
            {
                [mutableArray addObject:friend];
            }
        }
        
        self.currData = [NSArray arrayWithArray:mutableArray];
        self.allFriends = [NSArray arrayWithArray:mutableArray];
    }];
    
    //self.data = [NSArray arrayWithArray:mutableArray];
    //self.data = [mutableArray copy];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.topItem.title = @"";
    cellIdentifier = @"rowCell";
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.currData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSDictionary<FBGraphUser> *friend = [self.currData objectAtIndex:indexPath.row];
    cell.textLabel.text = friend.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSData *data = [NSData dataWithContentsOfURL : [NSURL URLWithString:[self getUserUrl:friend]]];
    cell.imageView.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([[UIImage imageWithData: data] CGImage],CGRectMake(20, 20, 60, 60) )];
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 20;
    
    return cell;
}

-(NSString*)getUserUrl:(NSDictionary<FBGraphUser>*)user
{
    FBGraphObject *picture = [user objectForKey:@"picture"];
    FBGraphObject *check = [picture objectForKey:@"data"];
    return [check objectForKey:@"url"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ChooseRow"]) {
        NSIndexPath *indexPath = [self.myTableView indexPathForSelectedRow];
        NSDictionary<FBGraphUser> *friend = self.currData[indexPath.row];
        NSString *name = friend.name;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *userID = nil;
        
        // The friend has the application
        if ([defaults objectForKey:friend.objectID] != nil)
        {
            userID = [defaults objectForKey:friend.objectID];
        }
        
        UITableViewCell *cell = [self.myTableView cellForRowAtIndexPath: self.myTableView.indexPathForSelectedRow];
        [[segue destinationViewController] setDetailItem:name :userID :self.friendsView :self.dialogs :[self getUserUrl:friend] url:cell.imageView.image];
    }
}

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSMutableArray *mutableArray = [(NSArray*)self.allFriends mutableCopy];
    
    for (NSDictionary<FBGraphUser> *curr in self.allFriends)
    {
        if ([[curr.name uppercaseString] rangeOfString:[searchText uppercaseString]].location == NSNotFound)
        {
            [mutableArray removeObject:curr];
        }
    }
    
    self.currData = [NSArray arrayWithArray:mutableArray];
    [self.myTableView reloadData];
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    [self performSegueWithIdentifier:@"ChooseRow" sender:tableView];
}

-(void) setDetailItem : (FriendsTab*) view : (NSMutableArray*) dialogs
{
    self.friendsView = view;
    self.dialogs = dialogs;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.parentViewController viewDidAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.topItem.title = @"Confess a Facebook friend";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

@end
