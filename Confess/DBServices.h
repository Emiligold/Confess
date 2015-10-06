//
//  DBServices.h
//  Confess
//
//  Created by Noga badhav on 11/11/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractEntity.h"
#import "ConfessEntity.h"
#import "FriendsNoAppConfesses.h"
#import "User.h"
#import <FacebookSDK/FacebookSDK.h>

@interface DBServices : NSObject

+(NSString*)myID;
+(id<AbstractEntity>)getEntityById:(id<AbstractEntity>)entityClass entityClass:(NSUInteger)objectID;
+(id<AbstractEntity>)getConversationsOfUser;
+(id<AbstractEntity>)getConversation:(NSString*)userUrl;
+(void)deleteEntityById:(id<AbstractEntity>)entityClass entityClass:(NSUInteger)objectID;
+(NSMutableArray*)getConfessesOfConversation:(NSUInteger)noAppCode;
+(NSMutableArray*)getMessagesByUrl:(NSString*)userUrl;
+(long long)insertNewConversation:(NSString*)userUrl;
+(long long)insertCodeUserConfesses:(NSString*)userId userId:(long long)confessId confessId:(NSString*)facebookId;
+(long long)insertNewCodeFriends:(long long)confessId confessId:(long long)noAppCode;
+(void)updateConversationStatus:(NSString*)userUrl userUrl:(NSUInteger)status;
+(void)updateDialogStatus:(NSString*)dialogId dialogId:(NSUInteger)status;
+(NSMutableArray*)getRecievedConversations:(NSString*)userUrl;
+(NSMutableArray*)getMyConfesses;
//+(void)insertUser:(long) userID userID:(NSString*)userFB;
+(UIColor*)getPreviousColor:(NSUInteger)userID;
+(UIColor*)getNextColor:(NSUInteger)userID;
+(NSMutableArray*)getSentConfesses:(NSString*)facebookId;
+(NSMutableArray*)select:(id<AbstractEntity>)entityClass entityClass:(NSMutableArray*)parameters;
+(void)insertFacebookUrl:(NSString*)url name:(NSString*)name;
+(User*)getUserByFB:(NSString*)facebookId;
+(id<AbstractEntity>)getEntityByUniqe:(id<AbstractEntity>)entityClass entityClass:(NSMutableArray*)parameters;
+(void)mergeEntity:(id<AbstractEntity>)entity;
+(id<FBGraphUser>)getCurrFacebookUser;
+(void)setCurrFacebookUser:(id<FBGraphUser>)user;
+(NSUInteger)currUserId;

@end
