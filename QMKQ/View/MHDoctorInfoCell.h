//
//  MHDoctorInfoCell.h
//  QMKQ
//
//  Created by shangjin on 15/8/1.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartView.h"

@interface MHDoctorInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *doctorImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shortDesc;
@property (weak, nonatomic) IBOutlet UILabel *clinicLabel;
@property (weak, nonatomic) IBOutlet StartView *startLevelImgView;

@end
