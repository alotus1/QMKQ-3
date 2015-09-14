//
//  Friend.m
//  QMKQ
//
//  Created by shangjin on 15/8/1.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "Friend.h"
#import "pinyin.h"
#import "FriendDetail.h"
#import "config.h"
#import "Patient.h"
#import <UIImageView+AFNetworking.h>
#import "FriendCell.h"
#import "FriendHeaderView.h"
#import "QMRequest.h"
#import "AppDelegate.h"
#import "AppDelegate+TestData.h"

@interface Friend () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray* contacts;//初始数据
@property (nonatomic, strong) NSMutableArray *sectionArray;//按第一个字母排序的二维名字的数组
/**
 * 用于定位，其实遍历名字就行了，之所以写这个是为了查找同名，和sectionArray一样是个二维数组
    可以放弃使用sectionArray，用这个提供tableview代理
 */
@property (nonatomic, strong) NSMutableArray *sectionIndexArray;
/**
 * 用于搜索筛选
 */
@property (nonatomic, strong) NSMutableDictionary *contactNameDic;//第一个字母开头的字典

@end

@implementation Friend


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"用户";
    
    // tableView
    self.tableView.backgroundColor=BgColor;
    UIView*footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.tabBarController.tabBar.frame.size.height)];
    footView.backgroundColor=self.tableView.backgroundColor;
    self.tableView.tableFooterView=footView;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.sectionIndexColor = NavigationBarBG;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexTrackingBackgroundColor = BgColor;
    
    //初始化数据
    self.sectionArray = [NSMutableArray array];
    self.sectionIndexArray=[NSMutableArray array];
    self.contactNameDic = [NSMutableDictionary dictionary];
    // 清空索引表
    for (int i = 0; i < ALPHA.length; i++) {
        [self.sectionArray addObject:[NSMutableArray array]];
        [self.sectionIndexArray addObject:[NSMutableArray array]];
    }
    //时时更新
    [self getPatients];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //更新详细页面的更新
    [self addPatients];
}

- (void)getPatients
{
    AppDelegate*app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    //朋友列表
    [[[QMRequest alloc]init] startWithPackage:@{@"doctorId":app.myself.doctorId} post:NO apiType:GetUserList completion:^(BOOL success, NSError *error, NSDictionary *result) {
        if (success) {
            [Patient createTableWithName:PatientInfoStoreKey andPropertyList:[Patient getPropertyListWithPrimaryKey:@[@"userId"]] result:^(TableState state) {
                if (state == TableStateExist || state == TableStateCreateSuccess) {
                    [Patient clearTableWithName:PatientInfoStoreKey result:^(HandleState state) {
                        if (state == HandleStateSuccess) {
                            //如果有数据
                            for (NSDictionary*pati in [result objectForKey:@"data"]) {
                                Patient*patient = [[Patient alloc]init];
                                [patient updateDataFromDictionary:pati];
                                [patient addToTableWithTableName:PatientInfoStoreKey result:nil];
                            }
                            //添加完所有数据重新获取
                            [self addPatients];
                        }
                    }];
                }
            }];
        }
    }];
}

- (void)addPatients
{
    [Patient selectTableWithName:PatientInfoStoreKey sqlString:nil result:^(HandleState state, NSArray *results) {
        if (state == HandleStateSuccess) {
            NSMutableArray * arr = [NSMutableArray arrayWithArray:results];
            for (NSInteger i = 0; i<arr.count; i++) {
                for (NSInteger j = i+1; j<arr.count; j++) {
                    Patient*pi = [arr objectAtIndex:i];
                    Patient*pj = [arr objectAtIndex:j];
                    if ([pi.userId intValue] > [pj.userId intValue]) {
                        [arr replaceObjectAtIndex:i withObject:pj];
                        [arr replaceObjectAtIndex:j withObject:pi];
                    }
                }
            }
            self.contacts=[NSArray arrayWithArray:arr];
            [self getDataFromContent];
            [self.tableView reloadData];
        }
    }];
}

- (void)getDataFromContent
{
    self.sectionArray = [NSMutableArray array];
    self.sectionIndexArray=[NSMutableArray array];
    self.contactNameDic = [NSMutableDictionary dictionary];
    // 清空索引表
    for (int i = 0; i < ALPHA.length; i++) {
        [self.sectionArray addObject:[NSMutableArray array]];
        [self.sectionIndexArray addObject:[NSMutableArray array]];
    }
    // 根据名字获取信息
    for (Patient *contact in self.contacts)
    {
        NSString *string = contact.name;
        // 获取第一个字母
        NSString * sectionName = nil;
        if([self searchText:@"曾" inString:string])
            sectionName = @"Z";
        else if([self searchText:@"解" inString:string])
            sectionName = @"X";
        else if([self searchText:@"仇" inString:string])
            sectionName = @"Q";
        else if([self searchText:@"朴" inString:string])
            sectionName = @"P";
        else if([self searchText:@"查" inString:string])
            sectionName = @"Z";
        else if([self searchText:@"能" inString:string])
            sectionName = @"N";
        else if([self searchText:@"乐" inString:string])
            sectionName = @"Y";
        else if([self searchText:@"单" inString:string])
            sectionName = @"S";
        else
            sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([string characterAtIndex:0])] uppercaseString];
        //获得第一个字母排序的字典
        [self.contactNameDic setObject:string forKey:sectionName];
        //根据第一个字母排序
        NSUInteger firstLetter = [ALPHA rangeOfString:[sectionName substringToIndex:1]].location;
        if (firstLetter != NSNotFound)
        {
            [[self.sectionArray objectAtIndex:firstLetter] addObject:string];
            [[self.sectionIndexArray objectAtIndex:firstLetter] addObject:contact];
        }
    }
}

- (BOOL)searchText:(NSString*)text inString:(NSString*)str
{
    NSComparisonResult result = [str compare:text options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, text.length)];
    if (result == NSOrderedSame)
        return YES;
    else
        return NO;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *indices = [NSMutableArray array];
    for (int i = 0; i < ALPHA.length; i++)
//        if ([[self.sectionArray objectAtIndex:i] count])
            [indices addObject:[[ALPHA substringFromIndex:i] substringToIndex:1]];
    //[indices addObject:@"\ue057"]; // <-- using emoji
    return indices;
}

//27个
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
//    return [ALPHA rangeOfString:title].location;
    return  27;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[self.sectionArray objectAtIndex:section] count] == 0) return 0;
    return 25.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([[self.sectionArray objectAtIndex:section] count] == 0) return nil;
    NSString *title = [NSString stringWithFormat:@"%@", [[ALPHA substringFromIndex:section] substringToIndex:1]];
    FriendHeaderView*view=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"friendHeader"];
    if (!view) {
        view = [[FriendHeaderView alloc]initWithReuseIdentifier:@"friendHeader"];
    }
    view.textLabel.text = title;
    
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ALPHA.length;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.sectionArray objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendCell * cell = [tableView dequeueReusableCellWithIdentifier:@"friendCell"];
    if (!cell) {
        cell = [[FriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"friendCell"];
    }
    cell.textLabel.textColor=UIColorFromRGB16(0x626262);
    
    cell.textLabel.text = [[self.sectionArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    Patient*patient = [[self.sectionIndexArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString:patient.headFile] placeholderImage:[UIImage imageNamed:@"tx"]];
    
    if ([cell viewWithTag:200]) {
        CGRect r = [cell viewWithTag:200].frame;
        r.size.height = 0.5f;
        [cell viewWithTag:200].frame = r;
    }else {
        CGFloat ory = 59.5f;
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, ory, ScreenWidth, 0.5)];
        view.tag = 200;
        view.backgroundColor=LineColor;
        [cell addSubview:view];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取用户所有信息
    FriendDetail*detail = ViewControllerFromStoryboardWithIdentifier(@"FriendDetail");
    detail.patient = [[self.sectionIndexArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    detail.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:detail animated:YES];
}










@end
