//
//  CaseHeaderView.m
//  QMKQ
//
//  Created by shangjin on 15/8/21.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "CaseHeaderView.h"
#import "config.h"

@implementation CaseHeaderView

- (void)layoutSubviews
{
    self.textLabel.textColor=UIColorFromRGB16(0x4d6ea5);
    self.contentView.backgroundColor=BgColor;
    [super layoutSubviews];
    CGRect f = self.textLabel.frame;
    f.origin.x=20;
    self.textLabel.frame=f;
}

@end
