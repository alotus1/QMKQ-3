//
//  Home.m
//  QMKQ
//
//  Created by shangjin on 15/7/31.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "Home.h"
#import "config.h"
#import "BOffLineCache.h"
#import <UIImageView+AFNetworking.h>
#import "QMRequest.h"
#import "WebImagePage.h"
#import "WebVC.h"

@interface Home ()

@property (weak, nonatomic) IBOutlet UIView *tipView;//问候父视图
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//时间标签
@property (nonatomic, strong) NSDateFormatter * dateFormat;//日期样式
@property (nonatomic, strong) NSTimer * timeTimer;//时间计时器
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;//问候语
@property (weak, nonatomic) IBOutlet UIImageView *imgView;//被几个图片
@property (nonatomic, strong) NSString *urlString;//UrlString
@property (weak, nonatomic) IBOutlet UIImageView *viewDi;//时间底图
@property (weak, nonatomic) IBOutlet UIImageView *viewLine;//线
@property (nonatomic, strong) IBOutlet WebImagePage *pageView;
@property (nonatomic, strong) NSArray * homePages;

@end

@implementation Home

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=BgColor;
    self.navigationItem.title=@"青苗口腔";
    self.viewDi.image = [UIImage imageNamed:@"shijiandi"];
    self.viewLine.image = [UIImage imageNamed:@"______"];
    [self setDef];
    
    [self createScrollView];
    
    //获取首页信息
    [self getHome];
}

- (void)createScrollView
{
    self.pageView.pageBackgroundColor = [UIColor clearColor];
    self.pageView.pageIndicatorTintColor = NavigationBarBG;
    self.pageView.currentPageColor = LineColor;
    __weak Home * weakSelf = self;
    self.pageView.action = ^(NSInteger index) {
        WebVC *vc=ViewControllerFromStoryboardWithIdentifier(@"WebVC");
        vc.homePageInfo = [weakSelf.homePages objectAtIndex:index];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
}


- (void)getHome
{
    [[[QMRequest alloc]init] startWithPackage:nil post:NO apiType:HomeDoctorTop completion:^(BOOL success, NSError *error, NSDictionary *result) {
        if (success) {
            NSDictionary*dic = [result objectForKey:@"data"];
            self.urlString = SafeValue([dic objectForKey:@"titlePic"], @"");
            self.tipLabel.text = SafeValue([dic objectForKey:@"title"], @"你好");
            [self.imgView setImageWithURL:[NSURL URLWithString:self.urlString] placeholderImage:[UIImage imageNamed:@"banner"]];
            [BOffLineCache storeOffLineData:result withKey:HomeDoctorTopStoreKey];
        }else if ([BOffLineCache offLineDataForKey:HomeDoctorTopStoreKey]) {
            // 如果获取出错，并且内存中含有，则从内存获取
            NSDictionary*dic = [[BOffLineCache offLineDataForKey:HomeDoctorTopStoreKey] objectForKey:@"data"];
            self.urlString = SafeValue([dic objectForKey:@"titlePic"], @"");
            self.tipLabel.text = SafeValue([dic objectForKey:@"title"], @"你好");
            [self.imgView setImageWithURL:[NSURL URLWithString:self.urlString] placeholderImage:[UIImage imageNamed:@"banner"]];
        }
    }];
    [[[QMRequest alloc]init] startWithPackage:nil post:NO apiType:HomeDoctorDown completion:^(BOOL success, NSError *error, NSDictionary *result) {
        if (success) {
            if ([result objectForKey:@"data"]) {
                self.homePages=[result objectForKey:@"data"];
            }else {
                self.homePages=[NSArray array];
            }
            NSMutableArray*imageArray = [NSMutableArray array];
            for (NSDictionary*item in self.homePages) {
                [imageArray addObject:[item objectForKey:@"titlePic"]];
            }
            self.pageView.imageArray=imageArray;
            [BOffLineCache storeOffLineData:result withKey:HomeDoctorDownStoreKey];
        }else if ([BOffLineCache offLineDataForKey:HomeDoctorDownStoreKey]) {
            result = [BOffLineCache offLineDataForKey:HomeDoctorDownStoreKey];
            if ([result objectForKey:@"data"]) {
                self.homePages=[result objectForKey:@"data"];
            }else {
                self.homePages=[NSArray array];
            }
            NSMutableArray*imageArray = [NSMutableArray array];
            for (NSDictionary*item in self.homePages) {
                [imageArray addObject:[item objectForKey:@"titlePic"]];
            }
            self.pageView.imageArray=imageArray;
        }
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setTime];
}

/**
 * 初始
 */
- (void)setDef
{
    self.dateFormat=[[NSDateFormatter alloc]init];
    self.dateFormat.dateFormat=@"HH-mm-ss";
}

/**
 * 设置时间
 */
- (void)setTime
{
    NSLog(@"%s",__func__);
    NSArray*dateArray=[[self.dateFormat stringFromDate:[NSDate date]] componentsSeparatedByString:@"-"];
    self.timeLabel.text=[NSString stringWithFormat:@"%@:%@",[dateArray objectAtIndex:0],[dateArray objectAtIndex:1]];
    if (self.timeTimer && self.timeTimer.isValid) {
        [self.timeTimer invalidate];
        self.timeTimer=nil;
    }
    self.timeTimer = [NSTimer scheduledTimerWithTimeInterval:60-[[dateArray objectAtIndex:2] floatValue] target:self selector:@selector(setTime) userInfo:nil repeats:NO];
}


@end
