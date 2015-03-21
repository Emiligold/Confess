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

+(BOOL)isDateInYear:(NSDate*)date
{
    return [DateHandler isEqual:[NSDate date] second:date year:YES month:NO week:NO day:NO hour:NO minute:NO];
}

+(BOOL)isEqual:(NSDate*)firstDate second:(NSDate*)secondDate year:(BOOL)year month:(BOOL)month week:(BOOL)week day:(BOOL)day hour:(BOOL)hour minute:(BOOL)minute
{
    NSDateComponents *first = [DateHandler getDateComponent:firstDate];
    NSDateComponents *second = [DateHandler getDateComponent:secondDate];
    
    return (!minute || [first minute] == [second minute]) &&
           (!hour || [first hour] == [second hour]) &&
           (!week || [first week] == [second week]) &&
           (!day || [first day] == [second day]) &&
           (!month || [first month] == [second month]) &&
           (!year || [first year] == [second year]) &&
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

+(NSUInteger)minutesBetweenDates:(NSDate*)first second:(NSDate*)second
{
    return [[DateHandler getDateComponent:first] minute] - [[DateHandler getDateComponent:second] minute];
}

+(NSDateComponents*)getDateComponent:(NSDate*)date
{
    return [[NSCalendar currentCalendar] components:NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:date];
}

+(NSString*)getDateMessageString:(NSDate*)date
{
    NSString *dateReturn = @"";
    
    if ([DateHandler isEqual:date second:[NSDate date] year:YES month:YES week:YES day:YES hour:YES minute:YES])
    {
        dateReturn = @"Just now";
    }
    else if ([DateHandler isEqual:date second:[NSDate date] year:YES month:YES week:YES day:YES hour:YES minute:NO])
    {
        dateReturn = [NSString stringWithFormat:@"%d minutes ago",
                      [DateHandler minutesBetweenDates:[NSDate date] second:date]];
    }
    else if ([DateHandler isEqual:date second:[NSDate date] year:YES month:YES week:YES day:YES hour:NO minute:NO])
    {
        dateReturn = [DateHandler hourOfDay:date];
    }
    else if ([DateHandler isEqual:[[NSDate date] dateByAddingTimeInterval: -86400.0] second:date year:YES month:YES week:NO day:YES hour:NO minute:NO])
    {
        dateReturn = [NSString stringWithFormat:@"Yesterday, %@", [DateHandler hourOfDay:date]];
    }
    else if ([DateHandler isEqual:[NSDate date] second:date year:YES month:YES week:YES day:NO hour:NO minute:NO])
    {
        dateReturn = [NSString stringWithFormat:@"%@, %@",
                      [DateHandler dayStringOfWeek:date], [DateHandler hourOfDay:date]];
    }
    else
    {
        dateReturn = [DateHandler stringFromDate: date];
    }
    
    return dateReturn;
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
