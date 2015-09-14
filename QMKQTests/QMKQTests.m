//
//  QMKQTests.m
//  QMKQTests
//
//  Created by shangjin on 15/7/31.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "QMRequest.h"

/**
 * 接口测试
 */
@interface QMKQTests : XCTestCase

@end

@implementation QMKQTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/**
 * 测试首页官方活动
 */
- (void)testActivityBanners
{
    QMRequest*request=[[QMRequest alloc]init];
    request.type=HomeDoctorTop;
    request.post=NO;
    request.params=@{};
    [self testRequest:[request getRequest] func:__FUNCTION__];
}

/**
 * 测试首页业界活动
 */
- (void)testIndustryBanners
{
    QMRequest*request=[[QMRequest alloc]init];
    request.type=HomeDoctorDown;
    request.post=YES;
    request.params=@{};
    [self testRequest:[request getRequest] func:__FUNCTION__];
}


/**
 * 测试好友列表
 */
- (void)testGetUserList
{
    QMRequest*request=[[QMRequest alloc]init];
    request.type=GetUserList;
    request.post=NO;
    request.params=@{@"doctorId":@"1"};
    [self testRequest:[request getRequest] func:__FUNCTION__];
}

/**
 * 测试好友详情
 */
- (void)testGetUserInfo
{
    QMRequest*request=[[QMRequest alloc]init];
    request.type=GetUserInfo;
    request.post=NO;
    request.params=@{@"userId":@"1"};
    [self testRequest:[request getRequest] func:__FUNCTION__];
}

/**
 * 测试更新/添加医生信息接口
 */
- (void)testUpdateDoctorInfo
{
    QMRequest*request=[[QMRequest alloc]init];
    request.type=AddMedicalInfo;
    request.post=YES;
    request.params=@{
//                     @"doctorId":@"1",
                     @"doctorName":@"mmm",
                     @"birthday":@"1980-1-1",
                     @"clinicId":@"1",
                     @"level":@"2",
                     @"detail":@"详细",
                     @"gender":@"0"};
    [self testRequest:[request getRequest] func:__FUNCTION__];
}

/**
 * 获取医生信息
 */
- (void)testGetDoctorInfo
{
    QMRequest*request=[[QMRequest alloc]init];
    request.type=GetMyInfo;
    request.post=NO;
    request.params=@{@"doctorId":@"1"};
    [self testRequest:[request getRequest] func:__FUNCTION__];
}

/**
 * 获取评论列表
 */
- (void)testGetDoctorUserComments
{
    QMRequest*request=[[QMRequest alloc]init];
    request.type=GetUserCommentList;
    request.post=NO;
    request.params=@{@"cursor":@"20"};
    [self testRequest:[request getRequest] func:__FUNCTION__];
}

/**
 * 上传医生头像接口
 */
//- (void)testUpdateDoctorHeadPic
//{
//    //暂时不测试
//}

- (void)testGetClinicList
{
    QMRequest*request=[[QMRequest alloc]init];
    request.type=GetClinicList;
    request.post=NO;
    request.params=@{@"provinceId":@"北京市",@"areaId":@"海淀区"};
    [self testRequest:[request getRequest] func:__FUNCTION__];
}

- (void)testGetUserCaseList
{
    QMRequest*request=[[QMRequest alloc]init];
    request.type=UserCaseList;
    request.post=NO;
    request.params=@{@"userId":@"1"};
    [self testRequest:[request getRequest] func:__FUNCTION__];
}

- (void)testUserCaseDetail
{
    QMRequest*request=[[QMRequest alloc]init];
    request.type=UserCaseDetail;
    request.post=NO;
    request.params=@{@"recordId":@"1"};
    [self testRequest:[request getRequest] func:__FUNCTION__];
}

/**
 * 其余接口不测了，做添加上逻辑再测
 */


/**
 * 发送请求并解析
 *
 * @param request 请求
 * @param func    方法
 */
- (void)testRequest:(NSURLRequest*)request func:(const char[21])func
{
    NSError * netErr = nil;
    NSHTTPURLResponse * response = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&netErr];
    
    XCTAssertEqual((int)(response.statusCode), 200 , @"%s : api返回码不为200 请求头为%@",func,response);
    XCTAssertNil(netErr,@"%s测试有个错误：%@",func,netErr);
    XCTAssertNotNil(data,@"%s测试返回为空",func);
    
    //解析
    NSError * resolveErr = nil;
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&resolveErr];
    XCTAssertNil(resolveErr,@"%s解析错误为:%@",func,resolveErr);
    XCTAssertTrue([dic isKindOfClass:[NSDictionary class]],@"\n*************************%s 错误的最后结果为：\n************************* %@ \n*************************", func , dic);
    if ([dic isKindOfClass:[NSDictionary class]] && dic!=nil) {
        NSLog(@"\n*************************%s 最后结果为：\n************************* %@ \n*************************",func,dic);
    }
}


/**
 * 测试请求时间
 */
//- (void)testPerformanceExample {
//    // This is an example of a performance test case.
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//    }];
//}

@end
