//
//  ThreeBtNoLeftCell.m
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "ThreeBtNoLeftCell.h"


@interface ThreeBtNoLeftCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdWidth;

@end

@implementation ThreeBtNoLeftCell

- (void)awakeFromNib {
    // Initialization code
//    self.first.otherButtons=@[self.second,self.third];
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
    if (needUpdateConstraints) {
        [self setNeedsUpdateConstraints];
    }
    [super layoutSubviews];
}

@end
