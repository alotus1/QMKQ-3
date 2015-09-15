//
//  QMWorkViewController.m
//  QMKQ
//
//  Created by Lotus on 15/9/7.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "QMWorkViewController.h"

#import "QMWorkView.h"
#import "NSDate+CQ.h"
#import <AFHTTPRequestOperationManager.h>
#import "FriendDetail.h"

#import "QMAppointmentHour.h"
#import "QMAppointmentDay.h"
#import "Patient.h"
#import "Doctor.h"
#import "AppDelegate.h"

#import "AppDelegate.h"


// 医生预约的时间间隔
#define QM_TIMEINTERVAL 30 * 60

#define QM_URL_DAYAPPOINTEDDATA @"http://101.200.199.34/api/appointment/day.go?year=%ld&month=%ld&day=%ld&doctorId=%@&userId=%@"
#define QM_URL_MONTHAPPOINTEDDATA @"http://101.200.199.34/api/appointment/month.go?year=%ld&month=%ld&doctorId=%@&userId=%@"
#define QM_URL_UPDATETIMELIST @"http://101.200.199.34/api/appointment/updateList.go?year=%ld&month=%ld&day=%ld&doctorId=%@&hourList=%@&hourStatusList=%@"

@interface QMWorkViewController ()

@property (weak , nonatomic) QMWorkView * workView ;


/**
 *  可以预约的起始时间
 */
@property (strong , nonatomic) NSDate * startDate ;

/**
 *  可以预约的结束时间
 */
@property (strong , nonatomic) NSDate * endDate ;

@property (strong , nonatomic) NSDateFormatter * dateFormatter ;

@property (weak , nonatomic) UIButton * rightNavButton ;

/**
 *  保存没有修改的原始数据,在用户取消修改的时候使用
 */
@property (strong , nonatomic) NSArray * appointmentHours ;

/**
 *  当前选中的日期
 */
@property (strong , nonatomic) NSDate * selectedDate ;

@property (strong , nonatomic) Doctor * doctor ;

@end

@implementation QMWorkViewController

- (void) setupTime {
    
    /***设置起始\结束时间****/
    
    self.dateFormatter = [[NSDateFormatter alloc] init] ;
    NSLocale * local = [NSLocale systemLocale] ;
    [self.dateFormatter setLocale:local] ;
    
    [self.dateFormatter setDateFormat:@"HH:mm:ss"];
    //    NSDate* startDate = [[dateformatter dateFromString:@"10:00:00"] currentZoneDate];
    //
    //    NSDate * endDate = [[dateformatter dateFromString:@"18:00:00"] currentZoneDate] ;
    
    self.startDate = [self.dateFormatter dateFromString:@"00:00:00"] ;
    self.endDate = [self.dateFormatter dateFromString:@"23:30:00"] ;
    
    
    /***设置起始\结束时间****/
}


- (void)viewDidLoad {
    
    [super viewDidLoad] ;
    
    // 获取医生信息
    self.doctor = ((AppDelegate *)[UIApplication sharedApplication].delegate).myself ;
    
    
    [self setupTime] ;
    
    self.selectedDate = [NSDate date] ;
    
    self.view.backgroundColor = BgColor ;
    
    // 请求网络数据
    [self sendRequestForDaysAppointmentDataWithDate:[NSDate date]] ;
    [self sendRequestForHoursAppointmentDataWithDate:[NSDate date]] ;
    
    [self setBlock] ;
    
    [self installRightNavButton] ;
}

- (void)viewWillDisappear:(BOOL)animated {
    

    [super viewWillDisappear:animated] ;
    
    self.rightNavButton.selected = NO ;
    self.workView.beginEditing = NO ;
}

- (void) installRightNavButton {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom] ;
    button.frame = CGRectMake(0, 0, 45, 30) ;
    button.titleLabel.font = QMTHINFONT(14) ;
    [button setTitle:@"锁定" forState:UIControlStateNormal] ;
    [button setTitle:@"取消" forState:UIControlStateSelected] ;
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight] ;
    [button addTarget:self action:@selector(editTimeList:) forControlEvents:UIControlEventTouchUpInside] ;
    [button setTitleColor:[UIColor colorWithColorString:@"006ab4"] forState:UIControlStateNormal] ;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected] ;
    
    
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithCustomView:button] ;
    self.navigationItem.rightBarButtonItem = rightItem ;
    self.rightNavButton = button ;
    
}

- (void) editTimeList : (UIButton *) button {
    
    // 判断是不是取消选中,如果是取消,则恢复用户修改以前
    if (button.selected) {
        [self sendRequestForHoursAppointmentDataWithDate:self.selectedDate] ;
    }
    
    button.selected = !button.selected ;
    // 通知workView进入编辑状态
    self.workView.beginEditing = button.selected ;
}


- (void) setBlock {

    __weak typeof(self) vc = self ;
    [self.workView setWantNewDateAppointmentInformation:^(NSDate *date) {
        //        NSLog(@"请求 %@每个时间段的预约信息" , date) ;
        [vc sendRequestForHoursAppointmentDataWithDate : date] ;
        self.selectedDate = date ;
    }] ;
        // 切换月份的时候需要重新进行网络请求
    [self.workView setChangeMonthBlock:^(NSDate *date) {
        
        [vc sendRequestForDaysAppointmentDataWithDate:date] ;
        [vc sendRequestForHoursAppointmentDataWithDate:date] ;
        self.selectedDate = date ;
    }] ;
    
    
    // 需要刷新数据
    [self.workView setShouldReloadDataBlock:^(QMWorkView *appointmentView , NSDate * date) {
        
        [vc sendRequestForDaysAppointmentDataWithDate:date] ;
        [vc sendRequestForHoursAppointmentDataWithDate:date] ;
    }] ;
    
    // 需要进行网络请求更改医生的工作时间表
    [self.workView setChangeDoctorWorkTimeBlock:^(NSString *hourList, NSString *hourStatusList, NSDate *date) {
        vc.rightNavButton.selected = NO ;
        vc.appointmentHours = [NSArray arrayWithArray:self.workView.dayAppointments] ;
        [vc sendRequestForChangeDoctorWorkTime:hourList hourStatusList:hourStatusList changeDate:date] ;
    }] ;
    
    // 需要跳转到用户详情页面
    [self.workView setShouldPushToFriendDetailBlock:^(Patient *patient) {
        FriendDetail*detail = ViewControllerFromStoryboardWithIdentifier(@"FriendDetail");
        detail.patient =patient;
        detail.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:detail animated:YES];
    }] ;
}

- (void)loadView {
    
    
    QMWorkView * workView = [[QMWorkView alloc] init] ;
    self.view = workView ;
    self.workView = workView ;
    
    NSLog(@"123");
    
}



#pragma mark - 网络相关
/**
 *  请求每个不同日期当天每个时间段的预约信息
 */
- (void) sendRequestForHoursAppointmentDataWithDate : (NSDate *) date {
    
    //    QMLog(@"请求%@ 日期下的预约信息   " , date) ;
    QMLog(@"dayin") ;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager] ;
    //此处设置后返回的默认是NSData的数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSInteger year = [date yearForDate] ;
    NSInteger month = [date monthForDate] ;
    NSInteger day = [date dayForDate] ;
    
    
    NSString * urlString = [NSString stringWithFormat:QM_URL_DAYAPPOINTEDDATA , year , month , day,self.doctor.doctorId , @"1"] ;

    NSLog(@"%@qqqqqqqqqqqqqqqqqqqqqq",urlString);
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError * error ;
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error] ;
        if (error) {
            NSLog(@"jsonError %@" , error) ;
        }
        
        NSArray * datas = [jsonDict valueForKey:@"data"] ;
        
        NSMutableArray * objs = [NSMutableArray array] ;
        for (NSDictionary * dict in datas) {
            
            QMAppointmentHour * appointmentHour = [QMAppointmentHour appointmentHourWithDict:dict] ;
            
            if (appointmentHour.hourStatus == QMAppointmentHourStatusRest) {
                continue ;
            }
            appointmentHour.startTime = [self.dateFormatter stringFromDate:[NSDate timeWithNumber:[appointmentHour.hour integerValue]]] ;
            
            NSDate * date = [NSDate dateWithDate:[NSDate date] time:appointmentHour.startTime] ;
            appointmentHour.endTime = [self.dateFormatter stringFromDate:[date dateByAddingTimeInterval:QM_TIMEINTERVAL]] ;
            
            
            [objs addObject:appointmentHour] ;
        }
        //        NSLog(@"%@" , objs) ;
        
        // 这里需要进行深复制
        self.workView.dayAppointments = objs ;
//        [self copyAppointmentHoursWithArray:objs] ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@" , error) ;
    }] ;
    
}

- (void) copyAppointmentHoursWithArray : (NSArray *) array {
    
    NSMutableArray * appointmentHours = [NSMutableArray array] ;
    for (QMAppointmentHour * appointmentHour in array) {
        [appointmentHours addObject:[appointmentHour copy]] ;
    }
    self.appointmentHours = appointmentHours ;

}

/**
 *  请求当月每天的预约状态信息
 */
- (void) sendRequestForDaysAppointmentDataWithDate : (NSDate *) date {
    
    
    QMLog(@"请求医生 %@ 月的预约信息" , date) ;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager] ;
    //此处设置后返回的默认是NSData的数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * urlString = [NSString stringWithFormat:QM_URL_MONTHAPPOINTEDDATA , [date yearForDate] , [date monthForDate] ,self.doctor.doctorId, @"1"] ;
    NSLog(@"%@ "  , urlString) ;
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError * error ;
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error] ;
        if (error) {
            NSLog(@"%@" , error) ;
        }
        
        NSArray * datas = [jsonDict valueForKey:@"data"] ;
        //        NSLog(@"%@" , datas) ;
        
        NSMutableArray * objs = [NSMutableArray array] ;
        for (NSDictionary * dict in datas) {
            QMAppointmentDay * appointmentDay = [QMAppointmentDay appointmentDayWithDict:dict] ;
            //            NSLog(@"%lu" , appointmentDay.day_status) ;
            [objs addObject:appointmentDay] ;
        }
        self.workView.monthAppointments = objs ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@" , error) ;
    }] ;
    
}

- (void) sendRequestForChangeDoctorWorkTime : (NSString *) hourList hourStatusList : (NSString *) hourStatusList changeDate : (NSDate *) changeDate
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager] ;
    //此处设置后返回的默认是NSData的数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSString * urlString = [NSString stringWithFormat:QM_URL_UPDATETIMELIST , [changeDate yearForDate] , [changeDate monthForDate] , [changeDate day],@"1", hourList , hourStatusList] ;
    QMLog(@"%@ "  , urlString) ;
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError * error ;
        NSDictionary * jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error] ;
        if (error) {
            QMLog(@"%@" , error) ;
            return ;
        }
        
        if ([jsonDict[@"code"] integerValue] != 1000) {
            // 提示医生重新修改
            return ;
        }
        
        QMLog(@"修改成功") ;
        QMLog(@"") ;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        QMLog(@"error %@" , error) ;
    }] ;
    

}


@end
