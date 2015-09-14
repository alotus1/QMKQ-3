//
//  Tools.h
//  QMKQ
//
//  Created by shangjin on 15/8/1.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DLRadioButton.h"

/**
 * 工具类
 */
@interface Tools : NSObject


+(NSString*)md5HexDigest:(NSString*)password;//md5加密

/**
 * 移除一个按钮的所有UIControlEventTouchUpInside点击方法
 *
 * @param button 按钮
 * @param target target
 */
+(void)button:(UIButton*)button removeAllActionsFromTarget:(id)target;
+(void)button:(UIButton*)button removeAllActionsFromTarget:(id)target controlEvents:(UIControlEvents)events;

/**
 * 给DLRadioButton这个类型的按钮和它的关联按钮添加同一种方法
 *
 * @param button 按钮
 * @param target target
 * @param action 方法
 */
+(void)button:(DLRadioButton*)button andOthersButtonAddTarget:(id)target action:(SEL)action;
+(void)button:(DLRadioButton*)button andOthersButtonAddTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)events;

/**
 * 验证电话号码
 *
 * @param number 电话号码
 *
 * @return 是中国电话号码返回YES
 */
+ (BOOL) validateMobile:(NSString *)number;

/**
 * 获取处理后的url
 *
 * @param str    url
 * @param suffix 后缀
 *
 * @return 处理后的url
 */
+ (NSString*)imageFromString:(NSString*)str withSuffix:(NSString*)suffix;

@end
