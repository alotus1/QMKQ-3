//
//  Doctor.h
//  QMKQ
//
//  Created by shangjin on 15/7/31.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDBObject.h"

typedef NS_ENUM(NSUInteger, ProfessionalTitleType) {
    ProfessionalTitle1,
    ProfessionalTitle2,
    ProfessionalTitle3,
};

/**
 * 医生类
 */
@interface Doctor : FMDBObject

@property (nonatomic, strong) NSString * doctorId;
@property (nonatomic, strong) NSString * headFileUrl;//服务器地址
//@property (nonatomic, strong) NSString * headFilePath;//本地地址
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * birthday;
@property (nonatomic, strong) NSString * desc;//介绍

//@property (nonatomic, strong) NSString * departments;//科室
@property (nonatomic, strong) NSString * hospital;//医院clinicName
@property (nonatomic, strong) NSString * doctorClinicId;//门诊id
@property (nonatomic, strong) NSString * doctorPatient;//治愈人数
@property (nonatomic, strong) NSString * doctorStar;//星数

//返回数据没体现
@property (nonatomic, strong) NSString * gender;//男女
@property (nonatomic, strong) NSString * phone;//没体现
@property (nonatomic, strong) NSString * professionalTitle;//职称
@property (nonatomic, strong) NSString * cityId;//北京110000成都510000

@property (nonatomic, strong) NSArray *comment;

- (void)updateDataFromDictionary:(NSDictionary*)dictionary;

@end
