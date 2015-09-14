//
//  FourTwoBtCell.m
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "FourTwoBtCell.h"
#import "config.h"

@implementation FourTwoBtCell


- (void)awakeFromNib {
    // Initialization code
    self.title.textColor = UIColorFromRGB16(0x4D6EA5);
    self.oneLeft.textColor = UIColorFromRGB16(0x626262);
    self.twoLeft.textColor = UIColorFromRGB16(0x626262);
    self.threeLeft.textColor = UIColorFromRGB16(0x626262);
    self.fourLeft.textColor = UIColorFromRGB16(0x626262);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
