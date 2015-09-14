//
//  Check.m
//  QMKQ
//
//  Created by shangjin on 15/8/9.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "Check.h"
#import "UCNameCell.h"
#import "TwoBtCell.h"
#import "ThreeBtCell.h"
#import "TwoFourBtCell.h"
#import "ThreeBtNoLeftCell.h"
#import "FourBtNoLeftCell.h"
#import "FourTwoBtCell.h"
#import "DocAdviceCell.h"
#import "QMPatientTeethCell.h"
#import "UserCaseConfig.h"
#import "Tools.h"
#import "config.h"
#import "CaseHeaderView.h"
#import "QMRequest.h"
#import "AppDelegate.h"
#import "JSON.h"

@interface Check () <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) FourBtNoLeftCell*toothFour;
@property (nonatomic, retain) ThreeBtNoLeftCell*toothThree;

@property (nonatomic, strong) NSString * tooth;
@property (nonatomic, strong) NSMutableArray * jibenzhuangkuang;//每颗牙齿的基本状况
@property (nonatomic, strong) NSMutableDictionary * moyaguanxi;//磨牙关系
@property (nonatomic, strong) NSMutableDictionary * yalieyongji;//牙列拥挤
@property (nonatomic, strong) NSMutableDictionary * yiweimochu;//第一恒压磨牙异位磨出
@property (nonatomic, assign) NSInteger qianyafuhe;//前牙覆颌
@property (nonatomic, assign) NSInteger qianyafugai;//前牙覆盖
@property (nonatomic, assign) NSInteger xiayashange;//下牙与上腭软组织接触
@property (nonatomic, assign) NSInteger qianyakaihe;//前牙开颌
@property (nonatomic, assign) NSInteger qianyafanhe;//前牙反颌
@property (nonatomic, assign) NSInteger houyafanhe;//后牙反颌
@property (nonatomic, assign) NSInteger houyasuohe;//后牙锁颌
@property (nonatomic, retain) UITextView * advice;
@property (nonatomic, retain) UILabel * hint;

@end

@implementation Check

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftButtonItem];
    
    UIView*footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    footView.backgroundColor=self.tableView.backgroundColor;
    self.tableView.tableFooterView=footView;
    [self.tableView registerClass:[QMPatientTeethCell class] forCellReuseIdentifier:@"QMPatientTeethCell"];
    // Do any additional setup after loading the view.
    [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignFirst)]];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    self.jibenzhuangkuang=[NSMutableArray array];
    self.moyaguanxi=[NSMutableDictionary dictionary];
    self.yalieyongji=[NSMutableDictionary dictionary];
    self.yiweimochu=[NSMutableDictionary dictionary];
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
    return 3;
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
    else if (section == 2) title = @"咬颌评估:";
    CaseHeaderView*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"checkHeader"];
    if (!view) {
        view = [[CaseHeaderView alloc]initWithReuseIdentifier:@"checkHeader"];
    }
    view.textLabel.text = title;
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger number = 0;
    if (section == 0) number = 1;
    else if (section == 1) number = 3;
    else if (section == 2) number = 11;
    return number;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = CellDefaultHeight;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 1) {
        if (row == 0) height = ScreenWidth;
    }else if (section == 2) {
        if (row == 0) height = TwoFourBtCellHeight;
        else if (row == 8) height = TwoThreeBtOneNumCellHeight;
        else if (row == 9) height = FourTwoBtCellHeight;
        else if (row == 10) height = DocAdviceCellHeight;
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
            identifierString = @"QMPatientTeethCell";
            QMPatientTeethCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            [cel addTarget:self andAction:@selector(selectTooth:)];
            cell = cel;
        }else if (row == 1) {
            identifierString = @"FourBtNoLeftCell";
            FourBtNoLeftCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];//qu
            self.toothFour=cel;
            [cel.first setTitle:@"龋齿" forState:0];
            [cel.second setTitle:@"缺失" forState:0];
            [cel.third setTitle:@"填充" forState:0];
            [cel.last setTitle:@"早萌" forState:0];
            NSMutableArray*status=[NSMutableArray array];
            for (NSDictionary*dic in self.jibenzhuangkuang) {
                NSString*ind = [dic objectForKey:@"toothIndex"];
                if ([self.tooth isEqualToString:ind]) {
                    [status addObject:[dic objectForKey:@"status"]];
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
                    }else if (st == 3) {
                        [cel.last setSelected:YES];
                    }
                }
            }
            [cel.first addTarget:self action:@selector(toothAction:) forControlEvents:UIControlEventTouchUpInside];
            [cel.second addTarget:self action:@selector(toothAction:) forControlEvents:UIControlEventTouchUpInside];
            [cel.third addTarget:self action:@selector(toothAction:) forControlEvents:UIControlEventTouchUpInside];
            [cel.last addTarget:self action:@selector(toothAction:) forControlEvents:UIControlEventTouchUpInside];
            cell = cel;
        }else if (row == 2) {
            identifierString = @"ThreeBtNoLeftCell";
            ThreeBtNoLeftCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            self.toothThree=cel;
            [cel.first setTitle:@"根管治疗" forState:0];
            [cel.second setTitle:@"窝沟封闭" forState:0];
            [cel.third setTitle:@"剩余乳牙" forState:0];
            NSMutableArray*status=[NSMutableArray array];
            for (NSDictionary*dic in self.jibenzhuangkuang) {
                NSString*ind = [dic objectForKey:@"toothIndex"];
                if ([self.tooth isEqualToString:ind]) {
                    [status addObject:[dic objectForKey:@"status"]];
                }
            }
            if (status.count>0) {
                for (id num in status) {
                    NSInteger st = [num intValue];
                    if (st == 4) {
                        [cel.first setSelected:YES];
                    }else if (st == 5) {
                        [cel.second setSelected:YES];
                    }else if (st == 6) {
                        [cel.third setSelected:YES];
                    }
                }
            }
            [cel.first addTarget:self action:@selector(toothAction:) forControlEvents:UIControlEventTouchUpInside];
            [cel.second addTarget:self action:@selector(toothAction:) forControlEvents:UIControlEventTouchUpInside];
            [cel.third addTarget:self action:@selector(toothAction:) forControlEvents:UIControlEventTouchUpInside];
            cell = cel;
        }
    }else if (section == 2) {
        if (row == 0) {
            identifierString = @"TwoFourBtCell";
            TwoFourBtCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.title.text = @"磨牙关系";
            cel.topLeft.text = @"左";
            cel.bottomLeft.text = @"右";
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
        }else if (row >= 1 && row <= 7 && row != 3) {
            identifierString = @"ThreeBtCell";
            ThreeBtCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            [cel.first setTitle:oneString forState:0];
            [cel.second setTitle:twoString forState:0];
            [cel.third setTitle:threeString forState:0];
            [Tools button:cel.first removeAllActionsFromTarget:self];
            [Tools button:cel.first andOthersButtonAddTarget:self action:@selector(threeBtAction:)];
            NSString *left = @"";
            if (row == 1) {
                left = @"前牙覆颌关系";
            }else if (row == 2) {
                left = @"前牙覆盖关系";
            }else if (row == 4) {
                left = @"前牙开颌";
            }else if (row == 5) {
                left = @"前牙反颌";
            }else if (row == 6) {
                left = @"后牙反颌";
            }else if (row == 7) {
                left = @"后牙锁颌";
            }
            cel.leftLabel.text = left;
            cell = cel;
        }else if (row == 3) {
            identifierString = @"TwoBtCell";
            TwoBtCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.leftLabel.text = @"下牙与上腭软组织接触";
            [cel.first setTitle:@"是" forState:0];
            [cel.last setTitle:@"否" forState:0];
            [Tools button:cel.first removeAllActionsFromTarget:self];
            [Tools button:cel.first andOthersButtonAddTarget:self action:@selector(ruanzuzhiAction:)];
            cell = cel;
        }else if (row == 8) {
            identifierString = @"TwoFourBtCell";
            TwoFourBtCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.TopFourth.hidden=YES;
            cel.bottomFourth.hidden = YES;
            [cel.topFirst setTitle:oneString forState:0];
            [cel.topSecond setTitle:twoString forState:0];
            [cel.topThird setTitle:threeString forState:0];
            [Tools button:cel.topFirst removeAllActionsFromTarget:self];
            [Tools button:cel.topFirst andOthersButtonAddTarget:self action:@selector(yalieyongjiActionTop:)];
            [cel.bottomFirst setTitle:oneString forState:0];
            [cel.bottomSecond setTitle:twoString forState:0];
            [cel.bottomThird setTitle:threeString forState:0];
            [Tools button:cel.bottomFirst removeAllActionsFromTarget:self];
            [Tools button:cel.bottomFirst andOthersButtonAddTarget:self action:@selector(yalieyongjiActionBottom:)];
            cel.title.text = @"牙列拥挤";
            cell = cel;
        }else if (row == 9) {
            identifierString = @"FourTwoBtCell";
            FourTwoBtCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.title.text = @"第一恒压磨牙异位磨出";
            cel.oneLeft.text = @"左上";
            [cel.oneFirst setTitle:@"正常" forState:0];
            [cel.oneLast setTitle:@"不正常" forState:0];
            [Tools button:cel.oneLast removeAllActionsFromTarget:self];
            [Tools button:cel.oneLast andOthersButtonAddTarget:self action:@selector(yiweimochuOneAction:)];
            cel.twoLeft.text = @"左下";
            [cel.twoFirst setTitle:@"正常" forState:0];
            [cel.twoLast setTitle:@"不正常" forState:0];
            [Tools button:cel.twoFirst removeAllActionsFromTarget:self];
            [Tools button:cel.twoFirst andOthersButtonAddTarget:self action:@selector(yiweimochuTwoAction:)];
            cel.threeLeft.text = @"右上";
            [cel.threeFirst setTitle:@"正常" forState:0];
            [cel.threeLast setTitle:@"不正常" forState:0];
            [Tools button:cel.threeFirst removeAllActionsFromTarget:self];
            [Tools button:cel.threeFirst andOthersButtonAddTarget:self action:@selector(yiweimochuThreeAction:)];
            cel.fourLeft.text = @"右下";
            [cel.fourFirst setTitle:@"正常" forState:0];
            [cel.fourLast setTitle:@"不正常" forState:0];
            [Tools button:cel.fourFirst removeAllActionsFromTarget:self];
            [Tools button:cel.fourFirst andOthersButtonAddTarget:self action:@selector(yiweimochuFourAction:)];
            cell = cel;
        }else if (row == 10) {
            identifierString = @"DocAdviceCell";
            DocAdviceCell*cel = [tableView dequeueReusableCellWithIdentifier:identifierString];
            cel.title.text = @"医生建议";
            cel.hint.text = @"请详细的描写患者的口腔状况和治疗建议。";
            self.advice=cel.textView;
            self.hint=cel.hint;
            cel.textView.delegate=self;
            cell = cel;
        }
    }
    
    CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
    if ([cell viewWithTag:200]) {
        CGRect r = [cell viewWithTag:200].frame;
        r.origin.y=height -0.5;
        r.size.height = 0.5f;
        [cell viewWithTag:200].frame = r;
    }else {
        if (row == 10 && section == 2) {
            
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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.hint.hidden=YES;
    self.hint.enabled=NO;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    if (textView.text.length>0) {
    }else {
        self.hint.hidden=NO;
        self.hint.enabled=YES;
    }
    return YES;
}

- (void)selectTooth:(UIButton*)bt
{
    self.tooth=bt.currentTitle;
    [self.toothThree.first setSelected:NO];
    [self.toothThree.second setSelected:NO];
    [self.toothThree.third setSelected:NO];
    [self.toothFour.first setSelected:NO];
    [self.toothFour.second setSelected:NO];
    [self.toothFour.third setSelected:NO];
    [self.toothFour.last setSelected:NO];
    
    [self.tableView reloadData];
}

- (void)toothAction:(DLRadioButton*)bt
{
    if ((self.tooth.length>0) && self.tooth != nil) {
    NSNumber* sta = @-1;
    //牙齿状态：0龋齿，1缺失，2充填，3早萌，4根管治疗，5窝沟封闭，6剩余乳牙
    if ([bt.currentTitle isEqualToString:@"龋齿"]) {
        sta=@0;
    }else if ([bt.currentTitle isEqualToString:@"缺失"]) {
        sta=@1;
    }else if ([bt.currentTitle isEqualToString:@"填充"]) {
        sta=@2;
    }else if ([bt.currentTitle isEqualToString:@"早萌"]) {
        sta=@3;
    }else if ([bt.currentTitle isEqualToString:@"根管治疗"]) {
        sta=@4;
    }else if ([bt.currentTitle isEqualToString:@"窝沟封闭"]) {
        sta=@5;
    }else if ([bt.currentTitle isEqualToString:@"剩余乳牙"]) {
        sta=@6;
    }
        NSMutableArray*arr=self.jibenzhuangkuang;
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
        [self.moyaguanxi setValue:[NSString stringWithFormat:@"%d",(int)t] forKey:@"left"];
    }else {
        [self.moyaguanxi removeObjectForKey:@"left"];
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
        [self.moyaguanxi setValue:[NSString stringWithFormat:@"%d",(int)t] forKey:@"right"];
    }else {
        [self.moyaguanxi removeObjectForKey:@"right"];
    }
}

- (void)threeBtAction:(DLRadioButton*)bt
{
    if (!bt.selectedButton) {
        return;
    }
    CGPoint p = [bt convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath*indexPath = [self.tableView indexPathForRowAtPoint:p];
    ThreeBtCell*cell=(ThreeBtCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    NSInteger t = 0;
    if (bt.selectedButton) {
        if ([bt isEqual:cell.first]) {
            t=1;
        }else if ([bt isEqual:cell.second]) {
            t=2;
        }else if ([bt isEqual:cell.third]) {
            t=3;
        }
    }
    if ([cell.leftLabel.text isEqualToString:@"前牙覆颌关系"]) {
        self.qianyafuhe=t;
    }else if ([cell.leftLabel.text isEqualToString:@"前牙覆盖关系"]) {
        self.qianyafugai=t;
    }else if ([cell.leftLabel.text isEqualToString:@"前牙开颌"]) {
        self.qianyakaihe=t;
    }else if ([cell.leftLabel.text isEqualToString:@"前牙反颌"]) {
        self.qianyafanhe=t-1;
    }else if ([cell.leftLabel.text isEqualToString:@"后牙反颌"]) {
        self.houyafanhe=t-1;
    }else if ([cell.leftLabel.text isEqualToString:@"后牙锁颌"]) {
        self.houyasuohe=t-1;
    }
}

- (void)ruanzuzhiAction:(DLRadioButton*)bt
{
    if (bt.selectedButton) {
        if ([bt.selectedButton.currentTitle isEqualToString:@"是"]) {
            self.xiayashange=1;
        }else {
            self.xiayashange=0;
        }
    }
}

- (void)yalieyongjiActionTop:(DLRadioButton*)bt
{
    if (bt.selectedButton) {
        CGPoint p = [bt convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath*indexPath = [self.tableView indexPathForRowAtPoint:p];
        TwoFourBtCell*cell=(TwoFourBtCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        NSInteger t = 0;
        if ([bt isEqual:cell.topFirst]) {
            t=1;
        }else if ([bt isEqual:cell.topSecond]) {
            t=2;
        }else if ([bt isEqual:cell.topThird]) {
            t=3;
        }
        [self.yalieyongji setValue:[NSString stringWithFormat:@"%d",(int)t] forKey:@"top"];
    }else {
        [self.yalieyongji removeObjectForKey:@"top"];
    }
}
- (void)yalieyongjiActionBottom:(DLRadioButton*)bt
{
    if (bt.selectedButton) {
        CGPoint p = [bt convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath*indexPath = [self.tableView indexPathForRowAtPoint:p];
        TwoFourBtCell*cell=(TwoFourBtCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        NSInteger t = 0;
        if ([bt isEqual:cell.bottomFirst]) {
            t=1;
        }else if ([bt isEqual:cell.bottomSecond]) {
            t=2;
        }else if ([bt isEqual:cell.bottomThird]) {
            t=3;
        }
        [self.yalieyongji setValue:[NSString stringWithFormat:@"%d",(int)t] forKey:@"bottom"];
    }else {
        [self.yalieyongji removeObjectForKey:@"bottom"];
    }
}

- (void)yiweimochuOneAction:(DLRadioButton*)bt
{
    if (bt.selectedButton) {
        CGPoint p = [bt convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath*indexPath = [self.tableView indexPathForRowAtPoint:p];
        FourTwoBtCell*cell=(FourTwoBtCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        NSInteger t = 0;
        if ([bt isEqual:cell.oneFirst]) {
        }else if ([bt isEqual:cell.oneLast]) {
            t=1;
        }
        [self.yiweimochu setValue:[NSString stringWithFormat:@"%d",(int)t] forKey:@"left_top"];
    }else {
        [self.yiweimochu removeObjectForKey:@"left_top"];
    }
}

- (void)yiweimochuTwoAction:(DLRadioButton*)bt
{
    if (bt.selectedButton) {
        CGPoint p = [bt convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath*indexPath = [self.tableView indexPathForRowAtPoint:p];
        FourTwoBtCell*cell=(FourTwoBtCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        NSInteger t = 0;
        if ([bt isEqual:cell.twoFirst]) {
        }else if ([bt isEqual:cell.twoLast]) {
            t=1;
        }
        [self.yiweimochu setValue:[NSString stringWithFormat:@"%d",(int)t] forKey:@"left_bottom"];
    }else {
        [self.yiweimochu removeObjectForKey:@"left_bottom"];
    }
}
- (void)yiweimochuThreeAction:(DLRadioButton*)bt
{
    if (bt.selectedButton) {
        CGPoint p = [bt convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath*indexPath = [self.tableView indexPathForRowAtPoint:p];
        FourTwoBtCell*cell=(FourTwoBtCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        NSInteger t = 0;
        if ([bt isEqual:cell.threeFirst]) {
        }else if ([bt isEqual:cell.threeLast]) {
            t=1;
        }
        [self.yalieyongji setValue:[NSString stringWithFormat:@"%d",(int)t] forKey:@"right_top"];
    }else {
        [self.yalieyongji removeObjectForKey:@"right_top"];
    }
}
- (void)yiweimochuFourAction:(DLRadioButton*)bt
{
    if (bt.selectedButton) {
        CGPoint p = [bt convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath*indexPath = [self.tableView indexPathForRowAtPoint:p];
        FourTwoBtCell*cell=(FourTwoBtCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        NSInteger t = 0;
        if ([bt isEqual:cell.fourFirst]) {
        }else if ([bt isEqual:cell.fourLast]) {
            t=1;
        }
        [self.yalieyongji setValue:[NSString stringWithFormat:@"%d",(int)t] forKey:@"right_bottom"];
    }else {
        [self.yalieyongji removeObjectForKey:@"right_bottom"];
    }
}
- (IBAction)tijiaoAction:(UIButton*)sender {
    NSMutableDictionary*dictionary=[NSMutableDictionary dictionary];
    
    NSMutableArray*mutableArr = [NSMutableArray array];
    for (NSDictionary*dic in self.jibenzhuangkuang) {
        NSString*ind = [dic objectForKey:@"toothIndex"];
        NSArray*status=[dic objectForKey:@"status"];
        [mutableArr addObject:@{@"toothIndex":ind,@"status":[status componentsJoinedByString:@","]}];
    }
    [dictionary setObject:mutableArr forKey:@"toothStatusList"];
    [dictionary setObject:self.moyaguanxi forKey:@"moYaGuanxi"];
    [dictionary setObject:[NSString stringWithFormat:@"%d",(int)self.qianyafuhe] forKey:@"qianYaFuHeGuanXi"];
    [dictionary setObject:[NSString stringWithFormat:@"%d",(int)self.qianyafugai] forKey:@"qianYaFuGaiGuanXi"];
    [dictionary setObject:[NSString stringWithFormat:@"%d",(int)self.xiayashange] forKey:@"xiaYaYuShangE"];
    [dictionary setObject:[NSString stringWithFormat:@"%d",(int)self.qianyakaihe] forKey:@"qianYaKaiHe"];
    [dictionary setObject:[NSString stringWithFormat:@"%d",(int)self.qianyafanhe] forKey:@"qianYaFanHe"];
    [dictionary setObject:[NSString stringWithFormat:@"%d",(int)self.houyafanhe] forKey:@"houYaFanHe"];
    [dictionary setObject:[NSString stringWithFormat:@"%d",(int)self.houyasuohe] forKey:@"houYaSuoHe"];
    [dictionary setObject:self.yalieyongji forKey:@"yaChiYongJi"];
    [dictionary setObject:self.yiweimochu forKey:@"diYiHengMoYa"];
    [dictionary setObject:SafeValue(self.advice.text, @"") forKey:@"doctor_suggest"];
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
//                     @"record_type" : @"0",
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
    sender.enabled=NO;
    AppDelegate*app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [[[QMRequest alloc] init] startWithPackage:@{@"userId":self.patient.userId,
                                                 @"type":@"0",
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
#warning 不一定是这个key
//            [arr addObject:[result objectForKey:@"data"]];
#warning 测试
            [arr addObject:@{@"comment_id" : @"<null>",
                            @"comment_star" : @"<null>",
                            @"create_time" : @"today",
                            @"doctor_id" : @"2",
                            @"pics_url" : @"<null>",
                            @"record_detail" : dictionary,
                            @"record_id" : @"6",
                            @"record_type" : @"0",
                            @"update_time" : @"<null>",
                             @"user_id" : @"3"}];
            self.patient.recordDetails = arr;
            [self __back];
        }else {
            ALERT1(@"提交出错");
            sender.enabled=YES;
        }
    }];
    
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
