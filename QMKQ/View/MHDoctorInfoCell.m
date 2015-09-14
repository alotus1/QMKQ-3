//
//  MHDoctorInfoCell.m
//  QMKQ
//
//  Created by shangjin on 15/8/1.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "MHDoctorInfoCell.h"
#import "config.h"

@implementation MHDoctorInfoCell

- (void)awakeFromNib
{
    self.nameLabel.textColor = UIColorFromRGB16(0x626262);
    self.shortDesc.textColor = UIColorFromRGB16(0x959595);
    self.clinicLabel.textColor = UIColorFromRGB16(0x959595);
    self.contentView.backgroundColor=UIColorFromRGB16(0xf5f4f4);
    self.backgroundColor=UIColorFromRGB16(0xf5f4f4);
}

@end
