//
//  Setting.m
//  QMKQ
//
//  Created by shangjin on 15/9/4.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "Setting.h"
#import "config.h"
#import "AppDelegate.h"
#import "Patient.h"

@interface Setting () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation Setting

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setLeftButtonItem];
    self.title=@"设置";
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = BgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
    if (section == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.textLabel.text = @"版本";
        cell.detailTextLabel.text = @"1.0";
    }else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"退出登录";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        [Doctor clearTableWithName:MyInfoStoreKey result:nil];
        [Patient clearTableWithName:PatientInfoStoreKey result:nil];
        UIViewController*vc = ViewControllerFromStoryboardWithIdentifier(@"Login");
        UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
        window.rootViewController = vc;
        [window makeKeyAndVisible];
    }
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
