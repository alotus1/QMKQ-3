//
//  FourBtNoLeftCell.m
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "FourBtNoLeftCell.h"

@interface FourBtNoLeftCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lastWidth;



@end

@implementation FourBtNoLeftCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews
{
    BOOL needUpdateConstraints = NO;
    if (self.firstWidth.constant!=self.first.currentTitle.length*14+20) {
        self.firstWidth.constant=self.first.currentTitle.length*14+20;
    }
    if (self.secondWidth.constant!=self.second.currentTitle.length*14+20) {
        self.secondWidth.constant=self.second.currentTitle.length*14+20;
    }
    if (self.thirdWidth.constant!=self.third.currentTitle.length*14+20) {
        self.thirdWidth.constant=self.third.currentTitle.length*14+20;
    }
    if (self.lastWidth.constant!=self.last.currentTitle.length*14+20) {
        self.lastWidth.constant=self.last.currentTitle.length*14+20;
    }
    if (needUpdateConstraints) {
        [self setNeedsUpdateConstraints];
    }
    [super layoutSubviews];
}

- (void)updateConstraints
{
    [super updateConstraints];
}

@end
