//
//  TwoBtLabel.h
//  FAView-master
//
//  Created by shangjin on 15/8/18.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoBtLabel : UIView

- (void)setNumber:(CGFloat)num;//设置数字
- (CGFloat)number;//获取当前数字
- (void)setRise:(CGFloat)rise;//设置增长
- (CGFloat)rise;
- (void)setDigitsAfterTheDecimalPoint:(NSInteger)digits;//设置小数点后有多少位
- (void)setRangeOfNumber:(NSRange)range;    //设置极限值

- (void)addTarget:(id)target andAction:(SEL)action forNumberChangeWithEvent:(UIControlEvents)event;


@end

@interface UIButton (TwoBtLabelBt)

- (TwoBtLabel*)getTwoBtLabel;

@end
