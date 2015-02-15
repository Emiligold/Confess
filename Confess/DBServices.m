//
//  DBServices.m
//  Confess
//
//  Created by Noga badhav on 11/11/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import "DBServices.h"
#import "DBManager.h"
#import "FriendsNoAppConfesses.h"
#import "ConfessEntity.h"
#import "CodeFriendsNoAppConfesses.h"
#import "DateHandler.h"
#import "User.h"
#import "ColorsHandler.h"
#import "UserSentConfesses.h"
#import "CodeUrls.h"

@implementation DBServices

+(id<AbstractEntity>)getEntityById:(id<AbstractEntity>)entityClass entityClass:(NSUInteger)objectID
{
    NSMutableArray *parameters = [[NSMutableArray alloc] initWithObjects:
                                  [NSString stringWithFormat:@"id = %ld", (unsigned long)objectID], nil];
    return [self uniqueSelect:entityClass entityClass:parameters];
}

+(id<AbstractEntity>)getConversationsOfUser
{
    NSMutableArray *parameters = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"user_id = '%@'", [self myID]], nil];
    return [self uniqueSelect:[[FriendsNoAppConfesses alloc] init] entityClass:parameters];
}

+(id<AbstractEntity>)getEntityByUniqe:(id<AbstractEntity>)entityClass entityClass:(NSMutableArray*)parameters
{
    return  [self uniqueSelect:entityClass entityClass:parameters];
}

+(id<AbstractEntity>)uniqueSelect:(id<AbstractEntity>)entityClass entityClass:(NSMutableArray*)parameters
{
    return [DBServices select:entityClass entityClass:parameters][0];
}

+(NSMutableArray*)select:(id<AbstractEntity>)entityClass entityClass:(NSMutableArray*)parameters
{
    [[DBManager shared] selectQuery:[entityClass tableName] table:parameters];
    NSMutableArray *values = [[NSMutableArray alloc] initWithArray:[[DBManager shared] executeNonExecutableQuery]];
    NSMutableArray *result = [[NSMutableArray alloc] init];

    for (NSMutableArray *curr in values)
    {
        [result addObject:[[entityClass initialize] initProperties:curr]];
    }
    
    return result;
}

+(id<AbstractEntity>)getConversation:(NSString*)userUrl
{
    NSMutableArray *parameters = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"user_id = '%@'", [self myID]], [NSString stringWithFormat:@"friend_url LIKE '%%%@.jpg%%'", [DBServices getSubUrl:userUrl]], nil];
    return [self uniqueSelect:[[FriendsNoAppConfesses alloc] init] entityClass:parameters];
}

+(NSString*)getSubUrl:(NSString*)userUrl
{
    NSString *firstPart = [userUrl substringFromIndex:[userUrl rangeOfString:@"/" options:NSBackwardsSearch].location];
    return [firstPart substringToIndex:[firstPart rangeOfString:@".jpg"].location];
}

+(NSMutableArray*)getRecievedConversations:(NSString*)userUrl
{
    NSMutableArray *parameters = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"a.friend_url = '%@'", userUrl], @"a.id = b.no_app_code", @"b.confess_id = c.id",  nil];
    [[DBManager shared] joinQuery:[[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%@ a", tFriendsNoAppConfesses], [NSString stringWithFormat:@"%@ b", tCodeFriendsNoAppConfesses], [NSString stringWithFormat:@"%@ c", tConfessEntity], nil] tables:parameters];
    [[DBManager shared] orderBy:[[NSMutableArray alloc] initWithObjects:@"c.date", nil] values:@"DESC"];
    NSMutableArray *values = [[NSMutableArray alloc] initWithArray:[[DBManager shared] executeNonExecutableQuery]];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (NSMutableArray *curr in values)
    {
        [[DBManager shared] deleteQuery:tFriendsNoAppConfesses table:[[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"id = %@", curr[0]], nil]];
        [[DBManager shared] deleteQuery:tCodeFriendsNoAppConfesses table:[[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"id = %@", curr[4]], nil]];
        [result addObject:[[NSMutableArray alloc] initWithObjects:curr[1], [[ConfessEntity alloc] initProperties:[NSMutableArray arrayWithArray:[curr subarrayWithRange:NSMakeRange(7, 5)]]], nil]];
        //[result addObject:[self getEntityById:[[ConfessEntity alloc] init] entityClass:((CodeFriendsNoAppConfesses*)[self getEntityByUniqe:[[CodeFriendsNoAppConfesses alloc] init] entityClass:[[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"no_app_code = %@", curr[0]], nil]]).confessID]];
    }
    
    return result;

}

+(NSMutableArray*)getConfessesOfConversation:(NSUInteger)noAppCode
{
    NSMutableArray *parameters = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"no_app_code = %lu", (unsigned long)noAppCode], nil];
    [[DBManager shared] selectQuery:tCodeFriendsNoAppConfesses table:parameters];
    NSMutableArray *values = [[NSMutableArray alloc] initWithArray:[[DBManager shared] executeNonExecutableQuery]];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for (NSMutableArray *curr in values)
    {
        [result addObject:[self getEntityById:[[ConfessEntity alloc] init] entityClass:((CodeFriendsNoAppConfesses*)[[[CodeFriendsNoAppConfesses alloc] init] initProperties:curr]).confessID]];
    }
    
    return result;
}

+(NSMutableArray*)getMessagesByUrl:(NSString*)userUrl
{
    FriendsNoAppConfesses *entity = [DBServices getConversation:userUrl];
    
    if (entity != nil)
    {
        return [DBServices getConfessesOfConversation:entity.objectID];
    }
    
    return [[NSMutableArray alloc] init];
}

+(void)insertNewConfess:(ConfessEntity*)confessEntity
{
    NSString *date = [NSString stringWithFormat:@"'%@'", [DateHandler stringFromDate:confessEntity.date]];
    NSMutableArray *parameters = [[NSMutableArray alloc] initWithObjects:
            @"null",
            confessEntity.url == nil ? @"null" : [NSString stringWithFormat:@"'%@'", ((CodeUrls*)[DBServices getEntityByUniqe:[[CodeUrls alloc] init] entityClass:[[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"url = '%@'", confessEntity.url], nil]]).url],
            [NSString stringWithFormat:@"'%@'", confessEntity.loginName],
            [NSString stringWithFormat:@"'%@'", confessEntity.content],
            date,
            [NSString stringWithFormat:@"%@", [NSNumber numberWithBool: confessEntity.isNew]],
            confessEntity.facebookID == nil ? @"null" : [NSString stringWithFormat:@"'%@'", confessEntity.facebookID], nil];
    [[DBManager shared] mergeQuery:tConfessEntity table:parameters];
    [[DBManager shared] executeExecutableQuery];
    [[DBManager shared] mergeQuery:tUserSentConfesses table:[[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"'%d'", [[LocalStorageService shared] currentUser].ID], confessEntity.facebookID != nil ? [NSString stringWithFormat:@"'%@'", confessEntity.facebookID] : @"null", confessEntity.url != nil ? [NSString stringWithFormat:@"'%@'", confessEntity.url] : @"null", date, @([[DBManager shared] lastInsertedRowID]), @(0), nil]];
    //return [[DBManager shared] lastInsertedRowID];
}

+(long long)insertNewConversation:(NSString*)userUrl
{
    NSMutableArray *parameters = [[NSMutableArray alloc] initWithObjects:@"null", [NSString stringWithFormat:@"'%@'",[self myID]], [NSString stringWithFormat:@"'%@'", userUrl], @"0", nil];
    [[DBManager shared] mergeQuery:tFriendsNoAppConfesses table:parameters];
    [[DBManager shared] executeExecutableQuery];
    return [[DBManager shared] lastInsertedRowID];
}

+(void)updateConversationStatus:(NSString*)userUrl userUrl:(NSUInteger)status
{
    NSMutableArray *setParameters = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:
                                     @"is_deleted = %ld", (unsigned long)status], nil];
    NSMutableArray *conditionParameters = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"user_id = '%@'", [self myID]], [NSString stringWithFormat:@"friend_url LIKE '%%%@.jpg%%'", [DBServices getSubUrl:userUrl]], nil];
    [[DBManager shared] updateQuery:tFriendsNoAppConfesses
                              table:setParameters setParameters:conditionParameters];
    [[DBManager shared] executeExecutableQuery];
}

+(long long)insertCodeUserConfesses:(NSString*)userId userId:(long long)confessId confessId:(NSString*)facebookId
{
    NSMutableArray *parameters = [[NSMutableArray alloc] initWithObjects:@"null", [NSString stringWithFormat:@"'%@'",userId], [NSString stringWithFormat:@"%lld", confessId], [NSString stringWithFormat:@"'%@'",facebookId], nil];
    [[DBManager shared] mergeQuery:tCodeUserConfesses table:parameters];
    [[DBManager shared] executeExecutableQuery];
    return [[DBManager shared] lastInsertedRowID];
}

+(long long)insertNewCodeFriends:(long long)confessId confessId:(long long)noAppCode
{
    NSMutableArray *parameters = [[NSMutableArray alloc] initWithObjects:@"null", [NSString stringWithFormat:@"%ld", (unsigned long)confessId], [NSString stringWithFormat:@"%ld", (unsigned long)noAppCode], nil];
    [[DBManager shared] mergeQuery:tCodeFriendsNoAppConfesses table:parameters];
    [[DBManager shared] executeExecutableQuery];
    return [[DBManager shared] lastInsertedRowID];
}

+(void)updateDialogStatus:(NSString*)dialogId dialogId:(NSUInteger)status
{
    NSMutableArray *setParameters = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:
                                                                             @"is_deleted = %ld", (unsigned long)status], nil];
    NSMutableArray *conditionParameters = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"dialog_id = '%@'", dialogId], nil];
    [[DBManager shared] updateQuery:tDialogs
                              table:setParameters setParameters:conditionParameters];
    [[DBManager shared] executeExecutableQuery];
}

+(NSString*)myID
{
    return [NSString stringWithFormat:@"%ld", (unsigned long)[LocalStorageService shared].currentUser.ID];
}

+(NSMutableArray*)getMyConfesses
{
    [[DBManager shared] joinQuery:[[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"%@ a", tCodeUserConfesses], [NSString stringWithFormat:@"%@ b", tConfessEntity], nil] tables:[[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"user_id = '%@'", [DBServices myID]], [NSString stringWithFormat:@"a.confess_id = b.id"], nil]];
    [[DBManager shared] orderBy:[[NSMutableArray alloc] initWithObjects:@"b.date", nil] values:@"DESC"];
    NSMutableArray *results = [[NSMutableArray alloc] initWithArray:[[DBManager shared] executeNonExecutableQuery]];
    NSMutableArray *final = [[NSMutableArray alloc] init];
    
    for (NSMutableArray *curr in results)
    {
        [final addObject: [[ConfessEntity alloc] initProperties:[[curr subarrayWithRange:NSMakeRange(5, 7)] mutableCopy]]];
    }
    
    return final;
}

+(void)insertUser:(long) userID userID:(NSString*)userFB
{
    [[DBManager shared] mergeQuery:tUsers table:[[NSMutableArray alloc] initWithObjects:@(userID), userFB, @(-1), nil]];
    [[DBManager shared] executeExecutableQuery];
}

+(UIColor*)getNextColor:(NSUInteger)userID
{
    User *user = [DBServices getEntityById:[[User alloc] init] entityClass:userID];
    NSUInteger nextIndex = (3 + ((long)(user.currColor + 1) % 3)) % 3;
    [[DBManager shared] mergeQuery:tUsers table:[[NSMutableArray alloc] initWithObjects:
                                                 @(user.userID), user.facebookID, @(nextIndex), nil]];
    [[DBManager shared] executeExecutableQuery];
    return [ColorsHandler getColorByIndex:nextIndex];
}

+(UIColor*)getPreviousColor:(NSUInteger)userID
{
    User *user = [DBServices getEntityById:[[User alloc] init] entityClass:userID];
    NSUInteger nextIndex = (3 + (((long)user.currColor - 1) % 3)) % 3;
    [[DBManager shared] mergeQuery:tUsers table:[[NSMutableArray alloc] initWithObjects:
                                                 @(user.userID), user.facebookID, @(nextIndex), nil]];
    [[DBManager shared] executeExecutableQuery];
    return [ColorsHandler getColorByIndex:nextIndex];
}

+(NSMutableArray*)getSentConfesses:(NSString*)userID
{
    return [[[DBServices select:[[UserSentConfesses alloc] init] entityClass:[[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"from_user_id = %@", userID], nil]] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO], nil]] mutableCopy];
}

+(void)insertFacebookUrl:(NSString*)url name:(NSString*)name
{
    NSMutableArray *result = [DBServices select:[[CodeUrls alloc] init] entityClass:[[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"name = \"%@\"", name], nil]];
    NSUInteger objectID = [result count] == 0 ? -1 : [((CodeUrls*)result[0]) objectID];
    [[DBManager shared] mergeQuery:tCodeUrls table:[[NSMutableArray alloc] initWithObjects:objectID == -1 ? @"null" : @(objectID), [NSString stringWithFormat:@"\"%@\"", url], [NSString stringWithFormat:@"\"%@\"", name], nil]];
    [[DBManager shared] executeExecutableQuery];
}

@end