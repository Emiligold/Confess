//
//  FacebookHandler.m
//  Confess
//
//  Created by Noga badhav on 23/01/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import "FacebookHandler.h"
#import <FacebookSDK/FacebookSDK.h>
#import "DBServices.h"
#import "FacebookCell.h"

@interface FacebookHandler ()

@property(nonatomic, strong) NSMutableArray* allFriends;
@property(nonatomic, strong) FriendsTab *friendsTab;

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

-(void)setFriendsView:(FriendsTab*)view
{
    self.friendsTab = view;
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
         self.haveApp = [[NSMutableDictionary alloc] init];
         
         for (NSDictionary<FBGraphUser>* friend in friends)
         {
             [mutableArray addObject:friend];
             [self.haveApp setObject:friend forKey:[FacebookCell getUserUrl:friend]];
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
             if ([self.haveApp objectForKey:[FacebookCell getUserUrl:friend]] == nil)
             {
                 NSString *url = [FacebookCell getUserUrl:friend];
                 [DBServices insertFacebookUrl:url name:friend.name];
                 [mutableArray addObject:friend];
             }
         }
         
         self.allFriends = [NSMutableArray arrayWithArray:mutableArray];
         [self.friendsTab facebookLoadCompleted];
     }];
    
    return self.allFriends;
}

@end
