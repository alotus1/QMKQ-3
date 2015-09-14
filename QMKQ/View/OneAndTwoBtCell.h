//
//  OneAndTwoBtCell.h
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLRadioButton.h"

@interface OneAndTwoBtCell : UITableViewCell
@property (weak, nonatomic) IBOutlet DLRadioButton *leftBt;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet DLRadioButton *labelRight;
@property (weak, nonatomic) IBOutlet DLRadioButton *last;

@end
