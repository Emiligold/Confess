//
//  ConfessEntity.h
//  Confess
//
//  Created by Noga badhav on 24/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractEntity.h"

@interface ConfessEntity : NSObject <AbstractEntity>

@property (nonatomic, assign) NSUInteger objectID;
@property (nonatomic, retain) NSString *facebookID;
@property (nonatomic, retain) NSString *loginName;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, assign) NSUInteger currColor;

@end