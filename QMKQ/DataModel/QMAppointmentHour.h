//
//  QMAppointmentHour.h
//  AppointmentView
//
//  Created by Lotus on 15/7/21.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, QMAppointmentHourStatus) {
    
    /**
     *  默认休息不可预约
     */
    QMAppointmentHourStatusRest = 0,
    /**
     *  可以预约
     */
    QMAppointmentHourStatusAvailable,
    /**
     *  其他情况下的不可预约
     */
    QMAppointmentHourStatusUnavilable,
    /**
     *  当前用户已约
     */
    QMAppointmentHourStatusAlreadyAppointedByMe ,
    /**
     *  该时间段已经被别的用户预约
     */
    QMAppointmentHourStatusAlreadyAppointedByOthers
};

/**
 *  医生一天中每个时间段的预约信息模型
 */

@interface QMAppointmentHour : NSObject <NSCopying>

/**
 *  预约的开始时间(这个可以存放后来传来的表示时间段的数字,往后发送预约请求的时候就可以不用再计算)
 */
@property (copy , nonatomic) NSString * hour ;

/**
 *  预约的结束时间(以00:00:00格式表示的时间字符串)
 */
@property (copy , nonatomic) NSString * endTime ;

/**
 *  预约的开始时间(以00:00:00格式表示的时间字符串)
 */
@property (copy , nonatomic) NSString * startTime ;

/**
 *  用户预约医生的日期
 */
@property (strong , nonatomic) NSDate * appointmentDate ;

/**
 *  该时间段预约用户的姓名
 */
@property (copy , nonatomic) NSString * userName ;

/**
 *  用户id
 */
@property (copy , nonatomic) NSString * userId ;

/**
 *  预约时间对应的预约状态(枚举)
 */
@property (assign , nonatomic) QMAppointmentHourStatus hourStatus ;



- (instancetype)initWithDict : (NSDictionary *) dict ;
+ (instancetype) appointmentHourWithDict : (NSDictionary *) dict ;



@end
