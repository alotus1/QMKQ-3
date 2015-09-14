//
//  UIColor+CQ.m
//  QMClient
//
//  Created by Lotus on 15/7/25.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "UIColor+CQ.h"

@implementation UIColor (CQ)

+ (UIColor *)colorWithColorString:(NSString *)color {
    
    
    NSMutableArray * colors = [NSMutableArray array] ;
    for (int i = 0 ; i < color.length ; i += 2) {
        NSString * sub = [color substringWithRange:NSMakeRange(i, 2)] ;
        unsigned int intColor ;
        [[NSScanner scannerWithString:sub] scanHexInt:&intColor] ;
        // 将intColor包装成对象存进数组中
        [colors addObject:@(intColor)] ;
    }
    
    return [UIColor colorWithRed:[colors[0] integerValue] / 255.0 green:[colors[1] integerValue] / 255.0 blue:[colors[2] integerValue] / 255.0 alpha:1] ;
    


}


@end
