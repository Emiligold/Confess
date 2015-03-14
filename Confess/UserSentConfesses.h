//
//  UserSentConfesses.h
//  Confess
//
//  Created by Noga badhav on 19/01/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractEntity.h"

@interface UserSentConfesses : NSObject <AbstractEntity>

@property (nonatomic, retain) NSString *fromUserID;
@property (nonatomic, retain) NSString *toUserID;
@property (nonatomic, retain) NSString *toUrlCcode;
@property (nonatomic, retain) NSDate *lastMessageDate;
@property (nonatomic, assign) NSUInteger confessID;
@property (nonatomic, assign) BOOL isDeleted;

@end
