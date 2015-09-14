//
//  QMWorkView.m
//  QMKQ
//
//  Created by Lotus on 15/9/7.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "QMWorkView.h"

#import "MJRefresh.h"
#import "CustomCalendar.h"

#import "QMAppointmentHour.h"
#import "Patient.h"

#import "QMDayAppointmentCell.h"

#import "NSDate+CQ.h"
#import "MJRefresh.h"

// 医生预约的时间间隔
#define QM_TIMEINTERVAL 30 * 60

@interface QMWorkView () <UITableViewDelegate , UITableViewDataSource , MJRefreshBaseViewDelegate , UIAlertViewDelegate>

/**
 *  用来显示当天预约时间段信心的tableView
 */
@property (weak , nonatomic) UITableView * tableView ;

/**
 *  日历视图
 */
@property (weak , nonatomic) CustomCalendar * calendarView ;

/**
 *  预约时间的数据源
 */
@property (strong , nonatomic) NSArray * dataSource ;


/**
 *  可以预约的起始时间
 
 @property (strong , nonatomic) NSDate * startDate ;
 
 /**
 *  可以预约的结束时间
 
 @property (strong , nonatomic) NSDate * endDate ;
 */

/**
 *  当前选择的预约日期
 */
@property (strong , nonatomic) NSDate * selectedDate ;

/**
 *  时间格式设置
 */
@property (strong , nonatomic) NSDateFormatter * dateFormatter ;

@property (weak , nonatomic) MJRefreshHeaderView * refreshHeaderView ;

@end

@implementation QMWorkView


#pragma mark - 数据相关
- (void)setBeginEditing:(BOOL)beginEditing {

    _beginEditing = beginEditing ;
    
    // 1.添加footView
    self.tableView.sectionFooterHeight = beginEditing ? 49 : 0 ;
    [self.tableView reloadData] ;
}

- (void)setMonthAppointments:(NSArray *)monthAppointments {
    
    _monthAppointments = monthAppointments ;
    
    // 将数据传递给日历视图
    self.calendarView.monthAppointments = monthAppointments ;
}


- (void)setDayAppointments:(NSArray *)dayAppointments {
    
    _dayAppointments = dayAppointments ;
    
    [self endRefresh] ;
    
    [self.tableView reloadData] ;
}


#pragma mark - 初始化

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        
        CustomCalendar * calendar = [[CustomCalendar alloc] init] ;
        
        __weak typeof(self) viewTmp = self ;
        // 选择日期之后进行的操作
        [calendar setSelectDayItemBlock:^(NSDate *date) {
            // 选择了新的日期之后需要切换预约表格的数据源
            
            // 1.需要获取日期中的"天(day)"
            //            [viewTmp settingDataSource : date.day] ;
            
            if (viewTmp.wantNewDateAppointmentInformation) {
                viewTmp.selectedDate = date ;
                viewTmp.wantNewDateAppointmentInformation(date) ;
            }
             
            
        }] ;
        
        // 更改月份的时候进行的操作
        [calendar setChangeMonthBlock:^(CustomCalendar *calendar,NSDate * date) {
            // 月份更改了之后需要通知控制器 , 进行新的网络请求,请求新的一个月的预约数据
            if (self.changeMonthBlock) {
                
                self.changeMonthBlock(date) ;
            }
        }] ;
        
        
        
        self.calendarView = calendar ;
        __weak typeof(calendar) calTmp = self.calendarView ;
        [calendar setViewHeightChangedBlock:^{
            [viewTmp.tableView beginUpdates] ;
            viewTmp.tableView.tableHeaderView = calTmp ;
            [viewTmp.tableView endUpdates] ;
        }] ;
        
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain] ;
        tableView.rowHeight = QM_SCALE_HEIGHT(55) ;
        tableView.delegate = self ;
        tableView.dataSource = self ;
        tableView.tableHeaderView = calendar ;
        // 去掉cell的分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone ;
        [self addSubview:tableView] ;
        self.tableView = tableView ;
        
        /*
        NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter] ;
        [notificationCenter addObserver:self selector:@selector(reloadData) name:QM_NOTIFICATION_RELOADDATA object:nil] ;
        */
        
        [self setupTime] ;
        [self installRefreshHeaderView] ;
        
        
        
    }
    return self ;
}

/**
 *  通知tableView刷新数据
 */
- (void) reloadData {
    
    [self.tableView reloadData] ;
}


- (void) setupTime {
    
    /***设置时间参数****/
    
    self.dateFormatter = [[NSDateFormatter alloc] init] ;
    NSLocale * local = [NSLocale systemLocale] ;
    [self.dateFormatter setLocale:local] ;
    
    [self.dateFormatter setDateFormat:@"HH:mm:ss"];
    
    self.selectedDate = [NSDate date] ;
    
    
}


#pragma mark - frame布局相关
- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    self.frame = newSuperview.bounds ;
    
    CGRect frame = self.frame ;
    frame.size.height = self.frame.size.height - 64 ;
    self.frame = frame ;
}

- (void)layoutSubviews {
    
    [super layoutSubviews] ;
    
    self.tableView.frame = self.bounds ;
    
}

#pragma mark - UITableView数据源方法
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dayAppointments.count ;
    //    return self.dataSource.count ;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 1.获取数据
    QMAppointmentHour * appointmentHour = self.dayAppointments[indexPath.row] ;
    
    // 2.创建cell
    QMDayAppointmentCell * cell = [QMDayAppointmentCell dayAppointmentCell:tableView andIndexPath:indexPath] ;
    cell.editing = self.beginEditing ;
    
    // 3.传递模型数据
    cell.appointmentHour = appointmentHour ;
    
    return cell ;
}

#pragma mark - UITableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    QMDayAppointmentCell * selectedCell = (QMDayAppointmentCell *)[tableView cellForRowAtIndexPath:indexPath] ;
    if ((selectedCell.appointmentHour.hourStatus == QMAppointmentHourStatusAlreadyAppointedByMe || selectedCell.appointmentHour.hourStatus == QMAppointmentHourStatusAlreadyAppointedByOthers) && !self.beginEditing) {
        // 已经有用户预约的情况,点击后跳转到相应的用户详情页面
        if (self.shouldPushToFriendDetailBlock) {
            Patient * patient = [[Patient alloc] init] ;
            patient.userId = selectedCell.appointmentHour.userId ;
            patient.name = selectedCell.appointmentHour.userName ;
            self.shouldPushToFriendDetailBlock(patient) ;
        }
        return ;
    }
    // 当不在编辑状态的时候不需要对时间进行操作
    if ((selectedCell.appointmentHour.hourStatus == QMAppointmentHourStatusAvailable || selectedCell.appointmentHour.hourStatus == QMAppointmentHourStatusUnavilable) && !self.beginEditing) {
        return ;
    }
    
    if (selectedCell.appointmentHour.hourStatus == QMAppointmentHourStatusUnavilable) {
        selectedCell.appointmentHour.hourStatus = QMAppointmentHourStatusAvailable ;
    } else if (selectedCell.appointmentHour.hourStatus == QMAppointmentHourStatusAvailable) {
        selectedCell.appointmentHour.hourStatus = QMAppointmentHourStatusUnavilable ;
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone] ;
    
}

/*
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {

    return self.beginEditing ? 49 : 0 ;
}
*/
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [button setImage:[UIImage imageNamed:@"suo2"] forState:UIControlStateNormal] ;
    [button setBackgroundImage:[UIImage imageNamed:@"yuyuedi"] forState:UIControlStateNormal] ;
    [button setBackgroundImage:[UIImage imageNamed:@"tijiaodi_hlighted"] forState:UIControlStateSelected] ;
    [button setTitleColor:[UIColor colorWithColorString:@"4d6ea5"] forState:UIControlStateNormal] ;
    [button setTitle:@"提交" forState:UIControlStateNormal] ;
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter] ;
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16] ;
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, -7) ;
    [button addTarget:self action:@selector(changeTimeList:) forControlEvents:UIControlEventTouchUpInside] ;
    
    return button ;

}


- (void) changeTimeList : (UIButton *) sender {
    
    // 提示医生是否要进行更改
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"预约锁定" message:@"您确定要这个时间段不能接受预约吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] ;
    [alertView show] ;
    
    
}




#pragma mark - 刷新相关
- (void) installRefreshHeaderView {
    
    MJRefreshHeaderView * headerView = [MJRefreshHeaderView header] ;
    headerView.scrollView = self.tableView ;
    headerView.delegate = self ;
    self.refreshHeaderView = headerView ;
    
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
    
    // 刷新数据
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        if (self.shouldReloadDataBlock) {
            self.shouldReloadDataBlock(self , self.selectedDate) ;
        }
    }
}

- (void)endRefresh {
    
    [self.refreshHeaderView endRefreshing] ;
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 1) {
        [self didChangeTimeList] ;
    }
}

- (void) didChangeTimeList {

    
    self.beginEditing = NO ;
    
    // 需要提交网络请求,更改医生的工作时间表
    NSMutableString * hourList = [NSMutableString string] ;
    NSMutableString * hourStatusList = [NSMutableString string] ;
    // 1.获取当前的医生工作时间表
    for (int i = 0; i < self.dayAppointments.count; i++) {
        QMAppointmentHour * appointmentHour = self.dayAppointments[i] ;
        if (appointmentHour.hourStatus != QMAppointmentHourStatusAvailable && appointmentHour.hourStatus != QMAppointmentHourStatusUnavilable) {
            // 不需要更改其他状态的预约模型
            continue ;
        }
        [hourList appendFormat:@"%@" , appointmentHour.hour] ;
        [hourStatusList appendFormat:@"%ld" , appointmentHour.hourStatus] ;
        if (i < self.dayAppointments.count - 1) {
            [hourList appendString:@","] ;
            [hourStatusList appendString:@","] ;
        }
    }
    
    // 2.通知控制器提交网络请求
    if (self.changeDoctorWorkTimeBlock) {
        self.changeDoctorWorkTimeBlock(hourList , hourStatusList , self.selectedDate) ;
    }
}

//- (void) cancelAppointment {
//
//    self.sendAppointmentRequest(self.dayAppointments[indexPath.row] , self.selectedDate , QMAppointmentViewSendAppointRequestTypeCancel) ;
//}

@end
