//
//  TwoFourBtCell.h
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLRadioButton.h"

@interface TwoFourBtCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *topLeft;
@property (weak, nonatomic) IBOutlet UILabel *bottomLeft;
@property (weak, nonatomic) IBOutlet DLRadioButton *topFirst;
@property (weak, nonatomic) IBOutlet DLRadioButton *topSecond;
@property (weak, nonatomic) IBOutlet DLRadioButton *topThird;
@property (weak, nonatomic) IBOutlet DLRadioButton *TopFourth;
@property (weak, nonatomic) IBOutlet DLRadioButton *bottomFirst;
@property (weak, nonatomic) IBOutlet DLRadioButton *bottomSecond;
@property (weak, nonatomic) IBOutlet DLRadioButton *bottomThird;
@property (weak, nonatomic) IBOutlet DLRadioButton *bottomFourth;

@end
