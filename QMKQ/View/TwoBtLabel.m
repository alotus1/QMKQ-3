//
//  TwoBtLabel.m
//  FAView-master
//
//  Created by shangjin on 15/8/18.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "TwoBtLabel.h"
#import "config.h"

@interface TwoBtLabel ()


@property (nonatomic, strong) UIButton * leftBt;
@property (nonatomic, strong) UIButton * rightBt;
@property (nonatomic, strong) UILabel * numberLabel;


@property (nonatomic, assign) CGFloat currentNumber;
@property (nonatomic, assign) CGFloat add;
@property (nonatomic, assign) NSInteger ww;
@property (nonatomic, assign) NSRange numberRange;
- (void)instance;
@end

@implementation TwoBtLabel

- (void)setRise:(CGFloat)rise
{
    self.add=rise;
}
- (CGFloat)rise
{
    return self.add;
}

- (void)setNumber:(CGFloat)num
{
    self.currentNumber=num;
    self.numberLabel.text = [NSString stringWithFormat:@"%d",(int)self.currentNumber];
    [self setNeedsDisplay];
}
- (CGFloat)number
{
    return self.currentNumber;
}

- (void)setDigitsAfterTheDecimalPoint:(NSInteger)digits
{
    if (digits<0) {
        digits=0;
    }
    self.ww = digits;
}

- (void)setRangeOfNumber:(NSRange)range
{
    self.numberRange=range;
}

- (instancetype)init {self=[super init];if(self){[self instance];}return self;}
- (instancetype)initWithFrame:(CGRect)frame {self=[super initWithFrame:frame];if(self){[self instance];}return self;}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {self=[super initWithCoder:aDecoder];if(self){[self instance];}return self;}

- (void)instance
{
    self.currentNumber=0;
    self.add=1;
    self.ww=0;
    self.numberRange=NSMakeRange(0, 0);
    self.leftBt=[[UIButton alloc]init];
    [self.leftBt setImage:[UIImage imageNamed:@"—"] forState:0];
    [self addSubview:self.leftBt];
    self.rightBt=[[UIButton alloc]init];
    [self.rightBt setImage:[UIImage imageNamed:@"＋"] forState:0];
    [self addSubview:self.rightBt];
    self.numberLabel=[[UILabel alloc]init];
    self.numberLabel.textColor = UIColorFromRGB16(0x626262);
    self.numberLabel.textAlignment=NSTextAlignmentCenter;
    self.numberLabel.text = @"0";
    [self addSubview:self.numberLabel];
    [self.leftBt addTarget:self action:@selector(changeNumber:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBt addTarget:self action:@selector(changeNumber:) forControlEvents:UIControlEventTouchUpInside];
    self.layer.borderColor=LineColor.CGColor;
    self.layer.borderWidth=0.5f;
}

- (void)changeNumber:(UIButton*)bt
{
    if ([bt isEqual:self.leftBt]) {
        //检查是否到极限值
        if (self.numberRange.location>self.currentNumber-self.add && !NSEqualRanges(self.numberRange, NSMakeRange(0, 0))) {
            return;
        }
        self.currentNumber=self.currentNumber-self.add;
    }else {
        //检查是否到极限值
        if (self.numberRange.length<self.currentNumber+self.add && !NSEqualRanges(self.numberRange, NSMakeRange(0, 0))) {
            return;
        }
        self.currentNumber=self.currentNumber+self.add;
    }
    NSString * text = [NSString stringWithFormat:@"%f",self.currentNumber];
    if (self.ww>=0) {
        NSRange r = [text rangeOfString:@"."];
        if (r.location!=NSNotFound) {
            NSInteger lenth = ((text.length-r.location-1)>self.ww)?(self.ww):(text.length-r.location-1);
            lenth = lenth>=0?lenth:0;
            NSString * f = [text substringWithRange:NSMakeRange(0, r.location)];
            NSString * l = [text substringWithRange:NSMakeRange(r.location+1, lenth)];
            if (self.ww>0) {
                text = [NSString stringWithFormat:@"%@.%@",f,l];
            }else {
                text = f;
            }
        }
    }
    self.numberLabel.text = text;
}

- (void)addTarget:(id)target andAction:(SEL)action forNumberChangeWithEvent:(UIControlEvents)event
{
//    [self.leftBt removeTarget:target action:action forControlEvents:event];
//    [self.rightBt removeTarget:target action:action forControlEvents:event];
    [self.leftBt addTarget:target action:action forControlEvents:event];
    [self.rightBt addTarget:target action:action forControlEvents:event];
}

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    double width = bounds.size.width;
    self.numberLabel.text = [NSString stringWithFormat:@"%d",(int)self.currentNumber];
    self.leftBt.frame=CGRectMake(0, 0, width/4.0, bounds.size.height);
    self.numberLabel.frame=CGRectMake(width/4.0, 0, width/2.0, bounds.size.height);
    self.rightBt.frame=CGRectMake(width*3.0/4.0, 0, width/4.0, bounds.size.height);
    [super layoutSubviews];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation UIButton (TwoBtLabelBt)

- (TwoBtLabel *)getTwoBtLabel
{
    if ([self.superview isKindOfClass:[TwoBtLabel class]]) {
        return (TwoBtLabel*)self.superview;
    }
    return nil;
}

@end


