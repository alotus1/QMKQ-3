//
//  UCNameCell.m
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "UCNameCell.h"
#import "config.h"

@implementation UCNameCell

- (void)awakeFromNib {
    // Initialization code
    self.name.textColor = UIColorFromRGB16(0x4D6EA5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
