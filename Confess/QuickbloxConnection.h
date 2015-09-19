//
//  QuickbloxConnection.h
//  Confess
//
//  Created by Noga badhav on 10/04/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface QuickbloxConnection : NSObject <QBChatDelegate>

+(instancetype)instance:(AppDelegate*)appDelegate;

-(void)StartConnection:(NSString*)userLogin userPassword:(NSString*)userPassword
              userMail:(NSString*)userMail loginView:(FBLoginView*)loginView;


@end
