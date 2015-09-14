//
//  LeftLeftLabelCell.m
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "LeftLeftLabelCell.h"
#import "config.h"

@implementation LeftLeftLabelCell

- (void)awakeFromNib {
    // Initialization code
    self.left.textColor = UIColorFromRGB16(0x4d6ea5);
    self.right.textColor = UIColorFromRGB16(0x626262);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
