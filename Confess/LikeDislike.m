//
//  LikeDislike.m
//  Confess
//
//  Created by Noga badhav on 19/09/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import "LikeDislike.h"

@implementation LikeDislike

-(id<AbstractEntity>)initialize
{
    return [[LikeDislike alloc] init];
}

-(id)initProperties:(NSMutableArray*)properties
{
    self.objectID = [properties[0] integerValue];
    self.confessID = [properties[1] integerValue];
    self.userID = [properties[2] integerValue];
    self.isLike = [properties[3] boolValue];
    
    return self;
}

-(NSString*)tableName
{
    return tLikeDislike;
}

-(NSMutableArray*)properties
{
    return [[NSMutableArray alloc] initWithObjects:
            (self.objectID == -1 ? @"null": [NSString stringWithFormat:@"%d", self.objectID]),
            [NSString stringWithFormat:@"%d", self.confessID],
            [NSString stringWithFormat:@"'%d'", self.userID],
            @(self.isLike),
            nil];
}


@end
