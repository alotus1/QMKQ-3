//
//  YiYuanMenZhenDelegate.m
//  QMKQ
//
//  Created by shangjin on 15/8/20.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "YiYuanMenZhenDelegate.h"
#import "config.h"

@interface YiYuanMenZhenDelegate ()
{
    BOOL isEnd;
    int start;
}

@property (nonatomic, strong) NSMutableArray * dataArray;

@end

@implementation YiYuanMenZhenDelegate

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.tableView.delegate=self;
        self.tableView.dataSource=self;
        self.tableView.addDataDelegate=self;
        self.tableView.tableFooterView=[[UIView alloc]init];
        self.dataArray=[NSMutableArray array];
        isEnd=NO;
        start = 0;
        __weak YiYuanMenZhenDelegate* weakDelegate = self;
        self.addDataForTableView = ^(NSArray*data) {
            if (data.count>0) {
                if (data.count<PerRequestCount) {
                    isEnd=YES;
                }
                [weakDelegate.dataArray addObjectsFromArray:data];
                [weakDelegate.tableView reloadData];
            }
        };
    }
    return self;
}

- (void)getFirstData
{
    [self.dataArray removeAllObjects];
    if (self.getDataForTableView) {
        self.getDataForTableView(start,PerRequestCount);
    }
}

- (void)addDataForAddNew
{
    if (!isEnd) {
        start += 1;
        if (self.getDataForTableView) {
            self.getDataForTableView(start,PerRequestCount);
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.tableView checkToUpdateDataDidEndDragging];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.tableView checkToUpdateDataWillBeginDragging];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    [self.tableView checkToUpdateDataWillBeginDecelerating];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString*identifier = @"menzenCell";
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"clinicName"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.didSelectRowWithInfo) {
        self.didSelectRowWithInfo([self.dataArray objectAtIndex:indexPath.row]);
    }
}





@end
