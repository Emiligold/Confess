//
//  AppDelegate.h
//  Confess
//
//  Created by Noga badhav on 30/09/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

-(void)ConnectedToFacebook:(NSString*)userLogin userPassword:(NSString*)userPassword
                  userMail:(NSString*)userMail loginView:(FBLoginView*)loginView;

-(void)ConnectedToQuickBlox:(NSString*)userLogin userPassword:(NSString*)userPassword loginView:(FBLoginView*)loginView;

@end
