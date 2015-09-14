//
//  Patient.m
//  QMKQ
//
//  Created by shangjin on 15/7/31.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "Patient.h"
#import "config.h"

@implementation Patient

//===========================================================
// - setUserId:
//===========================================================
- (void)setUserId:(NSString *)userId
{
    SETTINGValue(userId, @"");
}

//===========================================================
// - setName:
//===========================================================
- (void)setName:(NSString *)name
{
    SETTINGValue(name, @"没有名字");
}

//===========================================================
// - setPhone:
//===========================================================
- (void)setPhone:(NSString *)phone
{
    SETTINGValue(phone, @"");
}

//===========================================================
// - setHeadFile:
//===========================================================
- (void)setHeadFile:(NSString *)headFile
{
    SETTINGValue(headFile, @"");
}

//===========================================================
// - setGender:
//===========================================================
- (void)setGender:(NSString *)gender
{
    SETTINGValue(gender, @"");
}

//===========================================================
// - setYear:
//===========================================================
- (void)setYear:(NSString *)year
{
    SETTINGValue(year, @"");
}

//===========================================================
// - setMonth:
//===========================================================
- (void)setMonth:(NSString *)month
{
    SETTINGValue(month, @"");
}

//===========================================================
// - setDay:
//===========================================================
- (void)setDay:(NSString *)day
{
    SETTINGValue(day, @"");
}

//===========================================================
// - setWeight:
//===========================================================
- (void)setWeight:(NSString *)weight
{
    SETTINGValue(weight, @"");
}

//===========================================================
// - setHeight:
//===========================================================
- (void)setHeight:(NSString *)height
{
    SETTINGValue(height, @"");
}

//===========================================================
// - setTreatNum:
//===========================================================
- (void)setTreatNum:(NSString *)treatNum
{
    SETTINGValue(treatNum, @"");
}

//===========================================================
// - setWearTime:
//===========================================================
- (void)setWearTime:(NSString *)wearTime
{
    SETTINGValue(wearTime, @"");
}

//===========================================================
// - setEducation:
//===========================================================
- (void)setEducation:(NSString *)education
{
    SETTINGValue(education, @"");
}

//===========================================================
// - setNation:
//===========================================================
- (void)setNation:(NSString *)nation
{
    SETTINGValue(nation, @"");
}

//===========================================================
// - setRecordDetails:
//===========================================================
- (void)setRecordDetails:(NSArray *)recordDetails
{
    SETTINGValue(recordDetails, @[]);
}

- (void)setUserAddress:(NSString *)userAddress
{
    SETTINGValue(userAddress, @"");
}

- (void)setMouthFile:(NSString *)mouthFile
{
    SETTINGValue(mouthFile, @"");
}

- (void)updateDataFromDictionary:(NSDictionary *)dictionary
{
    if ([dictionary objectForKey:@"day"]) {
        self.day = [dictionary objectForKey:@"day"];
    }
    if ([dictionary objectForKey:@"education"]) {
        self.education = [dictionary objectForKey:@"education"];
    }
    if ([dictionary objectForKey:@"headFile"]) {
        self.headFile = [dictionary objectForKey:@"headFile"];
    }
    if ([dictionary objectForKey:@"height"]) {
        self.height = [dictionary objectForKey:@"height"];
    }
    if ([dictionary objectForKey:@"month"]) {
        self.month = [dictionary objectForKey:@"month"];
    }
    if ([dictionary objectForKey:@"userAddress"]) {
        self.userAddress = [dictionary objectForKey:@"userAddress"];
    }
    if ([dictionary objectForKey:@"name"]) {
        self.name = [dictionary objectForKey:@"name"];
    }
    if ([dictionary objectForKey:@"nation"]) {
        self.nation = [dictionary objectForKey:@"nation"];
    }
    if ([dictionary objectForKey:@"treatNum"]) {
        self.treatNum = [dictionary objectForKey:@"treatNum"];
    }
    if ([dictionary objectForKey:@"userId"]) {
        self.userId = [dictionary objectForKey:@"userId"];
    }
    if ([dictionary objectForKey:@"wearTime"]) {
        self.wearTime = [dictionary objectForKey:@"wearTime"];
    }
    if ([dictionary objectForKey:@"weight"]) {
        self.weight = [dictionary objectForKey:@"weight"];
    }
    if ([dictionary objectForKey:@"year"]) {
        self.year = [dictionary objectForKey:@"year"];
    }
    
    
    //不知道是什么参数
    if ([dictionary objectForKey:@"mouthFile"]) {
        self.mouthFile = [dictionary objectForKey:@"mouthFile"];
    }
    //参数名与api不符
    if ([dictionary objectForKey:@"patientGender"]) {
        self.gender = [dictionary objectForKey:@"patientGender"];
    }
}


@end
