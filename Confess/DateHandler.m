//
//  DateHandler.m
//  Confess
//
//  Created by Noga badhav on 11/11/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import "DateHandler.h"

@implementation DateHandler

NSDateFormatter *dateFormatter;

+(NSString*)stringFromDate:(NSDate*)date
{
    return [[self getDateFormater] stringFromDate:date];
}

+(NSDate*)dateFromString:(NSString*)date
{
    return [[self getDateFormater] dateFromString:date];
}

+(NSDateFormatter*)getDateFormater
{
    if (dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-mm-dd HH:mm"];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    }
    
    return dateFormatter;
}

@end
