//
//  NSString+Extention.m
//
//  Created by Lotus on 15-5-9.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "NSString+Extention.h"

@implementation NSString (Extention)

- (CGSize) sizeWithFont : (UIFont *) font maxSize : (CGSize) maxSize {
    
    NSDictionary * attrs = @{NSFontAttributeName : font} ;
    
    CGSize size = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size ;
    size.width += 2 ;
    size.height += 2 ;
    return size ;
}


/**
 *  转换时间的显示格式
 *
 *  @param oldDateFormatter 老格式
 *  @param newDateFormatter 新格式
 *
 *  @return 新格式时间字符串
 */
- (NSString *) timeWithOldDateFormatter : (NSDateFormatter *) oldDateFormatter newDateFormatter : (NSDateFormatter *) newDateFormatter {
    
    NSDate * oldDate = [oldDateFormatter dateFromString:self] ;
    
    return [newDateFormatter stringFromDate:oldDate] ;
}



/**
 *  获得小图url地址(字符串拼接)
 */
- (NSString *) getSmallImageURL {
    if (!self) {
        return nil ;
    }
    
    
    return [self appendWithString:@"_small"] ;
}

- (NSString *) getMiddleImageURL {
    
    if (!self) {
        return nil ;
    }
    
    return [self appendWithString:@"_middle"] ;
}

- (NSString *) appendWithString : (NSString *) string {
    NSMutableString * imageURL = [NSMutableString string] ;
    
    // 1.将字符串以"."为界限分割成数组
    NSArray * subStrings = [self componentsSeparatedByString:@"."] ;
    
    // 2.取子字符串的倒数第二个元素
    NSMutableString * newSub = [NSMutableString stringWithString:subStrings[subStrings.count - 2]] ;
    
    // 3.拼接新字符串
    [newSub appendString:string] ;
    
    // 4.将数组中的元素拼接成一个url
    for (int i = 0; i < subStrings.count - 2; i++) {
        [imageURL appendFormat:@"%@." , subStrings[i]] ;
    }
    [imageURL appendFormat:@"%@." , newSub] ;
    [imageURL appendString:[subStrings lastObject]] ;
    
    
    return imageURL ;
}

@end
