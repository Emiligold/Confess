//
//  FacebookConnection.m
//  Confess
//
//  Created by Noga badhav on 10/04/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import "FacebookConnection.h"
#import "DBServices.h"
#import "ViewController.h"
#import "AppDelegate.h"

@interface FacebookConnection ()

@property (nonatomic, strong) AppDelegate* appDelegate;

@end

@implementation FacebookConnection

+(instancetype)instance:(AppDelegate*)appDelegate
{
    static FacebookConnection* instance = nil;
    static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.appDelegate = appDelegate;
	});
	
	return instance;
}

-(void)startConnection
{
    self.loginView = [[FBLoginView alloc] init];
    self.loginView.delegate = self;
    self.loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    self.loginView.center = CGPointMake(160, 220);
}

-(void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    static BOOL connected = NO;
    
    if (!connected)
    {
        connected = YES;
        //NSLog(@"%@", user);
        [DBServices setCurrFacebookUser:user];
        self.profileID = user.objectID;
        // Create session with user
        NSString *userMail = [user objectForKey:@"email"];
        [self.appDelegate ConnectedToFacebook:user.name userPassword:user.objectID userMail:userMail loginView:self.loginView];
    }
}

@end
