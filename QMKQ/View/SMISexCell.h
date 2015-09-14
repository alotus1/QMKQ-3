//
//  SMISexCell.h
//  QMKQ
//
//  Created by shangjin on 15/8/8.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLRadioButton.h"

@interface SMISexCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImgView;
@property (weak, nonatomic) IBOutlet DLRadioButton *leftBt;
@property (weak, nonatomic) IBOutlet DLRadioButton *rightBt;

@end
