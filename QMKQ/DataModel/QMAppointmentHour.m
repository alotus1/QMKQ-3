//
//  QMAppointmentDay.m
//  AppointmentView
//
//  Created by Lotus on 15/7/21.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMAppointmentHour.h"

@implementation QMAppointmentHour

- (instancetype)initWithDict:(NSDictionary *)dict {

    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict] ;
    }
    return self ;
}

+ (instancetype)appointmentHourWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict] ;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
//    NSLog(@"%@" , key) ;
}



#pragma mark - NSCopying
- (id)copyWithZone:(NSZone *)zone {
    
    QMAppointmentHour * appointmentHour = [[QMAppointmentHour allocWithZone:zone] init] ;
    appointmentHour.hour = self.hour ;
    appointmentHour.startTime = self.startTime ;
    appointmentHour.endTime = self.endTime ;
    appointmentHour.appointmentDate = self.appointmentDate ;
    appointmentHour.userName = self.userName ;
    appointmentHour.userId = self.userId ;
    return appointmentHour ;
}

/*
- (NSString *)description
{
    return [NSString stringWithFormat:@"%ld", _hourStatus];
}
*/
@end
