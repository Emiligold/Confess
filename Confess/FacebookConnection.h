//
//  FacebookConnection.h
//  Confess
//
//  Created by Noga badhav on 10/04/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookConnection : NSObject <FBLoginViewDelegate>

@property (weak, nonatomic) NSString *profileID;
@property (weak, nonatomic) NSString *nameText;

@end
