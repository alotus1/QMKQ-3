//
//  CheckResult.m
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "CheckResult.h"
#import "UCNameCell.h"
#import "LeftRightLabelCell.h"
#import "DocAdviceLabelCell.h"
#import "UserCaseConfig.h"
#import "config.h"
#import "CaseHeaderView.h"

@interface CheckResult () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSDictionary * tooth;

@end

@implementation CheckResult

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
                 @"6":[NSMutableArray array]};
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
    return 2;
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
    else if (section == 1) title = @"口腔基本状况:";
    CaseHeaderView*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"checkResultHeader"];
    if (!view) {
        view = [[CaseHeaderView alloc]initWithReuseIdentifier:@"checkResultHeader"];
    }
    view.textLabel.text = title;
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if (section == 0) number = 1;
    else if (section == 1) number = 18;
    return number;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = CellDefaultHeight;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 1) {
        if (row == 17) height = DocAdviceLabelCellHeight;
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
        if (row <= 16) {
            identifierString = @"LeftRightLabelCell";
            LeftRightLabelCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.right.text = @"";
            switch (row) {
                case 0: {
                    cel.left.text = @"龋齿";
                    cel.right.text = [[self.tooth objectForKey:@"0"] componentsJoinedByString:@" "];
                }break;
                case 1: {
                    cel.left.text = @"缺失";
                    cel.right.text = [[self.tooth objectForKey:@"1"] componentsJoinedByString:@" "];
                }break;
                case 2: {
                    cel.left.text = @"充填";
                    cel.right.text = [[self.tooth objectForKey:@"2"] componentsJoinedByString:@" "];
                }break;
                case 3: {
                    cel.left.text = @"早萌";
                    cel.right.text = [[self.tooth objectForKey:@"3"] componentsJoinedByString:@" "];
                }break;
                case 4: {
                    cel.left.text = @"根管治疗";
                    cel.right.text = [[self.tooth objectForKey:@"4"] componentsJoinedByString:@" "];
                }break;
                case 5: {
                    cel.left.text = @"窝沟封闭";
                    cel.right.text = [[self.tooth objectForKey:@"5"] componentsJoinedByString:@" "];
                }break;
                case 6: {
                    cel.left.text = @"剩余乳牙";
                    cel.right.text = [[self.tooth objectForKey:@"6"] componentsJoinedByString:@" "];
                }break;
                case 7: {
                    cel.left.text = @"磨牙关系";
                    NSDictionary*moyaguanxi = [self.caseResult objectForKey:@"moYaGuanxi"];
                    cel.right.text = [NSString stringWithFormat:@"%@%@",SafeValue([moyaguanxi objectForKey:@"left"], @""),SafeValue([moyaguanxi objectForKey:@"right"], @"")];;
                }break;
                case 8: {
                    cel.left.text = @"下牙与上腭软组织接触";
                    cel.right.text = [[self.caseResult objectForKey:@"xiaYaYuShangE"] boolValue]?@"是":@"否";
                }break;
                case 9: {
                    cel.left.text = @"前牙覆颌关系";
                    if ([[self.caseResult objectForKey:@"qianYaFuHeGuanXi"] intValue]) {
                        cel.right.text = [NSString stringWithFormat:@"%d级",[[self.caseResult objectForKey:@"qianYaFuHeGuanXi"] intValue]];
                    }
                }break;
                case 10: {
                    cel.left.text = @"前牙覆盖关系";
                    if ([[self.caseResult objectForKey:@"qianYaFuGaiGuanXi"] intValue]) {
                        cel.right.text = [NSString stringWithFormat:@"%d级",[[self.caseResult objectForKey:@"qianYaFuGaiGuanXi"] intValue]];
                    }
                }break;
                case 11: {
                    cel.left.text = @"前牙开颌";
                    if ([[self.caseResult objectForKey:@"qianYaKaiHe"] intValue]) {
                        cel.right.text = [NSString stringWithFormat:@"%d级",[[self.caseResult objectForKey:@"qianYaKaiHe"] intValue]];
                    }
                }break;
                case 12: {
                    cel.left.text = @"前牙反颌";
                    NSString * text = @"正常";
                    NSInteger sw = [[self.caseResult objectForKey:@"qianYaFanHe"] intValue];
                    if (sw == 1) {
                        text = @"左侧";
                    }else if (sw == 2) {
                        text = @"右侧";
                    }
                    cel.right.text = text;
                }break;
                case 13: {
                    cel.left.text = @"后牙反颌";
                    NSString * text = @"正常";
                    NSInteger sw = [[self.caseResult objectForKey:@"houYaFanHe"] intValue];
                    if (sw == 1) {
                        text = @"左侧";
                    }else if (sw == 2) {
                        text = @"右侧";
                    }
                    cel.right.text = text;
                }break;
                case 14: {
                    cel.left.text = @"后牙锁颌";
                    NSString * text = @"正常";
                    NSInteger sw = [[self.caseResult objectForKey:@"houYaSuoHe"] intValue];
                    if (sw == 1) {
                        text = @"左侧";
                    }else if (sw == 2) {
                        text = @"右侧";
                    }
                    cel.right.text = text;
                }break;
                case 15: {
                    cel.left.text = @"牙齿拥挤";
                    NSDictionary * dic = [self.caseResult objectForKey:@"yaChiYongJi"];
                    NSString * text = @"";
                    if ([dic objectForKey:@"top"]) {
                        text = [NSString stringWithFormat:@"上:%@",[dic objectForKey:@"top"]];
                    }
                    if ([dic objectForKey:@"bottom"]) {
                        if (text.length>0) {
                            text = [text stringByAppendingString:[NSString stringWithFormat:@"/下:%@",[dic objectForKey:@"bottom"]]];
                        }else {
                            text = [NSString stringWithFormat:@"下:%@",[dic objectForKey:@"bottom"]];
                        }
                    }
                    cel.right.text = text;
                }break;
                case 16: {
                    cel.left.text = @"第一恒磨牙异位萌出";
                    
                    NSDictionary * dic = [self.caseResult objectForKey:@"diYiHengMoYa"];
                    NSString * lefttop = @"";
                    if ([dic objectForKey:@"left_top"]) {
                        lefttop = [NSString stringWithFormat:@"左上:%@",[[dic objectForKey:@"left_top"] boolValue]?@"不正常":@"正常"];
                    }
                    NSString * righttop = @"";
                    if ([dic objectForKey:@"right_top"]) {
                        righttop = [NSString stringWithFormat:@"右上:%@",[[dic objectForKey:@"right_top"] boolValue]?@"不正常":@"正常"];
                    }
                    NSString * leftbottom = @"";
                    if ([dic objectForKey:@"left_bottom"]) {
                        righttop = [NSString stringWithFormat:@"左下:%@",[[dic objectForKey:@"left_bottom"] boolValue]?@"不正常":@"正常"];
                    }
                    NSString * rightbottom = @"";
                    if ([dic objectForKey:@"right_bottom"]) {
                        righttop = [NSString stringWithFormat:@"右下:%@",[[dic objectForKey:@"right_bottom"] boolValue]?@"不正常":@"正常"];
                    }
                    NSString * text = @"";
                    if (lefttop.length>0) {
                        text = lefttop;
                    }
                    if (text.length>0 && righttop.length>0) {
                        text = [text stringByAppendingFormat:@"\%@",righttop];
                    }
                    if (text.length>0 && leftbottom.length>0) {
                        text = [text stringByAppendingFormat:@"\%@",leftbottom];
                    }
                    if (text.length>0 && rightbottom.length>0) {
                        text = [text stringByAppendingFormat:@"\%@",rightbottom];
                    }
                    cel.right.text = text;
                }break;
                    
                default:
                    break;
            }
            cell = cel;
        }else if (row == 17) {
            identifierString = @"DocAdviceLabelCell";
            DocAdviceLabelCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.title.text = @"医生建议";
            cel.message.text = [self.caseResult objectForKey:@"doctor_suggest"];
            cell = cel;
        }
    }
    if (row%2 == 1 && (row != 17)) {
        cell.contentView.backgroundColor=UIColorFromRGB16(0xfaf9f9);
    }else {
        cell.contentView.backgroundColor=[UIColor whiteColor];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
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
