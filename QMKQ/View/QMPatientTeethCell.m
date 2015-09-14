//
//  QMPatientTeethCell.m
//  QMKQ
//
//  Created by shangjin on 15/8/2.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "QMPatientTeethCell.h"

@interface QMPatientTeethCell ()

@property (nonatomic ,strong) UIImageView*imaView;

@end

@implementation QMPatientTeethCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.imaView=[[UIImageView alloc]init];
//        self.imaView.image=[UIImage imageNamed:@"teeth"];
//        [self addSubview:self.imaView];
        self.teethView=[[MoreBtView alloc]init];
        [self addSubview:self.teethView];
    }
    return self;
}

- (void)layoutSubviews
{
    self.teethView.frame=self.bounds;
    self.imaView.frame=self.bounds;
    double width = self.teethView.frame.size.width;
    self.teethView.roundBtCounts = [NSMutableDictionary dictionaryWithDictionary:
                                    @{
                                      @"topLeft":@[@5,@7],
                                      @"topRight":@[@5,@7],
                                      @"bottomLeft":@[@5,@7],
                                      @"bottomRight":@[@5,@7],
                                      @"buttonSize":[NSNumber numberWithDouble:width*25/32],//宽高
                                      @"distance":@[[NSNumber numberWithDouble:width*5/16],[NSNumber numberWithDouble:width*135/320]],//与最高一样
                                      @"lineSize":@[[NSNumber numberWithDouble:width/32],[NSNumber numberWithDouble:width/32]]//距离xy轴的计算距离
                                      }];
    self.teethView.itemSize=width/160;
    [super layoutSubviews];
}

- (void)addTarget:(id)target andAction:(SEL)action
{
    [self.teethView addTarget:target andAction:action];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
