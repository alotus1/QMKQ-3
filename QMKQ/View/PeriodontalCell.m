//
//  PeriodontalCell.m
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "PeriodontalCell.h"
#import "config.h"

@implementation PeriodontalCell

- (void)awakeFromNib {
    // Initialization code
    self.left.textColor = UIColorFromRGB16(0x4D6EA5);
    self.textfield.textColor = UIColorFromRGB16(0x626262);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
