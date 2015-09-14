//
//  MoreBtView.h
//  FAView-master
//
//  Created by shangjin on 15/8/17.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreBtView : UIView

//@{
//    @"topLeft":@[@5,@4],
//    @"topRight":@[@5,@4],
//    @"bottomLeft":@[@5,@4],
//    @"bottomRight":@[@5,@4],
//    @"bottonSize":@50,//宽高
//    @"distance":@[@20,@44],与最高一样
//    @"lineSize":@[@40,50]//距离xy轴的计算距离
//}
@property (nonatomic, strong) NSMutableDictionary *roundBtCounts;//周围按钮的数量

@property (nonatomic, assign) CGFloat itemSize;//每个项目间的空隙
//@property (nonatomic, assign) CGFloat lineSize;//距离xy轴的计算距离

- (UIButton *)selectedButton;
- (void)addTarget:(id)target andAction:(SEL)action;

@end
