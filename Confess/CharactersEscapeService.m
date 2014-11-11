//
//  CharactersEscapeService.m
//  Confess
//
//  Created by Noga badhav on 20/10/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import "CharactersEscapeService.h"

@implementation CharactersEscapeService

+ (NSString *)escape:(NSString *)unescapedString{
    NSMutableString *mutabeCopy = [unescapedString mutableCopy];
    [mutabeCopy replaceOccurrencesOfString:@"\\" withString:@"\\5c" options:0 range:NSMakeRange(0, mutabeCopy.length)];
    [mutabeCopy replaceOccurrencesOfString:@" " withString:@"\\20" options:0 range:NSMakeRange(0, mutabeCopy.length)];
    [mutabeCopy replaceOccurrencesOfString:@"\"" withString:@"\\22" options:0 range:NSMakeRange(0, mutabeCopy.length)];
    [mutabeCopy replaceOccurrencesOfString:@"&" withString:@"\\26" options:0 range:NSMakeRange(0, mutabeCopy.length)];
    [mutabeCopy replaceOccurrencesOfString:@"'" withString:@"\\27" options:0 range:NSMakeRange(0, mutabeCopy.length)];
    [mutabeCopy replaceOccurrencesOfString:@"/" withString:@"\\2f" options:0 range:NSMakeRange(0, mutabeCopy.length)];
    [mutabeCopy replaceOccurrencesOfString:@":" withString:@"\\3a" options:0 range:NSMakeRange(0, mutabeCopy.length)];
    [mutabeCopy replaceOccurrencesOfString:@"<" withString:@"\\3c" options:0 range:NSMakeRange(0, mutabeCopy.length)];
    [mutabeCopy replaceOccurrencesOfString:@">" withString:@"\\3e" options:0 range:NSMakeRange(0, mutabeCopy.length)];
    [mutabeCopy replaceOccurrencesOfString:@"@" withString:@"\\40" options:0 range:NSMakeRange(0, mutabeCopy.length)];
    
	return mutabeCopy;
}

+ (NSString *)unescape:(NSString *)escapedString{
    NSMutableString *mutabeCopy = [escapedString mutableCopy];
    [mutabeCopy replaceOccurrencesOfString:@"\\5c" withString:@"\\" options:0 range:NSMakeRange(0, mutabeCopy.length)];
    [mutabeCopy replaceOccurrencesOfString:@"\\20" withString:@" " options:0 range:NSMakeRange(0, mutabeCopy.length)];
    [mutabeCopy replaceOccurrencesOfString:@"\\22" withString:@"\"" options:0 range:NSMakeRange(0, mutabeCopy.length)];
    [mutabeCopy replaceOccurrencesOfString:@"\\26" withString:@"&" options:0 range:NSMakeRange(0, mutabeCopy.length)];
    [mutabeCopy replaceOccurrencesOfString:@"\\27" withString:@"'" options:0 range:NSMakeRange(0, mutabeCopy.length)];
    [mutabeCopy replaceOccurrencesOfString:@"\\2f" withString:@"/" options:0 range:NSMakeRange(0, mutabeCopy.length)];
    [mutabeCopy replaceOccurrencesOfString:@"\\3a" withString:@":" options:0 range:NSMakeRange(0, mutabeCopy.length)];
    [mutabeCopy replaceOccurrencesOfString:@"\\3c" withString:@"<" options:0 range:NSMakeRange(0, mutabeCopy.length)];
    [mutabeCopy replaceOccurrencesOfString:@"\\3e" withString:@">" options:0 range:NSMakeRange(0, mutabeCopy.length)];
    [mutabeCopy replaceOccurrencesOfString:@"\\40" withString:@"@" options:0 range:NSMakeRange(0, mutabeCopy.length)];
    
    return mutabeCopy;
}

@end
