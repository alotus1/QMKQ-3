//
//  QMWorkView.h
//  QMKQ
//
//  Created by Lotus on 15/9/7.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import <UIKit/UIKit.h>


@class QMAppointmentHour , Patient;

typedef NS_ENUM(NSUInteger, QMAppointmentViewSendAppointRequestType) {
    /**
     *  发送请求类型为请求预约
     */
    QMAppointmentViewSendAppointRequestTypeAppoint,
    /**
     *  请求类型为取消预约
     */
    QMAppointmentViewSendAppointRequestTypeCancel
};




@interface QMWorkView : UIView

/**
 *  开始编辑
 */
@property (assign , nonatomic) BOOL beginEditing ;

/**
 *  当天中每个时间段的预约信息
 */
@property (strong , nonatomic) NSArray * dayAppointments ;

/**
 *  当月每天的预约信息
 */
@property (strong , nonatomic) NSArray * monthAppointments ;



/**
 *  切换月份的时候进行的操作
 *  block中的参数为请求的日期信息
 */
@property (copy , nonatomic) void(^changeMonthBlock)(NSDate * date) ;

/**
 *  选择的日期更改后,通知控制器根据日期进行网络请求
 */
@property (copy , nonatomic) void(^wantNewDateAppointmentInformation)(NSDate * date) ;


//@property (copy , nonatomic) void(^sendAppointmentRequest)(QMAppointmentHour * appointmentHour , NSDate * selectedDate , QMAppointmentViewSendAppointRequestType requestType) ;
@property (copy , nonatomic) void(^changeDoctorWorkTimeBlock)(NSString * hourList , NSString * hourStatusList , NSDate * seletedDate) ;


/**
 *  下拉刷新的时候通知控制器的block
 */
@property (copy , nonatomic) void(^shouldReloadDataBlock)(QMWorkView * appointmentView , NSDate * selectedDate) ;

/**
 *  通知控制器跳转到用户详情页面(参数中的病人只有病人的名字和id,其他信息都需要进行网络请求才可以获取到)
 */
@property (copy , nonatomic) void(^shouldPushToFriendDetailBlock)(Patient * patient) ;


@end
