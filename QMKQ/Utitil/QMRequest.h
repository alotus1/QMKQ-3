//
//  QMRequest.h
//  QMKQ
//
//  Created by shangjin on 15/7/31.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 请求block
 *
 * @param success 是否成功
 * @param error   错误信息
 * @param result  数据结果
 */
typedef void(^QMRequestBlock)(BOOL success, NSError * error ,NSDictionary * result);

typedef NS_ENUM(NSUInteger, ErrorType) {
    RequestSuccessButCanNotParseData,//成功请求而不能解析数据
    RequestFailed,//请求失败
};

typedef NS_ENUM(NSUInteger, QMApiType) {
    //医生接口
    //登录
    SendVerCode,//获取手机验证码
    VercodeLogin,//验证码登录接口
    //首页
    HomeDoctorTop,//获取首页上半部分/homepage/doctorTop.go
    HomeDoctorDown,//获取首页下半部分:/homepage/doctorDown.go
    //工作
    TodayPlan,//获取首页工作信息:[待定]
    TodayJob,//获取工作tab的今日工作列表
    AppointmentJob,//获取工作tab的预约列表
    //用户
    GetUserList,//获取用户列表/medicalRecord/myPatients.go
    GetUserInfo,//获取用户详情信息/user/info.go
    LockAppointment,//预约锁定/解锁【done】
    CancelAppointment,//取消已预约门诊【done】
    MakeFriend,//发送申请【取消】
    UserCaseList,//用户病例列表/medicalRecord/list.go
    UserCaseDetail,//用户病例详情/medicalRecord/detail.go
    UploadCasePic,//上传病例图片/medicalRecord/uploadPic.go
    UploadCaseInfo,//上传病历信息/medicalRecord/add.go
    PatientRecordStatus,///medicalRecord/patientRecordStatus.go
    //我
    AddMedicalInfo,//上传或更新医生信息:［待调整］/doctor/addOrUpdateDoctorInfo.go
    GetSummaryInfo,//获取医生个人详情信息
    GetUserCommentList,//获取用户评论列表/user/doctorComment.go
    GetMyInfo,//获取医生个人详情信息/doctor/info/byDoctorId.go
    SearchUser,//搜索个人信息【取消】
    GetClinicList,//获取诊所列表/clinic/clinicList.go
    UploadHeadPic,//上传医生头像/doctor/uploadHeadPic.go
    //通用接口
    RegisterDevice,//上传设备信息【待定】
    UploadLocation,//上传位置信息【待定】
};

@interface QMRequest : NSObject

@property (nonatomic, assign) QMApiType type;//api
@property (nonatomic, assign) BOOL post;//请求格式
/**
 * 自助设置接口
 *
 * @param package 参数
 * @param finish  回调块
 */
- (void)startWithPackage:(NSDictionary*)package completion:(QMRequestBlock)finish;
/**
 * 直传参数接口
 *
 * @param package 参数
 * @param post    请求方式
 * @param type    api
 * @param finish  回调块
 */
- (void)startWithPackage:(NSDictionary *)package post:(BOOL)post apiType:(QMApiType)type completion:(QMRequestBlock)finish;
/**
 * 传图片接口
 *
 * @param images  图片
 * @param package 参数
 * @param post    请求方式
 * @param type    api
 * @param finish  回调块
 */
- (void)uploadImages:(NSObject*)images withPackage:(NSDictionary *)package post:(BOOL)post apiType:(QMApiType)type completion:(QMRequestBlock)finish;

@property (nonatomic, strong) NSDictionary* params;//请求格式
//测试使用
- (NSURLRequest*)getRequest;

@end
