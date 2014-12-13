//
//  User.m
//  Confess
//
//  Created by Noga badhav on 05/12/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import "User.h"

@implementation User

-(NSString*)tableName
{
    return tUsers;
}

-(id)initProperties:(NSMutableArray*)properties
{
    self.userID = [properties[0] integerValue];
    self.facebookID = properties[1];
    self.currColor = [properties[2] integerValue];
    return self;
}

@end
