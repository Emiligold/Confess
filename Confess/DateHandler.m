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

+(BOOL)isDateInToday:(NSDate*)date
{
    return [DateHandler isEqual:date second:[NSDate date]];
}

+(BOOL)isDateInYesterday:(NSDate*)date
{
    return [DateHandler isEqual:[[NSDate date] dateByAddingTimeInterval: -86400.0] second:date];
}

+(BOOL)isEqual:(NSDate*)firstDate second:(NSDate*)secondDate
{
    NSDateComponents *first = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:firstDate];
    NSDateComponents *second = [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:secondDate];
    
    return [first day] == [second day] &&
           [first month] == [second month] &&
           [first year] == [second year] &&
           [first era] == [second era];
}

+(NSString*)dayStringOfWeek:(NSDate*)date
{
    NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];
    [weekFormatter setDateFormat: @"EEEE"];
    
    return [weekFormatter stringFromDate:date];
}

+(NSString*)hourOfDay:(NSDate*)date
{
    NSDateFormatter *hourFormatter = [[NSDateFormatter alloc] init];
    [hourFormatter setDateFormat:@"HH:mm"];
    
    return [hourFormatter stringFromDate:date];
}

+(NSDateFormatter*)getDateFormater
{
    if (dateFormatter == nil)
    {
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    }
    
    return dateFormatter;
}

@end
