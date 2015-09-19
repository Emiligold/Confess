//
//  Like.h
//  Confess
//
//  Created by Noga badhav on 19/09/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractEntity.h"

@interface Like : NSObject <AbstractEntity>

@property (nonatomic, assign) NSUInteger objectID;
@property (nonatomic, assign) NSUInteger confessID;
@property (nonatomic, assign) NSUInteger userID;

@end
