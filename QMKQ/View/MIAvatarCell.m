//
//  MIAvatarCell.m
//  QMKQ
//
//  Created by shangjin on 15/8/8.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "MIAvatarCell.h"
#import "config.h"

@implementation MIAvatarCell

- (void)awakeFromNib {
    // Initialization code
    self.leftLabel.textColor = UIColorFromRGB16(0x626262);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
