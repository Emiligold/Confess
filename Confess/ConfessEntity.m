//
//  ConfessEntity.m
//  Confess
//
//  Created by Noga badhav on 24/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import "ConfessEntity.h"
#import "DateHandler.h"

@implementation ConfessEntity

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:@(self.objectID) forKey:@"objectID"];
    [encoder encodeObject:self.facebookID forKey:@"facebookID"];
    [encoder encodeObject:self.loginName forKey:@"loginName"];
    [encoder encodeObject:self.content forKey:@"content"];
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeObject:@(self.isNew) forKey:@"isNew"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        self.objectID = [[decoder decodeObjectForKey:@"objectID"] integerValue];
        self.facebookID = [decoder decodeObjectForKey:@"facebookID"];
        self.loginName = [decoder decodeObjectForKey:@"loginName"];
        self.content = [decoder decodeObjectForKey:@"content"];
        self.date = [decoder decodeObjectForKey:@"date"];
        self.isNew = [[decoder decodeObjectForKey:@"isNew"] boolValue];
    }
    return self;
}

-(id)initProperties:(NSMutableArray*)properties
{
    self.objectID = [properties[0] integerValue];
    self.loginName = properties[2];
    self.facebookID = properties[1];
    self.content = properties[3];
    self.date = [DateHandler dateFromString:properties[4]];
    self.isNew = [properties[5] boolValue];
    return self;
}

-(NSString*)tableName
{
    return tConfessEntity;
}

@end
