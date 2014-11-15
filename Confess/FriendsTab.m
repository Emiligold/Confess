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

@interface FriendsTab () <UITableViewDelegate, UITableViewDataSource, QBActionStatusDelegate>

@property (nonatomic, strong) NSMutableArray *dialogs;
@property (weak, nonatomic) IBOutlet UITableView *chatTable;

@end

@implementation FriendsTab

NSString *contactName;
id senderContact;
NSString *phone;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    self.tabBarController.tabBar.hidden = NO;
    self.chatTable.allowsMultipleSelectionDuringEditing = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [QBChat dialogsWithExtendedRequest:nil delegate:self];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"Chat"])
    {
        ConfessView *translationQuizAssociateVC = [segue destinationViewController];
        [translationQuizAssociateVC setDetailItem:contactName : phone : self : self.dialogs : nil];
    }
    else if ([[segue identifier] isEqualToString:@"Associate"])
    {
        SearchFacebook *translationQuizAssociateVC = [segue destinationViewController];
        [translationQuizAssociateVC setDetailItem: self : self.dialogs];
    }
    else if ([[segue identifier] isEqualToString:@"DialogChoose"])
    {
        NSString *name = ((UITableViewCell *)sender).textLabel.text;
        ConfessView *destinationViewController = [segue destinationViewController];
        [destinationViewController setDetailItem:name : nil :self :self.dialogs : nil];
        
        if ([self.dialogs[((UITableViewCell *)sender).tag] isKindOfClass:[QBChatDialog class]])
        {
            QBChatDialog *dialog = self.dialogs[((UITableViewCell *)sender).tag];
            destinationViewController.dialog = dialog;
        }
        else
        {
            ConfessEntity *dialog = self.dialogs[((UITableViewCell *)sender).tag];
            [destinationViewController setDetailItem:name : nil :self :self.dialogs : dialog.facebookID];
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
    [self performSegueWithIdentifier:@"Chat" sender:senderContact];

    //self.phoneNumber.text = phone;
    
}

- (IBAction)facebookClicked:(id)sender {
    [self performSegueWithIdentifier:@"Associate" sender:sender];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.dialogs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatRoomCellIdentifier"];
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
    
    NSData *data = [NSData dataWithContentsOfURL : [NSURL URLWithString:url]];
    cell.imageView.image = [UIImage imageWithData: data];
    CGFloat widthScale = 50 / cell.imageView.image.size.width;
    CGFloat heightScale = 50 / cell.imageView.image.size.height;
    cell.imageView.transform = CGAffineTransformMakeScale(widthScale, heightScale);
    cell.imageView.layer.cornerRadius = cell.imageView.frame.size.height / 2;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

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
        [self.chatTable reloadData];
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([self.dialogs[indexPath.row] isKindOfClass:[QBChatDialog class]])
        {
            //TODO: Check if works
            QBChatDialog *dialog = self.dialogs[indexPath.row];
            [DBServices updateDialogStatus:dialog.ID dialogId:1];
        }
        else
        {
            ConfessEntity *dialog = self.dialogs[indexPath.row];
            [DBServices updateConversationStatus:dialog.facebookID userUrl:1];
        }
        
        [self.dialogs removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end