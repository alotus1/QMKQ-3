//
//  DocAdviceCell.m
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "DocAdviceCell.h"
#import "config.h"

@implementation DocAdviceCell

- (void)awakeFromNib {
    // Initialization code
    self.title.textColor = UIColorFromRGB16(0x4D6EA5);
    self.hint.textColor = UIColorFromRGB16(0xbfbfbf);
    self.textView.textColor = UIColorFromRGB16(0xbfbfbf);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
