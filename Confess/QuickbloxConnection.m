//
//  QuickbloxConnection.m
//  Confess
//
//  Created by Noga badhav on 10/04/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import "QuickbloxConnection.h"
#import "AppDelegate.h"

@interface QuickbloxConnection () <QBActionStatusDelegate>

@property (nonatomic, strong) AppDelegate* appDelegate;

@end

@implementation QuickbloxConnection

+(instancetype)instance:(AppDelegate*)appDelegate
{
    static QuickbloxConnection* instance = nil;
    static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.appDelegate = appDelegate;
	});
	
	return instance;
}

-(void)StartConnection:(NSString*)userLogin userPassword:(NSString*)userPassword
              userMail:(NSString*)userMail loginView:(FBLoginView*)loginView
{
    QBSessionParameters *parameters = [QBSessionParameters new];
    parameters.userLogin = [userLogin stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    parameters.userPassword = userPassword;
    parameters.userEmail = userMail;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [QBRequest createSessionWithExtendedParameters:parameters successBlock:^(QBResponse *response, QBASession *session) {
        // Save current user
        QBUUser *currentUser = [QBUUser user];
        currentUser.ID = session.userID;
        currentUser.login = userLogin;
        currentUser.password = userPassword;
        currentUser.email = userMail;
        [defaults setObject:@(currentUser.ID) forKey:userPassword];
        //
        [[LocalStorageService shared] setCurrentUser:currentUser];
        
        // Login to QuickBlox Chat
        //
        [[ChatService instance] loginWithUser:currentUser completionBlock:^{
            [self.appDelegate ConnectedToQuickBlox:userLogin userPassword:userPassword loginView:loginView];
            // hide alert after delay
            //double delayInSeconds = 0.2;
            //dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            //dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            //    [self loginViewShowingLoggedInUser:loginView];
            
            //});
        }];} errorBlock:^(QBResponse *response)
     {
     }];
}

@end
