//
//  FriendsNoAppConfesses.m
//  Confess
//
//  Created by Noga badhav on 11/11/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import "FriendsNoAppConfesses.h"

@implementation FriendsNoAppConfesses

-(id)initProperties:(NSMutableArray*)properties
{
    self.objectID = [properties[0] integerValue];
    self.userID = properties[1];
    self.friendUrl = properties[2];
    self.isDeleted = [properties[3] boolValue];
    return self;
}

-(NSString*)tableName
{
    return tFriendsNoAppConfesses;
}

-(id<AbstractEntity>)initialize
{
    return [[FriendsNoAppConfesses alloc] init];
}

-(NSMutableArray*)properties
{
    return [[NSMutableArray alloc] initWithObjects:
            [NSString stringWithFormat:@"%d", self.objectID],
            self.userID,
            self.friendUrl,
            @(self.isDeleted),
            nil];
}

@end
