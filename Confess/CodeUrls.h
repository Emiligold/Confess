//
//  CodeUrls.h
//  Confess
//
//  Created by Noga badhav on 20/01/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractEntity.h"

@interface CodeUrls : NSObject <AbstractEntity>

@property (nonatomic, assign) NSUInteger objectID;
@property (nonatomic, retain) NSString *url;

@end
