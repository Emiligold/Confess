//
//  FacebookHandler.m
//  Confess
//
//  Created by Noga badhav on 23/01/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import "FacebookHandler.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookHandler ()

@property(nonatomic, strong) NSMutableArray* allFriends;

@end

@implementation FacebookHandler

+(instancetype)instance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
	
	dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
	});
	
	return instance;
    
}


-(NSMutableArray*)getAllFriends
{
    if (self.allFriends != nil)
    {
        return self.allFriends;
    }
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    [FBRequestConnection startWithGraphPath:@"/me/friends"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              )
     {
         NSArray* friends = [result objectForKey:@"data"];
         
         for (NSDictionary<FBGraphUser>* friend in friends)
         {
             [mutableArray addObject:friend];
         }
         
         self.allFriends = [NSMutableArray arrayWithArray:mutableArray];
     }];
    
    [FBRequestConnection startWithGraphPath:@"/me/taggable_friends"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              )
     {
         NSArray* friends = [result objectForKey:@"data"];
         
         for (NSDictionary<FBGraphUser>* friend in friends)
         {
             if (![mutableArray containsObject:friend])
             {
                 [mutableArray addObject:friend];
             }
         }
         
         self.allFriends = [NSMutableArray arrayWithArray:mutableArray];
     }];
    
    return self.allFriends;
}

@end
