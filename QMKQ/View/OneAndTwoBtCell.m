//
//  OneAndTwoBtCell.m
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "OneAndTwoBtCell.h"
#import "config.h"

@implementation OneAndTwoBtCell

- (void)awakeFromNib {
    // Initialization code
    self.leftLabel.textColor = UIColorFromRGB16(0x626262);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
