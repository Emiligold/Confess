//
//  ConfessEntity.h
//  Confess
//
//  Created by Noga badhav on 24/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractEntity.h"
#import "CodeUrls.h"

@interface ConfessEntity : NSObject <AbstractEntity>

@property (nonatomic, assign) NSUInteger objectID;
@property (nonatomic, retain) NSString *toFacebookID;
@property (nonatomic, retain) CodeUrls *url;
@property (nonatomic, retain) NSString *toName;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSDate *lastMessageDate;
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, assign) BOOL isDeleted;
@property (nonatomic, retain) NSString *fromFacebookID;

@end