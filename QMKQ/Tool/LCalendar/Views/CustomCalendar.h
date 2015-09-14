//
//  CustomCalendar.h
//  CustomCalendar
//
//  Created by 袁偲￼琦 on 15/7/15.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "QMWeekView.h"

@interface CustomCalendar : UIView


//#warning block暂时定义成最简单的,往后需要参数再往上添加
/**
 *  选择一个日期后执行的block操作
 */
@property (copy , nonatomic) void(^selectDayItemBlock)(NSDate * selectedDate) ;

/**
 *  当月每天的预约状态信息
 */
@property (strong , nonatomic) NSArray * monthAppointments ;

/**
 *  想要显示哪个日期的日历就可以设置这个值
 */
@property (strong , nonatomic) NSDate * tagetDate ;

/**
 *  当日历的高度改变之后需要进行操作的block方法
 */
@property (copy , nonatomic) void(^viewHeightChangedBlock)() ;

/**
 *  改变月份的时候进行的操作
 */
@property (copy , nonatomic) void(^changeMonthBlock)(CustomCalendar * calendar , NSDate * date) ;



/**
 *  调用这个方法传入block
 *
 *  @param selectDayItemBlock 设置选择日期后需要执行的操作

- (void) selectedDayItemWithBlock:(void (^)(NSInteger))selectDayItemBlock;
 */


@end
