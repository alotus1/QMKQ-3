//
//  AppDelegate.m
//  QMKQ
//
//  Created by shangjin on 15/7/31.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "AppDelegate.h"
#import "config.h"
#import "QMRequest.h"
#import "BOffLineCache.h"
#import "AppDelegate+TestData.h"

@interface AppDelegate ()



@end

@implementation AppDelegate


#pragma mark  -
#pragma mark Network Reachability Clear Disk
- (void)clearDisk
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // 局域网络,不花钱
     */
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring,时时监测,有变化立即通知
    // 把shareManager换成MyDomain是因为需要判断服务器网络连接状态
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BaseUrl]];
    [manager.reachabilityManager startMonitoring];
    // 检测网络连接的单例,网络变化时的回调方法
    __weak AFHTTPRequestOperationManager*man=manager;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         DLog(@"判断是否有网用来管理离线数据  %d",(int)status);
         // TODO:计划功能 ，根据数据性质以后再说
         if (status==2) {//wifi
             //缓存操作：删除缓存的图片、文件
         }else if (status==1) {//3g
             //缓存操作：删除缓存文件，保留图片
         }else {
             //没有网使用离线
         }
         [man.reachabilityManager stopMonitoring];
         [self reach];
     }];
}

#pragma mark  -
#pragma mark Network Reachability
- (void)reach
{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BaseUrl]];
    [manager.reachabilityManager startMonitoring];
    [self setReachabilityStatus:manager];
}

- (void)setReachabilityStatus:(AFHTTPRequestOperationManager*)manager
{
    NSOperationQueue * poration=manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         DLog(@"判断在程序当中是否有网  %d",(int)status);
         if (status==2||status==1) {
             //突然来网
             self.hasNetwork=YES;
             [poration setSuspended:NO];
         }else {
             //突然没网,挂起
             self.hasNetwork=NO;
             [poration setSuspended:YES];
         }
     }];
}


#pragma mark    设置控件样式
/**
 * 设置控件样式
 *
 * @param application 有些地方使用application
 */
- (void)setAppearance:(UIApplication*)application
{
    //设置状态栏
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    //设置导航栏
    UINavigationBar*navigationBar=[UINavigationBar appearance];
//    [navigationBar setBarTintColor:NavigationBarBG];
    navigationBar.barTintColor=NavigationBarBG;
    [navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:19.0f],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [navigationBar setTranslucent:NO];
//    UIImage *backImg = [UIImage imageNamed:@"<--1"];
//    [backImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [[UINavigationBar appearance] setBackIndicatorImage:nil];
//    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:nil];
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage new] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UITabBar*tabbar=[UITabBar appearance];
    tabbar.barTintColor=UIColorFromRGB16(0xEEEEEE);
    tabbar.tintColor=UIColorFromRGB16(0x00A0E9);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //重新开启app调用接口
    
    //加载前设置样式
    [self setAppearance:application];
    
    //清除磁盘
    [self clearDisk];
    
    //添加测试数据
    [self addTestData];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}


@end
