//
//  FriendCell.m
//  QMKQ
//
//  Created by shangjin on 15/8/19.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "FriendCell.h"

@implementation FriendCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame=CGRectMake(23, 10, 40, 40);
    self.textLabel.frame=CGRectMake(75, self.textLabel.frame.origin.y, self.textLabel.frame.size.width, self.textLabel.frame.size.height);
}

@end
