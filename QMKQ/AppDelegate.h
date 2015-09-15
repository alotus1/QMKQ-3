//
//  AppDelegate.h
//  QMKQ
//
//  Created by shangjin on 15/7/31.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import "Doctor.h"
#import "Patient.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) BOOL hasNetwork;

@property (nonatomic, strong) Doctor * myself;
@property (nonatomic, strong) Patient * patient;

/**
 * 设置请求状态，如果有网直接请求，如果没网挂起，如果没网又有网请求重新启动
 *
 * @param manager AFNetworking请求
 */
- (void)setReachabilityStatus:(AFHTTPRequestOperationManager*)manager;

@end

