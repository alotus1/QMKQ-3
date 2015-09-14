//
//  NSString+Extention.h
//
//  Created by Lotus on 15-5-9.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extention)

- (CGSize) sizeWithFont : (UIFont *) font maxSize : (CGSize) maxSize ;


/**
 *  转换时间的显示格式
 *
 *  @param oldDateFormatter 老格式
 *  @param newDateFormatter 新格式
 *
 *  @return 新格式时间字符串
 */
- (NSString *) timeWithOldDateFormatter : (NSDateFormatter *) oldDateFormatter newDateFormatter : (NSDateFormatter *) newDateFormatter ;

/**
 *  获得小图url地址(字符串拼接)
 */
- (NSString *) getSmallImageURL ;

- (NSString *) getMiddleImageURL ;

@end
