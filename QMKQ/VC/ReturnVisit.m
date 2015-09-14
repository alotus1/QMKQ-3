//
//  ReturnVisit.m
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "ReturnVisit.h"
#import "UCNameCell.h"
#import "TwoBtCell.h"
#import "PeriodontalDateCell.h"
#import "DocAdviceCell.h"
#import "ThreeBtCell.h"
#import "OneAndTwoBtCell.h"
#import "OneBtCell.h"
#import "ThreeBtOneNumCell.h"
#import "TwoThreeBtOneNumCell.h"
#import "TwoTwoNumCell.h"
#import "GetImageCell.h"
#import "QMPatientTeethCell.h"
#import "FourBtNoLeftCell.h"
#import "ThreeBtNoLeftCell.h"
#import "TwoFourBtCell.h"
#import "UserCaseConfig.h"
#import "QBImagePickerController.h"
#import "config.h"
#import "Tools.h"
#import <LGActionSheet.h>
#import "CaseHeaderView.h"
#import "QMRequest.h"
#import "AppDelegate.h"

@interface ReturnVisit () <UITableViewDelegate,UITableViewDataSource,QBImagePickerControllerDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    NSInteger uploadCount;
    NSInteger finishCount;
    BOOL tijiaole;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSString * tooth;
@property (nonatomic, strong) NSMutableArray * toothStatusList;//每颗牙齿的基本状况
@property (nonatomic, strong) QMPatientTeethCell    *qmteethCell;
@property (nonatomic, retain) ThreeBtNoLeftCell*toothThree;
@property (nonatomic, retain) ThreeBtNoLeftCell*toothThree1;
@property (nonatomic, retain) ThreeBtNoLeftCell*toothThree2;
@property (nonatomic, strong) UIDatePicker* datePicker;

@property (nonatomic, strong) UITextField *zhengyepeidaishijian;//整夜佩戴时间
@property (nonatomic, strong) UITextView *peiDaiShiJianProblem_first;//初步佩戴诱导器遇到过哪些问题
@property (nonatomic, strong) UITextView *peiDaiShiJianProblem_now;//现阶段佩戴有到期遇到哪些问题
@property (nonatomic, strong) UITextView *peiDaiShiJianProblem_check;//检查有到期是否存在损坏等问题
@property (nonatomic, strong) UITextField *wear_time;//整夜佩戴时间
@property (nonatomic, strong) NSMutableDictionary*wear_check;//佩戴问题
@property (nonatomic, strong) NSMutableDictionary*moYaGuanxi;//磨牙关系
@property (nonatomic, strong) NSMutableDictionary*qianYaFuHeGuanXi;//前牙覆颌关系
@property (nonatomic, strong) NSMutableDictionary*qianYaFuGaiGuanXi;//前牙覆盖关系
@property (nonatomic, strong) NSMutableDictionary*qianYaKaiHe;//前牙开颌
@property (nonatomic, strong) NSMutableDictionary*yaChiPaiLieYongJi;//牙齿排列拥挤
@property (nonatomic, strong) NSMutableDictionary*zhongXian;//中线
@property (nonatomic, assign) NSInteger heLeixing;//颌类型
@property (nonatomic, assign) NSInteger fanHe;//反颌
@property (nonatomic, assign) NSInteger xiaHeHouTui;//是否下颌后退
@property (nonatomic, assign) NSInteger shangHeJianYa;//上颌尖牙高位萌出
@property (nonatomic, assign) NSInteger chunJiaXiang;//唇颊像
@property (nonatomic, assign) NSInteger sheEXiang;//涉恶想
//@property (nonatomic, assign) NSInteger diWei;//低位
//@property (nonatomic, assign) NSInteger gaoWei;//高位
@property (nonatomic, assign) NSInteger kaiHe;//开颌
@property (nonatomic, assign) NSInteger yongJi;//拥挤
@property (nonatomic, assign) NSInteger suoHe;//锁颌
@property (nonatomic, strong) NSMutableDictionary*touXiangPicUrl;//头像
@property (nonatomic, strong) NSMutableDictionary*zhengMianKouNeiPicUrl;//正面口内
@property (nonatomic, strong) NSMutableDictionary*heWeiPicUrl;//上下颌
@property (nonatomic, strong) NSMutableDictionary*xRayPicUrl;//x光片
@property (nonatomic, retain) UITextView*doctor_suggest;//doctor_suggest
@property (nonatomic, retain) UILabel *hint;

@property (nonatomic, retain) GetImageCell * touxiang;
@property (nonatomic, retain) GetImageCell * zhengmian;
@property (nonatomic, retain) GetImageCell * shangxia;
@property (nonatomic, retain) GetImageCell * xray;
@property (nonatomic, strong) NSIndexPath * imageViewIndex;
@property (nonatomic, strong) NSMutableDictionary * imageDic;

@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) dispatch_group_t group;

@end

@implementation ReturnVisit

- (void)viewDidLoad {
    [super viewDidLoad];
    
    uploadCount = 0;
    finishCount = 0;
    tijiaole = NO;
    
    [self setLeftButtonItem];
    UIView*footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    footView.backgroundColor=self.tableView.backgroundColor;
    self.tableView.tableFooterView=footView;
    [self.tableView registerClass:[QMPatientTeethCell class] forCellReuseIdentifier:@"QMPatientTeethCell"];
    // 防止重用机制的注册
    [self.tableView registerClass:[QMPatientTeethCell class] forCellReuseIdentifier:@"QMPatientTeethCell"];
    
    // Do any additional setup after loading the view.
    [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignFirst)]];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    self.toothStatusList=[NSMutableArray array];
    self.wear_check=[NSMutableDictionary dictionary];
    self.moYaGuanxi=[NSMutableDictionary dictionary];
    self.qianYaFuHeGuanXi=[NSMutableDictionary dictionary];
    self.qianYaFuGaiGuanXi=[NSMutableDictionary dictionary];
    self.qianYaKaiHe=[NSMutableDictionary dictionary];
    self.yaChiPaiLieYongJi=[NSMutableDictionary dictionary];
    self.zhongXian=[NSMutableDictionary dictionary];
    
    
    self.touXiangPicUrl=[NSMutableDictionary dictionary];
    self.zhengMianKouNeiPicUrl=[NSMutableDictionary dictionary];
    self.heWeiPicUrl=[NSMutableDictionary dictionary];
    self.xRayPicUrl=[NSMutableDictionary dictionary];
    self.imageViewIndex = [NSIndexPath indexPathForItem:-1 inSection:-1];
    self.imageDic = [NSMutableDictionary dictionary];;
    
    
    self.queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.group = dispatch_group_create();
}

- (void)resignFirst
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
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
    else if (section == 2) title = @"咬颌诱导检查:";
    else if (section == 3) title = @"咬颌评估:";
    CaseHeaderView*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"returnVisitHeader"];
    if (!view) {
        view = [[CaseHeaderView alloc]initWithReuseIdentifier:@"returnVisitHeader"];
    }
    view.textLabel.text = title;
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if (section == 0) number = 1;
    else if (section == 1) number = 8;
    else if (section == 2) number = 4;
    else if (section == 3) number = 20;
    return number;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = CellDefaultHeight;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 1) {
        if (row == 2 || row ==3 || row ==4) height = PlaceholderHeight;
    }else if (section == 2 && row == 0) {
        height = ScreenWidth;
    }else if (section == 3) {
        if (row == 0 || row == 1 || row == 2) height = ThreeBtOneNumCellHeight;
        if (row == 3)  height = TwoThreeBtOneNumCellHeight;
        if (row == 4) height = TwoTwoNumCellHeight;
        if (row==5)  height = TwoFourBtCellHeight;
        else if (row >= 14 && row <= 17) height = GetImageCellHeight;
        else if (row == 18) height = DocAdviceCellHeight;
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
        if (row == 0) {
            identifierString = @"TwoBtCell";
            TwoBtCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.leftLabel.text = @"是否整夜佩戴";
            [cel.first setTitle:@"是" forState:0];
            [cel.last setTitle:@"否" forState:0];
            [Tools button:cel.first removeAllActionsFromTarget:self];
            [Tools button:cel.first andOthersButtonAddTarget:self action:@selector(zhengyepeidaiAction:)];
            cell = cel;
        }else if (row == 1) {
            identifierString = @"PeriodontalDateCell1";
            PeriodontalDateCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.left.text = @"进入整夜佩戴时间";
            cel.textField.delegate=self;
            self.zhengyepeidaishijian=cel.textField;
            cel.dateLabel.text = @"年/月/日";
            cell = cel;
        }else if (row == 2) {
            identifierString = @"DocAdviceCell1";//避免重用机制
            DocAdviceCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.title.text = @"初步佩戴诱导器遇到过哪些问题";
            cel.textView.delegate=self;
            self.peiDaiShiJianProblem_first=cel.textView;
            cel.hint.text = @"";
            cell = cel;
        }else if (row == 3) {
            identifierString = @"DocAdviceCell1";
            DocAdviceCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.title.text = @"现阶段佩戴诱导器遇到过哪些问题";
            cel.textView.delegate=self;
            self.peiDaiShiJianProblem_now=cel.textView;
            cel.hint.text = @"";
            cell = cel;
        }else if (row == 4) {
            identifierString = @"DocAdviceCell1";
            DocAdviceCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.title.text = @"检查诱导器是否存在损坏等问题";
            cel.textView.delegate=self;
            self.peiDaiShiJianProblem_check=cel.textView;
            cel.hint.text = @"";
            cell = cel;
        }else if (row == 5) {
            identifierString = @"TwoBtCell";
            TwoBtCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.leftLabel.text = @"检查诱导器现阶段是否合适";
            [cel.first setTitle:@"是" forState:0];
            [cel.last setTitle:@"否" forState:0];
            [Tools button:cel.first removeAllActionsFromTarget:self];
            [Tools button:cel.first andOthersButtonAddTarget:self action:@selector(shifouheshiAction:)];
            cell = cel;
        }else if (row == 6) {
            identifierString = @"TwoBtCell";
            TwoBtCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.leftLabel.text = @"诱导器更换";
            [cel.first setTitle:@"是" forState:0];
            [cel.last setTitle:@"否" forState:0];
            [Tools button:cel.first removeAllActionsFromTarget:self];
            [Tools button:cel.first andOthersButtonAddTarget:self action:@selector(genghuanAction:)];
            cell = cel;
        }else if (row == 7) {
            identifierString = @"TwoBtCell";
            TwoBtCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.leftLabel.text = @"是否已进行诱导器深层清理";
            [cel.first setTitle:@"是" forState:0];
            [cel.last setTitle:@"否" forState:0];
            [Tools button:cel.first removeAllActionsFromTarget:self];
            [Tools button:cel.first andOthersButtonAddTarget:self action:@selector(qingliAction:)];
            cell = cel;
        }
    }else if (section == 2) {
        if (row == 0) {
            identifierString = @"QMPatientTeethCell";
            QMPatientTeethCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            [cel addTarget:self andAction:@selector(selectTooth:)];
            cell = cel;
        }else if (row == 1) {
            identifierString = @"ThreeBtNoLeftCell";
            ThreeBtNoLeftCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];//qu
            self.toothThree=cel;
            [cel.first setTitle:@"龋齿" forState:0];
            [cel.second setTitle:@"外翻" forState:0];
            [cel.third setTitle:@"早失牙" forState:0];
            cel.third.hidden = NO;
            NSArray*status=nil;
            for (NSDictionary*dic in self.toothStatusList) {
                NSString*ind = [dic objectForKey:@"toothIndex"];
                if ([self.tooth isEqualToString:ind]) {
                    status=[dic objectForKey:@"status"];
                    break;
                }
            }
            if (status.count>0) {
                for (id num in status) {
                    NSInteger st = [num intValue];
                    if (st == 0) {
                        [cel.first setSelected:YES];
                    }else if (st == 1) {
                        [cel.second setSelected:YES];
                    }else if (st == 2) {
                        [cel.third setSelected:YES];
                    }
                }
            }
            [cel.first addTarget:self action:@selector(toothAction:) forControlEvents:UIControlEventTouchUpInside];
            [cel.second addTarget:self action:@selector(toothAction:) forControlEvents:UIControlEventTouchUpInside];
            [cel.third addTarget:self action:@selector(toothAction:) forControlEvents:UIControlEventTouchUpInside];
            cell = cel;
        }else if (row == 2) {
            identifierString = @"ThreeBtNoLeftCell";
            ThreeBtNoLeftCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            self.toothThree1=cel;//4滞留，5发育不能，6内翻，7先天缺失
            [cel.first setTitle:@"滞留" forState:0];
            [cel.second setTitle:@"内翻" forState:0];
            [cel.third setTitle:@"多生牙" forState:0];
            cel.third.hidden = NO;
            NSArray*status=nil;
            for (NSDictionary*dic in self.toothStatusList) {
                NSString*ind = [dic objectForKey:@"toothIndex"];
                if ([self.tooth isEqualToString:ind]) {
                    status=[dic objectForKey:@"status"];
                    break;
                }
            }
            if (status.count>0) {
                for (id num in status) {
                    NSInteger st = [num intValue];
                    if (st == 4) {
                        [cel.first setSelected:YES];
                    }else if (st == 6) {
                        [cel.second setSelected:YES];
                    }else if (st == 3) {
                        [cel.third setSelected:YES];
                    }
                }
            }
            [cel.first addTarget:self action:@selector(toothAction:) forControlEvents:UIControlEventTouchUpInside];
            [cel.second addTarget:self action:@selector(toothAction:) forControlEvents:UIControlEventTouchUpInside];
            [cel.third addTarget:self action:@selector(toothAction:) forControlEvents:UIControlEventTouchUpInside];
            cell = cel;
        }else if (row == 3) {
            identifierString = @"ThreeBtNoLeftCell";
            ThreeBtNoLeftCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            self.toothThree2=cel;//4滞留，5发育不能，6内翻，7先天缺失
            [cel.first setTitle:@"发育不能" forState:0];
            [cel.second setTitle:@"先天缺失" forState:0];
            [cel.third setTitle:@"占位字" forState:0];
            cel.third.hidden = YES;
            NSArray*status=nil;
            for (NSDictionary*dic in self.toothStatusList) {
                NSString*ind = [dic objectForKey:@"toothIndex"];
                if ([self.tooth isEqualToString:ind]) {
                    status=[dic objectForKey:@"status"];
                    break;
                }
            }
            if (status.count>0) {
                for (id num in status) {
                    NSInteger st = [num intValue];
                    if (st == 5) {
                        [cel.first setSelected:YES];
                    }else if (st == 7) {
                        [cel.second setSelected:YES];
                    }
                }
            }
            [cel.first addTarget:self action:@selector(toothAction:) forControlEvents:UIControlEventTouchUpInside];
            [cel.second addTarget:self action:@selector(toothAction:) forControlEvents:UIControlEventTouchUpInside];
            cell = cel;
        }
    }else if (section == 3) {
        if (row == 0 || row == 1 || row == 2) {
            identifierString = @"ThreeBtOneNumCell";
            ThreeBtOneNumCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.leftLabel.text = @"牙:";
            cel.leftLabel.hidden=YES;
            [cel.first setTitle:oneString forState:0];
            [cel.second setTitle:twoString forState:0];
            [cel.third setTitle:threeString forState:0];
            if (row == 0) {
                cel.titleLabel.text = @"前牙覆颌关系";
                [Tools button:cel.first removeAllActionsFromTarget:self];
                [Tools button:cel.first andOthersButtonAddTarget:self action:@selector(qianYaFuHeGuanXiAction:)];
                [cel.rightNum addTarget:self andAction:@selector(qianYaFuHeGuanXiNumBt:) forNumberChangeWithEvent:UIControlEventTouchUpInside];
            }else if (row == 1) {
                cel.titleLabel.text = @"前牙覆盖关系";
                [Tools button:cel.first removeAllActionsFromTarget:self];
                [Tools button:cel.first andOthersButtonAddTarget:self action:@selector(qianYaFuGaiGuanXiAction:)];
                [cel.rightNum addTarget:self andAction:@selector(qianYaFuGaiGuanXiNumBt:) forNumberChangeWithEvent:UIControlEventTouchUpInside];
            }else if (row == 2) {
                cel.titleLabel.text = @"前牙开颌";
                [Tools button:cel.first removeAllActionsFromTarget:self];
                [Tools button:cel.first andOthersButtonAddTarget:self action:@selector(qianYaKaiHeAction:)];
                [cel.rightNum addTarget:self andAction:@selector(qianYaKaiHeNumBt:) forNumberChangeWithEvent:UIControlEventTouchUpInside];
            }
            cell = cel;
        }else if (row == 3) {
            identifierString = @"TwoThreeBtOneNumCell";
            TwoThreeBtOneNumCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.titleLabel.text = @"牙列拥挤";
            cel.topLeft.text = @"上";
            cel.bottomLeft.text = @"下";
            [cel.topFirst setTitle:oneString forState:0];
            [cel.topSecond setTitle:twoString forState:0];
            [cel.topThird setTitle:threeString forState:0];
            [Tools button:cel.topFirst removeAllActionsFromTarget:self];
            [Tools button:cel.topFirst andOthersButtonAddTarget:self action:@selector(yaChiPaiLieYongJiActionTop:)];
            [cel.topRightNum addTarget:self andAction:@selector(yaChiPaiLieYongJiTopNumBt:) forNumberChangeWithEvent:UIControlEventTouchUpInside];
            [cel.bottomFirst setTitle:oneString forState:0];
            [cel.bottomSecond setTitle:twoString forState:0];
            [cel.bottomThird setTitle:threeString forState:0];
            [Tools button:cel.bottomFirst removeAllActionsFromTarget:self];
            [Tools button:cel.bottomFirst andOthersButtonAddTarget:self action:@selector(yaChiPaiLieYongJiActionBottom:)];
            [cel.bottomRightNum addTarget:self andAction:@selector(yaChiPaiLieYongJiBottomNumBt:) forNumberChangeWithEvent:UIControlEventTouchUpInside];
            cel.topLeft.text = @"左:";
            cel.bottomLeft.text = @"右:";
            cell = cel;
        }else if (row == 4) {
            identifierString = @"TwoTwoNumCell";
            TwoTwoNumCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.title.text = @"中线";
            [cel.topBt setTitle:@"正" forState:0];
            [Tools button:cel.topBt removeAllActionsFromTarget:self];
            [Tools button:cel.topBt andOthersButtonAddTarget:self action:@selector(zhongXianTopBtAction:)];
            [cel.bottomBt setTitle:@"正" forState:0];
            [Tools button:cel.bottomBt removeAllActionsFromTarget:self];
            [Tools button:cel.bottomBt andOthersButtonAddTarget:self action:@selector(zhongXianBottomBtAction:)];
            cel.oneOneLabel.text = @"左偏";
            cel.oneTwoLabel.text = @"右偏";
            cel.twoOneLabel.text = @"左偏";
            cel.twoTwoLabel.text = @"右偏";
            [cel.oneoneNum addTarget:self andAction:@selector(zhongXianTopZuoPianNumBt:) forNumberChangeWithEvent:UIControlEventTouchUpInside];
            [cel.oneTwoNum addTarget:self andAction:@selector(zhongXianTopYouPianNumBt:) forNumberChangeWithEvent:UIControlEventTouchUpInside];
            [cel.twoOneNum addTarget:self andAction:@selector(zhongXianBottomZuoPianNumBt:) forNumberChangeWithEvent:UIControlEventTouchUpInside];
            [cel.twoTwoNum addTarget:self andAction:@selector(zhongXianBottomYouPianNumBt:) forNumberChangeWithEvent:UIControlEventTouchUpInside];
            cell = cel;
        }else if (row == 5) {
            identifierString = @"TwoFourBtCell";
            TwoFourBtCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.title.text = @"磨牙关系";
            cel.topLeft.text = @"左:";
            cel.bottomLeft.text = @"右:";
            [cel.topFirst setTitle:@"中性" forState:0];
            [cel.topSecond setTitle:@"远中" forState:0];
            [cel.topThird setTitle:@"近中" forState:0];
            [cel.TopFourth setTitle:@"无法判定" forState:0];
            [Tools button:cel.topFirst removeAllActionsFromTarget:self];
            [Tools button:cel.topFirst andOthersButtonAddTarget:self action:@selector(moyaguanxiTop:)];
            [cel.bottomFirst setTitle:@"中性" forState:0];
            [cel.bottomSecond setTitle:@"远中" forState:0];
            [cel.bottomThird setTitle:@"近中" forState:0];
            [cel.bottomFourth setTitle:@"无法判定" forState:0];
            [Tools button:cel.topFirst removeAllActionsFromTarget:self];
            [Tools button:cel.topFirst andOthersButtonAddTarget:self action:@selector(moyaguanxiBottom:)];
            cell = cel;
        }else if (row == 6) {
            identifierString = @"ThreeBtCell";
            ThreeBtCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.leftLabel.text = @"颌类型";
            cel.RightLabel.text = @"";
            [cel.first setTitle:@"乳" forState:0];
            [cel.second setTitle:@"恒" forState:0];
            [cel.third setTitle:@"替" forState:0];
            [Tools button:cel.first removeAllActionsFromTarget:self];
            [Tools button:cel.first andOthersButtonAddTarget:self action:@selector(heLeixingAction:)];
            cell = cel;
        }else if (row == 7) {
            identifierString = @"ThreeBtCell";
            ThreeBtCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.leftLabel.text = @"上颌尖牙高位萌出";
            cel.RightLabel.text = @"";
            [cel.first setTitle:@"正常" forState:0];
            [cel.second setTitle:@"左侧" forState:0];
            [cel.third setTitle:@"右侧" forState:0];
            [Tools button:cel.first removeAllActionsFromTarget:self];
            [Tools button:cel.first andOthersButtonAddTarget:self action:@selector(shangHeJianYaAction:)];
            cell = cel;
        }else if (row == 8) {
            identifierString = @"OneAndTwoBtCell";
            OneAndTwoBtCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            [cel.leftBt setTitle:@"反颌" forState:0];
            [Tools button:cel.leftBt removeAllActionsFromTarget:self];
            [Tools button:cel.leftBt andOthersButtonAddTarget:self action:@selector(fanHeAction:)];
            [cel.labelRight setTitle:@"可" forState:0];
            [cel.last setTitle:@"否" forState:0];
            cel.leftLabel.text = @"下颌可退";
            [Tools button:cel.labelRight removeAllActionsFromTarget:self];
            [Tools button:cel.labelRight andOthersButtonAddTarget:self action:@selector(xiaHeHouTuiAction:)];
            cell = cel;
        }else if (row <= 13) {
            identifierString = @"OneBtCell";
            OneBtCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            if (row == 9) {
                [cel.bt setTitle:@"唇颊向" forState:0];
                [Tools button:cel.bt removeAllActionsFromTarget:self];
                [Tools button:cel.bt andOthersButtonAddTarget:self action:@selector(chunJiaXiangAction:)];
            } else if (row == 10) {
                [cel.bt setTitle:@"舌颚向" forState:0];
                [Tools button:cel.bt removeAllActionsFromTarget:self];
                [Tools button:cel.bt andOthersButtonAddTarget:self action:@selector(sheEXiangAction:)];
            }else if (row == 11) {
                [cel.bt setTitle:@"开颌" forState:0];
                [Tools button:cel.bt removeAllActionsFromTarget:self];
                [Tools button:cel.bt andOthersButtonAddTarget:self action:@selector(kaiHeAction:)];
            }else if (row == 12) {
                [cel.bt setTitle:@"拥挤" forState:0];
                [Tools button:cel.bt removeAllActionsFromTarget:self];
                [Tools button:cel.bt andOthersButtonAddTarget:self action:@selector(yongJiAction:)];
            }else if (row == 13) {
                [cel.bt setTitle:@"锁颌" forState:0];
                [Tools button:cel.bt removeAllActionsFromTarget:self];
                [Tools button:cel.bt andOthersButtonAddTarget:self action:@selector(suoHeAction:)];
            }
            cell = cel;
        }else if (row == 14) {
            identifierString = @"GetImageCell";
            GetImageCell*cel =  [tableView dequeueReusableCellWithIdentifier:identifierString];
            self.touxiang=cel;
            cel.title.text = @"正面像/侧面像/微笑像";
            cel.lastImgView.hidden=YES;
            [cel.firstImgView addImageGestureTarget:self andAction:@selector(zhengmianxiang)];
            [cel.secondImgView addImageGestureTarget:self andAction:@selector(cemianxiang)];
            [cel.thirdImgView addImageGestureTarget:self andAction:@selector(weixiaoxiang)];
            cell = cel;
        }else if (row == 15) {
            identifierString = @"GetImageCell";
            GetImageCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
                self.zhengmian=cel;
            cel.title.text = @"正面口内像/侧位像";
            cel.thirdImgView.hidden=YES;
            cel.lastImgView.hidden=YES;
            [cel.firstImgView addImageGestureTarget:self andAction:@selector(kouneixiang)];
            [cel.secondImgView addImageGestureTarget:self andAction:@selector(ceweixiang)];
            cell = cel;
        }else if (row == 16) {
            identifierString = @"GetImageCell";
            GetImageCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
                self.shangxia=cel;
            cel.title.text = @"上颌位像/下颌位像";
            cel.thirdImgView.hidden=YES;
            cel.lastImgView.hidden=YES;
            [cel.firstImgView addImageGestureTarget:self andAction:@selector(shangeweixiang)];
            [cel.secondImgView addImageGestureTarget:self andAction:@selector(xiaeweixiang)];
            cell = cel;
        }else if (row == 17) {
            identifierString = @"GetImageCell";
            GetImageCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
                self.xray=cel;
            cel.title.text = @"X光片";
            [cel.firstImgView addImageGestureTarget:self andAction:@selector(xguangpian)];
            [cel.secondImgView addImageGestureTarget:self andAction:@selector(xguangpian1)];
            [cel.thirdImgView addImageGestureTarget:self andAction:@selector(xguangpian2)];
            [cel.lastImgView addImageGestureTarget:self andAction:@selector(xguangpian3)];
            cell = cel;
        }else if (row == 18) {
            identifierString = @"DocAdviceCell";
            DocAdviceCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.title.text = @"医生建议";
            cel.hint.text = @"请详细的描写患者的口腔状况和治疗建议。";
            cel.textView.delegate=self;
            self.hint=cel.hint;
            self.doctor_suggest=cel.textView;
            cell = cel;
        }else if (row == 19) {
            identifierString = @"PeriodontalDateCell";
            PeriodontalDateCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.left.text = @"诱导器佩戴时间";
            cel.textField.delegate=self;
            self.wear_time = cel.textField;
            cel.dateLabel.text = @"年/月/日";
            cell = cel;
        }
    }
    
    CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    if ([cell viewWithTag:200]) {
        CGRect r = [cell viewWithTag:200].frame;
        r.origin.y=height-0.5;
        r.size.height = 0.5f;
        [cell viewWithTag:200].frame = r;
    }else {
        if (row == 19 && section == 3) {
            
        }else {
            CGFloat ory = height-0.5;
            UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, ory, ScreenWidth, 0.5)];
            view.tag = 200;
            view.backgroundColor=LineColor;
            [cell addSubview:view];
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.zhengyepeidaishijian]) {
        NSDateFormatter*datefor = [[NSDateFormatter alloc]init];
        datefor.dateFormat=@"yyyy/MM/dd";
        if (!self.datePicker) {
            self.datePicker = [[UIDatePicker alloc] init];
            self.datePicker.datePickerMode=UIDatePickerModeDate;
            self.datePicker.frame = CGRectMake(0.f, 0.f, self.datePicker.frame.size.width, 100.f);
        }
        self.datePicker.date=[datefor dateFromString:[datefor stringFromDate:[NSDate date]]];
        [[[LGActionSheet alloc] initWithTitle:@"请选择日期"
                                         view:self.datePicker
                                 buttonTitles:@[@"确定"]
                            cancelButtonTitle:@"取消"
                       destructiveButtonTitle:nil
                                actionHandler:^(LGActionSheet *actionSheet, NSString *title, NSUInteger index) {
                                    self.zhengyepeidaishijian.text = [datefor stringFromDate:self.datePicker.date];
                                    [self.wear_check setObject:self.zhengyepeidaishijian.text forKey:@"peiDaiShiJian"];
                                }
                                cancelHandler:nil
                           destructiveHandler:nil] showAnimated:YES completionHandler:nil];
        return NO;
    }
    if ([textField isEqual:self.wear_time]) {
        NSDateFormatter*datefor = [[NSDateFormatter alloc]init];
        datefor.dateFormat=@"yyyy/MM/dd";
        if (!self.datePicker) {
            self.datePicker = [[UIDatePicker alloc] init];
            self.datePicker.datePickerMode=UIDatePickerModeDate;
            self.datePicker.frame = CGRectMake(0.f, 0.f, self.datePicker.frame.size.width, 100.f);
        }
        self.datePicker.date=[datefor dateFromString:[datefor stringFromDate:[NSDate date]]];
        [[[LGActionSheet alloc] initWithTitle:@"请选择日期"
                                         view:self.datePicker
                                 buttonTitles:@[@"确定"]
                            cancelButtonTitle:@"取消"
                       destructiveButtonTitle:nil
                                actionHandler:^(LGActionSheet *actionSheet, NSString *title, NSUInteger index) {
                                    self.wear_time.text = [datefor stringFromDate:self.datePicker.date];
                                }
                                cancelHandler:nil
                           destructiveHandler:nil] showAnimated:YES completionHandler:nil];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView isEqual:self.doctor_suggest]) {
        self.hint.hidden=YES;
        self.hint.enabled=NO;
    }
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if ([textView isEqual:self.doctor_suggest]) {
        if (textView.text.length>0) {
        }else {
            self.hint.hidden=NO;
            self.hint.enabled=YES;
        }
    }
    if ([textView isEqual:self.peiDaiShiJianProblem_first]) {
        [self.wear_check setObject:textView.text forKey:@"peiDaiShiJianProblem_first"];
    }else if ([textView isEqual:self.peiDaiShiJianProblem_now]) {
        [self.wear_check setObject:textView.text forKey:@"peiDaiShiJianProblem_now"];
    }else if ([textView isEqual:self.peiDaiShiJianProblem_check]) {
        [self.wear_check setObject:textView.text forKey:@"peiDaiShiJianProblem_check"];
    }
    
    
    return YES;
}


#pragma mark    bt

- (void)shifouheshiAction:(DLRadioButton*)bt
{
    if (bt.selectedButton) {
        if ([bt.selectedButton.currentTitle isEqualToString:@"是"]) {
            [self.wear_check setObject:@"1" forKey:@"youDaoQi"];
        }else {
            [self.wear_check setObject:@"0" forKey:@"youDaoQi"];
        }
    }
}
- (void)genghuanAction:(DLRadioButton*)bt
{
    if (bt.selectedButton) {
        if ([bt.selectedButton.currentTitle isEqualToString:@"是"]) {
            [self.wear_check setObject:@"1" forKey:@"youDaoQiGengHuan"];
        }else {
            [self.wear_check setObject:@"0" forKey:@"youDaoQiGengHuan"];
        }
    }
}
- (void)qingliAction:(DLRadioButton*)bt
{
    if (bt.selectedButton) {
        if ([bt.selectedButton.currentTitle isEqualToString:@"是"]) {
            [self.wear_check setObject:@"1" forKey:@"youDaoQiQingLi"];
        }else {
            [self.wear_check setObject:@"0" forKey:@"youDaoQiQingLi"];
        }
    }
}
- (void)zhengyepeidaiAction:(DLRadioButton*)bt
{
    if (bt.selectedButton) {
        if ([bt.selectedButton.currentTitle isEqualToString:@"是"]) {
            [self.wear_check setObject:@"1" forKey:@"zhengYePeiDai"];
        }else {
            [self.wear_check setObject:@"0" forKey:@"zhengYePeiDai"];
        }
    }
}

- (void)selectTooth:(UIButton*)bt
{
    self.tooth=bt.currentTitle;
    
    [self.toothThree.first setSelected:NO];
    [self.toothThree.second setSelected:NO];
    [self.toothThree.third setSelected:NO];
    [self.toothThree1.first setSelected:NO];
    [self.toothThree1.second setSelected:NO];
    [self.toothThree1.third setSelected:NO];
    [self.toothThree2.first setSelected:NO];
    [self.toothThree2.second setSelected:NO];
    [self.toothThree2.third setSelected:NO];
    
    [self.tableView reloadData];
    
}

- (void)toothAction:(DLRadioButton*)bt
{
    if ((self.tooth.length>0) && self.tooth!=nil) {
    NSNumber* sta = @-1;
        //牙齿状态：0龋齿，1外翻，2早失牙，3多生牙，4滞留，5发育不能，6内翻，7先天缺失
    if ([bt.currentTitle isEqualToString:@"龋齿"]) {
        sta=@0;
    }else if ([bt.currentTitle isEqualToString:@"外翻"]) {
        sta=@1;
    }else if ([bt.currentTitle isEqualToString:@"早失牙"]) {
        sta=@2;
    }else if ([bt.currentTitle isEqualToString:@"多生牙"]) {
        sta=@3;
    }else if ([bt.currentTitle isEqualToString:@"滞留"]) {
        sta=@4;
    }else if ([bt.currentTitle isEqualToString:@"发育不能"]) {
        sta=@5;
    }else if ([bt.currentTitle isEqualToString:@"内翻"]) {
        sta=@6;
    }else if ([bt.currentTitle isEqualToString:@"先天缺失"]) {
        sta=@7;
    }
    NSMutableArray*arr=self.toothStatusList;
        //取消
    if (!bt.selectedButton) {
        //查找是否有这个bt
        for (NSInteger i = 0; i< arr.count;i++) {
            NSDictionary*dic = [arr objectAtIndex:i];
            //如果有
            if ([[dic objectForKey:@"toothIndex"] isEqualToString: self.tooth]) {
                //获得到所有的status
                NSMutableArray*status=[NSMutableArray arrayWithArray:[dic objectForKey:@"status"]];
                //是否有这个选项
                for (NSInteger j=0; j < status.count; j++) {
                    NSNumber*state=[status objectAtIndex:j];
                    if ([state intValue] == [sta intValue]) {
                        [status removeObjectAtIndex:j];
                        break;
                    }
                }
                if (status.count>0) {
                    //还有其他选项，则替换
                    [dic setValue:status forKey:@"status"];
                    [arr replaceObjectAtIndex:i withObject:dic];
                }else {
                    //没有其他选项，移除所有
                    [arr removeObjectAtIndex:i];
                }
                break;
            }
        }
    }else {
        //确定
        BOOL hav = NO;
        //查找是否选中过
        for (NSInteger i = 0; i< arr.count;i++) {
            NSDictionary*dic = [arr objectAtIndex:i];
            //如果选中过
            if ([[dic objectForKey:@"toothIndex"] isEqualToString: self.tooth]) {
                //添加这个选项，并替换
                [[dic objectForKey:@"status"] addObject:sta];
                [arr replaceObjectAtIndex:i withObject:dic];
                hav = YES;
                break;
            }
        }
        //如果没有选中过
        if (!hav) {
            NSMutableArray*status=[NSMutableArray array];
            [status addObject:sta];
            NSDictionary*dic=@{@"toothIndex":self.tooth,@"status":status};
            [arr addObject:dic];
        }
    }
    }else {
        ALERT1(@"请选择牙齿");
    }
}





- (void)moyaguanxiTop:(DLRadioButton*)bt
{
    if (bt.selectedButton) {
        NSInteger t = 0;
        if ([bt.selectedButton.currentTitle isEqualToString:@"中性"]) {
        }else if ([bt.selectedButton.currentTitle isEqualToString:@"远中"]) {
            t=1;
        }else if ([bt.selectedButton.currentTitle isEqualToString:@"近中"]) {
            t=2;
        }else if ([bt.selectedButton.currentTitle isEqualToString:@"无法判定"]) {
            t=3;
        }
        [self.moYaGuanxi setValue:[NSString stringWithFormat:@"%d",(int)t] forKey:@"left"];
    }else {
        [self.moYaGuanxi removeObjectForKey:@"left"];
    }
}

- (void)moyaguanxiBottom:(DLRadioButton*)bt
{
    if (bt.selectedButton) {
        NSInteger t = 0;
        if ([bt.selectedButton.currentTitle isEqualToString:@"中性"]) {
        }else if ([bt.selectedButton.currentTitle isEqualToString:@"远中"]) {
            t=1;
        }else if ([bt.selectedButton.currentTitle isEqualToString:@"近中"]) {
            t=2;
        }else if ([bt.selectedButton.currentTitle isEqualToString:@"无法判定"]) {
            t=3;
        }
        [self.moYaGuanxi setValue:[NSString stringWithFormat:@"%d",(int)t] forKey:@"right"];
    }else {
        [self.moYaGuanxi removeObjectForKey:@"right"];
    }
}

- (void)heLeixingAction:(DLRadioButton*)bt
{
    if (bt.selectedButton) {
        CGPoint p = [bt convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath*indexPath = [self.tableView indexPathForRowAtPoint:p];
        ThreeBtCell*cell=(ThreeBtCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        NSInteger t = 0;
        if ([bt isEqual:cell.first]) {
        }else if ([bt isEqual:cell.second]) {
            t=1;
        }else if ([bt isEqual:cell.third]) {
            t=2;
        }
        self.heLeixing=t;
    }
}
- (void)shangHeJianYaAction:(DLRadioButton*)bt
{
    if (bt.selectedButton) {
        CGPoint p = [bt convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath*indexPath = [self.tableView indexPathForRowAtPoint:p];
        ThreeBtCell*cell=(ThreeBtCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        NSInteger t = 0;
        if ([bt isEqual:cell.first]) {
        }else if ([bt isEqual:cell.second]) {
            t=1;
        }else if ([bt isEqual:cell.third]) {
            t=2;
        }
        self.shangHeJianYa=t;
    }
}
- (void)fanHeAction:(DLRadioButton*)bt
{
    if (bt.selected) {
        self.fanHe=1;
    }else {
        self.fanHe=0;
        CGPoint p = [bt convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath*indexPath = [self.tableView indexPathForRowAtPoint:p];
        OneAndTwoBtCell*cell=(OneAndTwoBtCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.labelRight.selected=NO;
        cell.last.selected=NO;
    }
}
- (void)xiaHeHouTuiAction:(DLRadioButton*)bt
{
    if (!self.fanHe) {
        ALERT1(@"请选择反颌");
        bt.selected=NO;
        return;
    }
    if (bt.selectedButton) {
        CGPoint p = [bt convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath*indexPath = [self.tableView indexPathForRowAtPoint:p];
        OneAndTwoBtCell*cell=(OneAndTwoBtCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        NSInteger t = 0;
        if ([bt isEqual:cell.labelRight]) {
            t=1;
        }else if ([bt isEqual:cell.last]) {
            t=0;
        }
        self.xiaHeHouTui=t;
    }
}
- (void)chunJiaXiangAction:(DLRadioButton*)bt
{
    if (bt.selected) {
        self.chunJiaXiang=1;
    }else {
        self.chunJiaXiang=0;
    }
}
- (void)sheEXiangAction:(DLRadioButton*)bt
{
    if (bt.selected) {
        self.sheEXiang=1;
    }else {
        self.sheEXiang=0;
    }
}
//- (void)diWeiAction:(DLRadioButton*)bt
//{
//    if (bt.selected) {
//        self.diWei=1;
//    }else {
//        self.diWei=0;
//    }
//}
//- (void)gaoWeiAction:(DLRadioButton*)bt
//{
//    if (bt.selected) {
//        self.gaoWei=1;
//    }else {
//        self.gaoWei=0;
//    }
//}
- (void)kaiHeAction:(DLRadioButton*)bt
{
    if (bt.selected) {
        self.kaiHe=1;
    }else {
        self.kaiHe=0;
    }
}
- (void)yongJiAction:(DLRadioButton*)bt
{
    if (bt.selected) {
        self.yongJi=1;
    }else {
        self.yongJi=0;
    }
}
- (void)suoHeAction:(DLRadioButton*)bt
{
    if (bt.selected) {
        self.suoHe=1;
    }else {
        self.suoHe=0;
    }
}
- (void)qianYaFuHeGuanXiAction:(DLRadioButton*)bt
{
    CGPoint p = [bt convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath*indexPath = [self.tableView indexPathForRowAtPoint:p];
    ThreeBtOneNumCell*cell=(ThreeBtOneNumCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.rightNum setNumber:0];
    if (bt.selectedButton) {
        NSInteger t = 0;
        if ([bt isEqual:cell.first]) {
            t=1;
        }else if ([bt isEqual:cell.second]) {
            t=2;
        }else if ([bt isEqual:cell.third]) {
            t=3;
        }
        [self.qianYaFuHeGuanXi setObject:[NSString stringWithFormat:@"%d",(int)t] forKey:@"level"];
        [self.qianYaFuHeGuanXi setObject:[NSString stringWithFormat:@"%d",0] forKey:@"margin"];
    }else {
        [self.qianYaFuHeGuanXi removeObjectForKey:@"level"];
        [self.qianYaFuHeGuanXi removeObjectForKey:@"margin"];
    }
}
- (void)qianYaFuHeGuanXiNumBt:(UIButton*)numBt
{
    TwoBtLabel*label=[numBt getTwoBtLabel];
    if (label) {
        if ([self.qianYaFuHeGuanXi objectForKey:@"level"]) {
            [self.qianYaFuHeGuanXi setObject:[NSString stringWithFormat:@"%d",(int)[label number]] forKey:@"margin"];
        }else {
            ALERT1(@"请选择覆颌关系等级");
        }
    }
}

- (void)qianYaFuGaiGuanXiAction:(DLRadioButton*)bt
{
    CGPoint p = [bt convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath*indexPath = [self.tableView indexPathForRowAtPoint:p];
    ThreeBtOneNumCell*cell=(ThreeBtOneNumCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.rightNum setNumber:0];
    if (bt.selectedButton) {
        NSInteger t = 0;
        if ([bt isEqual:cell.first]) {
            t=1;
        }else if ([bt isEqual:cell.second]) {
            t=2;
        }else if ([bt isEqual:cell.third]) {
            t=3;
        }
        [self.qianYaFuGaiGuanXi setObject:[NSString stringWithFormat:@"%d",(int)t] forKey:@"level"];
        [self.qianYaFuGaiGuanXi setObject:[NSString stringWithFormat:@"%d",0] forKey:@"margin"];
    }else {
        [self.qianYaFuGaiGuanXi removeObjectForKey:@"level"];
        [self.qianYaFuGaiGuanXi removeObjectForKey:@"margin"];
    }
}
- (void)qianYaFuGaiGuanXiNumBt:(UIButton*)numBt
{
    TwoBtLabel*label=[numBt getTwoBtLabel];
    if (label) {
        if ([self.qianYaFuGaiGuanXi objectForKey:@"level"]) {
            [self.qianYaFuGaiGuanXi setObject:[NSString stringWithFormat:@"%d",(int)[label number]] forKey:@"margin"];
        }else {
            ALERT1(@"请选择覆盖关系等级");
        }
    }
}

- (void)qianYaKaiHeAction:(DLRadioButton*)bt
{
    CGPoint p = [bt convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath*indexPath = [self.tableView indexPathForRowAtPoint:p];
    ThreeBtOneNumCell*cell=(ThreeBtOneNumCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.rightNum setNumber:0];
    if (bt.selectedButton) {
        NSInteger t = 0;
        if ([bt isEqual:cell.first]) {
            t=1;
        }else if ([bt isEqual:cell.second]) {
            t=2;
        }else if ([bt isEqual:cell.third]) {
            t=3;
        }
        [self.qianYaKaiHe setObject:[NSString stringWithFormat:@"%d",(int)t] forKey:@"level"];
        [self.qianYaKaiHe setObject:[NSString stringWithFormat:@"%d",0] forKey:@"margin"];
    }else {
        [self.qianYaKaiHe removeObjectForKey:@"level"];
        [self.qianYaKaiHe removeObjectForKey:@"margin"];
    }
}
- (void)qianYaKaiHeNumBt:(UIButton*)numBt
{
    TwoBtLabel*label=[numBt getTwoBtLabel];
    if (label) {
        if ([self.qianYaKaiHe objectForKey:@"level"]) {
            [self.qianYaKaiHe setObject:[NSString stringWithFormat:@"%d",(int)[label number]] forKey:@"margin"];
        }else {
            ALERT1(@"请选择前牙开颌关系等级");
        }
    }
}

- (void)yaChiPaiLieYongJiActionTop:(DLRadioButton*)bt
{
    CGPoint p = [bt convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath*indexPath = [self.tableView indexPathForRowAtPoint:p];
    TwoThreeBtOneNumCell*cell=(TwoThreeBtOneNumCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.topRightNum setNumber:0];
    if (bt.selectedButton) {
        NSInteger t = 0;
        if ([bt isEqual:cell.topFirst]) {
            t=1;
        }else if ([bt isEqual:cell.topSecond]) {
            t=2;
        }else if ([bt isEqual:cell.topThird]) {
            t=3;
        }
        if ([self.yaChiPaiLieYongJi objectForKey:@"top"]) {
            NSMutableDictionary*dic=[self.yaChiPaiLieYongJi objectForKey:@"top"];
            [dic setObject:[NSString stringWithFormat:@"%d",(int)t] forKey:@"level"];
        }else {
            NSMutableDictionary*dic=[NSMutableDictionary dictionary];
            [dic setObject:[NSString stringWithFormat:@"%d",(int)t] forKey:@"level"];
            [dic setObject:[NSString stringWithFormat:@"%d",0] forKey:@"margin"];
            [self.yaChiPaiLieYongJi setObject:dic forKey:@"top"];
        }
    }else {
        [self.yaChiPaiLieYongJi setObject:[NSMutableDictionary dictionary] forKey:@"top"];
    }
}
- (void)yaChiPaiLieYongJiTopNumBt:(UIButton*)numBt
{
    TwoBtLabel*label=[numBt getTwoBtLabel];
    if (label) {
        if ([SafeValue([self.yaChiPaiLieYongJi objectForKey:@"top"], @{}) objectForKey:@"level"]) {
            NSMutableDictionary*dic=[self.yaChiPaiLieYongJi objectForKey:@"top"];
            [dic setObject:[NSString stringWithFormat:@"%d",(int)label.number] forKey:@"margin"];
        }else {
            ALERT1(@"请选择牙齿排列上排列等级");
        }
    }
}

- (void)yaChiPaiLieYongJiActionBottom:(DLRadioButton*)bt
{
    CGPoint p = [bt convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath*indexPath = [self.tableView indexPathForRowAtPoint:p];
    TwoThreeBtOneNumCell*cell=(TwoThreeBtOneNumCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.bottomRightNum setNumber:0];
    if (bt.selectedButton) {
        NSInteger t = 0;
        if ([bt isEqual:cell.bottomFirst]) {
            t=1;
        }else if ([bt isEqual:cell.bottomSecond]) {
            t=2;
        }else if ([bt isEqual:cell.bottomThird]) {
            t=3;
        }
        if ([self.yaChiPaiLieYongJi objectForKey:@"bottom"]) {
            NSMutableDictionary*dic=[self.yaChiPaiLieYongJi objectForKey:@"bottom"];
            [dic setObject:[NSString stringWithFormat:@"%d",(int)t] forKey:@"level"];
        }else {
            NSMutableDictionary*dic=[NSMutableDictionary dictionary];
            [dic setObject:[NSString stringWithFormat:@"%d",(int)t] forKey:@"level"];
            [dic setObject:[NSString stringWithFormat:@"%d",0] forKey:@"margin"];
            [self.yaChiPaiLieYongJi setObject:dic forKey:@"bottom"];
        }
    }else {
        [self.yaChiPaiLieYongJi setObject:[NSMutableDictionary dictionary] forKey:@"bottom"];
    }
}
- (void)yaChiPaiLieYongJiBottomNumBt:(UIButton*)numBt
{
    TwoBtLabel*label=[numBt getTwoBtLabel];
    if (label) {
        if ([SafeValue([self.yaChiPaiLieYongJi objectForKey:@"bottom"], @{}) objectForKey:@"level"]) {
            NSMutableDictionary*dic=[self.yaChiPaiLieYongJi objectForKey:@"bottom"];
            [dic setObject:[NSString stringWithFormat:@"%d",(int)label.number] forKey:@"margin"];
        }else {
            ALERT1(@"请选择牙齿排列下排列等级");
        }
    }
}
- (void)zhongXianTopBtAction:(DLRadioButton*)bt
{
    if (bt.selectedButton) {
        CGPoint p = [bt convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath*indexPath = [self.tableView indexPathForRowAtPoint:p];
        TwoTwoNumCell*cell=(TwoTwoNumCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.oneoneNum.number=0;
        cell.oneTwoNum.number=0;
        if ([self.zhongXian objectForKey:@"top"]) {
            NSMutableDictionary*dic=[self.zhongXian objectForKey:@"top"];
            [dic setObject:@"0" forKey:@"orientation"];
        }else {
            NSMutableDictionary*dic=[NSMutableDictionary dictionary];
            [dic setObject:@"0" forKey:@"orientation"];
            [self.zhongXian setObject:dic forKey:@"top"];
        }
    }else {
        [self.zhongXian setObject:[NSMutableDictionary dictionary] forKey:@"top"];
    }
}
- (void)zhongXianTopZuoPianNumBt:(UIButton*)numBt
{
    TwoBtLabel*label=[numBt getTwoBtLabel];
    if (label) {
        CGPoint p = [numBt convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath*indexPath = [self.tableView indexPathForRowAtPoint:p];
        TwoTwoNumCell*cell=(TwoTwoNumCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.oneTwoNum setNumber:0];
        cell.topBt.selected=NO;
        if ([self.zhongXian objectForKey:@"top"]) {
            NSMutableDictionary*dic=[self.zhongXian objectForKey:@"top"];
            [dic setObject:@"1" forKey:@"orientation"];
            [dic setObject:[NSString stringWithFormat:@"%d",(int)label.number] forKey:@"margin"];
        }else {
            NSMutableDictionary*dic=[NSMutableDictionary dictionary];
            [dic setObject:@"1" forKey:@"orientation"];
            [dic setObject:[NSString stringWithFormat:@"%d",(int)label.number] forKey:@"margin"];
            [self.zhongXian setObject:dic forKey:@"top"];
        }
    }
}
- (void)zhongXianTopYouPianNumBt:(UIButton*)numBt
{
    TwoBtLabel*label=[numBt getTwoBtLabel];
    if (label) {
        CGPoint p = [numBt convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath*indexPath = [self.tableView indexPathForRowAtPoint:p];
        TwoTwoNumCell*cell=(TwoTwoNumCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.oneoneNum setNumber:0];
        cell.topBt.selected=NO;
        if ([self.zhongXian objectForKey:@"top"]) {
            NSMutableDictionary*dic=[self.zhongXian objectForKey:@"top"];
            [dic setObject:@"2" forKey:@"orientation"];
            [dic setObject:[NSString stringWithFormat:@"%d",(int)label.number] forKey:@"margin"];
        }else {
            NSMutableDictionary*dic=[NSMutableDictionary dictionary];
            [dic setObject:@"2" forKey:@"orientation"];
            [dic setObject:[NSString stringWithFormat:@"%d",(int)label.number] forKey:@"margin"];
            [self.zhongXian setObject:dic forKey:@"top"];
        }
    }
}
- (void)zhongXianBottomBtAction:(DLRadioButton*)bt
{
    if (bt.selectedButton) {
        CGPoint p = [bt convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath*indexPath = [self.tableView indexPathForRowAtPoint:p];
        TwoTwoNumCell*cell=(TwoTwoNumCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        cell.twoOneNum.number=0;
        cell.twoTwoNum.number=0;
        if ([self.zhongXian objectForKey:@"bottom"]) {
            NSMutableDictionary*dic=[self.zhongXian objectForKey:@"bottom"];
            [dic setObject:@"0" forKey:@"orientation"];
        }else {
            NSMutableDictionary*dic=[NSMutableDictionary dictionary];
            [dic setObject:@"0" forKey:@"orientation"];
            [self.zhongXian setObject:dic forKey:@"bottom"];
        }
    }else {
        [self.zhongXian setObject:[NSMutableDictionary dictionary] forKey:@"bottom"];
    }
}
- (void)zhongXianBottomZuoPianNumBt:(UIButton*)numBt
{
    TwoBtLabel*label=[numBt getTwoBtLabel];
    if (label) {
        CGPoint p = [numBt convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath*indexPath = [self.tableView indexPathForRowAtPoint:p];
        TwoTwoNumCell*cell=(TwoTwoNumCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.twoTwoNum setNumber:0];
        cell.bottomBt.selected=NO;
        if ([self.zhongXian objectForKey:@"bottom"]) {
            NSMutableDictionary*dic=[self.zhongXian objectForKey:@"bottom"];
            [dic setObject:@"1" forKey:@"orientation"];
            [dic setObject:[NSString stringWithFormat:@"%d",(int)label.number] forKey:@"margin"];
        }else {
            NSMutableDictionary*dic=[NSMutableDictionary dictionary];
            [dic setObject:@"1" forKey:@"orientation"];
            [dic setObject:[NSString stringWithFormat:@"%d",(int)label.number] forKey:@"margin"];
            [self.zhongXian setObject:dic forKey:@"bottom"];
        }
    }
}
- (void)zhongXianBottomYouPianNumBt:(UIButton*)numBt
{
    TwoBtLabel*label=[numBt getTwoBtLabel];
    if (label) {
        CGPoint p = [numBt convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath*indexPath = [self.tableView indexPathForRowAtPoint:p];
        TwoTwoNumCell*cell=(TwoTwoNumCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        [cell.twoOneNum setNumber:0];
        cell.bottomBt.selected=NO;
        if ([self.zhongXian objectForKey:@"bottom"]) {
            NSMutableDictionary*dic=[self.zhongXian objectForKey:@"bottom"];
            [dic setObject:@"2" forKey:@"orientation"];
            [dic setObject:[NSString stringWithFormat:@"%d",(int)label.number] forKey:@"margin"];
        }else {
            NSMutableDictionary*dic=[NSMutableDictionary dictionary];
            [dic setObject:@"2" forKey:@"orientation"];
            [dic setObject:[NSString stringWithFormat:@"%d",(int)label.number] forKey:@"margin"];
            [self.zhongXian setObject:dic forKey:@"bottom"];
        }
    }
}

- (void)presentImagePickerWithHint:(NSString*)title
{
    QBImagePickerController*imagePickerController = [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.filterType=QBImagePickerControllerFilterTypePhotos;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    imagePickerController.prompt=title;
    [imagePickerController.selectedAssetURLs removeAllObjects];
    imagePickerController.maximumNumberOfSelection=1;
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}
- (void)zhengmianxiang
{
    self.imageViewIndex = [NSIndexPath indexPathForItem:0 inSection:0];
    [self presentImagePickerWithHint:@"正面像"];
}
- (void)cemianxiang
{
    self.imageViewIndex = [NSIndexPath indexPathForItem:1 inSection:0];
    [self presentImagePickerWithHint:@"侧面像"];
}
- (void)weixiaoxiang
{
    self.imageViewIndex = [NSIndexPath indexPathForItem:2 inSection:0];
    [self presentImagePickerWithHint:@"微笑像"];
}
- (void)kouneixiang
{
    self.imageViewIndex = [NSIndexPath indexPathForItem:0 inSection:1];
    [self presentImagePickerWithHint:@"正面口内像"];
}
- (void)ceweixiang
{
    self.imageViewIndex = [NSIndexPath indexPathForItem:1 inSection:1];
    [self presentImagePickerWithHint:@"侧位像"];
}
- (void)shangeweixiang
{
    self.imageViewIndex = [NSIndexPath indexPathForItem:0 inSection:2];
    [self presentImagePickerWithHint:@"上颌位像"];
}
- (void)xiaeweixiang
{
    self.imageViewIndex = [NSIndexPath indexPathForItem:1 inSection:2];
    [self presentImagePickerWithHint:@"下颌位像"];
}
- (void)xguangpian
{
    self.imageViewIndex = [NSIndexPath indexPathForItem:0 inSection:3];
    [self presentImagePickerWithHint:@"X光片"];
}
- (void)xguangpian1
{
    self.imageViewIndex = [NSIndexPath indexPathForItem:1 inSection:3];
    [self presentImagePickerWithHint:@"X光片"];
}
- (void)xguangpian2
{
    self.imageViewIndex = [NSIndexPath indexPathForItem:2 inSection:3];
    [self presentImagePickerWithHint:@"X光片"];
}
- (void)xguangpian3
{
    self.imageViewIndex = [NSIndexPath indexPathForItem:3 inSection:3];
    [self presentImagePickerWithHint:@"X光片"];
}


- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    NSLog(@"Selected assets:");
    NSLog(@"%@", assets);
    ALAsset*asset = [assets lastObject];
    UIImage*image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
    
    NSInteger section = self.imageViewIndex.section;
    NSInteger row = self.imageViewIndex.item;
    GetImageCell*cell = nil;
    if (section == 0) {
        cell = self.touxiang;
    }else if (section == 1) {
        cell = self.zhengmian;
    }else if (section == 2) {
        cell = self.shangxia;
    }else if (section == 3) {
        cell = self.xray;
    }
    if (cell) {
        if (row == 0) {
            [cell.firstImgView setImage:image];
        }else if (row == 1) {
            [cell.secondImgView setImage:image];
        }else if (row == 2) {
            [cell.thirdImgView setImage:image];
        }else if (row == 3) {
            [cell.lastImgView setImage:image];
        }
    }
    NSIndexPath * imageIndexPath = [NSIndexPath indexPathForItem:self.imageViewIndex.item inSection:self.imageViewIndex.section];
    [self uploadImageWithIndexPath:imageIndexPath image:image];
    self.imageViewIndex = [NSIndexPath indexPathForItem:-1 inSection:-1];
    
    NSLog(@"image %@",image);
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)uploadImageWithIndexPath:(NSIndexPath*)imageIndexPath image:(UIImage*)image
{
    NSMutableDictionary * dic = nil;
    NSString * recordType = @"";
    NSInteger x = imageIndexPath.section * 10 + imageIndexPath.item;
    switch (x) {
        case 0:{
            dic = self.touXiangPicUrl;
            recordType = @"zhengMianXiang";
        }
            break;
        case 1:{
            dic = self.touXiangPicUrl;
            recordType = @"ceMianXiang";
        }
            break;
        case 2:{
            dic = self.touXiangPicUrl;
            recordType = @"weiXiaoXiang";
        }
            break;
        case 10:{
            dic = self.zhengMianKouNeiPicUrl;
            recordType = @"zhengMianKouNeiXiang";
        }
            break;
        case 11:{
            dic = self.zhengMianKouNeiPicUrl;
            recordType = @"ceWeiXiang";
        }
            break;
        case 20:{
            dic = self.heWeiPicUrl;
            recordType = @"shangHeWeiXiang";
        }
            break;
        case 21:{
            dic = self.heWeiPicUrl;
            recordType = @"xiaHeWeiXiang";
        }
            break;
        case 30:{
            dic = self.xRayPicUrl;
            recordType = @"xRayPicUrl0";
        }
            break;
        case 31:{
            dic = self.xRayPicUrl;
            recordType = @"xRayPicUrl1";
        }
            break;
        case 32:{
            dic = self.xRayPicUrl;
            recordType = @"xRayPicUrl2";
        }
            break;
        case 33:{
            dic = self.xRayPicUrl;
            recordType = @"xRayPicUrl3";
        }
            break;
            
        default:
            break;
    }
    
    /**
     pic	byte[]	必需	图片
     recordId	int	必需	病历ID
     picType	String	必需	图片类型后缀:jgp,png等
     recordType	String	必需	病历图片类型，如”正面像”等，建议用英文字母代替中文
     */
    uploadCount +=1;
    dispatch_group_async(self.group, self.queue, ^{
        [[[QMRequest alloc] init] uploadImages:image withPackage:@{@"picType":@"png",@"recordType":recordType} post:YES apiType:UploadCasePic completion:^(BOOL success, NSError *error, NSDictionary *result) {
            finishCount += 1;
            if (success && [[result objectForKey:@"data"] objectForKey:@"picURL"]) {
                NSString*imageUrl = SafeValue([[result objectForKey:@"data"] objectForKey:@"picURL"], @"");
                [dic setObject:imageUrl forKey:recordType];
            }
            if (uploadCount == finishCount && tijiaole) {
                [self tijiaoAction:nil];
            }
        }];
    });
}

- (IBAction)tijiaoAction:(UIButton*)sender {
    if (uploadCount != finishCount) {
        sender.enabled = NO;
        tijiaole = YES;
        return;
    }
    dispatch_group_notify(self.group, self.queue, ^{
        
    for (NSIndexPath*idx in self.imageDic.allKeys) {
        NSInteger x = idx.section * 10 + idx.item;
        id url = nil;
        NSString * message;
        switch (x) {
            case 0:{url=[self.touXiangPicUrl objectForKey:@"zhengMianXiang"];
                message=@"正面像";
            }break;
            case 1:{url=[self.touXiangPicUrl objectForKey:@"ceMianXiang"];
                message=@"侧面像";
            }break;
            case 2:{url=[self.touXiangPicUrl objectForKey:@"weiXiaoXiang"];
                message=@"微笑像";
            }break;
            case 10:{url=[self.zhengMianKouNeiPicUrl objectForKey:@"zhengMianKouNeiXiang"];
                message=@"正面像口内像";
            }break;
            case 11:{url=[self.zhengMianKouNeiPicUrl objectForKey:@"ceWeiXiang"];
                message=@"侧位像";
            }break;
            case 20:{url=[self.heWeiPicUrl objectForKey:@"shangHeWeiXiang"];
                message=@"上颌位像";
            }break;
            case 21:{url=[self.heWeiPicUrl objectForKey:@"xiaHeWeiXiang"];
                message=@"下颌位像";
            }break;
            case 30:{url=[self.xRayPicUrl objectForKey:@"xRayPicUrl0"];
                message=@"第1张xRay";
            }break;
            case 31:{url=[self.xRayPicUrl objectForKey:@"xRayPicUrl1"];
                message=@"第2张xRay";
            }break;
            case 32:{url=[self.xRayPicUrl objectForKey:@"xRayPicUrl2"];
                message=@"第3张xRay";
            }break;
            case 33:{url=[self.xRayPicUrl objectForKey:@"xRayPicUrl3"];
                message=@"第4张xRay";
            }break;
                
            default:
                break;
        }
        if (url==nil || [url isEqual:[NSNull null]] || [url  isEqual: @""] || url == NULL) {
            DLog(@" %@ 有问题，或者没传上去",message);
            DLog(@"图像为 %@",[self.imageDic objectForKey:idx]);
            return;
        }
    }
    
    
    
    NSMutableDictionary*dictionary=[NSMutableDictionary dictionary];
    NSMutableArray*mutableArr = [NSMutableArray array];
    for (NSDictionary*dic in self.toothStatusList) {
        NSString*ind = [dic objectForKey:@"toothIndex"];
        NSArray*status=[dic objectForKey:@"status"];
        [mutableArr addObject:@{@"toothIndex":ind,@"status":[status componentsJoinedByString:@","]}];
    }
    [dictionary setObject:mutableArr forKey:@"toothStatusList"];
    [dictionary setObject:self.wear_check forKey:@"wear_check"];
    [dictionary setObject:self.moYaGuanxi forKey:@"moYaGuanxi"];
    [dictionary setObject:[NSString stringWithFormat:@"%d",(int)self.heLeixing] forKey:@"heLeixing"];
    [dictionary setObject:[NSString stringWithFormat:@"%d",(int)self.fanHe] forKey:@"fanHe"];
    [dictionary setObject:[NSString stringWithFormat:@"%d",(int)self.xiaHeHouTui] forKey:@"xiaHeHouTui"];
    [dictionary setObject:[NSString stringWithFormat:@"%d",(int)self.shangHeJianYa] forKey:@"shangHeJianYa"];
    [dictionary setObject:[NSString stringWithFormat:@"%d",(int)self.chunJiaXiang] forKey:@"chunJiaXiang"];
    [dictionary setObject:[NSString stringWithFormat:@"%d",(int)self.sheEXiang] forKey:@"sheEXiang"];
    [dictionary setObject:[NSString stringWithFormat:@"%d",(int)self.kaiHe] forKey:@"kaiHe"];
    [dictionary setObject:[NSString stringWithFormat:@"%d",(int)self.yongJi] forKey:@"yongJi"];
    [dictionary setObject:[NSString stringWithFormat:@"%d",(int)self.suoHe] forKey:@"suoHe"];
    [dictionary setObject:self.qianYaFuHeGuanXi forKey:@"qianYaFuHeGuanXi"];
    [dictionary setObject:self.qianYaFuGaiGuanXi forKey:@"qianYaFuGaiGuanXi"];
    [dictionary setObject:self.qianYaKaiHe forKey:@"qianYaKaiHe"];
    [dictionary setObject:self.yaChiPaiLieYongJi forKey:@"yaChiPaiLieYongJi"];
    [dictionary setObject:self.zhongXian forKey:@"zhongXian"];
    [dictionary setObject:self.touXiangPicUrl forKey:@"touXiangPicUrl"];
    [dictionary setObject:self.zhengMianKouNeiPicUrl forKey:@"zhengMianKouNeiPicUrl"];
    [dictionary setObject:self.heWeiPicUrl forKey:@"heWeiPicUrl"];
    [dictionary setObject:self.xRayPicUrl forKey:@"xRayPicUrl"];
    [dictionary setObject:SafeValue(self.wear_time.text, @"") forKey:@"wear_time"];
    [dictionary setObject:SafeValue(self.doctor_suggest.text, @"") forKey:@"doctor_suggest"];
    
    
    
    
    DLog(@"result %@",dictionary);
//    NSMutableArray*arr = [NSMutableArray array];
//    
//    if ([self.patient.recordDetails isKindOfClass:[NSArray class]]) {
//        arr = [NSMutableArray arrayWithArray:self.patient.recordDetails];
//    }
//    [arr addObject:@{@"comment_id" : @"<null>",
//                     @"comment_star" : @"<null>",
//                     @"create_time" : @"today",
//                     @"doctor_id" : @"2",
//                     @"pics_url" : @"<null>",
//                     @"record_detail" : dictionary,
//                     @"record_id" : @"6",
//                     @"record_type" : @"2",
//                     @"update_time" : @"<null>",
//                     @"user_id" : @"3"}];
//    self.patient.recordDetails = arr;
    
    
    NSError *error;
    NSString * jsString = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (!jsonData || error) {
        NSString *e = [NSString stringWithFormat:@"Got an error: %@", error];
        ALERT1(e);
        return;
    }
    jsString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //    jsString = [dictionary JSONRepresentation];
    sender.enabled = NO;
    AppDelegate*app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [[[QMRequest alloc] init] startWithPackage:@{@"userId":self.patient.userId,
                                                 @"type":@"2",
                                                 @"doctorId":app.myself.doctorId,
                                                 @"recordDetail":jsString}
                                          post:YES
                                       apiType:UploadCaseInfo
                                    completion:^(BOOL success, NSError *error, NSDictionary *result)
     {
         if (success) {
             NSMutableArray*arr = [NSMutableArray array];
             
             if ([self.patient.recordDetails isKindOfClass:[NSArray class]]) {
                 arr = [NSMutableArray arrayWithArray:self.patient.recordDetails];
             }
#warning 不一定是这个key,没有数据
 //            [arr addObject:[result objectForKey:@"data"]];
#warning 测试
             [arr addObject:@{@"comment_id" : @"<null>",
                              @"comment_star" : @"<null>",
                              @"create_time" : @"today",
                              @"doctor_id" : @"2",
                              @"pics_url" : @"<null>",
                              @"record_detail" : dictionary,
                              @"record_id" : @"6",
                              @"record_type" : @"2",
                              @"update_time" : @"<null>",
                              @"user_id" : @"3"}];
             self.patient.recordDetails = arr;
             [self __back];
         }else {
             ALERT1(@"提交出错");
             sender.enabled=YES;
         }
     }];
        
    });
    
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
