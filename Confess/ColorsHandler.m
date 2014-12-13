//
//  ColorsHandler.m
//  Confess
//
//  Created by Noga badhav on 05/12/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import "ColorsHandler.h"

@implementation ColorsHandler

NSMutableArray *arrColors;
BOOL initialized;

+(void)initDictionary
{
    arrColors = [[NSMutableArray alloc] initWithObjects:
                      [UIColor lightGrayColor], [UIColor colorWithRed:(243/255.0) green:(204/255.0) blue:(239/255.0) alpha:1], [UIColor blueColor], nil];
    initialized = YES;
}

+(UIColor*)getColorByIndex:(NSUInteger) index
{
    if (!initialized)
    {
        [ColorsHandler initDictionary];
    }
    
    return [arrColors objectAtIndex:index];
}

@end
