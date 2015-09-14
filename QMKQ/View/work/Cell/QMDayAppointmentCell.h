//
//  QMDayAppointmentCell.h
//  AppointmentView
//
//  Created by Lotus on 15/7/21.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import <UIKit/UIKit.h>


@class QMAppointmentHour ;
/**
 *  显示当日所有时间段的预约状态信息cell
 */
@interface QMDayAppointmentCell : UITableViewCell

//+ (instancetype) dayAppointmentCell : (UITableView *) tableView ;

+ (instancetype) dayAppointmentCell : (UITableView *) tableView andIndexPath : (NSIndexPath *) indexPath ;
/**
 *  当前时间段的数据模型
 */
@property (strong , nonatomic) QMAppointmentHour * appointmentHour ;

/**
 *  当前cell的indexPath
 */
@property (strong , nonatomic) NSIndexPath * indexPath ;

@property (copy , nonatomic) void(^cancelAppointmentBlock)(NSIndexPath * indexPath) ;

@end
