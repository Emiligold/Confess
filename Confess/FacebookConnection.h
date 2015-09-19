//
//  FacebookConnection.h
//  Confess
//
//  Created by Noga badhav on 10/04/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"

@interface FacebookConnection : NSObject <FBLoginViewDelegate>

+(instancetype)instance:(AppDelegate*)appDelegate;
-(void)startConnection;
@property (weak, nonatomic) NSString *profileID;
@property (weak, nonatomic) NSString *nameText;
@property (strong, nonatomic) IBOutlet FBLoginView *loginView;

@end
