//
//  TwoFourBtCell.m
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "TwoFourBtCell.h"
#import "config.h"

@implementation TwoFourBtCell


- (void)awakeFromNib {
    // Initialization code
    self.title.textColor = UIColorFromRGB16(0x4D6EA5);
    self.topLeft.textColor = UIColorFromRGB16(0x626262);
    self.bottomLeft.textColor = UIColorFromRGB16(0x626262);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
