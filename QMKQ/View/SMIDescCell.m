//
//  SMIDescCell.m
//  QMKQ
//
//  Created by shangjin on 15/8/15.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "SMIDescCell.h"
#import "config.h"

@implementation SMIDescCell

- (void)awakeFromNib {
    // Initialization code
    self.leftLabel.textColor=UIColorFromRGB16(0x626262);
    self.leftView.backgroundColor=UIColorFromRGB16(0xF9F8F8);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
