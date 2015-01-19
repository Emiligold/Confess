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
    self.toUserID = properties[1];
    self.date = properties[2];
    self.confessID = [properties[3] integerValue];
    
    return self;
}

-(NSString*)tableName
{
    return tUserSentConfesses;
}

@end
