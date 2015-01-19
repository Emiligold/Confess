//
//  FriendsTab.m
//  Confess
//
//  Created by Noga badhav on 02/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import "FriendsTab.h"
#import "SearchFacebook.h"
#import "ConfessView.h"
#import "ConfessEntity.h"
#import "DateHandler.h"
#import "DBServices.h"
#import "SearchFacebookContainer.h"
//#import "FacebookSearchContainer.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FriendsTab () <QBActionStatusDelegate>

@property (nonatomic, strong) NSMutableArray *dialogs;
@property (weak, nonatomic) IBOutlet UITableView *chatTable;
@property (nonatomic, strong) NSMutableArray *allDialogs;

@end

@implementation FriendsTab

NSString *contactName;
id senderContact;
NSString *phone;
//SearchFacebookContainer *containerView;
NSString *cellIdentifier = @"ChatRoomCellIdentifier";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Navigation Initialize
    [self.navigationItem setHidesBackButton:YES animated:YES];
    UIButton *contactButton = [[UIButton alloc] init];
    contactButton.frame=CGRectMake(0,0,30,30);
    [contactButton setBackgroundImage:[UIImage imageNamed: @"Telefono.png"]
                       forState:UIControlStateNormal];
    [contactButton addTarget:self action:@selector(showPicker:)
      forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *contactItem = [[UIBarButtonItem alloc]
                               initWithCustomView:contactButton];
    UIButton *facebookButton = [[UIButton alloc] init];
    facebookButton.frame = CGRectMake(0, 0, 24, 24);
    [facebookButton setBackgroundImage:[UIImage imageNamed:@"Facebook_logo_(square).png"] forState:UIControlStateNormal];
    [facebookButton addTarget:self action:@selector(facebookClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *facebookItem = [[UIBarButtonItem alloc] initWithCustomView:facebookButton];
    self.navigationItem.rightBarButtonItem = contactItem;
    self.navigationItem.leftBarButtonItem = facebookItem;
    //UISearchBar *searchBar = [[UISearchBar alloc] init];
    //searchBar.placeholder = @"Find Facebook friends";
    //self.navigationItem.titleView = searchBar;
    
    
    self.tabBarController.tabBar.hidden = NO;
    self.chatTable.allowsMultipleSelectionDuringEditing = NO;
    //self.searchBar.delegate = self;
    //self.chatTable.tableHeaderView = self.searchBar;
    self.tabBarController.tabBar.barTintColor =  [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:(231/255.0) green:(238/255.0) blue:(243/255.0) alpha:1];
    self.tabBarController.tabBar.barTintColor = [UIColor colorWithRed:(231/255.0) green:(238/255.0) blue:(243/255.0) alpha:1];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [QBChat dialogsWithExtendedRequest:nil delegate:self];
    self.tabBarController.tabBar.hidden = NO;
    //self.searchBar.text = @"";
    
    if (self.dialogs.count > 0)
    {
        [self.chatTable setContentOffset:CGPointMake(0, 40)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)hideFacebookAction
{
    self.facebookImage.hidden = self.hideFacebook;
    NSArray *array = self.confessTab.items;
    NSMutableArray *arrayThatYouCanRemoveObjects = [NSMutableArray arrayWithArray:array];
    [arrayThatYouCanRemoveObjects removeObjectAtIndex:2];
    array = [NSArray arrayWithArray: arrayThatYouCanRemoveObjects];
    [self.confessTab setItems:array animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // TODO: Fix this
    if ([[segue identifier] isEqualToString:@"Chat"])
    {
        ConfessView *translationQuizAssociateVC = [segue destinationViewController];
        [translationQuizAssociateVC setDetailItem:contactName : phone : self : self.dialogs : nil url: nil];
    }
    // TODO: Remove this segue
    //else if ([[segue identifier] isEqualToString:@"Associate"])
    //{
    //    SearchFacebook *translationQuizAssociateVC = [segue destinationViewController];
    //    [translationQuizAssociateVC setDetailItem: self : self.dialogs];
    //}
    else if ([[segue identifier] isEqualToString:@"DialogChoose"])
    {
        NSString *name = ((UITableViewCell *)sender).textLabel.text;
        UIImage *image = ((UITableViewCell *)sender).imageView.image;
        ConfessView *destinationViewController = [segue destinationViewController];
        //destinationViewController.friendImage = image
        [destinationViewController setDetailItem:name :nil :self :self.dialogs :nil url:image];
        
        if ([self.dialogs[((UITableViewCell *)sender).tag] isKindOfClass:[QBChatDialog class]])
        {
            QBChatDialog *dialog = self.dialogs[((UITableViewCell *)sender).tag];
            destinationViewController.dialog = dialog;
        }
        else
        {
            ConfessEntity *dialog = self.dialogs[((UITableViewCell *)sender).tag];
            [destinationViewController setDetailItem:name : nil :self :self.dialogs : dialog.facebookID url: image];
        }
    }
    else if ([[segue identifier] isEqualToString:@"Container"])
    {
        //containerView = [segue destinationViewController];
        //[containerView setDetailItem:self view:self.dialogs];
    }
}

- (IBAction)showPicker:(id)sender
{
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    senderContact = sender;
    //[self performSegueWithIdentifier:@"Chat" sender:sender];
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:NO completion:nil];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self displayPerson:person];
    //[self performSegueWithIdentifier:@"Chat" sender:senderContact];
    //[self dismissViewControllerAnimated:NO completion:nil];
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)displayPerson:(ABRecordRef)person
{
    NSString* name = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonFirstNameProperty);
    //self.firstName.text = name;
    contactName = name;
    phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
       phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
    CFRelease(phoneNumbers);
    [self dismissViewControllerAnimated:NO completion:nil];
    [self performSegueWithIdentifier:@"Chat" sender:senderContact];

    //self.phoneNumber.text = phone;
    
}

- (IBAction)facebookClicked:(id)sender {
    //[self.searchBar resignFirstResponder];
    //[self performSelector:@selector(callSearchBar) withObject:NULL afterDelay:0];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"Find Facebook friends";
    self.navigationItem.titleView = searchBar;
    [searchBar resignFirstResponder];
    [searchBar becomeFirstResponder];
    searchBar.showsCancelButton = YES;
    self.searchBar.hidden = YES;
    [self.dialogs removeAllObjects];
    [self.allDialogs removeAllObjects];
    [self.chatTable reloadData];
    //self.container.hidden = NO;
    //[[self navigationController] setNavigationBarHidden:YES animated:YES];
    //self.searchBar.showsCancelButton = YES;
    //self.searchBar.placeholder = @"Confess a Facebook friend";
    //[self.dialogs removeAllObjects];
    //self.chatTable.alwaysBounceVertical = NO;
    //[self.chatTable reloadData];
    //self.chatTable.scrollEnabled = NO;
    
}

-(void)callSearchBar{
    [self.searchDisplayController setActive: YES animated: YES];
    self.searchDisplayController.searchBar.hidden = NO;
    [self.searchDisplayController.searchBar becomeFirstResponder];
    self.searchDisplayController.searchBar.placeholder = @"Confess Facebook friends";
    //[self.dialogs removeAllObjects];
    //[self.chatTable reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.dialogs count];
        
    //} else {
    //    return [self.allDialogs count];
    //}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.tag  = indexPath.row;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *url;
    
    if ([self.dialogs[indexPath.row] isKindOfClass:[QBChatDialog class]])
    {
        QBChatDialog *chatDialog = self.dialogs[indexPath.row];
        QBUUser *recipient = [LocalStorageService shared].usersAsDictionary[@(chatDialog.recipientID)];
        cell.textLabel.text = [recipient.login stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        cell.detailTextLabel.text = chatDialog.lastMessageText;
    }
    else
    {
        ConfessEntity *confess = self.dialogs[indexPath.row];
        cell.textLabel.text = confess.loginName;
        cell.detailTextLabel.text = confess.content;
        url = confess.facebookID;
    }
    
    //if (indexPath.row % 2)
    //{
        //cell.backgroundColor = [UIColor lightGrayColor];
        cell.backgroundColor = [UIColor colorWithRed:(231/255.0) green:(238/255.0) blue:(243/255.0) alpha:1];
    //}
    //else
    //{
        //cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"GrayConfess.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
        //cell.textLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"GrayConfess.png"]];
        //cell.detailTextLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"GrayConfess.png"]];
        //cell.backgroundColor = [UIColor colorWithRed:(199/255.0) green:(221/255.0) blue:(236/255.0) alpha:1];
    //}
    
    NSData *data = [NSData dataWithContentsOfURL : [NSURL URLWithString:url]];
    cell.imageView.image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([[UIImage imageWithData: data] CGImage],CGRectMake(20, 20, 45, 45) )];
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 20;
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self performSegueWithIdentifier:@"DialogChoose" sender:sender];
//}

- (void)completedWithResult:(Result *)result{
    if (result.success && [result isKindOfClass:[QBDialogsPagedResult class]]) {
        QBDialogsPagedResult *pagedResult = (QBDialogsPagedResult *)result;
        NSArray *dialogs = pagedResult.dialogs;
        NSMutableArray *dialogsFilter = [dialogs mutableCopy];
        
        for (QBChatDialog *dialog in dialogs)
        {
            NSMutableArray *parameters = [[NSMutableArray alloc] init];
            [parameters addObject:[NSString stringWithFormat:@"dialog_id = '%@'", dialog.ID]];
            [[DBManager shared] selectQuery:tDialogs table:parameters];
            NSArray *result = [[NSArray alloc] initWithArray:[[DBManager shared] executeNonExecutableQuery]];
            
            if ((dialog.userID != [LocalStorageService shared].currentUser.ID) ||
                (result.count != 0 && ((NSMutableArray*)result[0])[1]))
            {
                [dialogsFilter removeObject:dialog];
            }
        }
        
        NSString *myID = [NSString stringWithFormat:@"%ld", (unsigned long)[LocalStorageService shared].currentUser.ID];
        self.dialogs = [dialogsFilter mutableCopy];
        
        if (self.dialogs == nil)
        {
            self.dialogs = [[NSMutableArray alloc] init];
        }
        
        NSMutableArray *parameters = [[NSMutableArray alloc] init];
        [parameters addObject:[NSString stringWithFormat:@"user_id = '%@'", myID]];
        [[DBManager shared] selectQuery:tFriendsNoAppConfesses table:parameters];
        NSMutableArray *resultFirst = [[NSMutableArray alloc]
                                       initWithArray:[[DBManager shared] executeNonExecutableQuery]];
        
        //TODO: Improve this shit
        for (NSMutableArray *curr in resultFirst)
        {
            // The dialog is not deleted
            if (resultFirst.count > 0 && ![curr[3] boolValue])
            {
                // Getting last confess
                NSMutableArray *parameters = [[NSMutableArray alloc] init];
                [parameters addObject:[NSString stringWithFormat:@"no_app_code = %@", curr[0]]];
                [[DBManager shared] selectQuery:tCodeFriendsNoAppConfesses table:parameters];
                [parameters removeAllObjects];
                [parameters addObject:@"confess_id"];
                [[DBManager shared] orderBy:parameters values:@"DESC"];
                NSMutableArray *resultSecond = [[NSMutableArray alloc] initWithArray:[[DBManager shared] executeNonExecutableQuery]];
                [parameters removeAllObjects];
                [parameters addObject:[NSString stringWithFormat:@"id = %@", resultSecond[0][1]]];
                [[DBManager shared] selectQuery:tConfessEntity table:parameters];
                NSMutableArray *confessResult = [[NSMutableArray alloc] initWithArray:[[DBManager shared] executeNonExecutableQuery]];
                ConfessEntity *confess = [[ConfessEntity alloc] init];
                confess.objectID = [((NSMutableArray*)confessResult[0])[0] integerValue];
                confess.loginName = ((NSMutableArray*)confessResult[0])[2];
                confess.facebookID = ((NSMutableArray*)confessResult[0])[1];
                confess.content = ((NSMutableArray*)confessResult[0])[3];
                confess.date = [DateHandler dateFromString:((NSMutableArray*)confessResult[0])[4]];
                confess.isNew = [((NSMutableArray*)confessResult[0])[5] boolValue];
                [self.dialogs addObject:confess];
            }
        }
        
        QBGeneralResponsePage *pagedRequest = [QBGeneralResponsePage responsePageWithCurrentPage:0 perPage:100];
        NSSet *dialogsUsersIDs = pagedResult.dialogsUsersIDs;
        [QBRequest usersWithIDs:[dialogsUsersIDs allObjects] page:pagedRequest successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *users) {
            
            [LocalStorageService shared].users = users;
            
        } errorBlock:nil];
        
        _allDialogs = [NSMutableArray arrayWithArray:self.dialogs];
        [self.chatTable reloadData];
        
        if (self.dialogs.count > 0 /* TODO: && self.container.hidden*/)
        {
            //[self.chatTable setContentOffset:CGPointMake(0, 40)];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        if ([self.dialogs[indexPath.row] isKindOfClass:[QBChatDialog class]])
//        {
            //TODO: Check if works
//            QBChatDialog *dialog = self.dialogs[indexPath.row];
//            [DBServices updateDialogStatus:dialog.ID dialogId:1];
//        }
//        else
//        {
//            ConfessEntity *dialog = self.dialogs[indexPath.row];
//            [DBServices updateConversationStatus:dialog.facebookID userUrl:1];
//        }
        
//        [self.dialogs removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.chatTable reloadData];
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

/*-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.placeholder == nil || [searchBar.placeholder isEqualToString:@""])
    {
        NSMutableArray *mutableArray = [(NSArray*)_allDialogs mutableCopy];
    
        for (NSObject *curr in _allDialogs)
        {
            NSString *name;
        
            if ([curr isKindOfClass:[QBChatDialog class]])
            {
                QBChatDialog *dialog = (QBChatDialog*)curr;
                QBUUser *recipient = [LocalStorageService shared].usersAsDictionary[@(dialog.recipientID)];
                name = [recipient.login stringByReplacingOccurrencesOfString:@"_" withString:@" "];
            }
            else
            {
                ConfessEntity *dialg = (ConfessEntity*)curr;
                name = dialg.loginName;

            }
        
            if (![searchText  isEqualToString: @""] && [[name uppercaseString] rangeOfString:[searchText uppercaseString]].location == NSNotFound)
            {
                [mutableArray removeObject:curr];
            }
        }
    
        self.dialogs = [NSMutableArray arrayWithArray:mutableArray];
        [self.chatTable reloadData];
    }
    else
    {
        //FacebookSearchContainer *container = (FacebookSearchContainer*)self.container;
        //NSMutableArray *mutableArray = [(NSArray*)containerView.allFriends mutableCopy];
        
        //for (NSDictionary<FBGraphUser> *curr in containerView.allFriends)
        //{
        //    if ([[curr.name uppercaseString] rangeOfString:[searchText uppercaseString]].location == NSNotFound)
        //    {
        //        [mutableArray removeObject:curr];
        //    }
        //}
        
        //containerView.currData = [NSArray arrayWithArray:mutableArray];
        //[containerView.myTableView reloadData];
    }
}*/

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.searchDisplayController.searchBar.placeholder = @"Search";
   // [searchBar resignFirstResponder];
    //[searchBar setShowsCancelButton:NO animated:YES];
    //[[self navigationController] setNavigationBarHidden:NO animated:YES];
    //self.searchBar.placeholder = @"";
    //self.container.hidden = YES;
    //self.searchBar.text = @"";
    //self.chatTable.hidden = NO;
    //self.chatTable.alwaysBounceVertical = YES;
    //self.chatTable.scrollEnabled = YES;
    
    if (self.dialogs.count > 0)
    {
        //[self.chatTable setContentOffset:CGPointMake(0, 44)];
    }
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
   // [[self navigationController] setNavigationBarHidden:YES animated:YES];
    //self.navigationController.navigationBar.hidden=TRUE;
    //CGRect r=self.view.frame;
    //r.origin.y=-0.08;
    //r.size.height+=0.08;
    //self.view.frame=r;
    //[searchBar setShowsCancelButton:YES animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //CGRect rect = self.searchBar.frame;
    //rect.origin.y = MIN(0, scrollView.contentOffset.y);
    //self.searchBar.frame = rect;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSMutableArray *mutableArray = [(NSArray*)_allDialogs mutableCopy];
    
    for (NSObject *curr in _allDialogs)
    {
        NSString *name;
        
        if ([curr isKindOfClass:[QBChatDialog class]])
        {
            QBChatDialog *dialog = (QBChatDialog*)curr;
            QBUUser *recipient = [LocalStorageService shared].usersAsDictionary[@(dialog.recipientID)];
            name = [recipient.login stringByReplacingOccurrencesOfString:@"_" withString:@" "];
        }
        else
        {
            ConfessEntity *dialg = (ConfessEntity*)curr;
            name = dialg.loginName;
            
        }
        
        if (![searchText  isEqualToString: @""] && [[name uppercaseString] rangeOfString:[searchText uppercaseString]].location == NSNotFound)
        {
            [mutableArray removeObject:curr];
        }
    }
    
    self.dialogs = [NSMutableArray arrayWithArray:mutableArray];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

@end