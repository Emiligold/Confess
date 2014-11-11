//
//  LocalStorageService.h
//  Confess
//
//  Created by Noga badhav on 20/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalStorageService : NSObject

@property (nonatomic, strong) QBUUser *currentUser;
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, readonly) NSDictionary *usersAsDictionary;

+ (instancetype)shared;
- (BOOL) doesUserExists : (NSString*) name;

@end
