//
//  TwoTwoNumCell.m
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "TwoTwoNumCell.h"
#import "config.h"

@implementation TwoTwoNumCell

- (void)awakeFromNib {
    // Initialization code
    [self.oneoneNum setNumber:0];
    [self.oneoneNum setRise:1];
    [self.oneoneNum setDigitsAfterTheDecimalPoint:0];
    [self.oneTwoNum setNumber:0];
    [self.oneTwoNum setRise:1];
    [self.oneTwoNum setDigitsAfterTheDecimalPoint:0];
    [self.twoOneNum setNumber:0];
    [self.twoOneNum setRise:1];
    [self.twoOneNum setDigitsAfterTheDecimalPoint:0];
    [self.twoTwoNum setNumber:0];
    [self.twoTwoNum setRise:1];
    [self.twoTwoNum setDigitsAfterTheDecimalPoint:0];
    self.title.textColor = UIColorFromRGB16(0x4D6EA5);
    self.oneOneLabel.textColor = UIColorFromRGB16(0x626262);
    self.oneTwoLabel.textColor = UIColorFromRGB16(0x626262);
    self.twoOneLabel.textColor = UIColorFromRGB16(0x626262);
    self.twoTwoLabel.textColor = UIColorFromRGB16(0x626262);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
