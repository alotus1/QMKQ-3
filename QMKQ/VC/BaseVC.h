//
//  BaseVC.h
//  QMKQ
//
//  Created by shangjin on 15/8/8.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseVC : UIViewController
- (void)setLeftButtonItem;
//返回上页
- (void)__back;

- (void)addKeyboardNotifi;
- (void)showKeyboard:(NSNotification*)notifi;
- (void)hideKeyboard:(NSNotification*)notifi;
@end
