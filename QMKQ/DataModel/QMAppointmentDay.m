//
//  QMAppointmentDay.m
//  AppointmentView
//
//  Created by Lotus on 15/7/22.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMAppointmentDay.h"

@implementation QMAppointmentDay

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict] ;
    }
    return self ;
}

+ (instancetype)appointmentDayWithDict:(NSDictionary *)dict {
    
    return [[self alloc] initWithDict:dict] ;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"day %@ , status %lu", _day , _day_status];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    NSLog(@"%@" , key) ;
}

@end
