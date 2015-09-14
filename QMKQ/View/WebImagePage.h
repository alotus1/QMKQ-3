//
//  WebImagePage.h
//  QMKQ
//
//  Created by shangjin on 15/8/26.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebImagePage : UIView

/**
 * PageControl 的背景颜色
 */
@property (nonatomic,strong) UIColor *pageBackgroundColor;
/**
 * PageControl 在普通状态下的颜色
 */
@property (nonatomic,strong) UIColor *pageIndicatorTintColor;
/**
 * PageControl 选中状态的颜色
 */
@property (nonatomic,strong) UIColor *currentPageColor;

@property (nonatomic, strong) NSArray * imageArray;//imageArray
@property (nonatomic ,copy)  void(^action)(NSInteger index );//点击


@end
