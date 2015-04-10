//
//  FacebookConnection.m
//  Confess
//
//  Created by Noga badhav on 10/04/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import "FacebookConnection.h"
#import "DBServices.h"

@implementation FacebookConnection

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    //NSLog(@"%@", user);
    [DBServices setCurrFacebookUser:user];
    self.profileID = user.objectID;
    self.nameText = user.name;
    // Create session with user
    NSString *userLogin = [user.name stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *userPassword = user.objectID;
    NSString *userMail = [user objectForKey:@"email"];
    
    if (isNew)
    {
        FBGraphObject *picture = [user objectForKey:@"picture"];
        FBGraphObject *check = [picture objectForKey:@"data"];
        NSString *url = [check objectForKey:@"url"];
        NSMutableArray *confesses = [DBServices getRecievedConversations:url];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        for (NSMutableArray *values in confesses)
        {
            ConfessEntity *curr = values[1];
            QBChatDialog *chatDialog = [QBChatDialog new];
            NSMutableArray *selectedUsersIDs = [NSMutableArray array];
            NSMutableArray *selectedUsersNames = [NSMutableArray array];
            [selectedUsersIDs addObject:curr.toFacebookID];
            [selectedUsersNames addObject:curr.toName];
            chatDialog.occupantIDs = selectedUsersIDs;
            chatDialog.type = QBChatDialogTypePrivate;
            [QBChat createDialog:chatDialog delegate:self];
            QBChatMessage *message = [[QBChatMessage alloc] init];
            message.text = curr.content;
            message.senderID = [values[0] integerValue];
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"save_to_history"] = @YES;
            [message setCustomParameters:params];
            //message.senderID = [LocalStorageService shared].currentUser.ID;
            [[ChatService instance] sendMessage:message];
            [DBServices insertCodeUserConfesses:[defaults objectForKey:user.objectID] userId:curr.objectID confessId:user.objectID];
        }
    }
    
    [self tryToConnect:userLogin :userPassword :userMail :loginView];
    
    if (fetched)
    {
        [self loginViewShowingLoggedInUser : loginView];
    }
    
    self.tbc.profileID = self.profileID;
    self.tbc.nameText = self.nameText;
    [self.tbc initProperties];

}

@end
