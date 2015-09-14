//
//  MIAnotherCell.m
//  QMKQ
//
//  Created by shangjin on 15/8/8.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "MIAnotherCell.h"
#import "config.h"

@implementation MIAnotherCell

- (void)awakeFromNib {
    // Initialization code
    self.leftLabel.textColor = UIColorFromRGB16(0x626262);
    self.rightLabel.textColor = UIColorFromRGB16(0x7D7D7D);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
