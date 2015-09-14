//
//  NSDate+CQ.h
//  CustomCalendar
//
//  Created by 袁偲￼琦 on 15/7/16.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CQ)

/**
 *  date中的几号
 */
@property (assign , nonatomic) NSInteger day ;

/**
 *  返回当前时区的时间
 */
+ (NSDate *) currentDate ;

/**
 *  对象方法
 *
 *  @param date 需要转换成当前时区时间的日期
 *
 *  @return 返回当前时区的时间
 */
- (NSDate *) currentZoneDate ;


/**
 *  获得格式为"yyyy年mm月dd日"的字符串
 *
 *  @return 返回格式为"yyyy年mm月dd日"的字符串
 */
- (NSString *) stringWithChineseDateFormatter ;

/**
 *  给定一个1-48的数字,计算表示的时间,以半小时为划分
 *
 *  @param number 给定的数字
 *
 *  @return 返回给定数组对应的48小时的时间划分(这个NSDate对象在取数值的时候需要使用"00:00"的格式转化成字符串)
 */
+ (NSDate *) timeWithNumber : (NSInteger) number ;

/**
 *  给定一个时间,以半小时为划分,获得一个1-48的数字
 *
 *  @return 返回给定时间对应的数字
 */
- (NSInteger) numberForCurrentDate ;

/**
 *  获得日期里的年月日信息,不需要时间,返回年月日的字符串(yyyy-mm-dd)
 *
 *  @return 返回年月日的字符串(yyyy-mm-dd)
 */
- (NSString *) stringWithoutTime ;

/**
 *  获得一个对象,用给定的日期和时间来拼接
 *
 *  @param date 年月日
 *  @param time 时间
 *
 *  @return 拼接好的时间
 */
+ (NSDate *) dateWithDate : (NSDate *) date time : (NSString *) time ;

/**
 *  获得日期中的时间
 *
 *  @return 返回日期中的时间(格式HH:mm:ss)
 */
- (NSString *) timeInDate ;


/**
 *  日期中的年
 *
 *  @return 日期中的年
 */
- (NSInteger) yearForDate ;

/**
 *  日期中的月
 *
 *  @return 日期中的月
 */
- (NSInteger) monthForDate ;

/**
 *  日期中的天
 *
 *  @return 日期中的天
 */
- (NSInteger) dayForDate ;

/**
 *  判断两个日期的年月日是否相同
 *
 *  @param otherDate 其他日期
 *
 *  @return 年月日是否相同
 */
- (BOOL) isEqualToDateWithoutTime :(NSDate *)otherDate ;

/**
 *  获得当前日期是星期几
 *
 *  @return 星期
 */
- (NSString *) weekdayChinese ;


@end
