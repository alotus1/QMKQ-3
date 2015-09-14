//
//  MHDoctorUserComCell.h
//  QMKQ
//
//  Created by shangjin on 15/8/8.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MHDoctorUserComCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageToBottom;
@property (weak, nonatomic) IBOutlet UIImageView *userImgView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hintImgView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *arrowButton;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgView;

@end
