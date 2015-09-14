//
//  TwoTwoNumCell.h
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLRadioButton.h"
#import "TwoBtLabel.h"

@interface TwoTwoNumCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet DLRadioButton *topBt;
@property (weak, nonatomic) IBOutlet DLRadioButton *bottomBt;
@property (weak, nonatomic) IBOutlet UILabel *oneOneLabel;
@property (weak, nonatomic) IBOutlet TwoBtLabel *oneoneNum;
@property (weak, nonatomic) IBOutlet UILabel *oneTwoLabel;
@property (weak, nonatomic) IBOutlet TwoBtLabel *oneTwoNum;
@property (weak, nonatomic) IBOutlet UILabel *twoOneLabel;
@property (weak, nonatomic) IBOutlet TwoBtLabel *twoOneNum;
@property (weak, nonatomic) IBOutlet UILabel *twoTwoLabel;
@property (weak, nonatomic) IBOutlet TwoBtLabel *twoTwoNum;

@end
