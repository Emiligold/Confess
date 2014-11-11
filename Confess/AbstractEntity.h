//
//  AbstractEntity.h
//  Confess
//
//  Created by Noga badhav on 11/11/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AbstractEntity <NSObject>

-(NSString*)tableName;
-(id)initProperties:(NSMutableArray*)properties;

@end
