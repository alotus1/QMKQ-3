//
//  NSDate+CQ.m
//  CustomCalendar
//
//  Created by 袁偲￼琦 on 15/7/16.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "NSDate+CQ.h"

@implementation NSDate (CQ)

+ (NSDate *)currentDate {

//    NSDate * date = [[NSDate date] currentZoneDate:<#(NSDate *)#>]
    
    return [[NSDate date] currentZoneDate] ;
}

- (NSDate *)currentZoneDate {

    NSTimeZone * zone = [NSTimeZone systemTimeZone] ;
    // 计算时间与zone的时间差
    NSInteger interval = [zone secondsFromGMTForDate:self] ;
    // 重新创建更新时间
    NSDate * newDate = [NSDate dateWithTimeInterval:interval sinceDate:self] ;
    
    return newDate ;
}


- (NSInteger)day {

    // 获取components信息
    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] ;
    
    return components.day ;
}

- (NSString *)stringWithChineseDateFormatter {

    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init] ;
    dateFormatter.dateFormat = @"yyyy年MM月dd日" ;
    return [dateFormatter stringFromDate:self] ;
}

+ (NSDate *)timeWithNumber:(NSInteger)number {

    // 设置时间格式
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init] ;
    dateFormatter.dateFormat = @"HH:mm" ;
    
    // 计算时间间隔
    // 通过字符串获取日期
    NSDate * date = [dateFormatter dateFromString:@"00:00"] ;
    date = [date dateByAddingTimeInterval:(number - 1) * 30 * 60] ;
    
//    NSLog(@"date %@" , [dateFormatter stringFromDate:date]) ;
    
    return date ;
}

- (NSInteger)numberForCurrentDate {

    // 设置时间格式
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init] ;
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm" ;
    
    // 00:00
    NSDate * TimeZero = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ 00:00" , [self stringWithoutTime]]] ;
    
    // 计算给定时间对应的数字
    NSTimeInterval interval = [self timeIntervalSinceDate:TimeZero] ;
    double halfHours = interval / (30 * 60) + 1 ;
    
    NSInteger number = halfHours > (NSInteger)halfHours ? (NSInteger)halfHours + 1 : halfHours;
    return number ;
    
}

- (NSString *)stringWithoutTime {

    // 设置时间格式
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init] ;
    dateFormatter.dateFormat = @"yyyy-MM-dd" ;
    
    
    // 取当前对象的日期字符串
    NSString * dateString = [dateFormatter stringFromDate:self] ;
    return dateString ;

}

- (NSString *)timeInDate {

    // 设置时间格式
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init] ;
    dateFormatter.dateFormat = @"HH:mm" ;
    
    return [dateFormatter stringFromDate:self] ;
}

+ (NSDate *)dateWithDate:(NSDate *)date time:(NSString *)time {
    // 设置时间格式
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init] ;
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss" ;
    
    NSString * dateString = [NSString stringWithFormat:@"%@ %@" , [date stringWithoutTime] , time] ;
    
    return [dateFormatter dateFromString:dateString] ;
    
}

/**
 *  日期中的年
 *
 *  @return 日期中的年
 */
- (NSInteger) yearForDate {

    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] ;
    return components.year ;
}

/**
 *  日期中的月
 *
 *  @return 日期中的月
 */
- (NSInteger) monthForDate {

    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] ;
    return components.month ;
}

/**
 *  日期中的天
 *
 *  @return 日期中的天
 */
- (NSInteger) dayForDate {

    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] ;
    return components.day ;
}


/**
 *  判断两个日期的年月日是否相同
 *
 *  @param otherDate 其他日期
 *
 *  @return 年月日是否相同
 */
- (BOOL) isEqualToDateWithoutTime :(NSDate *)otherDate {

    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init] ;
    dateFormatter.dateFormat = @"yyyy-MM-dd" ;
    
    return [[dateFormatter stringFromDate:self] isEqualToString:[dateFormatter stringFromDate:otherDate]] ;
}



/**
 *  获得当前日期是星期几
 *
 *  @return 星期
 */
- (NSString *) weekdayChinese {

    NSArray * weekdays = @[@"周日" , @"周一" , @"周二" , @"周三" , @"周四" , @"周五" , @"周六"] ;
    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:self] ;
    return weekdays[components.weekday - 1] ;
}




@end
