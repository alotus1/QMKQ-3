//
//  TwoThreeBtCell.m
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "TwoThreeBtOneNumCell.h"
#import "config.h"

@implementation TwoThreeBtOneNumCell

- (void)awakeFromNib {
    // Initialization code
    [self.topRightNum setNumber:0];
    [self.topRightNum setRise:1];
    [self.topRightNum setDigitsAfterTheDecimalPoint:0];
    [self.bottomRightNum setNumber:0];
    [self.bottomRightNum setRise:1];
    [self.bottomRightNum setDigitsAfterTheDecimalPoint:0];
    self.titleLabel.textColor = UIColorFromRGB16(0x4D6EA5);
    self.topLeft.textColor = UIColorFromRGB16(0x626262);
    self.bottomLeft.textColor = UIColorFromRGB16(0x626262);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
