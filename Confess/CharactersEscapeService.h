//
//  CharactersEscapeService.h
//  Confess
//
//  Created by Noga badhav on 20/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CharactersEscapeService : NSObject

+ (NSString *)escape:(NSString *)unescapedString;
+ (NSString *)unescape:(NSString *)escapedString;

@end
