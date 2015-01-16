//
//  SearchFacebookContainer.m
//  Confess
//
//  Created by Noga badhav on 15/01/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import "SearchFacebookContainer.h"
#import <FacebookSDK/FacebookSDK.h>
#import "ConfessWrite.h"

@interface SearchFacebookContainer ()

@property (weak, nonatomic) IBOutlet FriendsTab *friendsView;
@property (nonatomic, strong) NSMutableArray *dialogs;

@end

@implementation SearchFacebookContainer

static NSString *cellIdentifier;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    [self performSegueWithIdentifier:@"ChooseRow" sender:tableView];
}

-(void) setDetailItem : (FriendsTab*) view : (NSMutableArray*) dialogs
{
    self.friendsView = view;
    self.dialogs = dialogs;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

-(void) setDetailItem : (UIViewController*) view view : (NSMutableArray*) dialogs
{
    self.friendsView = (FriendsTab*)view;
    self.dialogs = dialogs;
}

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ChooseRow"])
    {
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
        self.friendsView.container.hidden = YES;
    }
}


@end
