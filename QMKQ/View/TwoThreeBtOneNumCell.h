//
//  TwoThreeBtCell.h
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLRadioButton.h"
#import "TwoBtLabel.h"

@interface TwoThreeBtOneNumCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *topLeft;
@property (weak, nonatomic) IBOutlet DLRadioButton *topFirst;
@property (weak, nonatomic) IBOutlet DLRadioButton *topSecond;
@property (weak, nonatomic) IBOutlet DLRadioButton *topThird;
@property (weak, nonatomic) IBOutlet TwoBtLabel *topRightNum;
@property (weak, nonatomic) IBOutlet UILabel *bottomLeft;
@property (weak, nonatomic) IBOutlet DLRadioButton *bottomFirst;
@property (weak, nonatomic) IBOutlet DLRadioButton *bottomSecond;
@property (weak, nonatomic) IBOutlet DLRadioButton *bottomThird;
@property (weak, nonatomic) IBOutlet TwoBtLabel *bottomRightNum;



@end
