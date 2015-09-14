//
//  SetMyInfo.m
//  QMKQ
//
//  Created by shangjin on 15/8/8.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "SetMyInfo.h"
#import "DLRadioButton.h"
#import "SMIAvatarCell.h"
#import "SMIAnotherCell.h"
#import "SMISexCell.h"
#import "SMIBirthdayCell.h"
#import "SMIDescCell.h"
#import "config.h"
#import "Tools.h"
#import "QMRequest.h"
#import <LGActionSheet.h>
#import <UIImageView+AFNetworking.h>
#import "QBImagePickerController.h"
#import "BImageCache.h"
#import "SMIMenzhenCell.h"
#import "YiYuanMenZhenDelegate.h"
#import "AppDelegate.h"


@interface SetMyInfo () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,QBImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    CGFloat keyboardHeight;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) UIImageView *imgView;
@property (nonatomic, retain) UITextField *name;
@property (nonatomic, retain) UITextField *menzhen;
@property (nonatomic, retain) UITextField *yiyuan;
@property (nonatomic, retain) UITextField *zhicheng;
@property (nonatomic, retain) UITextField *birthdayField;
@property (nonatomic, strong) NSDate *birthday;
@property (nonatomic, retain) UITextView *jianjie;

@property (nonatomic, strong) YiYuanMenZhenDelegate *yiyuanDataDelegate;
@property (nonatomic, strong) NSString * yiyuanId;

@property (nonatomic, strong) UIDatePicker * datePicker;

@property (nonatomic, strong) UIImagePickerController*picker;
@property (nonatomic, strong) NSString * imagePath;

//用来修复重复点击不能回收的bug
@property (nonatomic, retain) LGActionSheet * mySheet;

@end

@implementation SetMyInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"个人设置";
    if (self.navigationController.viewControllers.count > 1) {
        [self setLeftButtonItem];
    }
    // Do any additional setup after loading the view.
    // 日期
    NSDateFormatter*dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateFormat=@"yyyy.MM.dd";
    
    // 图片选择器
    self.picker=[[UIImagePickerController alloc]init];
    self.picker.delegate=self;
    
    // tableView
    self.tableView.backgroundColor=BgColor;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView=[[UIView alloc]init];
    if (!self.my) {
        //不存在即为第一次进入
        [Doctor selectTableWithName:MyInfoStoreKey sqlString:nil result:^(HandleState state, NSArray *results) {
            self.my=[results lastObject];
            self.my.gender=@"0";
        }];
    }
    [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignFirst)]];
    
    // 门诊相关
    UITableView*yiyuanTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth-20, 100) style:UITableViewStylePlain];
    self.yiyuanDataDelegate = [[YiYuanMenZhenDelegate alloc]initWithTableView:yiyuanTableView];
    __weak SetMyInfo*weakSelf = self;
    self.yiyuanDataDelegate.getDataForTableView = ^(int page, int count)
    {
        // 请求门诊数据
        if (weakSelf.menzhen.text.length > 0) {
            NSString*string = [weakSelf.menzhen.text isEqualToString:@"北京"]?@"110000":@"510000";
            [[[QMRequest alloc] init] startWithPackage:@{@"cityId":string,@"start":[NSString stringWithFormat:@"%d",page],@"max":[NSString stringWithFormat:@"%d",count]} post:NO apiType:GetClinicList completion:^(BOOL success, NSError *error, NSDictionary *result) {
                if (success) {
                    NSArray*array = [result objectForKey:@"data"];
                    if (array.count>0) {
                        if (weakSelf.yiyuanDataDelegate.addDataForTableView) {
                            weakSelf.yiyuanDataDelegate.addDataForTableView(array);
                        }
                    }
                }
            }];
        }else {
            ALERT1(@"请选择城市");
        }
    };
    
    //键盘收缩
    keyboardHeight=0;
    [self addKeyboardNotifi];
}

- (void)resignFirst
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)showKeyboard:(NSNotification*)notifi
{
    UIView*vi = nil;
    if (self.name.isFirstResponder) {
        vi=self.name;
    }else if (self.yiyuan.isFirstResponder) {
        vi=self.yiyuan;
    }else if (self.zhicheng.isFirstResponder) {
        vi=self.zhicheng;
    }else if (self.jianjie.isFirstResponder) {
        vi=self.jianjie;
    }
    CGRect r= [vi convertRect:vi.bounds toView:self.view];
    NSValue*fv=[notifi.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect f = [fv CGRectValue];
    if (r.origin.y+r.size.height > ScreenHeight-f.size.height&& keyboardHeight == 0) {
        //
        keyboardHeight=f.size.height;
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame=CGRectMake(0, self.view.frame.origin.y-keyboardHeight, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

- (void)hideKeyboard:(NSNotification*)notifi
{
    if (keyboardHeight != 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame=CGRectMake(0, self.view.frame.origin.y+keyboardHeight, self.view.frame.size.width, self.view.frame.size.height);
            keyboardHeight=0;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    if (indexPath.row == 0) {
        height = 100;
    }else if (indexPath.row == 1) {
        height = 5;
    }else {
        height = 55;
    }
    if (indexPath.row == 7) {
        height = 175;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell*cell = nil;
    
    if (indexPath.row == 0) {
        SMIAvatarCell*c = [tableView dequeueReusableCellWithIdentifier:@"SMIAvatarCell"];
        if (self.my.doctorId!=0) {
            c.imageView.image=[UIImage imageWithContentsOfFile:self.my.headFileUrl];
        }
        self.imgView=c.imgView;
        [c.imgView setImageWithURL:[NSURL URLWithString:self.my.headFileUrl] placeholderImage:[UIImage imageNamed:@"tx1"]];
        cell = c;
    }else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SMISeparatorCell"];
        cell.backgroundColor=BgColor;
    }else if ((indexPath.row == 2 || indexPath.row == 6)) {
        SMIAnotherCell*c = [tableView dequeueReusableCellWithIdentifier:@"SMIAnotherCell"];
        c.leftImgView.image = [UIImage imageNamed:@"_"];
        if (indexPath.row == 2) {
            c.leftLabel.text = @"姓名";
            if (self.my.doctorId!=0) {
                c.rightTextField.text = self.my.name;
            }
            self.name=c.rightTextField;
        }else if (indexPath.row == 6) {
            c.leftLabel.text = @"职称";
            if (self.my.doctorId!=0) {
                c.rightTextField.text = self.my.professionalTitle;
            }
            self.zhicheng=c.rightTextField;
            self.zhicheng.delegate = self;
        }
        c.rightTextField.delegate=self;
        
        cell = c;
    }else if (indexPath.row == 3) {
        SMISexCell*c = [tableView dequeueReusableCellWithIdentifier:@"SMISexCell"];
        c.leftImgView.image = [UIImage imageNamed:@"_"];
        [Tools button:c.leftBt removeAllActionsFromTarget:self];
        [Tools button:c.leftBt andOthersButtonAddTarget:self action:@selector(selectSex:)];
        
        if (self.my.doctorId!=0) {
            if ([self.my.gender intValue] == 0) {
                c.leftBt.selected=YES;
            }else {
                c.rightBt.selected=YES;
            }
        }
        cell = c;
    }else if (indexPath.row == 4) {
        SMIBirthdayCell*c = [tableView dequeueReusableCellWithIdentifier:@"SMIBirthdayCell"];
        c.leftImgView.image = [UIImage imageNamed:@"_"];
        c.leftLabel.text = @"生日";
        c.birthdayTextField.delegate=self;
        self.birthdayField=c.birthdayTextField;
        if (self.my.doctorId!=0) {
            NSDateFormatter*datefor = [[NSDateFormatter alloc]init];
            datefor.dateFormat=@"yyyy/MM/dd";
            if (self.my.birthday.length>0) {
                NSString*birStr = self.my.birthday;
                NSArray*dayArr=[birStr componentsSeparatedByString:@" "];
                NSArray*dateArray = [[dayArr objectAtIndex:0] componentsSeparatedByString:@"-"];
                NSString*dayStr = [dateArray lastObject];
//                NSString*monthStr = [MonthDictionary objectForKey:[NSString stringWithFormat:@"%d",[[dateArray objectAtIndex:1] intValue]]];
                NSString * monthStr = [dateArray objectAtIndex:1];
                self.birthday=[datefor dateFromString:[NSString stringWithFormat:@"%@/%@/%@",[dateArray objectAtIndex:0],monthStr,dayStr]];
            }
            c.birthdayTextField.text = [datefor stringFromDate:self.birthday];
        }
        cell = c;
    }else if (indexPath.row == 5) {
        SMIMenzhenCell*cel = [tableView dequeueReusableCellWithIdentifier:@"SMIMenzhenCell"];
        cel.imgView.image = [UIImage imageNamed:@"_"];
        cel.leftLabel.text = @"门诊";
        if (self.my.doctorId!=0) {
            cel.shiField.text = [self.my.cityId intValue]==110000?@"北京":@"成都";
            cel.yiyuanField.text = self.my.hospital;
            self.yiyuanId = self.my.doctorClinicId;
        }
        self.menzhen=cel.shiField;
        self.menzhen.delegate=self;
        self.yiyuan=cel.yiyuanField;
        self.yiyuan.delegate=self;
        cell = cel;
    }else if (indexPath.row == 7) {
        SMIDescCell*c = [tableView dequeueReusableCellWithIdentifier:@"SMIDescCell"];
        c.leftLabel.text = @"个人简介";
        self.jianjie=c.rightTextView;
        c.rightTextView.delegate=self;
        if (self.my.doctorId!=0) {
        c.rightTextView.text = self.my.desc;
        }
        cell = c;
    }
    if ([cell viewWithTag:200]) {
        CGRect r = [cell viewWithTag:200].frame;
        r.size.height = 1;
        [cell viewWithTag:200].frame = r;
    }else if (indexPath.row >1) {
        CGFloat ory = 54;
        if (indexPath.row == 0) {
            ory = 99;
        }else if (indexPath.row ==1) {
            ory = 4;
        }else if (indexPath.row == 7) {
            ory = 174;
        }
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, ory, self.view.frame.size.width, 1)];
        view.tag = 200;
        view.backgroundColor=LineColor;
        [cell addSubview:view];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)selectSex:(DLRadioButton*)bt
{
    if (bt.selectedButton == nil && bt.selected==NO) {
        if ([bt.currentTitle isEqualToString:@"男"]) {
            self.my.gender=@"1";
        }else {
            self.my.gender=@"0";
        }
        for (DLRadioButton*oth in bt.otherButtons) {
            oth.selected=YES;
        }
    }else {
        if ([bt.selectedButton.currentTitle isEqualToString:@"男"]) {
            self.my.gender=@"0";
        }else {
            self.my.gender=@"1";
        }
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.birthdayField]) {
        NSDateFormatter*datefor = [[NSDateFormatter alloc]init];
        datefor.dateFormat=@"yyyy/MM/dd";
        if (!self.datePicker) {
            self.datePicker = [[UIDatePicker alloc] init];
            self.datePicker.date=[datefor dateFromString:[datefor stringFromDate:[NSDate date]]];
            self.datePicker.datePickerMode=UIDatePickerModeDate;
            self.datePicker.frame = CGRectMake(0.f, 0.f, self.datePicker.frame.size.width, 100.f);
            
        }
        [[[LGActionSheet alloc] initWithTitle:@"请选择你的生日"
                                         view:self.datePicker
                                 buttonTitles:@[@"确定"]
                            cancelButtonTitle:@"取消"
                       destructiveButtonTitle:nil
                                actionHandler:^(LGActionSheet *actionSheet, NSString *title, NSUInteger index) {
                                    self.birthdayField.text = [datefor stringFromDate:self.datePicker.date];
                                    self.birthday = self.datePicker.date;
                                }
                                cancelHandler:nil
                           destructiveHandler:nil] showAnimated:YES completionHandler:nil];
        return NO;
    }else if ([textField isEqual:self.menzhen]) {
        [[[LGActionSheet alloc] initWithTitle:@"请选择城市"
                                         view:nil
                                 buttonTitles:@[@"北京",@"成都"]
                            cancelButtonTitle:@"取消"
                       destructiveButtonTitle:nil
                                actionHandler:^(LGActionSheet *actionSheet, NSString *title, NSUInteger index) {
                                    self.menzhen.text = title;
                                }
                                cancelHandler:nil
                           destructiveHandler:nil] showAnimated:YES completionHandler:nil];
        return NO;
    }else if ([textField isEqual:self.yiyuan]) {
        [self.yiyuanDataDelegate getFirstData];
        //必须无限创建，LGActionSheet没优化好
        self.mySheet = nil;
        self.mySheet = [[LGActionSheet alloc] initWithTitle:@"请选择门诊" view:self.yiyuanDataDelegate.tableView buttonTitles:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil];
        [self.mySheet showAnimated:YES completionHandler:nil];
        
        __weak SetMyInfo * weakSelf = self;
        if (!self.yiyuanDataDelegate.didSelectRowWithInfo) {
            self.yiyuanDataDelegate.didSelectRowWithInfo = ^(NSDictionary*info)
           {
                DLog(@"%@",info);
                weakSelf.yiyuanId = [info objectForKey:@"clinicId"];
                weakSelf.yiyuan.text=[info objectForKey:@"clinicName"];
                [weakSelf.mySheet dismissAnimated:YES completionHandler:nil];
            };
        }
        return NO;
    }else if ([textField isEqual:self.zhicheng]) {
        [[[LGActionSheet alloc] initWithTitle:@"请选择你的职称"
                                         view:nil
                                 buttonTitles:@[@"医师",@"主治医师",@"副主任医师",@"主任医师"]
                            cancelButtonTitle:@"取消"
                       destructiveButtonTitle:nil
                                actionHandler:^(LGActionSheet *actionSheet, NSString *title, NSUInteger index) {
                                    self.zhicheng.text = title;
                                }
                                cancelHandler:nil
                           destructiveHandler:nil] showAnimated:YES completionHandler:nil];
        return NO;
    }
    if (keyboardHeight != 0 && self.jianjie.isFirstResponder) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame=CGRectMake(0, self.view.frame.origin.y+keyboardHeight, self.view.frame.size.width, self.view.frame.size.height);
            keyboardHeight=0;
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)tijiao:(id)sender {
    NSString*str=@"";
    if (self.name.text.length>0) {
        self.my.name=self.name.text;
    }else {
        str = [str stringByAppendingString:@"\n请填写姓名"];
    }
    if (self.birthday) {
        NSDateFormatter*datefor = [[NSDateFormatter alloc]init];
        datefor.dateFormat=@"yyyy-MM-dd";
        self.my.birthday=[datefor stringFromDate:self.birthday];
    }else {
        str = [str stringByAppendingString:@"\n生日不能为空"];
    }
    if (self.menzhen.text.length>0) {
        self.my.cityId=[self.menzhen.text isEqualToString:@"北京"]?@"110000":@"510000";
    }else {
        str = [str stringByAppendingString:@"\n请填写城市"];
    }
    if (self.yiyuan.text.length>0) {
        self.my.doctorClinicId=self.yiyuanId;
        self.my.hospital=self.yiyuan.text;
    }else {
        str = [str stringByAppendingString:@"\n请选择门诊"];
    }
    NSString * level = @"0";
    if (self.zhicheng.text.length>0) {
        self.my.professionalTitle=self.zhicheng.text;
        if ([self.my.professionalTitle isEqualToString:@"医师"]) {
            level = @"1";
        }else if ([self.my.professionalTitle isEqualToString:@"主治医师"]) {
            level = @"2";
        }else if ([self.my.professionalTitle isEqualToString:@"副主任医师"]) {
            level = @"3";
        }else if ([self.my.professionalTitle isEqualToString:@"主任医师"]) {
            level = @"4";
        }
    }else {
        str = [str stringByAppendingString:@"\n请填写职称"];
    }
    if (str.length>0) {
        ALERT2(@"提交出问题了", str);
        return;
    }
    if (self.jianjie.text.length>0) {
        self.my.desc=self.jianjie.text;
    }else {
        self.my.desc=@"";
    }
    if (self.my.doctorId!=0 && self.my.doctorId != nil) {
        if (self.imgView.image) {
            [[[QMRequest alloc]init] uploadImages:self.imgView.image withPackage:@{@"doctorId":self.my.doctorId,@"picType":@"png"} post:YES apiType:UploadHeadPic completion:^(BOOL success, NSError *error, NSDictionary *result) {
                if (success && [result objectForKey:@"doctorPicPath"]) {
                    self.my.headFileUrl=[result objectForKey:@"doctorPicPath"];
                    [self.my updateDataForTableName:MyInfoStoreKey sqlString:nil result:nil];
                }
            }];
        }
        
        
        QMRequest*request=[[QMRequest alloc]init];
        request.type=AddMedicalInfo;
        request.post=YES;
        [request startWithPackage:@{
                                    @"doctorId":self.my.doctorId,
                                    @"doctorName":self.my.name,
                                    @"birthday":self.my.birthday,
                                    @"clinicId":self.my.doctorClinicId,
                                    @"level":level,
                                    @"detail":self.my.desc,
                                    @"gender":(self.my.gender.length>0?self.my.gender:@"0")}
                       completion:^(BOOL success, NSError *error, NSDictionary *result)
         {
             if (success) {
                 [self.my updateDataForTableName:MyInfoStoreKey sqlString:nil result:^(HandleState state) {
                     if (state == HandleStateSuccess) {
                         if (self.navigationController.viewControllers.count > 1) {
                             ALERT1(@"成功修改信息");
                             [self __back];
                         }else {
                             //本来这里可以直接跳转，为保证数据保存完整，重新执行保存
                             ALERT1(@"注册成功");
                             [self saveDoctorInfo];
                         }
                     }
                 }];
             }
         }];
    }else {
        ALERT1(@"注册信息错误!");
    }
}

//保存信息
- (void)saveDoctorInfo
{
    __weak SetMyInfo * weakSelf = self;
    [Doctor createTableWithName:MyInfoStoreKey andPropertyList:[Doctor getPropertyListWithPrimaryKey:@[@"doctorId"]] result:^(TableState state) {
        if (state == TableStateCreateSuccess || state == TableStateExist) {
            [self.my addToTableWithTableName:MyInfoStoreKey result:^(HandleState state) {
                if (state == HandleStateSuccess) {
                    DLog(@"成功新增");
                    //更换主页,主线程，异步跳转页面
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        __block UIViewController * vc = ViewControllerFromStoryboardWithIdentifier(@"TabBarVC");
                        if (weakSelf) {
                            [weakSelf presentViewController:vc animated:YES completion:^{
                                UIWindow*keyWindow = [[UIApplication sharedApplication].delegate window];
                                [keyWindow setRootViewController:vc];
                                [keyWindow makeKeyAndVisible];
                            }];
                        }else {
                            UIWindow*keyWindow = [[UIApplication sharedApplication].delegate window];
                            [keyWindow setRootViewController:vc];
                            [keyWindow makeKeyAndVisible];
                        }
                    });
                }else {
                    [weakSelf.my updateDataForTableName:MyInfoStoreKey sqlString:nil result:^(HandleState state) {
                        if (state == HandleStateSuccess) {
                            DLog(@"成功新增");
                            //更换主页,主线程，异步跳转页面
                            dispatch_async(dispatch_get_main_queue(), ^{
                                __block UIViewController * vc = ViewControllerFromStoryboardWithIdentifier(@"TabBarVC");
                                if (weakSelf) {
                                    [weakSelf presentViewController:vc animated:YES completion:^{
                                        UIWindow*keyWindow = [[UIApplication sharedApplication].delegate window];
                                        [keyWindow setRootViewController:vc];
                                        [keyWindow makeKeyAndVisible];
                                    }];
                                }else {
                                    UIWindow*keyWindow = [[UIApplication sharedApplication].delegate window];
                                    [keyWindow setRootViewController:vc];
                                    [keyWindow makeKeyAndVisible];
                                }
                            });
                        }
                    }];
//                    // 如果不是数据模型出错，不会出现这个错误
//                    ALERT1(@"数据库错误请重启");
                }
            }];
        }
    }];
}




- (IBAction)imageTapGesture:(id)sender {
    //选取图片
    
    [[[LGActionSheet alloc] initWithTitle:@"图片获取方式"
                                     view:nil
                             buttonTitles:@[@"打开相册",@"打开相机"]
                        cancelButtonTitle:@"取消"
                   destructiveButtonTitle:nil
                            actionHandler:^(LGActionSheet *actionSheet, NSString *title, NSUInteger index) {
                                if ([title isEqualToString:@"打开相册"]) {
                                    self.picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                                }else {
                                    //检查相机模式是否可用
                                    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                        //@"sorry, no camera or camera is unavailable."
                                        ALERT1(@"相机设备不能使用");
                                        return;
                                    }
                                    self.picker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                                }
                                [self presentViewController:self.picker animated:YES completion:nil];
                            }
                            cancelHandler:nil
                       destructiveHandler:nil] showAnimated:YES completionHandler:nil];
}


#pragma mark - QBImagePickerControllerDelegate

//- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
//{
//    NSLog(@"Selected assets:");
//    NSLog(@"%@", assets);
//    
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}
//
//- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
//{
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}

#pragma mark    - imagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    DLog(@"image : %@",image!=nil?@"存在":@"不在");
    //照相
    self.imgView.image=image;
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    DLog(@"info : %@",info);
    //相册
    UIImage*img=[info objectForKey:UIImagePickerControllerOriginalImage];
    //本地url UIImagePickerControllerReferenceURL;
    self.imgView.image=img;
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
