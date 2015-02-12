//
//  FacebookHandler.h
//  Confess
//
//  Created by Noga badhav on 23/01/15.
//  Copyright (c) 2015 Noga badhav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendsTab.h"
@interface FacebookHandler : NSObject

+(instancetype)instance;
-(NSMutableArray*)getAllFriends;
-(void)setFriendsView:(FriendsTab*)view;

@end
