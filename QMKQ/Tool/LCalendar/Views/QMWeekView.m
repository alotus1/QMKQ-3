//
//  QMWeekView.m
//  CustomCalendar
//
//  Created by 袁偲￼琦 on 15/7/16.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMWeekView.h"
#import "config.h"

@interface QMWeekView ()

@property (strong , nonatomic) NSArray * weekdays ;

/**
 *  显示当前的年和月份
 */
@property (weak , nonatomic) UILabel * monthLabel ;

/**
 *  上个月
 */
@property (weak , nonatomic) UIButton * previousMonthButton ;

/**
 *  下个月
 */
@property (weak , nonatomic) UIButton * nextMonthButton ;

/**
 *  分割线
 */
@property (weak , nonatomic) UIImageView * diliverView ;

@end

@implementation QMWeekView

- (void)setCurrentDate:(NSDate *)currentDate {

    _currentDate = currentDate ;
    
//    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init] ;
//    NSLocale * currentLocale = [NSLocale systemLocale] ;


    NSString * dateString = [NSDateFormatter localizedStringFromDate:currentDate dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle] ;
    self.monthLabel.text = dateString ;
//#warning 这里打印的日期是英文,尝试换成中文
//    NSLog(@"%@" , dateString) ;
}

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithColorString:@"f7f7f7"] ;
        
        NSArray * dataSource = @[@"日" , @"一", @"二", @"三", @"四", @"五", @"六"] ;
        
        CGFloat leftPadding = ScreenWidth == 320 ? 6 : 24 ;
        
        // 添加子控件
        // 添加左右两侧切换月份的控件
        UIButton * previousMonthButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
//        [previousMonthButton setTitle:@"<" forState:UIControlStateNormal] ;
        previousMonthButton.contentEdgeInsets = UIEdgeInsetsMake(QM_SCALE_HEIGHT(0), leftPadding, 0, 0) ;
//        [previousMonthButton setImageEdgeInsets:UIEdgeInsetsMake(QM_SCALE_HEIGHT(0), leftPadding, 0, 0)] ;
        [previousMonthButton setImage:[UIImage imageNamed:@"button_left"] forState:UIControlStateNormal] ;
        previousMonthButton.imageView.contentMode = UIViewContentModeLeft ;
        [previousMonthButton addTarget:self action:@selector(changeMonthButtonTouch:) forControlEvents:UIControlEventTouchUpInside] ;
        [self addSubview:previousMonthButton] ;
        self.previousMonthButton = previousMonthButton ;
        
        UIButton * nextMonthButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
        nextMonthButton.imageView.contentMode = UIViewContentModeRight ;
        [nextMonthButton setImage:[UIImage imageNamed:@"button_right"] forState:UIControlStateNormal] ;
        [nextMonthButton setImageEdgeInsets:UIEdgeInsetsMake(QM_SCALE_HEIGHT(0), 0, 0, leftPadding)] ;
        [nextMonthButton addTarget:self action:@selector(changeMonthButtonTouch:) forControlEvents:UIControlEventTouchUpInside] ;
        [self addSubview:nextMonthButton] ;
        self.nextMonthButton = nextMonthButton ;
        
        
        // 显示当前月
        UILabel * monthLabel = [[UILabel alloc] init] ;
        monthLabel.font = [UIFont systemFontOfSize:20] ;
        monthLabel.textColor = UIColorFromRGB16(0x4d6ea5) ;
        monthLabel.textAlignment = NSTextAlignmentCenter ;
        [self addSubview:monthLabel] ;
        self.monthLabel = monthLabel ;
        
        
        // 显示星期
        NSMutableArray * weekdays = [NSMutableArray array] ;
        for (NSInteger i = 0 ; i < 7; i++) {
            UILabel * weekday = [[UILabel alloc] init] ;
            weekday.font = [UIFont systemFontOfSize:12] ;
            weekday.text = dataSource[i] ;
            weekday.textAlignment = NSTextAlignmentCenter ;
            if (i == 0 || i == 6) {
                weekday.textColor = [UIColor lightGrayColor] ;
            }
            [self addSubview:weekday] ;
            [weekdays addObject:weekday] ;
        }
        self.weekdays = weekdays ;
        
        UIImageView * diliverView = [[UIImageView alloc] init] ;
        diliverView.image = [UIImage imageNamed:@"first_diliver_line"] ;
        [self addSubview:diliverView] ;
        self.diliverView = diliverView ;
        
        
    }
    return self ;
}

- (void) changeMonthButtonTouch : (UIButton *) button {

    // block为空则不进行下面的操作
    if (!self.buttonClickBlock) {
        return ;
    }
    
    // 判断是切换上一个月还是下一个月
    QMWeekViewButtonType type = button == self.previousMonthButton ? QMWeekViewButtonTypePreviousMonth : QMWeekViewButtonTypeNextMonth ;
    // 调用block
    self.buttonClickBlock(self , type) ;
   
}

- (void)layoutSubviews {

    [super layoutSubviews] ;
    
    // 显示月份label的frame
    CGFloat monthX = 0 ;
    CGFloat monthY = 0 ;
    CGFloat monthW = self.frame.size.width ;
    CGFloat monthH = QM_SCALE_HEIGHT(55) ;
    self.monthLabel.frame = CGRectMake(monthX, monthY, monthW, monthH) ;
//    self.monthLabel.backgroundColor = [UIColor redColor] ;
    
    // 切换月份button的frame
    CGFloat previousX = 0 ;
    CGFloat previousY = monthY ;
    CGFloat previousW = QM_SCALE_WIDTH(50) ;
    CGFloat previousH = monthH ;
    self.previousMonthButton.frame = CGRectMake(previousX, previousY, previousW, previousH) ;
//    self.previousMonthButton.backgroundColor = [UIColor redColor] ;
    
    CGFloat nextW = QM_SCALE_WIDTH(50) ;
    CGFloat nextH = monthH ;
    CGFloat nextX = self.frame.size.width - nextW ;
    CGFloat nextY = monthY ;
    self.nextMonthButton.frame = CGRectMake(nextX, nextY, nextW, nextH) ;
//    self.nextMonthButton.backgroundColor = [UIColor greenColor] ;
    
    // 设置每个label的布局情况
    CGFloat labelY = CGRectGetMaxY(self.monthLabel.frame) ;
    CGFloat labelW = self.frame.size.width / self.weekdays.count ;
    CGFloat labelH = QM_SCALE_WIDTH(20) - 1 ;
    
    NSInteger i = 0 ;
    for (UILabel * label in self.weekdays) {
        CGFloat labelX = labelW * i++ ;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH) ;
//        label.backgroundColor = [UIColor greenColor] ;
    }
    
    // 分割线
    CGFloat diliverW = self.frame.size.width ;
    CGFloat diliverH = 1 ;
    CGFloat diliverX = 0 ;
    CGFloat diliverY = self.frame.size.height - diliverH ;
    self.diliverView.frame = CGRectMake(diliverX, diliverY, diliverW, diliverH) ;
    
}

@end
