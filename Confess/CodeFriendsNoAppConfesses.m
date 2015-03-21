//
//  CodeFriendsNoAppConfesses.m
//  Confess
//
//  Created by Noga badhav on 11/11/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import "CodeFriendsNoAppConfesses.h"

@implementation CodeFriendsNoAppConfesses

-(id)initProperties:(NSMutableArray*)properties
{
    self.objectID = [properties[0] integerValue];
    self.confessID = [properties[1] integerValue];
    self.noAppCode = [properties[2] integerValue];
    return self;
}

-(NSString*)tableName
{
    return tCodeFriendsNoAppConfesses;
}

-(id<AbstractEntity>)initialize
{
    return [[CodeFriendsNoAppConfesses alloc] init];
}

-(NSMutableArray*)properties
{
    return [[NSMutableArray alloc] initWithObjects:
            [NSString stringWithFormat:@"%d", self.objectID],
            [NSString stringWithFormat:@"%d", self.confessID],
            [NSString stringWithFormat:@"%d", self.noAppCode],
            nil];
}

@end
