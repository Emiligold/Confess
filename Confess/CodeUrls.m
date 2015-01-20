//
//  CodeUrls.m
//  Confess
//
//  Created by Noga badhav on 20/01/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import "CodeUrls.h"

@implementation CodeUrls

-(id)initProperties:(NSMutableArray*)properties
{
    self.objectID = [properties[0] integerValue];
    self.url = properties[1];
    
    return self;
}

-(NSString*)tableName
{
    return tCodeUrls;
}

-(id<AbstractEntity>)initialize
{
    return [[CodeUrls alloc] init];
}

@end
