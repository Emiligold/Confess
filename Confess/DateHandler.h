//
//  DateHandler.h
//  Confess
//
//  Created by Noga badhav on 11/11/14.
//  Copyright (c) 2014 Noga badhav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHandler : NSObject

+(NSString*)stringFromDate:(NSDate*)date;
+(NSDate*)dateFromString:(NSString*)date;
+(BOOL)isDateInToday:(NSDate*)date;
+(BOOL)isDateInYesterday:(NSDate*)date;
+(NSString*)dayStringOfWeek:(NSDate*)date;
+(NSString*)hourOfDay:(NSDate*)date;

@end
