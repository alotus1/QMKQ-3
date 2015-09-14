//
//  QMCalendarButton.m
//  QMClient
//
//  Created by Lotus on 15/7/26.
//  Copyright (c) 2015年 Lotus. All rights reserved.
//

#import "QMCalendarButton.h"

@implementation QMCalendarButton


- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.imageView.contentMode = UIViewContentModeCenter ;
//        self.backgroundColor = [UIColor yellowColor];
        self.titleLabel.font = [UIFont systemFontOfSize:14] ;
    }
    return self ;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    
    CGFloat W = 28 ;//QM_SCREEN_WIDTH / 7 ;
    CGFloat H = W ;
    CGFloat X = (QM_SCREEN_WIDTH / 7 - W) * 0.5 ;
    CGFloat Y = 8  ;
    
    
    return CGRectMake(X, Y, W, H) ;

}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    
    CGFloat X = 0 ;
    CGFloat Y = CGRectGetMaxY(self.titleLabel.frame) - 2;
    CGFloat W = QM_SCREEN_WIDTH / 7 ;
    CGFloat H = contentRect.size.height - Y ;
    return CGRectMake(X, Y, W, H) ;

}

@end
