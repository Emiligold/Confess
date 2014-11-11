//
//  ConfessView.m
//  Confess
//
//  Created by Noga badhav on 03/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import "ConfessView.h"
#import "ConfessWrite.h"
#import "ConfessMessageViewCell.h"
#import "FriendsTab.h"
#import "ConfessEntity.h"
#import "DateHandler.h"
#import "DBServices.h"
#import "FriendsNoAppConfesses.h"

@interface ConfessView () <UITableViewDelegate, UITableViewDataSource, QBActionStatusDelegate>

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, weak) IBOutlet UITableView *confessesTableView;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *userUrl;
@property (nonatomic, weak) IBOutlet FriendsTab *friendsView;
@property (nonatomic, strong) NSMutableArray *dialogs;

@end

@implementation ConfessView

ConfessWrite *translationQuizAssociateVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.topItem.title = @"";
    self.tabBarController.tabBar.hidden = YES;
    self.confessButton.enabled = NO;
    self.writeButton.enabled = NO;
    self.messages = [NSMutableArray array];
    self.confessesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.confessesTableView registerClass:[ConfessMessageViewCell class] forCellReuseIdentifier:@"ChatMessageCellIdentifier"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatDidReceiveMessageNotification:)
                                                 name:kNotificationDidReceiveNewMessage object:nil];
    
    if (self.dialog == nil && self.userID != nil)
    {
        // Check if the dialog between the two users already exists
        for (QBChatDialog *dialog in self.dialogs)
        {
            if ((dialog.recipientID == [self.userID integerValue]) &&
                (dialog.userID == [LocalStorageService shared].currentUser.ID))
            {
                self.dialog = dialog;
                break;
            }
        }
    }
    
    if (self.dialog != nil)
    {
        // get messages history
        [QBChat messagesWithDialogID:self.dialog.ID extendedRequest:nil delegate:self];
    }
    else if (self.userID != nil)
    {
        QBChatDialog *chatDialog = [QBChatDialog new];
        NSMutableArray *selectedUsersIDs = [NSMutableArray array];
        NSMutableArray *selectedUsersNames = [NSMutableArray array];
        NSString *user = [self.check.title stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        [selectedUsersIDs addObject:self.userID];
        [selectedUsersNames addObject:user];
        chatDialog.occupantIDs = selectedUsersIDs;
        chatDialog.type = QBChatDialogTypePrivate;
        [QBChat createDialog:chatDialog delegate:self];
        self.dialog = chatDialog;
    }
    else
    {
        self.messages = [[NSMutableArray alloc] initWithArray:[DBServices getMessagesByUrl:self.userUrl]];
        [self.confessesTableView reloadData];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    BOOL result = NO;
    
    if (@selector(copy:) == action || @selector(test:) == action)
    {
        result = YES;
    }
    
    return result;
}

-(void)setDetailItem:(NSString*) name : (NSString*) userID :
    (FriendsTab*) view : (NSMutableArray*) dialogs : (NSString*) url;
{
    self.check.title = name;
    self.userID = userID;
    self.friendsView = view;
    self.dialogs = dialogs;
    self.userUrl = url;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
    // parent is nil if this view controller was removed
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"Write"])
    {
        translationQuizAssociateVC = [segue destinationViewController];
        [translationQuizAssociateVC initProperties:self.check.title : self];
        self.container.hidden = NO;
    }
}


-(void) test :(id)sender
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellHeight;
    
    if ([[self.messages objectAtIndex:indexPath.row] isKindOfClass:[QBChatAbstractMessage class]])
    {
        QBChatAbstractMessage *chatMessage = [self.messages objectAtIndex:indexPath.row];
        cellHeight = [ConfessMessageViewCell heightForCellWithMessage:chatMessage];
    }
    else
    {
        ConfessEntity *confess = [self.messages objectAtIndex:indexPath.row];
        cellHeight = [ConfessMessageViewCell heightForCellWithConfess:confess];
    }
    
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ChatMessageCellIdentifier = @"ChatMessageCellIdentifier";
    ConfessMessageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatMessageCellIdentifier];
    
    if(cell == nil){
        cell = [[ConfessMessageViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChatMessageCellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([self.messages[indexPath.row] isKindOfClass:[QBChatAbstractMessage class]])
    {
        QBChatAbstractMessage *message = self.messages[indexPath.row];
        [cell configureCellWithMessage:message];
    }
    else
    {
        ConfessEntity *confess = [self.messages objectAtIndex:indexPath.row];
        [cell configureCellWithConfess:confess];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.messages count];
}

-(void)sendConfess:(NSString*) confess
{
    NSString *user;
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    QBChatMessage *message;
    
    if (self.userID != nil)
    {
        // create a message
        message = [[QBChatMessage alloc] init];
        message.text = confess;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"save_to_history"] = @YES;
        [message setCustomParameters:params];
    
        message.senderID = [LocalStorageService shared].currentUser.ID;
    
        [[ChatService instance] sendMessage:message];
        user = [NSString stringWithFormat:@"%ld", (unsigned long)message.recipientID];
    }
    else
    {
        //NSString *key = [NSString stringWithFormat:@"%@%@", myID, @"sentConfesses"];
        //user = [NSString stringWithFormat:@"%@,%@", myID, self.userUrl];
        
        //if ([defaults objectForKey:key] == nil)
        //{
        //    [defaults setObject:[[NSMutableArray alloc] init] forKey:key];
        //}
        
        //NSMutableArray *urls = [defaults objectForKey:key];
        //NSMutableArray *copyUrls = [NSMutableArray arrayWithArray:urls];
        //[defaults setObject:@"" forKey:[NSString stringWithFormat:@"%@,Status", user]];
        
        //if (![copyUrls containsObject:self.userUrl])
        //{
        //    [copyUrls addObject:self.userUrl];
        //    [defaults setObject:copyUrls forKey:key];
        //}
    }
    
    //if ([defaults objectForKey:user] == nil)
    //{
    //    [defaults setObject:[NSMutableArray array] forKey:user];
    //    [defaults synchronize];
    //}

   // NSMutableArray *check = (NSMutableArray*)[defaults objectForKey:user];
    //NSMutableArray *copy = [NSMutableArray arrayWithArray:check];
    ConfessEntity *confessEntity = [[ConfessEntity alloc] init];
    confessEntity.loginName = self.check.title;
    
    if (self.userID != nil)
    {
        confessEntity.facebookID = self.userID;
    }
    else
    {
        confessEntity.facebookID = self.userUrl;
    }
    
    confessEntity.content = confess;
    NSDate *currDate = [NSDate date];
    confessEntity.date = currDate;
    confessEntity.isNew = YES;
    long long confessID = [DBServices insertNewConfess:confessEntity];
    
    if (self.userID == nil)
    {
        FriendsNoAppConfesses *result = [DBServices getConversation:self.userUrl];
        long long no_app_code;
        
        if (result == nil)
        {
            no_app_code = [DBServices insertNewConversation:self.userUrl];
        }
        else
        {
            [DBServices updateConversationStatus:self.userUrl userUrl:0];
            no_app_code = result.objectID;
        }
        
        [DBServices insertNewCodeFriends:confessID confessId:no_app_code];
    }
    else
    {
        [DBServices insertCodeUserConfesses:self.userID userId:confessID confessId:self.userID];
    }
    
    //[copy addObject:confessEntity];
    
    //[defaults setObject:copy forKey:user];
    //[defaults synchronize];
    
    if (message != nil)
    {
        [self.messages addObject:message];
    }
    else
    {
        [self.messages addObject:confessEntity];
    }
    
    [self.confessesTableView reloadData];
    
    if (self.dialog != nil)
    {
        [DBServices updateDialogStatus:self.dialog.ID dialogId:0];
    }
    
    if(self.messages.count > 0){
        NSIndexPath* ipath = [NSIndexPath indexPathForRow: self.messages.count-1 inSection: [self.confessesTableView numberOfSections] - 1];
        [self.confessesTableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
       // [self.confessesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    //[defaults synchronize];
}

- (void)chatDidReceiveMessageNotification:(NSNotification *)notification{
    
    //QBChatMessage *message = notification.userInfo[kMessage];
    //if(message.senderID != self.dialog.recipientID){
    //    return;
    //}
    
    // save message
    //[self.messages addObject:message];
    
    // Reload table
    //[self.confessesTableView reloadData];
    //if(self.messages.count > 0){
    //    [self.confessesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0]
    //                                  atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    //}
    
    QBChatMessage *message = notification.userInfo[kMessage];
    if(message.senderID != self.dialog.recipientID){
        return;
    }
    
    // save message
    //[self.messages addObject:message];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:message.text forKey:[NSString stringWithFormat:@"%ld", (unsigned long)message.recipientID]];
    [defaults synchronize];
    
    // Reload table
    [self.confessesTableView reloadData];
    
    if(self.messages.count > 0){
        [self.confessesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0]
                                       atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)completedWithResult:(Result *)result
{
    if (result.success && [result isKindOfClass:QBChatHistoryMessageResult.class]) {
        QBChatHistoryMessageResult *res = (QBChatHistoryMessageResult *)result;
        NSArray *messages = res.messages;
        self.messages = [[NSMutableArray alloc] init];
        [self.messages addObjectsFromArray:[messages mutableCopy]];
        [self.confessesTableView reloadData];
        
        if (self.messages.count > 0)
        {
            NSIndexPath* ipath = [NSIndexPath indexPathForRow: self.messages.count-1 inSection: 0];
            [self.confessesTableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
        }
    }
}

@end
