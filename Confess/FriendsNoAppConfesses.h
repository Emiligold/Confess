//
//  FriendsNoAppConfesses.h
//  Confess
//
//  Created by Noga badhav on 11/11/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractEntity.h"

@interface FriendsNoAppConfesses : NSObject <AbstractEntity>

@property (nonatomic, assign) NSUInteger objectID;
@property (nonatomic, retain) NSString *userID;
@property (nonatomic, retain) NSString *friendUrl;
@property (nonatomic, assign) BOOL isDeleted;

@end
