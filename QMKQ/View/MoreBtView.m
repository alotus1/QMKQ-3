//
//  MoreBtView.m
//  FAView-master
//
//  Created by shangjin on 15/8/17.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "MoreBtView.h"
#import <math.h>
#import "config.h"
#define RADIAN(a) (a*M_PI/180.0)
#define ANGLE(r) (180.0*r/M_PI)
#define ANGLEFromSin(v) asin(v)/M_PI*180
#define ANGLEFromCos(v) acos(v)/M_PI*180
#define ANGLEFromTan(v) atan(v)/M_PI*180
#define SINFromAngle(v) sin(v*M_PI/180)
#define COSFromAngle(v) cos(v*M_PI/180)
#define TANFromAngle(v) tan(v*M_PI/180)


@interface MoreBtView ()

@property (nonatomic, retain) UIButton * selectButton;
@property (nonatomic, strong) NSMutableArray *bts;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;

@end

@implementation MoreBtView

- (instancetype)init {self=[super init];if(self){[self instance];}return self;}
- (instancetype)initWithFrame:(CGRect)frame {self=[super initWithFrame:frame];if(self){[self instance];}return self;}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {self=[super initWithCoder:aDecoder];if(self){[self instance];}return self;}
- (void)awakeFromNib {   [super awakeFromNib]; [self instance]; }

- (void)instance{
    //创造按钮
    self.bts=[NSMutableArray array];
    self.roundBtCounts=[NSMutableDictionary dictionary];
    //清一下
    for (UIView*vi in self.subviews) {
        [vi removeFromSuperview];
    }
}

- (UIButton*)selectedButton
{
    return self.selectButton;
}

- (void)layoutSubviews
{
    double wh = [[self.roundBtCounts objectForKey:@"buttonSize"] floatValue]>0?[[self.roundBtCounts objectForKey:@"buttonSize"] floatValue]:0;
    if (wh&&!(self.bts.count>0)) {
        NSArray*topLeft = [self.roundBtCounts objectForKey:@"topLeft"]?[self.roundBtCounts objectForKey:@"topLeft"]:@[];
        NSArray*topRight = [self.roundBtCounts objectForKey:@"topRight"]?[self.roundBtCounts objectForKey:@"topRight"]:@[];
        NSArray*bottomLeft = [self.roundBtCounts objectForKey:@"bottomLeft"]?[self.roundBtCounts objectForKey:@"bottomLeft"]:@[];
        NSArray*bottomRight = [self.roundBtCounts objectForKey:@"bottomRight"]?[self.roundBtCounts objectForKey:@"bottomRight"]:@[];
        double itemSize = self.itemSize;
        //以最高的层数为准
        NSArray* distance = [self.roundBtCounts objectForKey:@"distance"];
        NSArray* lineSize = [self.roundBtCounts objectForKey:@"lineSize"];
        for (NSInteger i=0; i < distance.count; i++) {
            //第一层圆心距离selfcenter的距离
            //三角形的斜边为btDis
            double btDis = [[distance objectAtIndex:i] floatValue];
            //轴倾斜后在这一层圆心距离相同的点，距离轴的距离
            double toline = [[lineSize objectAtIndex:i] floatValue];
            //空格的角度
            double tempAngle = [self angleForWidth:itemSize distance:btDis];
            //距离轴的角度
            double tolineAngle = [self angleForWidth:toline distance:btDis];
            //真正有用的空间的长度
            double useAngle = 90 - tolineAngle*2;
            //创建第一层
            if (topLeft.count>i) {
                //按钮数量
                NSInteger topLeftCount = [[topLeft objectAtIndex:i] integerValue];
                //按钮宽度
                double  ttempAngle= tempAngle;
                double btAngle = (useAngle - (topLeftCount+1)*ttempAngle) / topLeftCount;
                double btWidth = [self widthForAngle:btAngle distance:btDis];
                //空格为零时，实际宽度大于测用宽度
                if (wh<btWidth) {
                    btWidth = wh;
                    btAngle = [self angleForWidth:wh distance:btDis];
                    ttempAngle = (useAngle - (topLeftCount)*btAngle) / (topLeftCount + 1);
                }
                //第一个点的弧度
                double curAngle = tolineAngle + btAngle*0.5 + ttempAngle;
                for (NSInteger j=0; j<topLeftCount; j++) {
                    UIButton*bt=[self btWithWidth:btWidth];
                    [bt setTitle:[NSString stringWithFormat:@"%@%d",i==0?@"5":@"1",(int)(topLeftCount-j)] forState:UIControlStateNormal];
                    
                    CGPoint buttonCenter;
                    double vsin = SINFromAngle(curAngle);
                    double vcos = COSFromAngle(curAngle);
                    buttonCenter.x = self.frame.size.width*0.5 - fabs(vcos)*btDis;
                    buttonCenter.y = self.frame.size.height*0.5 - fabs(vsin)*btDis;
                    bt.center = buttonCenter;
                    
                    curAngle += ttempAngle + btAngle;
                    [self addSubview:bt];
                    [self.bts addObject:bt];
                }
            }
            
            if (topRight.count>i) {
                //按钮数量
                NSInteger topRightCount = [[topRight objectAtIndex:i] integerValue];
                //按钮宽度
                double  ttempAngle= tempAngle;
                double btAngle = (useAngle - (topRightCount+1)*ttempAngle) / topRightCount;
                double btWidth = [self widthForAngle:btAngle distance:btDis];
                //空格为零时，实际宽度大于测用宽度
                if (wh<btWidth) {
                    btWidth = wh;
                    btAngle = [self angleForWidth:wh distance:btDis];
                    ttempAngle = (useAngle - (topRightCount)*btAngle) / (topRightCount + 1);
                }
                //第一个点的弧度
                double curAngle = tolineAngle + btAngle*0.5 + ttempAngle;
                for (NSInteger j=0; j<topRightCount; j++) {
                    UIButton*bt=[self btWithWidth:btWidth];
                    [bt setTitle:[NSString stringWithFormat:@"%@%d",i==0?@"6":@"2",(int)(topRightCount-j)] forState:UIControlStateNormal];
                    
                    CGPoint buttonCenter;
                    double vsin = SINFromAngle(curAngle);
                    double vcos = COSFromAngle(curAngle);
                    buttonCenter.x = self.frame.size.width*0.5 + fabs(vcos)*btDis;
                    buttonCenter.y = self.frame.size.height*0.5 - fabs(vsin)*btDis;
                    bt.center = buttonCenter;
                    
                    curAngle += ttempAngle + btAngle;
                    [self addSubview:bt];
                    [self.bts addObject:bt];
                }
            }
            
            if (bottomLeft.count>i) {
                //按钮数量
                NSInteger bottomLeftCount = [[bottomLeft objectAtIndex:i] integerValue];
                //按钮宽度
                double  ttempAngle= tempAngle;
                double btAngle = (useAngle - (bottomLeftCount+1)*ttempAngle) / bottomLeftCount;
                double btWidth = [self widthForAngle:btAngle distance:btDis];
                //空格为零时，实际宽度大于测用宽度
                if (wh<btWidth) {
                    btWidth = wh;
                    btAngle = [self angleForWidth:wh distance:btDis];
                    ttempAngle = (useAngle - (bottomLeftCount)*btAngle) / (bottomLeftCount + 1);
                }
                //第一个点的弧度
                double curAngle = tolineAngle + btAngle*0.5 + ttempAngle;
                for (NSInteger j=0; j<bottomLeftCount; j++) {
                    UIButton*bt=[self btWithWidth:btWidth];
                    [bt setTitle:[NSString stringWithFormat:@"%@%d",i==0?@"8":@"4",(int)(bottomLeftCount-j)] forState:UIControlStateNormal];
                    
                    CGPoint buttonCenter;
                    double vsin = SINFromAngle(curAngle);
                    double vcos = COSFromAngle(curAngle);
                    buttonCenter.x = self.frame.size.width*0.5 - fabs(vcos)*btDis;
                    buttonCenter.y = self.frame.size.height*0.5 + fabs(vsin)*btDis;
                    bt.center = buttonCenter;
                    
                    curAngle += ttempAngle + btAngle;
                    [self addSubview:bt];
                    [self.bts addObject:bt];
                }
            }
            
            if (bottomRight.count>i) {
                //按钮数量
                NSInteger bottomRightCount = [[bottomRight objectAtIndex:i] integerValue];
                //按钮宽度
                double  ttempAngle= tempAngle;
                double btAngle = (useAngle - (bottomRightCount+1)*ttempAngle) / bottomRightCount;
                double btWidth = [self widthForAngle:btAngle distance:btDis];
                //空格为零时，实际宽度大于测用宽度
                if (wh<btWidth) {
                    btWidth = wh;
                    btAngle = [self angleForWidth:wh distance:btDis];
                    ttempAngle = (useAngle - (bottomRightCount)*btAngle) / (bottomRightCount + 1);
                }
                //第一个点的弧度
                double curAngle = tolineAngle + btAngle*0.5 + ttempAngle;
                for (NSInteger j=0; j<bottomRightCount; j++) {
                    UIButton*bt=[self btWithWidth:btWidth];
                    [bt setTitle:[NSString stringWithFormat:@"%@%d",i==0?@"7":@"3",(int)(bottomRightCount-j)] forState:UIControlStateNormal];
                    
                    CGPoint buttonCenter;
                    double vsin = SINFromAngle(curAngle);
                    double vcos = COSFromAngle(curAngle);
                    buttonCenter.x = self.frame.size.width*0.5 + fabs(vcos)*btDis;
                    buttonCenter.y = self.frame.size.height*0.5 + fabs(vsin)*btDis;
                    bt.center = buttonCenter;
                    
                    curAngle += ttempAngle + btAngle;
                    [self addSubview:bt];
                    [self.bts addObject:bt];
                }
            }
        }
        [self setNeedsLayout];
    }
    
    [super layoutSubviews];
}

- (UIButton*)btWithWidth:(double)btWidth
{
    UIButton*bt=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, btWidth, btWidth)];
    bt.layer.cornerRadius=btWidth/2.0f;
    bt.backgroundColor=[UIColor clearColor];
    bt.layer.borderColor=TeethBtTitle.CGColor;
    bt.layer.borderWidth=0.5f;
    [bt setTitleColor:TeethBtTitle forState:0];
    
    [bt addTarget:self action:@selector(upBt:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    [bt removeTarget:self.target action:self.action forControlEvents:UIControlEventAllEvents];
    [bt addTarget:self.target action:self.action forControlEvents:UIControlEventTouchUpInside];
    return bt;
}


- (void)upBt:(UIButton*)bt
{
    self.selectButton=bt;
    [bt setTitleColor:[UIColor whiteColor] forState:0];
    bt.backgroundColor=NavigationBarBG;
    bt.layer.borderColor=NavigationBarBG.CGColor;
    bt.layer.borderWidth=0.0f;
    for (UIButton*b in self.bts) {
        if (![b isEqual:bt] && b != bt) {
            [b setTitleColor:TeethBtTitle forState:0];
            b.backgroundColor=[UIColor clearColor];
            b.layer.borderColor=TeethBtTitle.CGColor;
            b.layer.borderWidth=0.5f;
        }
    }
}

- (void)addTarget:(id)target andAction:(SEL)action
{
    self.target=target;
    self.action=action;
    for (UIButton*b in self.bts) {
        [b removeTarget:target action:action forControlEvents:UIControlEventAllEvents];
        [b addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
}

- (double)angleForWidth:(double)n distance:(double)m
{
    double vsin = (n/(2*m));
    double angle = ANGLEFromSin(vsin)*2;
    return angle;
}
- (double)widthForAngle:(double)angle distance:(double)m
{
    double vsin = SINFromAngle(angle/2);
    double width = m * vsin * 2;
    return width;
}


#pragma mark    计算
//返回点，构成为三角形的:(高，底)
- (CGPoint)pointForHeightAndBottomFrom:(double)distance andToline:(double)toline
{
    return CGPointMake(sqrt(distance*distance-toline*toline), toline);
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] setFill];
    CGContextFillRect(ctx, rect);
    int startX=rect.size.width/2;//圆心x坐标
    int startY=rect.size.height/2;//圆心y坐标
    
    double radius = (rect.size.width*560/750)/2.0f;
    //上层 大
    CGContextSetFillColorWithColor(ctx, UIColorFromRGB16(0xe8e8e8).CGColor);
    CGContextAddArc(ctx, startX, startY, radius, RADIAN(0), RADIAN(0+180), 0);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    //下层 大
    CGContextSetFillColorWithColor(ctx, UIColorFromRGB16(0xededed).CGColor);
    CGContextAddArc(ctx, startX, startY, radius, RADIAN(0), RADIAN(180), 1);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    double radius1 = (rect.size.width*140/750)/2.0f;
    //上层 小
    CGContextSetFillColorWithColor(ctx, UIColorFromRGB16(0xf4f4f4).CGColor);
    CGContextAddArc(ctx, startX, startY, radius1, RADIAN(0), RADIAN(0+180), 0);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    //下层 小
    CGContextSetFillColorWithColor(ctx, UIColorFromRGB16(0xf6f6f6).CGColor);
    CGContextAddArc(ctx, startX, startY, radius1, RADIAN(0), RADIAN(180), 1);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    //白线
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextMoveToPoint(ctx, startX, startY-radius);
    CGContextAddLineToPoint(ctx, startX, startY+radius);
    CGContextStrokePath(ctx);
    
    //画字
    int relative = rect.size.width*90/750;
    [@"1" drawAtPoint:CGPointMake(startX-relative, startY-relative-7) withAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB16(0x4d6ea5),NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [@"2" drawAtPoint:CGPointMake(startX+relative-7, startY-relative-7) withAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB16(0x4d6ea5),NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [@"3" drawAtPoint:CGPointMake(startX+relative-7, startY+relative-7) withAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB16(0x4d6ea5),NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [@"4" drawAtPoint:CGPointMake(startX-relative, startY+relative-7) withAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB16(0x4d6ea5),NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    relative = rect.size.width*40/750;
    [@"5" drawAtPoint:CGPointMake(startX-relative, startY-relative-7) withAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB16(0x4d6ea5),NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [@"6" drawAtPoint:CGPointMake(startX+relative-7, startY-relative-7) withAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB16(0x4d6ea5),NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [@"7" drawAtPoint:CGPointMake(startX+relative-7, startY+relative-7) withAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB16(0x4d6ea5),NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [@"8" drawAtPoint:CGPointMake(startX-relative, startY+relative-7) withAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB16(0x4d6ea5),NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    relative = radius/2.0f;
    [@"上半口" drawAtPoint:CGPointMake(startX-27, startY-relative-9) withAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    [@"下半口" drawAtPoint:CGPointMake(startX-27, startY+relative-9) withAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB16(0xbfbfbf),NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    
//    UIGraphicsEndImageContext();
//    CGContextRelease(ctx);
    [super drawRect:rect];
    
    
    
}


//- (void)drawCircle:(CGContextRef)ctx width:(double)width
//{
//    double circleWidth = rect.size.width*width/750;
//    double circleOriginSize = (rect.size.width-circleWidth)/2.0f;
//    CGContextFillEllipseInRect(ctx, CGRectMake(circleOriginSize, circleOriginSize, circleWidth, circleWidth));
//}


@end
