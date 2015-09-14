//
//  QMAppointmentDay.h
//  AppointmentView
//
//  Created by Lotus on 15/7/22.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QMAppointmentDayStatus) {
    /**
     *  可预约
     */
    QMAppointmentDayStatusEnable = 0,
    /**
     *  不可预约
     */
    QMAppointmentDayStatusDisable ,
    /**
     *  已经约满
     */
    QMAppointmentDayStatusFull
};

/**
 *  医生一个月中每天的预约信息
 */
@interface QMAppointmentDay : NSObject

/**
 *  日期
 */
@property (copy , nonatomic) NSString * day ;

/**
 *  当日医生的预约状态
 */
@property (assign , nonatomic) QMAppointmentDayStatus day_status ;


- (instancetype)initWithDict : (NSDictionary *) dict ;
+ (instancetype) appointmentDayWithDict : (NSDictionary *) dict ;



@end
