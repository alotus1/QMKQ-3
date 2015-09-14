//
//  YiYuanMenZhenDelegate.h
//  QMKQ
//
//  Created by shangjin on 15/8/20.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIScrollView+ScrollMore.h"


@interface YiYuanMenZhenDelegate : NSObject <UITableViewDelegate,UITableViewDataSource,UIScrollViewDataDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, copy) void (^didSelectRowWithInfo) (NSDictionary*info);
@property (nonatomic, copy) void (^getDataForTableView) (int page, int count);
@property (nonatomic, copy) void (^addDataForTableView) (NSArray*data);

- (instancetype)initWithTableView:(UITableView*)tableView;
- (void)getFirstData;

@end
