//
//  QMCalendar.h
//  CustomCalendar
//
//  Created by 袁偲￼琦 on 15/7/15.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  日历中每天的模型
 */
@interface QMCalendar : NSObject

/**
 *  日期,如果为-1则显示不同的样式
 */
@property (assign , nonatomic) NSInteger day ;

/**
 *  是否是当天
 */
@property (assign , nonatomic) BOOL isSelectedDay ;

/**
 *  显示这个日期的字体颜色
 */
@property (strong , nonatomic) UIColor * dayColor ;

/**
 *  记录当前模型表示的日期
 */
@property (strong , nonatomic) NSDate * date ;

/**
 *  标记是否是预约当天
 */
@property (assign , nonatomic) BOOL isAppointedDay ;

@end
