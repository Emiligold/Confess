//
//  ViewController.m
//  Confess
//
//  Created by Noga badhav on 30/09/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import "ViewController.h"
#import "FriendsTab.h"
#import "TabController.h"
#import "ConfessView.h"
#import "AppDelegate.h"
#import "DBServices.h"

@interface ViewController () <QBActionStatusDelegate>

-(void)toggleHiddenState:(BOOL)shouldHide;

@end

@implementation ViewController

BOOL fetched;
NSString* UserLogin;
NSString* UserPassword;
NSString* UserEmail;
BOOL isNew;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self toggleHiddenState:YES];
    self.content.lineBreakMode = NSLineBreakByWordWrapping;
    self.content.numberOfLines = 2;
    self.content.textColor = [UIColor colorWithRed:(125/255.0) green:(128/255.0) blue:(130/255.0) alpha:1];
    self.content.layer.shadowColor = [self.content.textColor CGColor];
    self.content.layer.shadowOffset = CGSizeMake(2.5, 2.5);
    self.content.layer.shadowRadius = 3.5;
    self.content.layer.shadowOpacity = 0.0;
    self.content.layer.masksToBounds = NO;
    self.content.font = [UIFont systemFontOfSize:14];
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 30.f;
    style.maximumLineHeight = 30.f;
    NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,};
    self.content.attributedText = [[NSAttributedString alloc] initWithString:@"Text your friend anonymously what you didn't have the courage to tell"
                                                                  attributes:attributtes];
    [self.content sizeToFit];
    [self.content setTextAlignment:NSTextAlignmentCenter];
    self.continueNoFacebook.hidden = true;
    self.loginView = [[FBLoginView alloc] init];
    self.loginView.delegate = self;
    self.loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    self.loginView.center = CGPointMake(160, 220);
    [self.view addSubview:self.loginView];
    self.loginView.hidden = true;
    //self.view.backgroundColor = [UIColor colorWithRed:(214/255.0) green:(195/255.0) blue:(163/255.0) alpha:1];
    self.view.backgroundColor = [UIColor whiteColor];
    self.startButton.alpha = 0.0;
    
    if ([FBSession activeSession] == nil || [FBSession activeSession].state == FBSessionStateCreated)
    {
        [self.view addSubview:self.startButton];
        [UIView animateWithDuration:5.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{self.startButton.alpha = 1.0;}
                     completion:nil];
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    isNew = NO;
    if ([defaults objectForKey:@"LogInWithoutFacebook"] != nil)
    {
        QBSessionParameters *parameters = [QBSessionParameters new];
        parameters.userLogin = NSUserName();
        parameters.userPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
        
        [QBRequest createSessionWithExtendedParameters:parameters successBlock:^(QBResponse *response, QBASession *session) {
            // Save current user
            QBUUser *currentUser = [QBUUser user];
            currentUser.ID = session.userID;
            currentUser.login = NSUserName();
            currentUser.password = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
            //
            [[LocalStorageService shared] setCurrentUser:currentUser];
            
            // Login to QuickBlox Chat
            //
            [[ChatService instance] loginWithUser:currentUser completionBlock:^{
                
                // hide alert after delay
                double delayInSeconds = 0.2;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self toggleHiddenState:NO];
                    self.tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"TabController"];
                    self.tbc.selectedIndex=1;
                    self.loginView.hidden = NO;
                    self.tbc.loginView = self.loginView;
                    self.tbc.profileID = self.profileID;
                    self.tbc.nameText = self.nameText;
                    [self.tbc initProperties];
                    [self presentViewController:self.tbc animated:YES completion:nil];
                });
            }];} errorBlock:^(QBResponse *response) {
                NSString *errorMessage = [[response.error description] stringByReplacingOccurrencesOfString:@"(" withString:@""];
                errorMessage = [errorMessage stringByReplacingOccurrencesOfString:@")" withString:@""];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors"
                                                                message:errorMessage
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles: nil];
                [alert show];
            }];
        
        self.tbc.nameText = self.nameText;
        [self.tbc initProperties];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startClicked:(id)sender {
    self.startButton.hidden = YES;
    self.content.hidden = YES;
    self.loginView.hidden = NO;
    self.continueNoFacebook.hidden = NO;
}

-(void)fadeIn:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration andWait:(NSTimeInterval)wait
{
    if (UserPassword == nil)
    {
        [UIView beginAnimations:@"Fade In" context:nil];
        [UIView setAnimationDelay:wait];
        [UIView setAnimationDuration:duration];
        self.startButton.alpha = 1;
        [UIView commitAnimations];
    }
}

-(void)toggleHiddenState:(BOOL)shouldHide{
    //self.content.hidden = shouldHide;
    //self.lblEmail.hidden = shouldHide;
    //self.profilePicture.hidden = shouldHide;
    //self.content.hidden = YES;
    self.continueNoFacebook.hidden = YES;
}

-(void)loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    //self.lblLoginStatus.text = @"You are logged in.";
    [self toggleHiddenState:NO];
    self.tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"TabController"];
    self.tbc.selectedIndex=1;
    self.loginView.hidden = NO;
    self.tbc.loginView = self.loginView;
    self.tbc.profileID = self.profileID;
    self.tbc.nameText = self.nameText;
    [self.tbc initProperties];
    
    if (!fetched && UserLogin != nil)
    {
        [self tryToConnect:UserLogin :UserPassword :UserEmail :loginView];
    }
    else if (fetched)
    {
        [self presentViewController:self.tbc animated:YES completion:nil];
    }
}

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

-(void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView{
    //self.content.text = @"You are logged out";
    
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
    [self toggleHiddenState:YES];
    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* facebookCookies = [cookies cookiesForURL:[NSURL URLWithString:@"https://facebook.com/"]];
    
    for (NSHTTPCookie* cookie in facebookCookies) {
        [cookies deleteCookie:cookie];
    }
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
    
    if (self.tbc != nil)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ConfessView *viewController = (ConfessView *)[storyboard instantiateViewControllerWithIdentifier:@"ConfessView"];
        [self presentViewController:viewController animated:YES completion:nil];
    }
}


-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
    //NSLog(@"%@", [error localizedDescription]);
}

- (IBAction)continueWithoutFacebookClicked:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Continue without Facebook?" message:@"Confess contacts only" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        QBUUser *signUp = [QBUUser user];
        signUp.login = NSUserName();
        signUp.password = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];
        
        [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session)
         {
             [QBRequest signUp:signUp successBlock:^(QBResponse *response, QBUUser *user)
              {
                  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                  [defaults setObject:@(YES) forKey:@"LogInWithoutFacebook"];
                  
                  QBUUser *login = [QBUUser user];
                  login.login = signUp.login;
                  login.password = signUp.password;
                  login.ID = user.ID;
                  //
                  [[LocalStorageService shared] setCurrentUser:user];
                  
                  [self toggleHiddenState:NO];
                  self.tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"TabController"];
                  self.tbc.selectedIndex=1;
                  self.loginView.hidden = NO;
                  self.tbc.loginView = self.loginView;
                  self.tbc.profileID = self.profileID;
                  self.tbc.nameText = self.nameText;
                  [self.tbc initProperties];
                  [self presentViewController:self.tbc animated:YES completion:nil];
                  //[[ChatService instance] loginWithUser:user completionBlock:^{
                  //        [self loginViewShowingLoggedInUser:loginView];
                  //}];
                  // Sign up was successful
              } errorBlock:^(QBResponse *response) {
                  // Handle error here
              }];
             
         }errorBlock:^(QBResponse *response) { }];

        
        self.tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"TabController"];
        self.tbc.selectedIndex=1;
        self.tbc.loginView = self.loginView;
        self.tbc.hideFacebook = YES;
        [self.tbc hideFacebookAction];
        [self.tbc initProperties];
        [self presentViewController:self.tbc animated:YES completion:nil];
    }
}

- (IBAction)buttonTouched:(id)sender
{
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
         }];
    }
}

-(void)tryToConnect : (NSString*) userLogin : (NSString*) userPassword : (NSString*) userMail : (FBLoginView*) loginView
{
    QBSessionParameters *parameters = [QBSessionParameters new];
    parameters.userLogin = userLogin;
    parameters.userPassword = userPassword;
    parameters.userEmail = userMail;
    UserLogin = userLogin;
    UserPassword = userPassword;
    UserEmail = userMail;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // If it's nil - the user needs to sign in
    if ([defaults objectForKey:userPassword] != nil)
    {
        if (!fetched)
        {
        [QBRequest createSessionWithExtendedParameters:parameters successBlock:^(QBResponse *response, QBASession *session) {
            // Save current user
            QBUUser *currentUser = [QBUUser user];
            currentUser.ID = session.userID;
            currentUser.login = userLogin;
            currentUser.password = userPassword;
            currentUser.email = userMail;
            fetched = YES;
            [defaults setObject:@(currentUser.ID) forKey:userPassword];
            //
            [[LocalStorageService shared] setCurrentUser:currentUser];
        
            // Login to QuickBlox Chat
            //
            [[ChatService instance] loginWithUser:currentUser completionBlock:^{
            [self loginViewShowingLoggedInUser:loginView];
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
    }
    else
    {
        QBUUser *signUp = [QBUUser user];
        signUp.login = userLogin;
        signUp.password = userPassword;
        signUp.email = userMail;
        
        [QBRequest createSessionWithSuccessBlock:^(QBResponse *response, QBASession *session)
         {
             [QBRequest signUp:signUp successBlock:^(QBResponse *response, QBUUser *user)
              {
                  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                  [defaults setObject:@(user.ID) forKey:userPassword];
                  User *appUser = [[User alloc] init];
                  appUser.facebookID = userPassword;
                  appUser.userID = user.ID;
                  appUser.currColor = -1;
                  [DBServices mergeEntity:appUser];
                  isNew = YES;
                  QBUUser *login = [QBUUser user];
                  login.login = userLogin;
                  login.password = userPassword;
                  login.email = userMail;
                  login.ID = user.ID;
                  fetched = YES;
                  //
                  [[LocalStorageService shared] setCurrentUser:user];
                  [self loginViewShowingLoggedInUser:loginView];
                  
                  // Login to QuickBlox Chat
                  //
                  //[[ChatService instance] loginWithUser:user completionBlock:^{
                  //        [self loginViewShowingLoggedInUser:loginView];
                  //}];
                  // Sign up was successful
              } errorBlock:^(QBResponse *response) {
                  // Handle error here
              }];

         }errorBlock:^(QBResponse *response) { }];
    }
}

@end
