//
//  AppDelegate+TestData.m
//  QMKQ
//
//  Created by shangjin on 15/8/15.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "AppDelegate+TestData.h"
#import "Doctor.h"
#import "Patient.h"
#import "config.h"
#import "QMRequest.h"

@implementation AppDelegate (TestData)


- (void)checkData
{
    [Doctor createTableWithName:MyInfoStoreKey andPropertyList:[Doctor getPropertyListWithPrimaryKey:@[@"doctorId"]] result:^(TableState state) {
        if (state == TableStateExist || state == TableStateCreateSuccess) {
            [Doctor selectTableWithName:MyInfoStoreKey sqlString:nil result:^(HandleState state, NSArray *results) {
                if (results.count>0) {
                    self.myself=[results lastObject];
                    //更新数据
                    [[[QMRequest alloc]init] startWithPackage:@{@"doctorId":self.myself.doctorId} post:NO apiType:GetMyInfo completion:^(BOOL success, NSError *error, NSDictionary *result) {
                        if (result.count>0 && success) {
                            [self.myself updateDataFromDictionary:[result objectForKey:@"data"]];
                            [self.myself updateDataForTableName:MyInfoStoreKey sqlString:nil result:nil];
                        }
                        if (!success) {
                            ALERT1(SafeValue([result objectForKey:@"tip"], @"服务错误"));
                        }
                    }];
                    //朋友列表
                    [[[QMRequest alloc]init] startWithPackage:@{@"doctorId":self.myself.doctorId} post:NO apiType:GetUserList completion:^(BOOL success, NSError *error, NSDictionary *result) {
                        if (success) {
                            [Patient createTableWithName:PatientInfoStoreKey andPropertyList:[Patient getPropertyListWithPrimaryKey:@[@"userId"]] result:^(TableState state) {
                                if (state == TableStateExist || state == TableStateCreateSuccess) {
                                    [Patient clearTableWithName:PatientInfoStoreKey result:^(HandleState state) {
                                        if (state == HandleStateSuccess) {
                                            //如果有数据
                                            for (NSDictionary*pati in [result objectForKey:@"data"]) {
                                                Patient*patient = [[Patient alloc]init];
                                                [patient updateDataFromDictionary:pati];
//                                                //删除没有名字的
//                                                if (patient.name.length<=0) {
//                                                    [patient deleteFromTableName:PatientInfoStoreKey Result:nil];
//                                                    continue;
//                                                }
                                                [patient addToTableWithTableName:PatientInfoStoreKey result:nil];
                                            }
                                        }
                                    }];
                                 }
                            }];
                        }
                        //请求不成功不做任何处理，使用本地存储数据
                    }];
                }else {
//                    //更新数据
//                    [[[QMRequest alloc]init] startWithPackage:@{@"doctorId":@"1"} post:NO apiType:GetMyInfo completion:^(BOOL success, NSError *error, NSDictionary *result) {
//                        if (result.count>0 && success) {
//                            self.myself = [[Doctor alloc]init];
//                            [self.myself updateDataFromDictionary:[result objectForKey:@"data"]];
//                            [self.myself updateDataForTableName:MyInfoStoreKey sqlString:nil result:nil];
//                            [self.myself addToTableWithTableName:MyInfoStoreKey result:nil];
//                            [self addTestData];
//                        }
//                        if (!success) {
//                            ALERT1(SafeValue([result objectForKey:@"tip"], @"服务错误"));
//                        }
//                    }];
                    
                    
                    UIViewController*vc = ViewControllerFromStoryboardWithIdentifier(@"Login");
                    self.window.rootViewController = vc;
                    [self.window makeKeyAndVisible];
                }
            }];
        }
    }];
}

- (void)checkDoctor
{
    //添加医生
    [Doctor createTableWithName:MyInfoStoreKey andPropertyList:[Doctor getPropertyListWithPrimaryKey:@[@"doctorId"]] result:^(TableState state) {
        if (state == TableStateExist || state == TableStateCreateSuccess) {
            [Doctor clearTableWithName:MyInfoStoreKey result:^(HandleState state) {
                if (state == HandleStateSuccess) {
                    UIViewController*vc = ViewControllerFromStoryboardWithIdentifier(@"SetMyInfoNavi");
                    self.window.rootViewController = vc;
                    [self.window makeKeyAndVisible];
                }
            }];
        }
    }];
}

- (void)addTestData
{
    // 以后真正使用的接口
    [self checkData];
    return;
    
    
//    // 默认没有医生信息
//    [self checkDoctor];
//    return;
    
    
    
    //添加医生
    [Doctor createTableWithName:MyInfoStoreKey andPropertyList:[Doctor getPropertyListWithPrimaryKey:@[@"doctorId"]] result:^(TableState state) {
        if (state == TableStateExist || state == TableStateCreateSuccess) {
            [Doctor clearTableWithName:MyInfoStoreKey result:^(HandleState state) {
                if (state == HandleStateSuccess) {
                    Doctor*myself=[[Doctor alloc]init];
                    myself.name=@"尚晋";
                    myself.doctorId=@"1";
                    myself.gender=@"男";
                    myself.birthday=@"2005-2-3";
                    myself.phone=@"142423524";
                    myself.desc=@"我的个人介绍";
                    myself.hospital=@"医院";
                    myself.professionalTitle=@"高级医师";
                    myself.comment=nil;
                    self.myself = myself;
                    [myself addToTableWithTableName:MyInfoStoreKey result:nil];
                }
            }];
        }
    }];
    
    //朋友列表
    [[[QMRequest alloc]init] startWithPackage:@{@"doctorId":[NSString stringWithFormat:@"%d",(int)1]} post:NO apiType:GetUserList completion:^(BOOL success, NSError *error, NSDictionary *result) {
        if (success) {
            NSLog(@"%@",result);
        }
    }];
    //添加病人
    [Patient createTableWithName:PatientInfoStoreKey andPropertyList:[Patient getPropertyListWithPrimaryKey:@[@"userId"]] result:^(TableState state) {
        if (state == TableStateExist || state == TableStateCreateSuccess) {
            [Patient clearTableWithName:PatientInfoStoreKey result:^(HandleState state) {
                if (state == HandleStateSuccess) {
                    int i = 5;
                    while (i>0) {
                        Patient*apatient=[[Patient alloc]init];
                        apatient.userId=[NSString stringWithFormat:@"%d",i];
                        apatient.name=[NSString stringWithFormat:@"name%d",i];
                        apatient.phone=@"395847";
                        apatient.headFile=@"";
                        apatient.gender=@"女";
                        apatient.year=@"2015";
                        apatient.month=@"6";
                        apatient.day=@"4";
                        apatient.weight=@"42";
                        apatient.height=@"165";
                        apatient.treatNum=@"4";
                        apatient.wearTime=@"22463521";
                        apatient.education=@"学校";
                        apatient.nation=@"民族";
                        apatient.recordDetails=nil;
                        [apatient addToTableWithTableName:PatientInfoStoreKey result:nil];
                        i--;
                    }
                }
            }];
        }
    }];
    
}

@end
