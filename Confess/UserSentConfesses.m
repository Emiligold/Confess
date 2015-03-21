//
//  UserSentConfesses.m
//  Confess
//
//  Created by Noga badhav on 19/01/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import "UserSentConfesses.h"

@implementation UserSentConfesses

-(id)initProperties:(NSMutableArray*)properties
{
    self.fromUserID = properties[0];
    self.toUserID = properties[1] == [NSNull null] ? nil : properties[1];
    self.toUrlCcode = properties[2];
    self.lastMessageDate = properties[3];
    self.confessID = [properties[4] integerValue];
    self.isDeleted = [properties[5] boolValue];
    
    return self;
}

-(NSString*)tableName
{
    return tUserSentConfesses;
}

-(id<AbstractEntity>)initialize
{
    return [[UserSentConfesses alloc] init];
}

-(NSMutableArray*)properties
{
    return [[NSMutableArray alloc] initWithObjects:
            self.fromUserID,
            self.toUserID,
            self.toUrlCcode,
            self.lastMessageDate,
            [NSString stringWithFormat:@"%d", self.confessID],
            @(self.isDeleted),
            nil];
}

@end
