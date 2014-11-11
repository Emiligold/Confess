//
//  LocalStorageService.m
//  Confess
//
//  Created by Noga badhav on 20/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import "LocalStorageService.h"

@implementation LocalStorageService

+ (instancetype)shared
{
	static id instance = nil;
	static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
		instance = [[self alloc] init];
	});
	
	return instance;
}

- (void)setUsers:(NSArray *)users
{
    _users = users;
    
    NSMutableDictionary *__usersAsDictionary = [NSMutableDictionary dictionary];
    for(QBUUser *user in users){
        [__usersAsDictionary setObject:user forKey:@(user.ID)];
    }
    
    _usersAsDictionary = [__usersAsDictionary copy];
}

- (BOOL) doesUserExists : (NSString*) name
{
    for(QBUUser *user in _users)
    {
        if ([user.login isEqualToString:name])
        {
            return YES;
        }
    }
    
    return NO;
}

@end
