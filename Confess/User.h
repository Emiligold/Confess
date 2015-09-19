//
//  User.h
//  Confess
//
//  Created by Noga badhav on 05/12/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractEntity.h"

@interface User : NSObject <AbstractEntity>

@property (nonatomic, assign) NSUInteger currColor;
@property (nonatomic, retain) NSString* facebookID;
@property (nonatomic, assign) NSUInteger userID;

@end
