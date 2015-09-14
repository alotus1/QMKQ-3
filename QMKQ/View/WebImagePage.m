//
//  WebImagePage.m
//  QMKQ
//
//  Created by shangjin on 15/8/26.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "WebImagePage.h"

@interface WebImagePage ()<UIScrollViewDelegate>
@property (nonatomic ,strong) UIScrollView *scrollView;
@property (nonatomic ,strong) UIPageControl *pageControl;

@end


@implementation WebImagePage


- (instancetype)init {self=[super init];if(self){[self instance];}return self;}
- (instancetype)initWithFrame:(CGRect)frame {self=[super initWithFrame:frame];if(self){[self instance];}return self;}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {self=[super initWithCoder:aDecoder];if(self){[self instance];}return self;}
- (void)awakeFromNib {[self instance];}
- (void)instance{
    [self setUpScrollView];
}

- (void)layoutSubviews
{
    [self setUpScrollView];
    
    [super layoutSubviews];
}

-(void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    
    [self setUpImage:imageArray];
    [self setUpPageControl:imageArray];
    [self setNeedsLayout];
}

/**
 *  设置scrollView
 */
-(void)setUpScrollView
{
    if (!self.scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.pagingEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pageViewClick:)];
        [scrollView addGestureRecognizer:tapGesture];
        
        [self addSubview:scrollView];
        self.scrollView = scrollView;
    }else {
        self.scrollView.frame = self.bounds;
    }
}

//手势点击
- (void)pageViewClick:(UITapGestureRecognizer *)tap
{
    if (self.action) {
        self.action(self.pageControl.currentPage);
    }
}



/**
 *  设置scrollView的内容图片：如果是网络图片的话就用SDWebImage加载，本地则直接设置
 *  暂时没想出其他方法。
 */
-(void)setUpImage:(NSArray *)array
{
    CGSize contentSize;
    CGPoint startPoint;
    for (UIView*v in self.scrollView.subviews) {
        [v removeFromSuperview];
    }
    if (array.count > 1) {     //多张图片
        for (int i = 0 ; i < array.count; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
            [self.scrollView addSubview:imageView];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:array[i]]];
                UIImage *image =  [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = image;
                });
            });
        }
        contentSize = CGSizeMake((array.count) * self.frame.size.width,0);
        startPoint = CGPointMake(0, 0);
    }else{ //1张图片
        for (int i = 0; i < array.count; i ++) {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height)];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:array[i]]];
                UIImage *image =  [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    imageView.image = image;
                });
            });
            
            [self addSubview:imageView];
        }
        contentSize = CGSizeMake(self.frame.size.width, 0);
        startPoint = CGPointZero;
    }
    
    //开始的偏移量跟内容尺寸
    self.scrollView.contentOffset = startPoint;
    self.scrollView.contentSize = contentSize;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int pageCount = scrollView.contentOffset.x / self.frame.size.width;
    self.pageControl.currentPage = pageCount;
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    int pageCount = scrollView.contentOffset.x / self.frame.size.width;
    self.pageControl.currentPage = pageCount;
}

-(void)setUpPageControl:(NSArray *)array
{
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.superview.backgroundColor = [UIColor redColor];
    self.pageControl.numberOfPages = array.count;
    //默认是0
    self.pageControl.currentPage = 0;
    //自动计算大小尺寸
    CGSize pageSize = [self.pageControl sizeForNumberOfPages:array.count];
    
    
    
    self.pageControl.bounds = CGRectMake(0, 0, self.frame.size.width, pageSize.height);
    self.pageControl.center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height-self.pageControl.frame.size.height/2.0);
    
    
    self.pageControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    
    
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
    [self.pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.pageControl];
    self.pageControl = self.pageControl;
}

-(void)pageChange:(UIPageControl *)page
{
    //获取当前页面的宽度
    CGFloat x = page.currentPage * self.bounds.size.width;
    //通过设置scrollView的偏移量来滚动图像
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (void)setPageBackgroundColor:(UIColor *)pageBackgroundColor
{
    if (pageBackgroundColor) {
        self.pageControl.backgroundColor = pageBackgroundColor;
    }
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor
{
    if (pageIndicatorTintColor) {
        self.pageControl.pageIndicatorTintColor = pageIndicatorTintColor;
    }
}
- (void)setCurrentPageColor:(UIColor *)currentPageColor
{
    if (currentPageColor) {
        self.pageControl.currentPageIndicatorTintColor = currentPageColor;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
