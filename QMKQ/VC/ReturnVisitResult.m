//
//  ReturnVisitResult.m
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "ReturnVisitResult.h"
#import "UCNameCell.h"
#import "LeftRightLabelCell.h"
#import "DocAdviceLabelCell.h"
#import "GetImageCell.h"
#import "LeftLeftLabelCell.h"
#import "UserCaseConfig.h"
#import <UIImageView+AFNetworking.h>
#import "config.h"
#import "CaseHeaderView.h"
#import "Tools.h"
#import <IDMPhotoBrowser.h>

@interface ReturnVisitResult () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSDictionary * tooth;
@end

@implementation ReturnVisitResult

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftButtonItem];
    // Do any additional setup after loading the view.
    
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.backgroundColor=BgColor;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    
    self.tooth=@{@"0":[NSMutableArray array],
                 @"1":[NSMutableArray array],
                 @"2":[NSMutableArray array],
                 @"3":[NSMutableArray array],
                 @"4":[NSMutableArray array],
                 @"5":[NSMutableArray array],
                 @"6":[NSMutableArray array],
                 @"7":[NSMutableArray array]};
    if ([self.caseResult isKindOfClass:[NSDictionary class]]) {
        for (NSDictionary*dic in [self.caseResult objectForKey:@"toothStatusList"]) {
            NSString*st=[dic objectForKey:@"status"];
            NSArray*status=[st componentsSeparatedByString:@","];
            for (NSInteger i = 0; i<status.count; i++) {
                NSString*s=[NSString stringWithFormat:@"%@",[status objectAtIndex:i]];
                NSMutableArray*arr=[self.tooth objectForKey:s];
                [arr addObject:[dic objectForKey:@"toothIndex"]];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) return 0;
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = @"";
    if (section == 0) return nil ;
    else if (section == 1) title = @"佩戴基本状况:";
    else if (section == 2) title = @"口腔基本状况:";
    else if (section == 3) title = @"咬颌评估:";
    else if (section == 4) title = @"照片:";
    CaseHeaderView*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"returnVisitResultHeader"];
    if (!view) {
        view = [[CaseHeaderView alloc]initWithReuseIdentifier:@"returnVisitResultHeader"];
    }
    view.textLabel.text = title;
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if (section == 0) number = 1;
    else if (section == 1) number = 8;
    else if (section == 2) number = 9;
    else if (section == 3) number = 14;
    else if (section == 4) number = 6;
    return number;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = CellDefaultHeight;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 4) {
        if (row < 4) height = GetImageCellHeight;
        else if (row == 4)
        {
            height = DocAdviceLabelCellHeight;
            
            UILabel*label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-50, 1000)];
            label.text = SafeValue([self.caseResult objectForKey:@"doctor_suggest"], @"");
            label.numberOfLines=0;
            CGRect r = [label textRectForBounds:label.bounds limitedToNumberOfLines:0];
            if (r.size.height > DocAdviceLabelCellHeight) {
                height = r.size.height;
            }
        }
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString * identifierString = @"temp";
    
    
    UITableViewCell*cell = nil;
    if (section == 0) {
        identifierString = @"UCNameCell";
        UCNameCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
        cel.name.text = self.patient.name;
//        cel.other.text = @"| 女 | 2005.8.7";
        cel.other.text = [NSString stringWithFormat:@"| %@ | %@.%@.%@",[self.patient.gender intValue]?@"女":@"男",self.patient.year,self.patient.month,self.patient.day];
        cell = cel;
    }else if (section == 1) {
            identifierString = @"LeftRightLabelCell";
            LeftRightLabelCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
        NSDictionary*dic=[self.caseResult objectForKey:@"wear_check"];
            switch (row) {
                case 0: {
                    cel.left.text = [[dic objectForKey:@"zhengYePeiDai"] boolValue]?@"整夜佩戴":@"不是整夜佩戴";
                    cel.right.text = @"";
                }break;
                case 1: {
                    cel.left.text = [NSString stringWithFormat:@"%@开始佩戴",SafeValue([dic objectForKey:@"peiDaiShiJian"],@"")];
                    cel.right.text = @"";
                }break;
                case 2: {
                    cel.left.text = [dic objectForKey:@"peiDaiShiJianProblem_first"];
                    cel.right.text = @"";
                }break;
                case 3: {
                    cel.left.text = [dic objectForKey:@"peiDaiShiJianProblem_now"];
                    cel.right.text = @"";
                }break;
                case 4: {
                    cel.left.text = [dic objectForKey:@"peiDaiShiJianProblem_check"];
                    cel.right.text = @"";
                }break;
                case 5: {
                    cel.left.text = [[dic objectForKey:@"youDaoQi"] boolValue]?@"诱导器现阶段合适":@"诱导器现阶段不合适";
                    cel.right.text = @"";
                }break;
                case 6: {
                    cel.left.text = [[dic objectForKey:@"youDaoQiGengHuan"] boolValue]?@"需更换诱导器":@"不需更换诱导器";
                    cel.right.text = @"";
                }break;
                case 7: {
                    cel.left.text = [[dic objectForKey:@"youDaoQiQingLi"] boolValue]?@"诱导器需深层清洁":@"诱导器不需深层清洁";
                    cel.right.text = @"";
                }break;
                    
                default:
                    break;
            }
            cell = cel;
    }else if (section == 2) {
        if (row <= 8) {
            identifierString = @"LeftRightLabelCell";
            LeftRightLabelCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            switch (row) {
                case 0: {
                    cel.left.text = @"磨牙关系";
                    NSDictionary*dic=[self.caseResult objectForKey:@"moYaGuanxi"];
                    
                    NSInteger t = [[dic objectForKey:@"left"] intValue];
                    NSInteger m = [[dic objectForKey:@"right"] intValue];
                    NSString*lef=@"无法分类";
                    NSString*rig=@"无法分类";
                    if (t == 0) {
                        lef = @"中性";
                    }else if (t==1) {
                        lef = @"远中";
                    }else {
                        lef = @"近中";
                    }
                    if (m == 0) {
                        rig = @"中性";
                    }else if (m==1) {
                        rig = @"远中";
                    }else {
                        rig = @"近中";
                    }
                    cel.right.text = [NSString stringWithFormat:@"左:%@/右:%@",lef,rig];
                }break;
                case 1: {
                    cel.left.text = @"乳牙龋牙";
                    cel.right.text = [[self.tooth objectForKey:@"0"] componentsJoinedByString:@" "];
                }break;
                case 2: {
                    cel.left.text = @"外翻";
                    cel.right.text = [[self.tooth objectForKey:@"1"] componentsJoinedByString:@" "];
                }break;
                case 3: {
                    cel.left.text = @"早失牙";
                    cel.right.text = [[self.tooth objectForKey:@"2"] componentsJoinedByString:@" "];
                }break;
                case 4: {
                    cel.left.text = @"多生牙";
                    cel.right.text = [[self.tooth objectForKey:@"3"] componentsJoinedByString:@" "];
                }break;
                case 5: {
                    cel.left.text = @"滞留";
                    cel.right.text = [[self.tooth objectForKey:@"4"] componentsJoinedByString:@" "];
                }break;
                case 6: {
                    cel.left.text = @"发育不能";
                    cel.right.text = [[self.tooth objectForKey:@"5"] componentsJoinedByString:@" "];
                }break;
                case 7: {
                    cel.left.text = @"内翻";
                    cel.right.text = [[self.tooth objectForKey:@"6"] componentsJoinedByString:@" "];
                }break;
                case 8: {
                    cel.left.text = @"先天缺失";
                    cel.right.text = [[self.tooth objectForKey:@"7"] componentsJoinedByString:@" "];
                }break;
                    
                default:
                    break;
            }
            cell = cel;
        }
    }else if (section == 3) {
        if (row <= 13) {
            identifierString = @"LeftRightLabelCell";
            LeftRightLabelCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            switch (row) {
                case 0: {
                    cel.left.text = @"颌类型";
                    if ([self.caseResult objectForKey:@"heLeixing"]) {
                        NSInteger t = [[self.caseResult objectForKey:@"heLeixing"] intValue];
                        if (t == 0) {
                            cel.right.text = @"乳";
                        }else if (t==1) {
                            cel.right.text = @"恒";
                        }else {
                            cel.right.text = @"替";
                        }
                    }
                }break;
                case 1: {
                    cel.left.text = @"反颌";
                    cel.right.text = [[self.caseResult objectForKey:@"fanHe"] boolValue]?@"是":@"否";
                }break;
                case 2: {
                    cel.left.text = @"下颌后退";
                    cel.right.text = [[self.caseResult objectForKey:@"xiaHeHouTui"] boolValue]?@"是":@"否";
                }break;
                case 3: {
                    cel.left.text = @"上颌尖牙高位萌出";
                    NSString * text = @"正常";
                    NSInteger sw = [[self.caseResult objectForKey:@"shangHeJianYa"] intValue];
                    if (sw == 1) {
                        text = @"左侧";
                    }else if (sw == 2) {
                        text = @"右侧";
                    }
                    cel.right.text = text;
                }break;
                case 4: {
                    cel.left.text = @"唇颊向";
                    cel.right.text = [[self.caseResult objectForKey:@"chunJiaXiang"] boolValue]?@"是":@"否";
                }break;
                case 5: {
                    cel.left.text = @"舌颚向";
                    cel.right.text = [[self.caseResult objectForKey:@"sheEXiang"] boolValue]?@"是":@"否";
                }break;
                case 6: {
                    cel.left.text = @"开颌";
                    cel.right.text = [[self.caseResult objectForKey:@"kaiHe"] boolValue]?@"是":@"否";
                }break;
                case 7: {
                    cel.left.text = @"拥挤";
                    cel.right.text = [[self.caseResult objectForKey:@"yongJi"] boolValue]?@"是":@"否";
                }break;
                case 8: {
                    cel.left.text = @"锁颌";
                    cel.right.text = [[self.caseResult objectForKey:@"suoHe"] boolValue]?@"是":@"否";
                }break;
                case 9: {
                    cel.left.text = @"前牙覆颌关系";
                    NSDictionary* dic = [self.caseResult objectForKey:@"qianYaFuHeGuanXi"];
                    if ([dic objectForKey:@"level"]) {
                        cel.right.text = [NSString stringWithFormat:@"%@度/%@mm",SafeValue([dic objectForKey:@"level"],@""),SafeValue([dic objectForKey:@"margin"], @"")];
                    }
                    
                }break;
                case 10: {
                    cel.left.text = @"前牙覆盖关系";
                    NSDictionary* dic = [self.caseResult objectForKey:@"qianYaFuGaiGuanXi"];
                    if ([dic objectForKey:@"level"]) {
                        cel.right.text = [NSString stringWithFormat:@"%@度/%@mm",SafeValue([dic objectForKey:@"level"],@""),SafeValue([dic objectForKey:@"margin"], @"")];
                    }
                }break;
                case 11: {
                    cel.left.text = @"前牙开颌";
                    NSDictionary* dic = [self.caseResult objectForKey:@"qianYaKaiHe"];
                    if ([dic objectForKey:@"level"]) {
                        cel.right.text = [NSString stringWithFormat:@"%@度/%@mm",SafeValue([dic objectForKey:@"level"],@""),SafeValue([dic objectForKey:@"margin"], @"")];
                    }
                }break;
                case 12: {
                    cel.left.text = @"牙齿排列拥挤";
                    NSDictionary*dic=[self.caseResult objectForKey:@"yaChiPaiLieYongJi"];
                    NSDictionary*top=[dic objectForKey:@"top"];
                    NSDictionary*bottom=[dic objectForKey:@"bottom"];
                    NSString*str=@"";
                    int to = [[top objectForKey:@"level"] intValue];
                    int bo = [[bottom objectForKey:@"level"] intValue];
                    if (to!=0) {
                        str = [str stringByAppendingString:[NSString stringWithFormat:@"上:%d级%@mm",[[top objectForKey:@"level"] intValue],SafeValue([top objectForKey:@"margin"],@"")]];
                    }
                    if (bo!=0) {
                        if (str.length>0) {
                            str = [str stringByAppendingString:@"/"];
                        }
                        str = [str stringByAppendingString:[NSString stringWithFormat:@"下:%d级%@mm",[[bottom objectForKey:@"level"] intValue],SafeValue([bottom objectForKey:@"margin"],@"")]];
                    }
                    cel.right.text = str;
                }break;
                case 13: {
                    cel.left.text = @"中线";
                    NSDictionary*dic=[self.caseResult objectForKey:@"zhongXian"];
                    NSDictionary*top=[dic objectForKey:@"top"];
                    NSDictionary*bottom=[dic objectForKey:@"bottom"];
                    NSString*str=@"";
                    int to = [[top objectForKey:@"orientation"] intValue];
                    int bo = [[bottom objectForKey:@"orientation"] intValue];
                    if (to!=0) {
                        if (to == 1) {
                            str = [str stringByAppendingString:[NSString stringWithFormat:@"上偏左%@mm",SafeValue([top objectForKey:@"margin"],@"")]];
                        }else {
                            str = [str stringByAppendingString:[NSString stringWithFormat:@"上偏右%@mm",SafeValue([top objectForKey:@"margin"],@"")]];
                        }
                    }
                    if (bo!=0) {
                        if (str.length>0) {
                            str = [str stringByAppendingString:@"/"];
                        }
                        if (bo == 1) {
                            str = [str stringByAppendingString:[NSString stringWithFormat:@"下偏左%@mm",SafeValue([bottom objectForKey:@"margin"],@"")]];
                        }else {
                            str = [str stringByAppendingString:[NSString stringWithFormat:@"下偏右%@mm",SafeValue([bottom objectForKey:@"margin"],@"")]];
                        }
                    }
                    cel.right.text = str;
                }break;
                    
                default:
                    break;
            }
            cell = cel;
        }
    }else if (section == 4) {
        if (row == 0) {
            identifierString = @"GetImageCell";
            GetImageCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.title.text = @"正面像/侧面像/微笑像";
            cel.lastImgView.hidden=YES;
            NSDictionary*dic = [self.caseResult objectForKey:@"touXiangPicUrl"];
            [cel.firstImgView setImageWithURL:[NSURL URLWithString:[Tools imageFromString:[dic objectForKey:@"zhengMianXiang"] withSuffix:@"_small"]] placeholderImage:[UIImage imageNamed:@"zp"]];
            [cel.secondImgView setImageWithURL:[NSURL URLWithString:[Tools imageFromString:[dic objectForKey:@"ceMianXiang"] withSuffix:@"_small"]] placeholderImage:[UIImage imageNamed:@"zp"]];
            [cel.thirdImgView setImageWithURL:[NSURL URLWithString:[Tools imageFromString:[dic objectForKey:@"weiXiaoXiang"] withSuffix:@"_small"]] placeholderImage:[UIImage imageNamed:@"zp"]];
            cel.firstImgView.tag = 100;
            cel.secondImgView.tag = 101;
            cel.thirdImgView.tag = 102;
            [cel.firstImgView addImageGestureTarget:self andAction:@selector(showImageGroup:)];
            [cel.secondImgView addImageGestureTarget:self andAction:@selector(showImageGroup:)];
            [cel.thirdImgView addImageGestureTarget:self andAction:@selector(showImageGroup:)];
            cell = cel;
        }else if (row == 1) {
            identifierString = @"GetImageCell";
            GetImageCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.title.text = @"正面口内像/侧位像";
            cel.thirdImgView.hidden=YES;
            cel.lastImgView.hidden=YES;
            NSDictionary*dic = [self.caseResult objectForKey:@"zhengMianKouNeiPicUrl"];
            [cel.firstImgView setImageWithURL:[NSURL URLWithString:[Tools imageFromString:[dic objectForKey:@"zhengMianKouNeiXiang"] withSuffix:@"_small"]] placeholderImage:[UIImage imageNamed:@"zp"]];
            [cel.secondImgView setImageWithURL:[NSURL URLWithString:[Tools imageFromString:[dic objectForKey:@"ceWeiXiang"] withSuffix:@"_small"]] placeholderImage:[UIImage imageNamed:@"zp"]];
            cel.firstImgView.tag = 200;
            cel.secondImgView.tag = 201;
            [cel.firstImgView addImageGestureTarget:self andAction:@selector(showImageGroup:)];
            [cel.secondImgView addImageGestureTarget:self andAction:@selector(showImageGroup:)];
            cell = cel;
        }else if (row == 2) {
            identifierString = @"GetImageCell";
            GetImageCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.title.text = @"上颌位像/下颌位像";
            cel.thirdImgView.hidden=YES;
            cel.lastImgView.hidden=YES;
            NSDictionary*dic = [self.caseResult objectForKey:@"heWeiPicUrl"];
            [cel.firstImgView setImageWithURL:[NSURL URLWithString:[Tools imageFromString:[dic objectForKey:@"shangHeWeiXiang"] withSuffix:@"_small"]] placeholderImage:[UIImage imageNamed:@"zp"]];
            [cel.secondImgView setImageWithURL:[NSURL URLWithString:[Tools imageFromString:[dic objectForKey:@"xiaHeWeiXiang"] withSuffix:@"_small"]] placeholderImage:[UIImage imageNamed:@"zp"]];
            cel.firstImgView.tag = 300;
            cel.secondImgView.tag = 301;
            [cel.firstImgView addImageGestureTarget:self andAction:@selector(showImageGroup:)];
            [cel.secondImgView addImageGestureTarget:self andAction:@selector(showImageGroup:)];
            cell = cel;
        }else if (row == 3) {
            identifierString = @"GetImageCell";
            GetImageCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.title.text = @"X光片";
            NSDictionary*dic = [self.caseResult objectForKey:@"xRayPicUrl"];
            [cel.firstImgView setImageWithURL:[NSURL URLWithString:[Tools imageFromString:[dic objectForKey:@"xRayPicUrl0"] withSuffix:@"_small"]] placeholderImage:[UIImage imageNamed:@"zp"]];
            [cel.secondImgView setImageWithURL:[NSURL URLWithString:[Tools imageFromString:[dic objectForKey:@"xRayPicUrl1"] withSuffix:@"_small"]] placeholderImage:[UIImage imageNamed:@"zp"]];
            [cel.thirdImgView setImageWithURL:[NSURL URLWithString:[Tools imageFromString:[dic objectForKey:@"xRayPicUrl2"] withSuffix:@"_small"]] placeholderImage:[UIImage imageNamed:@"zp"]];
            [cel.lastImgView setImageWithURL:[NSURL URLWithString:[Tools imageFromString:[dic objectForKey:@"xRayPicUrl3"] withSuffix:@"_small"]] placeholderImage:[UIImage imageNamed:@"zp"]];
            cel.firstImgView.tag = 400;
            cel.secondImgView.tag = 401;
            cel.thirdImgView.tag = 402;
            cel.lastImgView.tag = 403;
            [cel.firstImgView addImageGestureTarget:self andAction:@selector(showImageGroup:)];
            [cel.secondImgView addImageGestureTarget:self andAction:@selector(showImageGroup:)];
            [cel.thirdImgView addImageGestureTarget:self andAction:@selector(showImageGroup:)];
            [cel.lastImgView addImageGestureTarget:self andAction:@selector(showImageGroup:)];
            cell = cel;
        }else if (row == 4) {
            identifierString = @"DocAdviceLabelCell";
            DocAdviceLabelCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.title.text = @"医生建议";
            cel.message.text = SafeValue([self.caseResult objectForKey:@"doctor_suggest"], @"");
            cell = cel;
        }else if (row == 5) {
            identifierString = @"LeftLeftLabelCell";
            LeftLeftLabelCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.left.text = @"诱导器佩戴时间";
            cel.right.text = SafeValue([self.caseResult objectForKey:@"wear_time"], @"");
            cell = cel;
        }
    }
    if (row%2 == 1) {
        if (section == 4) {
            cell.contentView.backgroundColor=[UIColor whiteColor];
        }else {
            cell.contentView.backgroundColor=UIColorFromRGB16(0xfaf9f9);
        }
    }else {
        cell.contentView.backgroundColor=[UIColor whiteColor];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)showImageGroup:(UITapGestureRecognizer*)gesture
{
    NSInteger integer = gesture.view.tag;
    NSInteger section = integer/100;
    NSInteger item = integer - section*100;
    NSInteger position = 0;
    NSInteger index = 0;
    NSInteger number = 0;
    NSMutableArray * photos = [NSMutableArray array];
    for (NSInteger i = 0; i<11; i++) {
        [photos addObject:[NSObject new]];
    }
    
    NSDictionary*dic1 = [self.caseResult objectForKey:@"touXiangPicUrl"];
    if ([self haveUrl:[dic1 objectForKey:@"zhengMianXiang"]]) {
        [photos replaceObjectAtIndex:0 withObject:[self getMiddleImage:[dic1 objectForKey:@"zhengMianXiang"]]];
        number++;
    }
    if ([self haveUrl:[dic1 objectForKey:@"ceMianXiang"]]) {
        [photos replaceObjectAtIndex:1 withObject:[self getMiddleImage:[dic1 objectForKey:@"ceMianXiang"]]];
        number++;
    }
    if ([self haveUrl:[dic1 objectForKey:@"weiXiaoXiang"]]) {
        [photos replaceObjectAtIndex:2 withObject:[self getMiddleImage:[dic1 objectForKey:@"weiXiaoXiang"]]];
        number++;
    }
    if (section>1) {
        index = number;
        position = 3;
    }
    
    NSDictionary*dic2 = [self.caseResult objectForKey:@"zhengMianKouNeiPicUrl"];
    if ([self haveUrl:[dic2 objectForKey:@"zhengMianKouNeiXiang"]]) {
        [photos replaceObjectAtIndex:3 withObject:[self getMiddleImage:[dic2 objectForKey:@"zhengMianKouNeiXiang"]]];
        number++;
    }
    if ([self haveUrl:[dic2 objectForKey:@"ceWeiXiang"]]) {
        [photos replaceObjectAtIndex:4 withObject:[self getMiddleImage:[dic2 objectForKey:@"ceWeiXiang"]]];
        number++;
    }
    if (section>2) {
        index = number;
        position = 5;
    }
    
    NSDictionary*dic3 = [self.caseResult objectForKey:@"heWeiPicUrl"];
    if ([self haveUrl:[dic3 objectForKey:@"shangHeWeiXiang"]]) {
        [photos replaceObjectAtIndex:5 withObject:[self getMiddleImage:[dic3 objectForKey:@"shangHeWeiXiang"]]];
        number++;
    }
    if ([self haveUrl:[dic3 objectForKey:@"xiaHeWeiXiang"]]) {
        [photos replaceObjectAtIndex:6 withObject:[self getMiddleImage:[dic3 objectForKey:@"xiaHeWeiXiang"]]];
        number++;
    }
    if (section>3) {
        index = number;
        position = 7;
    }
    
    NSDictionary*dic4 = [self.caseResult objectForKey:@"xRayPicUrl"];
    if ([self haveUrl:[dic4 objectForKey:@"xRayPicUrl0"]]) {
        [photos replaceObjectAtIndex:7 withObject:[self getMiddleImage:[dic4 objectForKey:@"xRayPicUrl0"]]];
        number++;
    }
    if ([self haveUrl:[dic4 objectForKey:@"xRayPicUrl1"]]) {
        [photos replaceObjectAtIndex:8 withObject:[self getMiddleImage:[dic4 objectForKey:@"xRayPicUrl1"]]];
        number++;
    }
    if ([self haveUrl:[dic4 objectForKey:@"xRayPicUrl2"]]) {
        [photos replaceObjectAtIndex:9 withObject:[self getMiddleImage:[dic4 objectForKey:@"xRayPicUrl2"]]];
        number++;
    }
    if ([self haveUrl:[dic4 objectForKey:@"xRayPicUrl3"]]) {
        [photos replaceObjectAtIndex:10 withObject:[self getMiddleImage:[dic4 objectForKey:@"xRayPicUrl3"]]];
        number++;
    }
    index += item;
    position += item;
    
    if (![[photos objectAtIndex:position] isKindOfClass:[NSString class]]) {
        return;
    }
    if (number>0) {
        NSMutableArray * arr = [NSMutableArray array];
        for (NSInteger i=0;i<photos.count; i++) {
            id item = [photos objectAtIndex:i];
            if ([item isKindOfClass:[NSString class]]) {
                [arr addObject:item];
            }
        }
        // Create and setup browser
        IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:[IDMPhoto photosWithURLs:photos] animatedFromView:gesture.view]; // using initWithPhotos:animatedFromView: method to use the zoom-in animation
        browser.displayActionButton = YES;
        browser.displayArrowButton = NO;
        browser.displayCounterLabel = YES;
        browser.usePopAnimation = YES;
//        browser.scaleImage = [(UIImageView*)gesture.view image];
        [browser setInitialPageIndex:index];
        // Show
        [self presentViewController:browser animated:YES completion:nil];
    }
    
}

- (BOOL) haveUrl:(id)item
{
    return [SafeValue(item, @"") length] > 0;
}

- (NSString*)getMiddleImage:(id)item
{
    return [Tools imageFromString:item withSuffix:@"_middle"];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
