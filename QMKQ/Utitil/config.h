//
//  config.h
//  QMKQ
//
//  Created by shangjin on 15/7/31.
//  Copyright (c) 2015年 skinner. All rights reserved.
//
/**
 * 配置文件
 */

#ifndef QMKQ_config_h
#define QMKQ_config_h



#pragma mark    --setValue
#define SETTINGValue(v,m) if ([v isEqual:[NSNull null]]) _##v=m; else _##v=v;
#define SafeValue(v,m) ([v isEqual:[NSNull null]]||v==nil||v==NULL)?m:v //从数组或字典中取数据的时候需要

#pragma mark ui
#define ALERT1(msg)  [[[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"Yes" otherButtonTitles:nil,nil] show]

#define ALERT2(title,msg)  [[[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Yes" otherButtonTitles:nil,nil] show]

#define ViewControllerFromStoryboardWithIdentifier(fy) [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:fy]

#pragma mark    存储key
#define HomeDoctorTopStoreKey @"HomeDoctorTop"
#define HomeDoctorDownStoreKey @"HomeDoctorDown"
#define MyInfoStoreKey @"doctor"
#define PatientInfoStoreKey @"patient"
#define CheckCaseStoreKey @"checkcase"
#define FirstVisitStoreKey @"firstvisit"
#define ReturnVisitStoreKey @"returnvisit"

#pragma mark    其他数据
// domain
#define BaseUrl @""
//屏幕长宽
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
// storyboard
#define StoryBoardName @"Main"
// system version
#define SystemVersion [[[UIDevice currentDevice]systemVersion]floatValue]
//获取整数
#define ToInt(x) ((int)(x+0.5))//四舍五入了
//定义输出
#ifdef DEBUG
#define DLog( s, ... ) NSLog( @"[%@:(%d)] \n%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define DLog( s, ... )
#endif

#pragma mark    颜色相关
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define UIColorFromRGB16(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// color
//#define NavigationBarBG [UIColor colorWithRed:0.114 green:0.667 blue:0.945 alpha:1.000]
#define NavigationBarBG UIColorFromRGB16(0x00A0E9)
#define TeethBtTitle [UIColor colorWithRed:0.314 green:0.431 blue:0.647 alpha:1.000]
#define BgColor UIColorFromRGB16(0xF5F4F4)
#define LineColor UIColorFromRGB16(0xEEEEEE)

#pragma mark    请求
#define PerRequestCount 20
#define MonthDictionary @{@"Jan":@"1",@"Feb":@"2",@"Mar":@"3",@"Apr":@"4",@"May":@"5",@"Jun":@"6",@"Jul":@"7",@"Aug":@"8",@"Sep":@"9",@"Oct":@"10",@"Nov":@"11",@"Dec":@"12"}

#endif
