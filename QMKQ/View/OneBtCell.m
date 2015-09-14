//
//  OneBtCell.m
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "OneBtCell.h"

@interface OneBtCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;

@end

@implementation OneBtCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    if (self.width.constant>self.bt.currentTitle.length*14+20) {
        self.width.constant=self.bt.currentTitle.length*14+20;
        [self setNeedsUpdateConstraints];
    }
    [super layoutSubviews];
}

- (void)updateConstraints
{
    [super updateConstraints];
}

@end
