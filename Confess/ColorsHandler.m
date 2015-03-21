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

+(UIColor*)lightBlueColor
{
    return [UIColor colorWithRed:(231/255.0) green:(238/255.0) blue:(243/255.0) alpha:1];
}

+(UIColor*)mediumBlueColor
{
    return [UIColor colorWithRed:(199/255.0) green:(221/255.0) blue:(236/255.0) alpha:1];
}

@end
