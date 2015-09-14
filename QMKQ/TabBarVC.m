//
//  TabBarVC.m
//  QMKQ
//
//  Created by shangjin on 15/7/31.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "TabBarVC.h"
#import "config.h"

@interface TabBarVC () <UITabBarControllerDelegate>
{
    NSInteger selIdx;
}

@end

@implementation TabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //为保证设置图片和背景的时候tabbar下边不会出现1像素左右的透视
    CGRect f = self.tabBar.frame;
    f.size.height=self.view.frame.size.height-f.origin.y;
    self.tabBar.frame=f;
    //代理
    self.delegate=self;
    selIdx=0;
    for (UITabBarItem*item in self.tabBar.items) {
        
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB16(0x00A0E9)} forState:UIControlStateSelected];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB16(0x7D7D7D)} forState:UIControlStateNormal];
        if ([[item title] isEqualToString:@"首页"]) {
            [item setImage:[UIImage imageNamed:@"syicon1"]];
            [item setSelectedImage:[UIImage imageNamed:@"syicon2"]];
        }else if ([[item title] isEqualToString:@"工作"]) {
            [item setImage:[UIImage imageNamed:@"gzicon1"]];
            [item setSelectedImage:[UIImage imageNamed:@"gzicon2"]];
        }else if ([[item title] isEqualToString:@"我"]) {
            [item setImage:[UIImage imageNamed:@"woicon1"]];
            [item setSelectedImage:[UIImage imageNamed:@"woicon2"]];
        }else if ([[item title] isEqualToString:@"消息"]) {
            [item setImage:[UIImage imageNamed:@"xxicon1"]];
            [item setSelectedImage:[UIImage imageNamed:@"xxicon2"]];
        }else if ([[item title] isEqualToString:@"用户"]) {
            [item setImage:[UIImage imageNamed:@"yhicon1"]];
            [item setSelectedImage:[UIImage imageNamed:@"yhicon2"]];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"%lu",(unsigned long)self.selectedIndex);
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
