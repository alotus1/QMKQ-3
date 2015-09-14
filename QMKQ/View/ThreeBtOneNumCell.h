//
//  ThreeBtOneNumCell.h
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLRadioButton.h"
#import "TwoBtLabel.h"

@interface ThreeBtOneNumCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet DLRadioButton *first;
@property (weak, nonatomic) IBOutlet DLRadioButton *second;
@property (weak, nonatomic) IBOutlet DLRadioButton *third;
@property (weak, nonatomic) IBOutlet TwoBtLabel *rightNum;

@end
