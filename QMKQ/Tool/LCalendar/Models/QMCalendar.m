//
//  QMCalendar.m
//  CustomCalendar
//
//  Created by 袁偲￼琦 on 15/7/15.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMCalendar.h"

@implementation QMCalendar

- (NSString *)description
{
    return [NSString stringWithFormat:@"date %@ day %ld , isSelectedDay %d", _date , _day , _isSelectedDay];
}

@end
