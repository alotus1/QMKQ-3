//
//  ThreeBtOneNumCell.m
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "ThreeBtOneNumCell.h"
#import "config.h"

@implementation ThreeBtOneNumCell


- (void)awakeFromNib {
    // Initialization code
    [self.rightNum setNumber:0];
    [self.rightNum setRise:1];
    [self.rightNum setDigitsAfterTheDecimalPoint:0];
    self.titleLabel.textColor = UIColorFromRGB16(0x4D6EA5);
    self.leftLabel.textColor = UIColorFromRGB16(0x626262);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
