//
//  QMPatientTeethCell.h
//  QMKQ
//
//  Created by shangjin on 15/8/2.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreBtView.h"

@interface QMPatientTeethCell : UITableViewCell
@property (strong, nonatomic) MoreBtView *teethView;

- (void)addTarget:(id)target andAction:(SEL)action;

@end
