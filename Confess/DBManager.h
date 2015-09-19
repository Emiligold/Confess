//
//  DBManager.h
//  Confess
//
//  Created by Noga badhav on 08/11/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;
-(NSArray *)loadDataFromDB:(NSString *)query;
-(void)executeQuery:(NSString *)query;
-(void)executeExecutableQuery;
-(NSArray *)executeNonExecutableQuery;
-(void)selectQuery:(NSString*)table table:(NSMutableArray*)conditionParameters;
-(void)mergeQuery:(NSString*)table table:(NSMutableArray*)values;
-(void)updateQuery:(NSString*)table table:(NSMutableArray*)setParameters setParameters:(NSMutableArray*)conditionParameters;
-(void)joinQuery:(NSMutableArray*)tables tables:(NSMutableArray*)conditionParameters;
-(void)orderBy:(NSMutableArray*)values values:(NSString*)method;
-(void)createConditionParameters:(NSMutableArray*)conditionParameters;
-(void)deleteQuery:(NSString*)table table:(NSMutableArray*)conditionParameters;
-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;
-(void)deleteQuery:(NSString*)table table:(NSMutableArray*)conditionParameters;
+(instancetype)shared;

@end
