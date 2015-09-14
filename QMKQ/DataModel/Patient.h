//
//  Patient.h
//  QMKQ
//
//  Created by shangjin on 15/7/31.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDBObject.h"

/**
 * 病人类
 */
@interface Patient : FMDBObject
/** 数据模型- -!类型...
 “phone”:””,//联系方式
 “treatNum”:””,//治疗次数
 “wearTime”:””,//配戴时长
 “headFile”:””//头像地址
 “name”:””,//名字
 “year”:””,//出生年月日
 “month”:””,//出生年月日
 “day”:””,//出生年月日
 “gender”:””,//性别
 “weight”:””,//体重
 “height”:””,//身高
 “education”:””,//学校
 “nation”:””,//民族
 */
@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * phone;
@property (nonatomic, strong) NSString * headFile;
@property (nonatomic, strong) NSString * gender;

@property (nonatomic, strong) NSString * year;
@property (nonatomic, strong) NSString * month;
@property (nonatomic, strong) NSString * day;
@property (nonatomic, strong) NSString * weight;
@property (nonatomic, strong) NSString * height;

@property (nonatomic, strong) NSString * treatNum;
@property (nonatomic, strong) NSString * wearTime;

@property (nonatomic, strong) NSString * education;
@property (nonatomic, strong) NSString * nation;
@property (nonatomic, strong) NSString * userAddress;
@property (nonatomic, strong) NSString * mouthFile;

//不使用病例模型
//@property (nonatomic, strong) NSString * caseList;//@"142,524,5345,123"
@property (nonatomic, strong) NSArray *recordDetails;//病例


- (void)updateDataFromDictionary:(NSDictionary*)dictionary;

@end
