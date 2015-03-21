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
#import <FacebookSDK/FacebookSDK.h>
#import "UserSentConfesses.h"
#import "ConfessCell.h"
#import "ConfessCell.h"
#import "FacebookHandler.h"
#import "FacebookCell.h"
#import "ColorsHandler.h"
#import "ConfessFriend.h"
#import "ReturnButtonContainer.h"
#import "ConfessButtonContainer.h"

@interface FriendsTab () <QBActionStatusDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *facebookTable;
@property (nonatomic, strong) NSMutableArray *friends;
@property (nonatomic, strong) NSMutableArray *allFriends;
@property (nonatomic, strong) UIView *modalView;
@property (nonatomic, strong) ConfessFriend *confessFriend;
@property (nonatomic, strong) ConfessButtonContainer *confessButton;
@property (nonatomic, strong) ReturnButtonContainer *returnButton;

@end

@implementation FriendsTab

NSString *contactName;
id senderContact;
NSString *phone;
NSString *chatCellIdentifier = @"ChatRoomCellIdentifier";
NSString *fbCellIdentifier = @"FbRoomCellIdentifier";
UIBarButtonItem *contactItem;

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
    contactItem = [[UIBarButtonItem alloc]
                               initWithCustomView:contactButton];
    self.navigationItem.rightBarButtonItem = contactItem;
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.placeholder = @"Confess Facebook friends";
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.delegate = self;
    
    self.tabBarController.tabBar.hidden = NO;
    self.chatTable.allowsMultipleSelectionDuringEditing = NO;
    self.chatTable.backgroundColor = [ColorsHandler lightBlueColor];
    //self.searchBar.delegate = self;
    //self.chatTable.tableHeaderView = self.searchBar;
    self.tabBarController.tabBar.barTintColor =  [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [ColorsHandler mediumBlueColor];
    self.tabBarController.tabBar.barTintColor = [ColorsHandler mediumBlueColor];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [QBChat dialogsWithExtendedRequest:nil delegate:self];
    self.tabBarController.tabBar.hidden = NO;
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
    else if ([[segue identifier] isEqualToString:@"DialogChoose"])
    {
        NSString *name = ((UITableViewCell *)sender).textLabel.text;
        UIImage *image = ((UITableViewCell *)sender).imageView.image;
        ConfessView *destinationViewController = [segue destinationViewController];
        //destinationViewController.friendImage = image
        
        if ([self.dialogs[((UITableViewCell *)sender).tag] isKindOfClass:[QBChatDialog class]])
        {
            QBChatDialog *dialog = self.dialogs[((UITableViewCell *)sender).tag];
            destinationViewController.dialog = dialog;
            [destinationViewController setDetailItem:name :nil :self :self.dialogs :nil url:image];
        }
        else
        {
            ConfessEntity *dialog = self.dialogs[((UITableViewCell *)sender).tag];
            [destinationViewController setDetailItem:name : nil :self :self.dialogs : dialog.toFacebookID url: image];
        }
    }
    else if ([[segue identifier] isEqualToString:@"FacebookChoose"])
    {
        //containerView = [segue destinationViewController];
        //[containerView setDetailItem:self view:self.dialogs];
    }
    else if ([[segue identifier] isEqualToString:@"ConfessFriendSegue"])
    {
        self.confessFriend = [segue destinationViewController];
        
        if (self.returnButton != nil)
        {
            self.returnButton.confessFriend = self.confessFriend;
        }
        if (self.confessButton != nil)
        {
            self.confessButton.confessFriend = self.confessFriend;
        }
    }
    else if ([[segue identifier] isEqualToString:@"ReturnContainerSegue"])
    {
        if (self.confessFriend != nil)
        {
            self.returnButton = [segue destinationViewController];
            self.returnButton.confessFriend = self.confessFriend;
        }
    }
    else  if ([[segue identifier] isEqualToString:@"ConfessContainerSegue"])
    {
        if (self.confessFriend != nil)
        {
            self.confessButton = [segue destinationViewController];
            self.confessButton.confessFriend = self.confessFriend;
        }
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
    //[self performSegueWithIdentifier:@"Chat" sender:senderContact];

    ABMultiValueRef instantMessage = ABRecordCopyValue(person, kABPersonInstantMessageProperty);
    
    BOOL returnValue = NO;
    
    if (instantMessage)
    {
        for (NSInteger i=0 ; i < ABMultiValueGetCount(instantMessage); i++)
        {
            CFDictionaryRef instantMessageValue = ABMultiValueCopyValueAtIndex(instantMessage, i);
            CFStringRef instantMessageString = CFDictionaryGetValue(instantMessageValue, kABPersonInstantMessageServiceKey);

            if (CFStringCompare(instantMessageString, kABPersonInstantMessageServiceFacebook, 0) == kCFCompareEqualTo)
            {
                returnValue = YES;
            }
            
            CFRelease(instantMessageString);
            CFRelease(instantMessageValue);
        }
    }

    
    //self.phoneNumber.text = phone;
    
}

- (IBAction)facebookClicked:(id)sender {
    //[self.searchBar resignFirstResponder];
    //[self performSelector:@selector(callSearchBar) withObject:NULL afterDelay:0];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    searchBar.placeholder = @"Confess Facebook friends";
    self.navigationItem.titleView = searchBar;
    [searchBar resignFirstResponder];
    [searchBar becomeFirstResponder];
    searchBar.showsCancelButton = YES;
    //self.searchBar.hidden = YES;
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
    if (self.facebookTable.hidden)
        return [self.dialogs count];
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.facebookTable.hidden)
    {
        ConfessCell *cell = [self.chatTable dequeueReusableCellWithIdentifier:chatCellIdentifier];
    
        if (cell == nil)
        {
            cell = [[ConfessCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chatCellIdentifier isMine:NO friendsTab:self meTab:nil];
        }
    
        cell.tag  = indexPath.row;
        cell.backgroundColor = [ColorsHandler lightBlueColor];

        if ([self.dialogs[indexPath.row] isKindOfClass:[QBChatDialog class]])
        {
            QBChatDialog *chatDialog = self.dialogs[indexPath.row];
            QBUUser *recipient = [LocalStorageService shared].usersAsDictionary[@(chatDialog.recipientID)];
            cell.textLabel.text = [recipient.login stringByReplacingOccurrencesOfString:@"_" withString:@" "];
            cell.detailTextLabel.text = chatDialog.lastMessageText;
        }
        else if ([self.dialogs[indexPath.row] isKindOfClass:[ConfessEntity class]])
        {
            ConfessEntity *confess = self.dialogs[indexPath.row];
            [cell configureCellWithConfess:confess];
        }
        
        return cell;
    }

    FacebookCell *cell = [self.facebookTable dequeueReusableCellWithIdentifier:fbCellIdentifier];

    if (cell == nil)
    {
        cell = [[FacebookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:fbCellIdentifier friendsTab:self];
    }
    
    NSDictionary<FBGraphUser> *user = [self.friends objectAtIndex:indexPath.row];
    [cell configureCellWithFriend:user];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.textLabel.text = friend.name;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //NSData *data = [NSData dataWithContentsOfURL : [NSURL URLWithString:[self getUserUrl:[self.friends objectAtIndex:indexPath.row]]]];
    //cell.imageView.bounds = CGRectMake(0,0,120,120);
    //cell.imageView.frame = CGRectMake(0,0,120,120);
    //UIImage *image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([[UIImage imageWithData: data] CGImage],CGRectMake(0, 0, 120, 120))];
    //cell.imageView.image = image;
    //cell.imageView.image = [UIImage imageWithData:data];
    //cell.imageView.layer.masksToBounds = YES;
    //cell.imageView.layer.cornerRadius = 20;
    //cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //cell.imageView.frame = CGRectMake(0,0,500,500);
    //self.rowWidth is the desired Width
    //self.rowHeight is the desired height
    //CGFloat widthScale = 70 / image.size.width;
    //CGFloat heightScale = 70 / image.size.height;
    //this line will do it!
    //cell.imageView.transform = CGAffineTransformMakeScale(widthScale, heightScale);
    cell.backgroundColor = [ColorsHandler lightBlueColor];
    
    //if (indexPath.row % 2)
    //{
        //cell.backgroundColor = [UIColor lightGrayColor];
    //}
    //else
    //{
        //cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"GrayConfess.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
        //cell.textLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"GrayConfess.png"]];
        //cell.detailTextLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"GrayConfess.png"]];
        //cell.backgroundColor = [UIColor colorWithRed:(199/255.0) green:(221/255.0) blue:(236/255.0) alpha:1];
    //}
    
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
        self.urlOrIdToDialog = [[NSMutableDictionary alloc] init];
        NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"lastMessageDate" ascending:NO];
        NSArray *descriptors = [NSArray arrayWithObject:descriptor];
        
        if (dialogs != nil && dialogs.count > 0)
        {
            dialogs = [[dialogs sortedArrayUsingDescriptors:descriptors] mutableCopy];
        }
        
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
            else
            {
                NSString *recipientID = [NSString stringWithFormat:@"%d", dialog.recipientID];
                
                if ([self.urlOrIdToDialog objectForKey:recipientID] == nil)
                {
                    [self.urlOrIdToDialog setObject:dialog forKey:recipientID];
                }
            }
        }

        NSString *myID = [NSString stringWithFormat:@"%ld", (unsigned long)[LocalStorageService shared].currentUser.ID];
        self.dialogs = [dialogsFilter mutableCopy];
        
        if (self.dialogs == nil)
        {
            self.dialogs = [[NSMutableArray alloc] init];
        }
        
        NSMutableArray *sentConfesses = [DBServices getSentConfesses:myID];
        
        for (ConfessEntity *confess in sentConfesses)
        {
            [self.dialogs addObject:confess];
            
            if ([self.urlOrIdToDialog objectForKey:confess.url.url] == nil)
            {
                [self.urlOrIdToDialog setObject:confess forKey:confess.url.url];
            }
        }
        
        self.dialogs = [[self.dialogs sortedArrayUsingDescriptors:descriptors] mutableCopy];
        //NSMutableArray *parameters = [[NSMutableArray alloc] init];
        //[parameters addObject:[NSString stringWithFormat:@"user_id = '%@'", myID]];
        //[[DBManager shared] selectQuery:tFriendsNoAppConfesses table:parameters];
        //NSMutableArray *resultFirst = [[NSMutableArray alloc]
        //                               initWithArray:[[DBManager shared] executeNonExecutableQuery]];
        
        //for (NSMutableArray *curr in resultFirst)
        //{
            // The dialog is not deleted
        //    if (resultFirst.count > 0 && ![curr[3] boolValue])
         //   {
                // Getting last confess
         //       NSMutableArray *parameters = [[NSMutableArray alloc] init];
         //       [parameters addObject:[NSString stringWithFormat:@"no_app_code = %@", curr[0]]];
         //       [[DBManager shared] selectQuery:tCodeFriendsNoAppConfesses table:parameters];
         //       [parameters removeAllObjects];
         //       [parameters addObject:@"confess_id"];
         //       [[DBManager shared] orderBy:parameters values:@"DESC"];
         //       NSMutableArray *resultSecond = [[NSMutableArray alloc] initWithArray:[[DBManager shared] executeNonExecutableQuery]];
         //       [parameters removeAllObjects];
         //       [parameters addObject:[NSString stringWithFormat:@"id = %@", resultSecond[0][1]]];
         //       [[DBManager shared] selectQuery:tConfessEntity table:parameters];
         //       NSMutableArray *confessResult = [[NSMutableArray alloc] initWithArray:[[DBManager shared] executeNonExecutableQuery]];
          //      ConfessEntity *confess = [[ConfessEntity alloc] init];
          //      confess.objectID = [((NSMutableArray*)confessResult[0])[0] integerValue];
          //      confess.loginName = ((NSMutableArray*)confessResult[0])[2];
          //      confess.facebookID = ((NSMutableArray*)confessResult[0])[1];
          //      confess.content = ((NSMutableArray*)confessResult[0])[3];
          //      confess.date = [DateHandler dateFromString:((NSMutableArray*)confessResult[0])[4]];
          //      confess.isNew = [((NSMutableArray*)confessResult[0])[5] boolValue];
          //      [self.dialogs addObject:confess];
          //  }
        //}
        
        QBGeneralResponsePage *pagedRequest = [QBGeneralResponsePage responsePageWithCurrentPage:0 perPage:100];
        NSSet *dialogsUsersIDs = pagedResult.dialogsUsersIDs;
        [QBRequest usersWithIDs:[dialogsUsersIDs allObjects] page:pagedRequest successBlock:^(QBResponse *response, QBGeneralResponsePage *page, NSArray *users) {
            
            [LocalStorageService shared].users = users;
            
        } errorBlock:nil];
        
        self.allFriends = [[[FacebookHandler instance] getAllFriends] mutableCopy];
        [[FacebookHandler instance] setFriendsView:self];
        self.friends = [NSMutableArray arrayWithArray:self.allFriends];
    }
}

-(void)facebookLoadCompleted
{
    _allDialogs = [NSMutableArray arrayWithArray:self.dialogs];
    [self.chatTable reloadData];
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}

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
    if (self.facebookTable.hidden)
        return [ConfessCell heightForCellWithConfess:self.dialogs[indexPath.row] isMine:NO];
    NSDictionary<FBGraphUser> *user = self.friends[indexPath.row];
    
    if ([self.urlOrIdToDialog objectForKey:user.objectID] != nil || [self.urlOrIdToDialog objectForKey:[FacebookCell getUserUrl:user]] != nil)
    {
        return 250;
    }
    
    return 120;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:NO animated:YES];
    self.navigationItem.rightBarButtonItem = contactItem;
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    self.facebookTable.hidden = YES;
    self.chatTable.hidden = NO;
    [self.chatTable reloadData];
    
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.navigationItem.rightBarButtonItem = nil;
    [searchBar setShowsCancelButton:YES animated:YES];
    self.chatTable.hidden = YES;
    self.facebookTable.hidden = NO;
    self.friends = [[FacebookHandler instance] getAllFriends];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.friends = [NSMutableArray arrayWithArray:[[FacebookHandler instance] getAllFriends]];
    
    NSMutableArray *mutableArray = [self.friends mutableCopy];
    
    for (NSDictionary<FBGraphUser> *curr in self.friends)
    {
        if ([[curr.name uppercaseString] rangeOfString:[searchText uppercaseString]].location == NSNotFound)
        {
            [mutableArray removeObject:curr];
        }
    }
    
    self.friends = [NSMutableArray arrayWithArray:mutableArray];
    [self.facebookTable reloadData];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

-(void)friendClicked:(UITableViewCell*)cell
{
    self.modalView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.modalView.opaque = NO;
    self.modalView.backgroundColor =
    [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.container.layer.cornerRadius = 25;
    self.container.layer.masksToBounds = YES;
    self.buttonsContainer.layer.cornerRadius = 15;
    self.buttonsContainer.layer.masksToBounds = YES;
    self.returnContainer.layer.cornerRadius = 15;
    self.returnContainer.layer.masksToBounds = YES;
    self.infoContainer.layer.cornerRadius = 15;
    self.infoContainer.layer.masksToBounds = YES;
    [self.modalView addSubview:self.container];
    [self.modalView addSubview:self.buttonsContainer];
    [self.modalView addSubview:self.returnContainer];
    [self.modalView addSubview:self.infoContainer];
    [self.view addSubview:self.modalView];

    if ([cell isKindOfClass:[ConfessCell class]])
    {
        NSString *name = ((ConfessCell *)cell).name.titleLabel.text;
        UIImage *image = ((ConfessCell *)cell).profileImage.image;
        
        if ([self.dialogs[((UITableViewCell *)cell).tag] isKindOfClass:[QBChatDialog class]])
        {
            QBChatDialog *dialog = self.dialogs[((ConfessCell *)cell).tag];
            self.confessFriend.dialog = dialog;
            [self.confessFriend setDetailItem:name :[NSString stringWithFormat:@"%d", dialog.recipientID] :self :self.dialogs :nil url:image];
        }
        else
        {
            ConfessEntity *dialog = self.dialogs[((ConfessCell *)cell).tag];
            [self.confessFriend setDetailItem:name : nil :self :self.dialogs : dialog.url url: image];
        }
    }
    else
    {
        NSString *name = ((FacebookCell *)cell).name.titleLabel.text;
        UIImage *image = ((FacebookCell *)cell).profileImage.image;
        NSDictionary<FBGraphUser> *friend = self.friends[cell.tag];
        NSString *url = [FacebookCell getUserUrl:friend];
        [self.confessFriend setDetailItem:name :[[[FacebookHandler instance] haveApp] valueForKey:url] :self :self.dialogs :((CodeUrls*)[DBServices getEntityByUniqe:[[CodeUrls alloc] init] entityClass:[[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"url = '%@'", url], nil]]) url:image];
    }
    
    self.container.hidden = NO;
    self.buttonsContainer.hidden = NO;
    self.returnContainer.hidden = NO;
    self.infoContainer.hidden = NO;
}

-(void)exitFriendClicked
{
    self.container.hidden = YES;
    self.buttonsContainer.hidden = YES;
    self.returnContainer.hidden = YES;
    self.infoContainer.hidden = YES;
    [self.modalView removeFromSuperview];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end