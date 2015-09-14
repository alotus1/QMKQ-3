//
//  MyInfo.m
//  QMKQ
//
//  Created by shangjin on 15/8/8.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "MyInfo.h"
#import "MIAvatarCell.h"
#import "MIAnotherCell.h"
#import "SetMyInfo.h"
#import "config.h"
#import <UIImageView+AFNetworking.h>

@interface MyInfo () <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSDictionary * userInfo;// {"name":"summer"}
@property (nonatomic, strong) NSArray * userInfoKey; //{"姓名"}

@end

@implementation MyInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"个人信息";
    [self setLeftButtonItem];
    
    //设置tableView
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.backgroundColor=BgColor;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//    NSDateFormatter*dateFormat=[[NSDateFormatter alloc]init];
//    dateFormat.dateFormat=@"yyyy.MM.dd";
    
    //右按钮
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:0];
    [rightButton addTarget:self action:@selector(editMyInfo) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*right = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=right;
    
    
    //数据
    if (!self.my) {
        [Doctor selectTableWithName:MyInfoStoreKey sqlString:nil result:^(HandleState state, NSArray *results) {
            if (state == HandleStateSuccess) {
                self.my = [results lastObject];
                [self.tableView reloadData];
            }
        }];
    }
    self.userInfoKey=@[@"名字",
                       @"性别",
                       @"生日",
                       @"电话",
                       @"介绍",
                       @"科室",
                       @"医院",
                       @"职称"];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString * birthDay = @"";
    NSArray*dayArr=[self.my.birthday componentsSeparatedByString:@" "];
    birthDay = [dayArr objectAtIndex:0];
    birthDay = [birthDay stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    self.userInfo= @{@"名字":self.my.name,
                     @"性别":[self.my.gender intValue]?@"女":@"男",
                     @"生日":birthDay,
                     @"电话":self.my.phone,
                     @"介绍":self.my.desc,
                     @"科室":self.my.hospital,
                     @"医院":self.my.hospital,
                     @"职称":self.my.professionalTitle
                     };
    [self.tableView reloadData];
}

//进入编辑页面
- (void)editMyInfo
{
    SetMyInfo*s=ViewControllerFromStoryboardWithIdentifier(@"SetMyInfo");
    s.my=self.my;
    [self.navigationController pushViewController:s animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    if (indexPath.row == 0) {
        height = 90;
    }else if (indexPath.row == 1) {
        height = 5;
    }else {
        height = 55;
    }
    if (indexPath.row == 6) {
        UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-23-23-90, 1000)];
        label.numberOfLines=0;
        NSString*key=[self.userInfoKey objectAtIndex:indexPath.row-2];
        NSString*safeString = [self.userInfo objectForKey:key];
        NSString*info=[safeString isEqualToString:@""]?@"hellow":safeString;
        label.text = info;
        CGRect r = [label textRectForBounds:label.bounds limitedToNumberOfLines:0];
        height = r.size.height + 35;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell = nil;
    
    if (indexPath.row == 0) {
        MIAvatarCell*c = [tableView dequeueReusableCellWithIdentifier:@"MIAvatarCell"];
        c.imageView.image = nil;
        [c.imgView setImageWithURL:[NSURL URLWithString:self.my.headFileUrl] placeholderImage:[UIImage imageNamed:@"tx"]];
        
        cell = c;
    }else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MISeparatorCell"];
        cell.backgroundColor=BgColor;
    }else if (indexPath.row >= 2 && indexPath.row != 6) {
        MIAnotherCell*c = [tableView dequeueReusableCellWithIdentifier:@"MIAnotherCell"];
        
        
        NSString*key=[self.userInfoKey objectAtIndex:indexPath.row-2];
        c.leftLabel.text = key;
        NSString*info=[self.userInfo objectForKey:key];
        c.rightLabel.text = info;
        
        if (c.rightLabel.text.length<=0) {
            c.rightLabel.text = @"未填写";
            c.rightLabel.textColor = UIColorFromRGB16(0xD2D2D2);
        }else {
            c.rightLabel.textColor = UIColorFromRGB16(0x7D7D7D);
        }
        cell = c;
    }else if (indexPath.row == 6) {
        MIAnotherCell*c = [tableView dequeueReusableCellWithIdentifier:@"MIAnotherCell1"];
        
        NSString*key=[self.userInfoKey objectAtIndex:indexPath.row-2];
        c.leftLabel.text = key;
        NSString*info=[self.userInfo objectForKey:key];
        c.rightLabel.text = info;
        
        UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-23-23-90, 1000)];
        label.numberOfLines=0;
        label.text = info;
        CGRect r = [label textRectForBounds:label.bounds limitedToNumberOfLines:0];
        if (c.rightLabel.text.length > 0 && r.size.height > 25) {
            c.rightLabel.textAlignment=NSTextAlignmentLeft;
        }else {
            c.rightLabel.textAlignment=NSTextAlignmentRight;
        }
        cell = c;
    }
    if ([cell viewWithTag:200]) {
        CGRect r = [cell viewWithTag:200].frame;
        if (indexPath.row == 6) {
            CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
            r.origin.y = height - 0.5;
        }
        r.size.height = 0.5f;
        [cell viewWithTag:200].frame = r;
    }else if (indexPath.row > 1) {
        CGFloat ory = 54.5f;
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, ory, ScreenWidth, 0.5)];
        view.tag = 200;
        view.backgroundColor=LineColor;
        [cell addSubview:view];
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
