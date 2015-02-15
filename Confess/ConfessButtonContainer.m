//
//  ConfessButtonContainer.m
//  Confess
//
//  Created by Noga badhav on 14/02/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import "ConfessButtonContainer.h"
#import "ConfessEntity.h"
#import "DBServices.h"
#import "FriendsNoAppConfesses.h"

@interface ConfessButtonContainer ()

@end

@implementation ConfessButtonContainer

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)confessClicked:(id)sender
{
    if (![[self.confessFriend.content.text stringByTrimmingCharactersInSet:
          [NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        ConfessEntity *confessEntity = [[ConfessEntity alloc] init];
        confessEntity.loginName = self.confessFriend.name.text;
        confessEntity.content = self.confessFriend.content.text;
        NSDate *currDate = [NSDate date];
        confessEntity.date = currDate;
        confessEntity.isNew = YES;
        confessEntity.url = self.confessFriend.userUrl;
        confessEntity.facebookID = self.confessFriend.userID;
        [DBServices insertNewConfess:confessEntity];
    
        if (self.confessFriend.userID != nil)
        {
            // create a message
            QBChatMessage *message = [[QBChatMessage alloc] init];
            message.text = confessEntity.content;
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"save_to_history"] = @YES;
            [message setCustomParameters:params];
            message.recipientID = [self.confessFriend.userID integerValue];
            message.senderID = [LocalStorageService shared].currentUser.ID;
            [[ChatService instance] sendMessage:message];
            //[DBServices insertCodeUserConfesses:self.confessFriend.userID userId:confessID confessId:self.confessFriend.userID];
            //[self.messages addObject:message];
            [DBServices updateDialogStatus:self.confessFriend.dialog.ID dialogId:0];
        }
        else
        {
            //FriendsNoAppConfesses *result = [DBServices getConversation:self.confessFriend.userUrl];
            //long long no_app_code = result == nil ? [DBServices insertNewConversation:self.confessFriend.userUrl] : result.objectID;
            //[DBServices updateConversationStatus:self.confessFriend.userUrl userUrl:0];
            //[DBServices insertNewCodeFriends:confessID confessId:no_app_code];
            //[self.messages addObject:confessEntity];
        }

        [self.confessFriend.friendsView.chatTable reloadData];
        [self.confessFriend exitClicked:nil];
    }
}
@end
