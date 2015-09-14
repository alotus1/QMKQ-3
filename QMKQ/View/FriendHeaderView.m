//
//  FriendHeaderView.m
//  QMKQ
//
//  Created by shangjin on 15/8/19.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "FriendHeaderView.h"
#import "config.h"

@implementation FriendHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
    self.contentView.backgroundColor=BgColor;
    self.textLabel.textColor = UIColorFromRGB16(0xBFBFBF);

    [super layoutSubviews];
    
    CGRect f = self.textLabel.frame;
    f.origin.x=28;
    self.textLabel.frame=f;
}

@end
