//
//  CodeUserConfesses.m
//  Confess
//
//  Created by Noga badhav on 11/11/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import "CodeUserConfesses.h"

@implementation CodeUserConfesses

-(id)initProperties:(NSMutableArray*)properties
{
    self.objectID = [properties[0] integerValue];
    self.userID = properties[1];
    self.confessID = [properties[2] integerValue];
    self.facebookID = properties[3];
    return self;
}

-(NSString*)tableName
{
    return tCodeUserConfesses;
}

-(id<AbstractEntity>)initialize
{
    return [[CodeUserConfesses alloc] init];
}

-(NSMutableArray*)properties
{
    return [[NSMutableArray alloc] initWithObjects:
            [NSString stringWithFormat:@"%d", self.objectID],
            self.userID,
            [NSString stringWithFormat:@"%d", self.confessID],
            self.facebookID,
            nil];
}

@end
