//
//  FriendDetail.m
//  QMKQ
//
//  Created by shangjin on 15/8/12.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "FriendDetail.h"
#import "Check.h"
#import "CheckResult.h"
#import "FirstVisit.h"
#import "FirstVisitResult.h"
#import "ReturnVisit.h"
#import "ReturnVisitResult.h"
#import "UserCaseConfig.h"
#import "config.h"
//cell
#import "FriendInfoCell.h"
#import "FriendHint.h"
#import "FriendCase.h"
#import "FriendYuyueCell.h"
#import "QMRequest.h"
#import "UIScrollView+ScrollMore.h"


#import <UIImageView+AFNetworking.h>

@interface FriendDetail () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDataDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *cBt;

@property (nonatomic, strong) NSMutableArray * caseArray;//病例
@property (nonatomic, strong) NSDictionary * appointment;//预约

@end

@implementation FriendDetail

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftButtonItem];
    self.title=@"用户详情";
    
    //tableView
    self.tableView.backgroundColor=BgColor;
    UIView*vi= [[UIView alloc]init];
    vi.backgroundColor=BgColor;
    self.tableView.tableFooterView=vi;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView addRefreshControl];
    self.tableView.addDataDelegate=self;
    
    //根据数据库加载本地病例，同时网络请求，以求更新
    if ([self.patient.recordDetails isKindOfClass:[NSArray class]] && self.patient.recordDetails) {
        self.caseArray = [NSMutableArray arrayWithArray:self.patient.recordDetails];
        [self.tableView reloadData];
    }else {
        self.caseArray = [NSMutableArray array];
    }
    
    [self addDataForUpdate];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addDataForUpdate];
}

- (void)addDataForUpdate
{
    // 获取病人预约接口,留下接口
    self.appointment=@{};
    
    [self requestPatients];
    [self requestCases];
}

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


- (void)requestPatients
{
    [[[QMRequest alloc]init] startWithPackage:@{@"userId":self.patient.userId} post:NO apiType:GetUserInfo completion:^(BOOL success, NSError *error, NSDictionary *result) {
        if (success) {
            Patient*patient = [[Patient alloc]init];
            [patient updateDataFromDictionary:[result objectForKey:@"data"]];
            if ([patient.userId intValue] > 0) {
                self.patient = patient;
                [patient updateDataForTableName:PatientInfoStoreKey sqlString:nil result:nil];
            }
        }
    }];
}

- (void)requestCases
{
    [[[QMRequest alloc]init] startWithPackage:@{@"userId":self.patient.userId} post:NO apiType:UserCaseList completion:^(BOOL success, NSError *error, NSDictionary *result) {
        if (success && [[result objectForKey:@"code"] intValue] == 1000) {
        }else {
            ALERT1(@"网络错误，不能请求病例");
        }
        if (result.count>0 && success) {
            NSArray*list = [result objectForKey:@"data"];
            if (list.count>0) {
                self.caseArray = [NSMutableArray arrayWithArray:list];
                self.patient.recordDetails = list;
                [self.patient updateDataForTableName:PatientInfoStoreKey sqlString:nil result:nil];
            }
        }
        if (self.tableView.refreshControl.isRefreshing) {
            [self.tableView.refreshControl endRefreshing];
        }
        [self.tableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger more = 0;
    if (self.caseArray.count>0) {
        more = 1;
    }
    //如果有预约，则需要某种排序
    if (self.appointment.count>0) {
        more += 2;
    }
    return 1+more+self.caseArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = CellDefaultHeight;
    if (indexPath.row == 0) {
        height = 100.0f;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifierString=@"";
    NSInteger row = indexPath.row;
    
    NSInteger t = 0;
    if (self.appointment.count>0) {
        t=row;
        if (row >=5) {
            t=5;
        }
    }else {
        if (row == 1) {
            t=4;
        }else if (row >= 2) {
            t=5;
        }
    }
    
    UITableViewCell*cell = nil;
    if (t == 0) {
        identifierString = @"FriendInfoCell";
        FriendInfoCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
        [cel.imgView setImageWithURL:[NSURL URLWithString:self.patient.headFile] placeholderImage:[UIImage imageNamed:@"tx"]];
        cel.nameLabel.text = self.patient.name;
        cel.infoLabel.text = [self.patient.gender intValue]==0?@"男":@"女";
        cel.birthLabel.text = [NSString stringWithFormat:@"%@.%@.%@",self.patient.year,self.patient.month,self.patient.day];
        cel.heightLabel.text = [NSString stringWithFormat:@"%@cm",self.patient.height];
        cel.weightLabel.text = [NSString stringWithFormat:@"%@kg",self.patient.weight];
        cell = cel;
    }else if (t == 1) {
        identifierString = @"FriendHint";
        FriendHint*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
        cel.hintLabel.text = @"最新预约";
        cel.hintImg.image=[UIImage imageNamed:@"zxyyicon"];
        cell = cel;
    }else if (t == 2) {
        identifierString = @"FriendYuyueCell";
        FriendYuyueCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
        cel.dateLabel.text = @"2015.09.26";
        cel.weekLabel.text = @"周五";
        cel.timeLabel.text = @"13：20";
        cel.caseDetailLabel.text = @"初诊";
        cel.caseCountLabel.text = @"第32周";
        cell = cel;
    }else if (t == 3) {
        identifierString = @"FriendSeparatorCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifierString];
    }else if (t == 4) {
        identifierString = @"FriendHint";
        FriendHint*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
        cel.hintLabel.text = @"就诊情况";
        cel.hintImg.image=[UIImage imageNamed:@"jzqkicon"];
        cell = cel;
    }else if (t == 5) {
        identifierString = @"FriendCase";
        FriendCase*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
        NSInteger m = 2;
        if (self.appointment.count>0) {
            m=5;
        }
        NSDictionary*ca = [self.caseArray objectAtIndex:indexPath.row-m];
//        cel.leftLabel.text = @"2014.12.26/初诊检查";
        NSString*type=@"";
        switch ([[ca objectForKey:@"record_type"] intValue]) {
            case 0:
                type=@"初次检查";
                break;
            case 1:
                type=@"初诊";
                break;
            case 2:
                type=@"复诊";
                break;
                
            default:
                break;
        }
        cel.leftLabel.text = [NSString stringWithFormat:@"%@/%@",SafeValue([ca objectForKey:@"create_time"],@""),type];
        cel.rightLabel.text = @"详情病例";
        cell = cel;
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger t = 0;
    if (self.appointment.count>0) {
        t=row;
        if (row >=5) {
            t=5;
        }
    }else {
        if (row == 1) {
            t=4;
        }else if (row >= 2) {
            t=5;
        }
    }
    if (t == 2) {
        //预约
    }else if (t == 5) {
        //病例详情
        NSInteger m = 2;
        if (self.appointment.count>0) {
            m=5;
        }
        NSDictionary*ca = [self.caseArray objectAtIndex:indexPath.row-m];
        
        id resultOri = SafeValue([ca objectForKey:@"record_detail"], @"");
        NSDictionary* result = [resultOri isKindOfClass:[NSDictionary class]]?resultOri:[self dictionaryWithJsonString:resultOri];
        
        UIViewController*controller=nil;
        switch ([[ca objectForKey:@"record_type"] intValue]) {
            case 0:
            {
                CheckResult*vc=ViewControllerFromStoryboardWithIdentifier(@"CheckResult");
                vc.caseResult=result?result:@{};
                vc.patient=self.patient;
                controller=vc;
            }
                break;
            case 1:
            {
                FirstVisitResult*vc=ViewControllerFromStoryboardWithIdentifier(@"FirstVisitResult");
                vc.caseResult=result?result:@{};
                vc.patient=self.patient;
                controller=vc;
            }
                break;
            case 2:
            {
                ReturnVisitResult*vc=ViewControllerFromStoryboardWithIdentifier(@"ReturnVisitResult");
                vc.caseResult=result?result:@{};
                vc.patient=self.patient;
                controller=vc;
            }
                break;
                
            default:
                break;
        }
        if (controller) {
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}


- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (IBAction)addACase:(UIButton*)sender {
    sender.enabled=NO;
    [[[QMRequest alloc] init] startWithPackage:@{@"userId":self.patient.userId} post:NO apiType:PatientRecordStatus completion:^(BOOL success, NSError *error, NSDictionary *result) {
        sender.enabled=YES;
        if (success == YES && [[result objectForKey:@"code"] intValue] == 1000) {
            NSInteger type = [[[result objectForKey:@"data"] objectForKey:@"type"] intValue];
            if (type==1) {
                //初诊病例
                FirstVisit*vc=ViewControllerFromStoryboardWithIdentifier(@"FirstVisit");
                vc.patient=self.patient;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (type == 2 ) {
                //复诊病例
                ReturnVisit*vc=ViewControllerFromStoryboardWithIdentifier(@"ReturnVisit");
                vc.patient=self.patient;
                [self.navigationController pushViewController:vc animated:YES];
            }else if (type == 0){
                //初诊检查
                Check*vc=ViewControllerFromStoryboardWithIdentifier(@"Check");
                vc.patient=self.patient;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else {
            ALERT1(@"网络错误");
        }
    }];
}



@end
