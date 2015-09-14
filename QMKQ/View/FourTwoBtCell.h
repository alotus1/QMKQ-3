//
//  FourTwoBtCell.h
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLRadioButton.h"

@interface FourTwoBtCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *oneLeft;
@property (weak, nonatomic) IBOutlet UILabel *twoLeft;
@property (weak, nonatomic) IBOutlet UILabel *threeLeft;
@property (weak, nonatomic) IBOutlet UILabel *fourLeft;
@property (weak, nonatomic) IBOutlet DLRadioButton *oneFirst;
@property (weak, nonatomic) IBOutlet DLRadioButton *oneLast;
@property (weak, nonatomic) IBOutlet DLRadioButton *twoFirst;
@property (weak, nonatomic) IBOutlet DLRadioButton *twoLast;
@property (weak, nonatomic) IBOutlet DLRadioButton *threeFirst;
@property (weak, nonatomic) IBOutlet DLRadioButton *threeLast;
@property (weak, nonatomic) IBOutlet DLRadioButton *fourFirst;
@property (weak, nonatomic) IBOutlet DLRadioButton *fourLast;

@end
