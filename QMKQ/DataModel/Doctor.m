//
//  Doctor.m
//  QMKQ
//
//  Created by shangjin on 15/7/31.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "Doctor.h"
#import "config.h"


@implementation Doctor


//===========================================================
// - setDoctorId:
//===========================================================
- (void)setDoctorId:(NSString *)doctorId
{
    SETTINGValue(doctorId,@"");
}

//===========================================================
// - setHeadFileUrl:
//===========================================================
- (void)setHeadFileUrl:(NSString *)headFileUrl
{
    SETTINGValue(headFileUrl,@"");
}

//===========================================================
// - setHeadFilePath:
//===========================================================
//- (void)setHeadFilePath:(NSString *)headFilePath
//{
//    SETTINGValue(headFilePath,@"");
//}

//===========================================================
// - setName:
//===========================================================
- (void)setName:(NSString *)name
{
    SETTINGValue(name,@"");
}

//===========================================================
// - setGender:
//===========================================================
- (void)setGender:(NSString *)gender
{
    SETTINGValue(gender,@"");
}

//===========================================================
// - setBirthday:
//===========================================================
- (void)setBirthday:(NSString *)birthday
{
    SETTINGValue(birthday,@"");
}

//===========================================================
// - setPhone:
//===========================================================
- (void)setPhone:(NSString *)phone
{
    SETTINGValue(phone,@"");
}

//===========================================================
// - setDesc:
//===========================================================
- (void)setDesc:(NSString *)desc
{
    SETTINGValue(desc,@"");
}

//===========================================================
// - setDepartments:
//===========================================================
//- (void)setDepartments:(NSString *)departments
//{
//    SETTINGValue(departments,@"");
//}

//===========================================================
// - setHospital:
//===========================================================
- (void)setHospital:(NSString *)hospital
{
    SETTINGValue(hospital,@"");
}

//===========================================================
// - setProfessionalTitle:
//===========================================================
- (void)setProfessionalTitle:(NSString *)professionalTitle
{
    SETTINGValue(professionalTitle,@"");
}

//===========================================================
// - setDoctorClinicId:
//===========================================================
- (void)setDoctorClinicId:(NSString *)doctorClinicId
{
    SETTINGValue(doctorClinicId,@"");
}

//===========================================================
// - setDoctorPatient:
//===========================================================
- (void)setDoctorPatient:(NSString *)doctorPatient
{
    SETTINGValue(doctorPatient,@"");
}

//===========================================================
// - setDoctorStar:
//===========================================================
- (void)setDoctorStar:(NSString *)doctorStar
{
    SETTINGValue(doctorStar,@"0");
}

//===========================================================
// - setComment:
//===========================================================
- (void)setComment:(NSArray *)comment
{
    SETTINGValue(comment,@[]);
}

- (void)setCityId:(NSString *)cityId
{
    SETTINGValue(cityId, @"");
}

- (void)updateDataFromDictionary:(NSDictionary *)dictionary
{
    if ([dictionary objectForKey:@"birthday"]) {
        self.birthday = [dictionary objectForKey:@"birthday"];
    }
    if ([dictionary objectForKey:@"doctorClinicId"]) {
        self.doctorClinicId = [dictionary objectForKey:@"doctorClinicId"];
    }
    if ([dictionary objectForKey:@"doctorStar"]) {
        self.doctorStar = [dictionary objectForKey:@"doctorStar"];
    }
    //还有4个参数没有体现
    
    
    //与api参数名不同
    if ([dictionary objectForKey:@"clinicName"]) {
        self.hospital = [dictionary objectForKey:@"clinicName"];
    }
    if ([dictionary objectForKey:@"cureNum"]) {
        self.doctorPatient = [dictionary objectForKey:@"cureNum"];
    }
        //相同参数
    if ([dictionary objectForKey:@"doctorPatient"]) {
        self.doctorPatient=[dictionary objectForKey:@"doctorPatient"];
    }
    if ([dictionary objectForKey:@"doctorDetail"]) {
        self.desc = [dictionary objectForKey:@"doctorDetail"];
    }
    if ([dictionary objectForKey:@"doctorName"]) {
        self.name = [dictionary objectForKey:@"doctorName"];
    }
    if ([dictionary objectForKey:@"doctorPicPath"]) {
        self.headFileUrl = [dictionary objectForKey:@"doctorPicPath"];
    }
    if ([dictionary objectForKey:@"doctorid"]) {
        self.doctorId = [dictionary objectForKey:@"doctorid"];
    }
    
}

@end
