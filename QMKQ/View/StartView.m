//
//  StartView.m
//  QMKQ
//
//  Created by shangjin on 15/8/31.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "StartView.h"
#import "config.h"

@implementation StartView

- (instancetype)init {self=[super init];if(self){[self instance];}return self;}
- (instancetype)initWithFrame:(CGRect)frame {self=[super initWithFrame:frame];if(self){[self instance];}return self;}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {self=[super initWithCoder:aDecoder];if(self){[self instance];}return self;}
- (void)awakeFromNib { [self instance];}
- (void)instance{
    self.startCount=0;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setStartCount:(NSInteger)startCount
{
    if (startCount != _startCount) {
        _startCount = startCount;
        [self setNeedsLayout];
    }
}

- (void)setCountOfStart
{
    for (UIView*v in self.subviews) {
        [v removeFromSuperview];
    }
    
    //星星
    double width = 13.5*ScreenWidth/375;
    double height = 12*ScreenWidth/375;
    double interval = 2*ScreenWidth/375;
    double selfwidth = self.frame.size.width;
    for (NSInteger i = 0; i<5; i++) {
        UIImageView*imageView=[[UIImageView alloc]initWithFrame:CGRectMake(selfwidth-width*(i+1)-i*interval, 0, width, height)];
        if (5-i>self.startCount) {
            imageView.image=[UIImage imageNamed:@"xx2"];
        }else {
            imageView.image=[UIImage imageNamed:@"xx1"];
        }
        [self addSubview:imageView];
    }
}

- (void)layoutSubviews
{
    [self setCountOfStart];
    [super layoutSubviews];
}

@end
