//
//  QMWeekView.h
//  CustomCalendar
//
//  Created by 袁偲￼琦 on 15/7/16.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QMWeekViewButtonType) {    // 点击的button是什么类型
    
    QMWeekViewButtonTypeNextMonth ,
    QMWeekViewButtonTypePreviousMonth
};


@interface QMWeekView : UIView

/**
 *  传入当前的日期,显示
 */
@property (strong , nonatomic) NSDate * currentDate ;

@property (copy , nonatomic) void(^buttonClickBlock)(QMWeekView * weekView , QMWeekViewButtonType buttonType) ;


@end
