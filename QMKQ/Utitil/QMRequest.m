//
//  QMRequest.m
//  QMKQ
//
//  Created by shangjin on 15/7/31.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "QMRequest.h"
#import <AFNetworking.h>
#import "AppDelegate.h"
#import "config.h"

@implementation QMRequest

- (instancetype)init{self = [super init];if (self) { self.post=YES; } return self;}

- (NSString*)domain
{
    return @"http://101.200.199.34/api";
}

- (NSString*)getApiFromType
{
    NSString*url=nil;
    switch (self.type) {
            
#pragma mark    医生接口
        case SendVerCode:
            url=@"/user/sendVerCode.go";///user/sendVerCode.go
            break;
        case VercodeLogin:
            url=@"/user/vercodeLogin.go";///user/vercodeLogin.go
            break;
        case HomeDoctorTop:
            url=@"/homepage/doctorTop.go";
            break;
        case HomeDoctorDown:
            url=@"/homepage/doctorDown.go";
            break;
        case TodayPlan:
            url=@"/doctor/todayPlan.go";
            break;
        case TodayJob:
            url=@"/doctor/todayJob.go";
            break;
        case AppointmentJob:
            url=@"/doctor/appointmentJob.go";
            break;
        case GetUserList:
            url=@"/medicalRecord/myPatients.go";
            break;
        case GetUserInfo:
            url=@"/user/info.go";
            break;
        case LockAppointment:
            url=@"/doctor/lockAppointment.go";
            break;
        case CancelAppointment:
            url=@"/doctor/cancelAppointment.go";
            break;
        case AddMedicalInfo:
            url=@"/doctor/addOrUpdateDoctorInfo.go";
            break;
        case GetSummaryInfo:
            url=@"/doctor/getSummaryInfo.go";
            break;
        case GetUserCommentList:
            url=@"/doctor/comment.go";
            break;
        case GetMyInfo:
            url=@"/doctor/info/byDoctorId.go";
            break;
        case SearchUser:
            url=@"/doctor/searchUser.go";
            break;
        case MakeFriend:
            url=@"/doctor/makeFriend.go";
            break;
        case GetClinicList:
            url=@"/clinic/clinicList.go";
            break;
        case UploadHeadPic:
            url=@"/doctor/uploadHeadPic.go";
            break;
        case UserCaseList:
            url=@"/medicalRecord/list.go";
            break;
        case UserCaseDetail:
            url=@"/medicalRecord/detail.go";
            break;
        case UploadCasePic:
            url=@"/medicalRecord/uploadPic.go";
            break;
        case UploadCaseInfo:
            url=@"/medicalRecord/add.go";
            break;
        case PatientRecordStatus:
            url=@"/medicalRecord/patientRecordStatus.go";
            break;
            
#pragma mark    通用接口
        case RegisterDevice:
            url=@"/common/registerDevice.go";
            break;
        case UploadLocation:
            url=@"/common/uploadLocation.go";
            break;
        
            
        default:
            break;
    }
    return url;
}

- (NSString*)requestUrl
{
    return [NSString stringWithFormat:@"%@%@",[self domain],[self getApiFromType]];
}

- (void)startWithPackage:(NSDictionary *)package completion:(QMRequestBlock)finish
{
    [self startWithPackage:package post:self.post apiType:self.type completion:finish];
}

- (void)startWithPackage:(NSDictionary *)package post:(BOOL)post apiType:(QMApiType)type completion:(QMRequestBlock)finish
{
    self.post=post;
    self.type=type;
    
    if (type==UploadHeadPic || type == UploadCasePic) {
        
    }else {
        //请求
        AFHTTPRequestOperationManager*manager=[AFHTTPRequestOperationManager manager];
        
        //设置请求状态
        AppDelegate*app=(AppDelegate*)[UIApplication sharedApplication].delegate;
        [app setReachabilityStatus:manager];
        //风火轮
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        //设置请求数据类型
        [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", nil]];
        /**
         * 其他说明：
         1.在登录成功后，每次请求需要将token放入header中。
         */
        NSLog(@"请求地址 : %@ 参数 : %@",self.requestUrl,package);
        [manager.requestSerializer setValue:@"token" forHTTPHeaderField:@"token"];
        if (!self.post) {
            [manager GET:self.requestUrl parameters:package success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                //解析
                finish(YES,nil,responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                finish(NO,error,nil);
            }];
        }else {
            [manager POST:self.requestUrl parameters:package success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                //解析
                finish(YES,nil,responseObject);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                finish(NO,error,nil);
            }];
        }
    }
}

- (void)uploadImages:(NSObject *)image withPackage:(NSDictionary *)package post:(BOOL)post apiType:(QMApiType)type completion:(QMRequestBlock)finish
{
    self.post=post;
    self.type=type;
    
    if (type!=UploadHeadPic && type != UploadCasePic) {
        return;
    }
    if (image == nil) {
        return;
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //设置请求状态
    AppDelegate*app=(AppDelegate*)[UIApplication sharedApplication].delegate;
    [app setReachabilityStatus:manager];
    //风火轮
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //设置请求数据类型
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", nil]];
    /**
     * 其他说明：
     1.在登录成功后，每次请求需要将token放入header中。
     */
    [manager.requestSerializer setValue:@"token" forHTTPHeaderField:@"token"];
    
    [manager POST:self.requestUrl parameters:package constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         if (image) {
             if ([image isKindOfClass:[UIImage class]]) {     // 图片
//                     NSData *eachImgData = UIImagePNGRepresentation(eachImg);
                 UIImage*img=(UIImage*)image;
                 NSData *eachImgData = UIImageJPEGRepresentation(img, 1.0);
                 [formData appendPartWithFileData:eachImgData name:@"pic" fileName:@"pic.png" mimeType:@"image/png"];
             }else if ([image isKindOfClass:[NSData class]]) {   // 图片
                 NSData*img=(NSData*)image;
                 [formData appendPartWithFileData:img name:@"pic" fileName:@"pic.png" mimeType:@"image/png"];
             }
         }
     } success:^(AFHTTPRequestOperation *operation, id responseObject) {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         finish(YES,nil,responseObject);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         finish(NO,error,nil);
     }];
    
}

- (NSString*)package
{
    NSString*str=@"";
    if (self.params.count>0) {
        for (NSString*key in [self.params allKeys]) {
            NSString*value = [self.params objectForKey:key];
            str = [str stringByAppendingString:[NSString stringWithFormat:@"%@=%@&",key,value]];
        }
        str = [str substringToIndex:str.length-1];
    }
    return str;
}

- (NSURLRequest *)getRequest
{
    NSString * _strUrl = [NSString stringWithFormat:@"%@%@%@",[self domain],[self getApiFromType],self.post?@"":[@"?" stringByAppendingString:[self package]]];
    NSLog(@"request url : %@",_strUrl);
    NSString *encodingStr = [_strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [[NSURL alloc] initWithString:encodingStr];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
    if (self.post) {
        [request setHTTPMethod:@"POST"];
        request.HTTPBody=[[self package] dataUsingEncoding:NSUTF8StringEncoding];
    }else {
        [request setHTTPMethod:@"GET"];
    }
    
    [request setValue:@"application/x-www-form-urlencoded;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    return request;
}

//解析数据
- (void)parseData:(id)resualt completion:(QMRequestBlock)finished
{
    NSDictionary*dic=nil;
    if ([resualt isKindOfClass:[NSData class]]) {
        dic =[NSJSONSerialization JSONObjectWithData:resualt options:NSJSONReadingMutableContainers error:nil];
    }else if ([resualt isKindOfClass:[NSDictionary class]]) {
        dic = resualt;
    }
    if (dic) {
        if ([[dic objectForKey:@"code"] intValue]!=1000) {
            finished(NO,[NSError errorWithDomain:[dic objectForKey:@"tip"] code:RequestFailed userInfo:nil],dic);
            return;
        }
        
        NSMutableDictionary*resolve=[[NSMutableDictionary alloc]init];
        //放上状态
        [resolve setObject:[dic objectForKey:@"code"] forKey:@"code"];
        
        //断言
//        NSAssert([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]], @"数据不能为数组");
        //需要解析的数据
        NSDictionary*dataForParse=[NSDictionary dictionaryWithDictionary:dic];
        if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]]) {
            dataForParse = [NSDictionary dictionaryWithDictionary:[dic objectForKey:@"data"]];
        }else if ([[dic objectForKey:@"data"] isKindOfClass:[NSArray class]])
        {
            dataForParse = @{@"data":[dic objectForKey:@"data"]};
        }
        
        
        //在此集成解析结果，如果解析中出现问题直接回调错误并return
        /**
         * resolve = 
         {
            code : 1000
            data : {}//解析好的数据模型
         }
         */
        [resolve setObject:dataForParse forKey:@"data"];
        finished(YES,nil,resolve);
    }else{
        finished(NO,[NSError errorWithDomain:@"can't parse data" code:RequestSuccessButCanNotParseData userInfo:nil],dic);
    }
}



@end
