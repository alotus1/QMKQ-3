//
//  MyHome.m
//  QMKQ
//
//  Created by shangjin on 15/8/1.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "MyHome.h"
#import "MyInfo.h"
#import "MHDoctorInfoCell.h"
#import "MHDoctorDescCell.h"
#import "MHDoctorUserComCell.h"
#import "config.h"
#import "Doctor.h"
#import "QMRequest.h"
#import <UIImageView+AFNetworking.h>
#import "UIScrollView+ScrollMore.h"
#import "AppDelegate.h"
#import "Setting.h"



@interface MyHome () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDataDelegate>
{
    BOOL isEnd;
    int start;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * moreCells;

@property (nonatomic, strong) NSMutableArray * comments;
@property (nonatomic, strong) Doctor * myself;

@end

@implementation MyHome

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)setAPPAction:(UIButton*)bt
{
    UIViewController * vc = ViewControllerFromStoryboardWithIdentifier(@"Setting");
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"个人主页";
    
    //右按钮
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton setTitle:@"设置" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:0];
    [rightButton addTarget:self action:@selector(setAPPAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*right = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=right;
    
    //初始化
    self.moreCells=[NSMutableArray array];
    self.comments=[NSMutableArray array];
    
    // tableView设置
    self.tableView.backgroundColor=BgColor;
    UIView*footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.tabBarController.tabBar.frame.size.height)];
    footView.backgroundColor=self.tableView.backgroundColor;
    self.tableView.tableFooterView=footView;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView addRefreshControl];
    self.tableView.addDataDelegate=self;
    
    //数据加载
    AppDelegate*app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ([app.myself.doctorId intValue]>0) {
        self.myself=app.myself;
    }else {
        //同步,从本地存储获取
        [Doctor selectTableWithName:MyInfoStoreKey sqlString:nil result:^(HandleState state, NSArray *results) {
            if (state == HandleStateSuccess) {
                app.myself = [results lastObject];
                self.myself=app.myself;
                //重新请求评论
                [self addDataForUpdate];
            }
        }];
    }
    //请求评论数据
    [self addDataForUpdate];
}

- (void)gentxinDoctor
{
    //更新数据
    [[[QMRequest alloc]init] startWithPackage:@{@"doctorId":self.myself.doctorId} post:NO apiType:GetMyInfo completion:^(BOOL success, NSError *error, NSDictionary *result) {
        if ([[result objectForKey:@"code"] integerValue] == 1000 && success) {
            [self.myself updateDataFromDictionary:[result objectForKey:@"data"]];
            [self.myself updateDataForTableName:MyInfoStoreKey sqlString:nil result:nil];
            AppDelegate*app = (AppDelegate*)[UIApplication sharedApplication].delegate;
            app.myself = self.myself;
            [self.tableView reloadData];
        }
    }];
}


/**
 * 更新
 */
- (void)addDataForAddNew
{
    if (!isEnd) {
        start += start;
        [self requestComments];
    }
}

- (void)addDataForUpdate
{
    isEnd = NO;
    start = 0;
    [self.comments removeAllObjects];
    [self addDataForAddNew];
    [self gentxinDoctor];
}
/**
 * 根据滑动状态判断是否要更新还是要添加
 *
 * @param scrollView 使用scrollView的代理
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.tableView checkToUpdateDataWillBeginDragging];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.tableView checkToUpdateDataWillBeginDecelerating];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.tableView checkToUpdateDataDidEndDragging];
}
/**
 * 请求数据
 */
- (void)requestComments
{
    QMRequest*request = [[QMRequest alloc]init];
    request.type=GetUserCommentList;
    request.post=NO;
    [request startWithPackage:@{@"start":[NSString stringWithFormat:@"%d",start],@"doctorId":self.myself.doctorId,@"max":[NSString stringWithFormat:@"%d",PerRequestCount]} completion:^(BOOL success, NSError *error, NSDictionary *result) {
        if (success) {
            NSArray* array = [result objectForKey:@"data"];
            if (array.count<PerRequestCount) {
                isEnd=YES;
            }
            if (array.count>0) {
                [self.comments addObjectsFromArray:array];
                [self.tableView reloadData];
            }
        }
        if (self.tableView.refreshControl.isRefreshing) {
            [self.tableView.refreshControl endRefreshing];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger mo = 0;
    if (self.comments.count>0) {
        mo = 2;
    }
    return 2+self.comments.count+mo;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    switch (indexPath.row) {
        case 0:
            height = 110;
            break;
        case 1:
        {
            // height = 150;
            BOOL hav = NO;
            for (NSIndexPath*inx in self.moreCells) {
                if (inx.row== indexPath.row) {
                    hav=YES;
                    break;
                }
            }
            if (hav) {
                //被打开
                UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-50, 1000)];
                label.numberOfLines=0;
                label.text = self.myself.desc;
                label.font = [UIFont systemFontOfSize:17.0f];
                CGRect r = [label textRectForBounds:label.bounds limitedToNumberOfLines:0];
                height = r.size.height + 90;
            }else {
                //未被打开
                UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-50, 1000)];
                label.numberOfLines=0;
                label.text = self.myself.desc;
                label.font = [UIFont systemFontOfSize:17.0f];
                CGRect r = [label textRectForBounds:label.bounds limitedToNumberOfLines:0];
                if (r.size.height > 70) {
                    height = 150;
                }else {
                    height = r.size.height + 90;
                }
            }
        }
            break;
        case 2:
            height = 5;
            break;
        case 3:
            height = 44;
            break;
            
        default:
        {
            // height = 95;
            
            BOOL hav = NO;
            for (NSIndexPath*inx in self.moreCells) {
                if (inx.row== indexPath.row) {
                    hav=YES;
                    break;
                }
            }
            if (hav) {
                UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-95, 1000)];
                label.numberOfLines=0;
                label.font = [UIFont systemFontOfSize:17.0f];
                label.text = [[self.comments objectAtIndex:indexPath.row-4] objectForKey:@"commentDetail"];
                CGRect r = [label textRectForBounds:label.bounds limitedToNumberOfLines:0];
                height = r.size.height + 70;
            }else {
                NSString * text = [[self.comments objectAtIndex:indexPath.row-4] objectForKey:@"commentDetail"];
                if (text.length<=0) {
                    height = 60;
                    break;
                }else {
                    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-95, 1000)];
                    label.numberOfLines=0;
                    label.font = [UIFont systemFontOfSize:17.0f];
                    label.text = text;
                    CGRect r = [label textRectForBounds:label.bounds limitedToNumberOfLines:0];
                    if (r.size.height > 25) {
                        height = 110;
                    }else {
                        height = r.size.height + 70;
                    }
                }
            }
        }
            break;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell=nil;
    if (indexPath.row==0) {
        MHDoctorInfoCell*c=[tableView dequeueReusableCellWithIdentifier:@"MHDoctorInfoCell"];
        c.doctorImgView.userInteractionEnabled=YES;
        [c.doctorImgView setImageWithURL:[NSURL URLWithString:self.myself.headFileUrl] placeholderImage:[UIImage imageNamed:@"tx"]];
        c.nameLabel.text=[NSString stringWithFormat:@"%@ %@",self.myself.name,self.myself.professionalTitle];
        [c.nameLabel sizeToFit];
        c.doctorImgView.backgroundColor=[UIColor orangeColor];
        c.doctorImgView.layer.cornerRadius=5.0f;
        c.shortDesc.text=[NSString stringWithFormat:@"已治疗%d位儿",[self.myself.doctorPatient intValue]];
        c.clinicLabel.text=[NSString stringWithFormat:@"%@%@口腔门诊部",[self.myself.cityId intValue]==110000?@"北京":@"成都",SafeValue(self.myself.hospital,@"")];
        c.startLevelImgView.startCount=[self.myself.doctorStar intValue]>5?5:[self.myself.doctorStar intValue];
        
        cell = c;
    }else if (indexPath.row == 1) {
        MHDoctorDescCell*c=[tableView dequeueReusableCellWithIdentifier:@"MHDoctorDescCell"];
        //因为cell重用
        c.arrowButton.enabled=YES;
        c.arrowButton.hidden=NO;
        c.arrowImgView.hidden=NO;
        c.descToBottom.constant=30;
        
        //添加数据
        c.descLabel.text = self.myself.desc;
        [c.arrowButton setImageEdgeInsets:UIEdgeInsetsMake(10, 8, 10, 8)];
        //是否打开
        BOOL hav = NO;
        for (NSIndexPath*inx in self.moreCells) {
            if (inx.row== indexPath.row) {
                hav=YES;
                break;
            }
        }
        if (!hav) {
            //如果没打开状态，如果小于3行，说明不能打开
            UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth-50, c.descLabel.frame.size.height+50)];
            label.numberOfLines=0;
            label.text = c.descLabel.text;
            label.font = [UIFont systemFontOfSize:17.0f];
            CGRect r = [label textRectForBounds:label.bounds limitedToNumberOfLines:0];
            c.arrowImgView.image = [UIImage imageNamed:@"v1"];
            if (r.size.height> 60) {//多于3行
                c.arrowButton.enabled=YES;
                c.arrowButton.hidden=NO;
                c.arrowImgView.hidden=NO;
                c.descToBottom.constant=30;
            }else {
                c.arrowButton.enabled=NO;
                c.arrowButton.hidden=YES;
                c.arrowImgView.hidden=YES;
                c.descToBottom.constant=5;
            }
        }else{
            c.arrowImgView.image = [UIImage imageNamed:@"v4"];
        }
        cell = c;
    }else if (indexPath.row == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MHSeparateCell"];
        cell.backgroundColor=RGBACOLOR(245, 243, 244, 255);
    }else if (indexPath.row == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MHComHintCell"];
        if (![cell viewWithTag:1000]) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(25, 43.5, ScreenWidth-50, 0.5)];
            line.tag = 1000;
            line.backgroundColor=LineColor;
            [cell addSubview:line];
        }
    }else if (indexPath.row >= 4) {
        MHDoctorUserComCell*comment =[tableView dequeueReusableCellWithIdentifier:@"MHDoctorUserComCell"];
        //因为cell重用的问题，必须初始化全部
        comment.arrowButton.enabled=YES;
        comment.arrowButton.hidden=NO;
        comment.arrowImgView.hidden=NO;
        comment.messageToBottom.constant=30;
        comment.userImgView.image=nil;
        
        NSDictionary*com=[self.comments objectAtIndex:indexPath.row-4];
        
        [comment.userImgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[com objectForKey:@"userPic"]]] placeholderImage:[UIImage imageNamed:@"tx2"]];
        comment.userNameLabel.text = [NSString stringWithFormat:@"%@",[com objectForKey:@"userName"]];
        NSDateFormatter*format = [[NSDateFormatter alloc]init];
        format.dateFormat=@"yyyy-MM-dd HH:mm:ss";
        NSDate * date = [format dateFromString:[com objectForKey:@"commentTime"]];
        NSDateFormatter*format1 = [[NSDateFormatter alloc]init];
        format1.dateFormat=@"yyyy.MM.dd";
        NSString * time = [format1 stringFromDate:date];
        comment.timeLabel.text = time;
        comment.hintImgView.image = [UIImage imageNamed:@"new"];
        if ([time isEqualToString:[format1 stringFromDate:[NSDate date]]]) {
            comment.hintImgView.hidden=NO;
        }else {
            comment.hintImgView.hidden=YES;
        }
        comment.messageLabel.text = [com objectForKey:@"commentDetail"];
        
        
        //线
        if (![comment viewWithTag:1000]) {
            UIImageView * line = [[UIImageView alloc]init];
            line.tag = 1000;
            line.image=[UIImage imageNamed:@"_--"];
            [comment addSubview:line];
        }
        UIView*line = [comment viewWithTag:1000];
        CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
        line.frame = CGRectMake(25, height - 0.5, ScreenWidth-50, 0.5);
        line.hidden=NO;
        if (indexPath.row-4 == self.comments.count-1) {
            line.hidden=YES;
        }
        BOOL hav = NO;
        for (NSIndexPath*inx in self.moreCells) {
            if (inx.row== indexPath.row) {
                hav=YES;
                break;
            }
        }
        if (!hav) {
            //如果没打开状态，如果小于2行，说明不能打开
            UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-95, comment.messageLabel.frame.size.height+50)];
            label.numberOfLines=0;
            label.text = comment.messageLabel.text;
            label.font = [UIFont systemFontOfSize:17.0f];
            CGRect r = [label textRectForBounds:label.bounds limitedToNumberOfLines:0];
            comment.arrowImgView.image = [UIImage imageNamed:@"v1"];
            if (r.size.height>25) {//多于2行
                comment.arrowButton.enabled=YES;
                comment.arrowButton.hidden=NO;
                comment.arrowImgView.hidden=NO;
                comment.messageToBottom.constant=30;
            }else {
                comment.arrowButton.enabled=NO;
                comment.arrowButton.hidden=YES;
                comment.arrowImgView.hidden=YES;
                comment.messageToBottom.constant=0;
            }
        }else {
            comment.arrowImgView.image = [UIImage imageNamed:@"v4"];
        }
        cell = comment;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (IBAction)showMyInfo:(id)sender {
    MyInfo*myInfo=ViewControllerFromStoryboardWithIdentifier(@"MyInfo");
    myInfo.hidesBottomBarWhenPushed=YES;
    myInfo.my=self.myself;
    [self.navigationController pushViewController:myInfo animated:YES];
}
//显示更多
- (IBAction)moreInfoAction:(UIButton*)sender {
    CGPoint p = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath*indexPath = [self.tableView indexPathForRowAtPoint:p];
    BOOL hav = NO;
    for (NSInteger i = 0; i < self.moreCells.count; i++) {
        NSIndexPath*inx=[self.moreCells objectAtIndex:i];
        if (inx.row== indexPath.row) {
            [self.moreCells removeObjectAtIndex:i];
            hav=YES;
            break;
        }
    }
    if (!hav) {
        [self.moreCells addObject:indexPath];
    }
    [self.tableView reloadData];
}


@end
