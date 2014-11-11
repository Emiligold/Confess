//
//  CodeFriendsNoAppConfesses.h
//  Confess
//
//  Created by Noga badhav on 11/11/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractEntity.h"

@interface CodeFriendsNoAppConfesses : NSObject <AbstractEntity>

@property (nonatomic, assign) NSUInteger objectID;
@property (nonatomic, assign) NSUInteger confessID;
@property (nonatomic, assign) NSUInteger noAppCode;

@end
