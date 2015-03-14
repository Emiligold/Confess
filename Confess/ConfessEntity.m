//
//  ConfessEntity.m
//  Confess
//
//  Created by Noga badhav on 24/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import "ConfessEntity.h"
#import "DateHandler.h"
#import "DBServices.h"
#import "CodeUrls.h"

@implementation ConfessEntity

-(id<AbstractEntity>)initialize
{
    return [[ConfessEntity alloc] init];
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:@(self.objectID) forKey:@"objectID"];
    [encoder encodeObject:self.url forKey:@"code_url"];
    [encoder encodeObject:self.loginName forKey:@"loginName"];
    [encoder encodeObject:self.content forKey:@"content"];
    [encoder encodeObject:self.lastMessageDate forKey:@"date"];
    [encoder encodeObject:@(self.isNew) forKey:@"isNew"];
    [encoder encodeObject:self.facebookID forKey:@"facebook_id"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if((self = [super init]))
    {
        self.objectID = [[decoder decodeObjectForKey:@"objectID"] integerValue];
        self.url = [decoder decodeObjectForKey:@"code_url"];
        self.facebookID = [decoder decodeObjectForKey:@"facebookID"];
        self.loginName = [decoder decodeObjectForKey:@"loginName"];
        self.content = [decoder decodeObjectForKey:@"content"];
        self.lastMessageDate = [decoder decodeObjectForKey:@"date"];
        self.isNew = [[decoder decodeObjectForKey:@"isNew"] boolValue];
        //self.currColor = [[decoder decodeObjectForKey:@"currColor"] integerValue];
    }
    
    return self;
}

-(id)initProperties:(NSMutableArray*)properties
{
    self.objectID = [properties[0] integerValue];
    self.loginName = properties[2];
    self.url = ((CodeUrls*)[DBServices getEntityById:[[CodeUrls alloc] init]
                                       entityClass:[properties[1] integerValue]]).url;
    self.content = properties[3];
    self.lastMessageDate = [DateHandler dateFromString:properties[4]];
    self.isNew = [properties[5] boolValue];
    //self.currColor = [properties[6] integerValue];
    self.facebookID = properties[6] == [NSNull null] ? nil : properties[6];
    
    return self;
}

-(NSString*)tableName
{
    return tConfessEntity;
}

@end
