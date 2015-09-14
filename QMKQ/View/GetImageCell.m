//
//  GetImageCell.m
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "GetImageCell.h"
#import "config.h"

@implementation GetImageCell

- (void)awakeFromNib {
    // Initialization code
    self.firstImgView.image = [UIImage imageNamed:@"zp"];
    self.secondImgView.image = [UIImage imageNamed:@"zp"];
    self.thirdImgView.image = [UIImage imageNamed:@"zp"];
    self.lastImgView.image = [UIImage imageNamed:@"zp"];
    self.title.textColor = UIColorFromRGB16(0x4D6EA5);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation UIImageView (ADDTARGETANDACTION)


- (void)addImageGestureTarget:(id)target andAction:(SEL)action
{
    self.userInteractionEnabled=YES;
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    [self addGestureRecognizer:tap];
}


@end

