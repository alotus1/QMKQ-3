//
//  Login.m
//  QMKQ
//
//  Created by shangjin on 15/9/1.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "Login.h"
#import "config.h"
#import "QMRequest.h"
#import "Tools.h"
#import "AppDelegate.h"
#import "AppDelegate+TestData.h"
#import "SetMyInfo.h"

@interface Login () <UITextFieldDelegate,UITextFieldDelegate>
{
    CGFloat keyboardHeight;
}
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *codeField;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBt;
@property (weak, nonatomic) IBOutlet UIButton *loginBt;

@property (nonatomic, strong) NSTimer *timer;//定时器
@property (nonatomic, assign) NSInteger time;

@end

@implementation Login

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    [self addKeyboardNotifi];
    keyboardHeight=0;
    self.phoneNumberField.delegate= self;
    self.codeField.delegate = self;
    self.phoneNumberField.returnKeyType=UIReturnKeyDone;
    self.codeField.returnKeyType=UIReturnKeyDone;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)showKeyboard:(NSNotification *)notifi
{
    UIView * vi = nil;
    if (self.codeField.isFirstResponder) {
        vi = self.codeField;
    }else {
        vi = self.phoneNumberField;
    }
    if (vi==nil) {
        return;
    }
    CGRect r= [vi convertRect:vi.bounds toView:self.view];
    NSValue*fv=[notifi.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect f = [fv CGRectValue];
    CGFloat ff = f.size.height == 0 ? f.origin.y : (ScreenHeight-f.size.height);
    if (r.origin.y+r.size.height > ff && keyboardHeight == 0) {
        //
        keyboardHeight=r.origin.y + r.size.height - ff + 90;
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

- (void)tapAction:(UITapGestureRecognizer*)tap
{
    [self.view.window endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)getCheckCodeFromPhone:(UIButton *)sender {
    if (self.phoneNumberField.text.length>0 && [Tools validateMobile:self.phoneNumberField.text]) {
        self.getCodeBt.enabled=NO;
        [[[QMRequest alloc] init] startWithPackage:@{@"mobileNo":self.phoneNumberField.text} post:NO apiType:SendVerCode completion:^(BOOL success, NSError *error, NSDictionary *result) {
            if (success && [[result objectForKey:@"code"] intValue] == 1000) {
                if (self.timer || self.timer.isValid) {
                    [self.timer invalidate];
                    self.timer=nil;
                }
                self.time = 60;
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(changeBtTitle) userInfo:nil repeats:YES];
                [self.getCodeBt setTitle:@"60s" forState:0];
            }else {
                ALERT1(@"验证码发送错误，请重试!");
                self.getCodeBt.enabled=YES;
            }
        }];
    }else {
        ALERT1(@"请输入正确的电话号码!");
    }
}
- (void)changeBtTitle
{
    self.time--;
    if (self.time<0) {
        [self.timer invalidate];
        self.timer = nil;
        [self.getCodeBt setTitle:@"获取验证码" forState:0];
        self.getCodeBt.enabled = YES;
    }else {
        [self.getCodeBt setTitle:[NSString stringWithFormat:@"%ds",(int)self.time] forState:0];
    }
}
- (IBAction)loginAction:(UIButton *)sender {
    if (self.codeField.text.length>0) {
        self.loginBt.enabled=NO;
        [[[QMRequest alloc] init] startWithPackage:@{@"mobileNo":self.phoneNumberField.text,@"vercode":self.codeField.text,@"appType":@"1"} post:NO apiType:VercodeLogin completion:^(BOOL success, NSError *error, NSDictionary *result) {
            if (success) {
                NSDictionary * data = [result objectForKey:@"data"];
                if ([[data objectForKey:@"uid"] intValue] != -1) {
                    ALERT1(@"用户请使用用户端登陆!");
                    self.loginBt.enabled=YES;
                }else {
                    AppDelegate*app=(AppDelegate*)[UIApplication sharedApplication].delegate;
                    app.myself=[[Doctor alloc]init];
                    app.myself.doctorId = [NSString stringWithFormat:@"%@",[data objectForKey:@"doctorId"]];
                    [Doctor createTableWithName:MyInfoStoreKey andPropertyList:[Doctor getPropertyListWithPrimaryKey:@[@"doctorId"]] result:nil];
                    [Doctor clearTableWithName:MyInfoStoreKey result:nil];
                    [app.myself addToTableWithTableName:MyInfoStoreKey result:nil];
                    if ([[data objectForKey:@"status"] intValue] == 1) {
                        //已填写过信息
                        //不只要获取医生信息还要获取医生治疗的病人
                        [app addTestData];
                        UIViewController * vc = ViewControllerFromStoryboardWithIdentifier(@"TabBarVC");
                        UIWindow*keyWindow = [app window];
                        [keyWindow setRootViewController:vc];
                        [keyWindow makeKeyAndVisible];
                    }else {
                        //未填写过信息
                        SetMyInfo*vc = ViewControllerFromStoryboardWithIdentifier(@"SetMyInfoNavi");
//                        vc.my=app.myself;
                        app.window.rootViewController = vc;
                        [app.window makeKeyAndVisible];
                    }
                }
            }else {
                ALERT1(@"验证码错误!");
                self.loginBt.enabled=YES;
            }
        }];
    }else {
        ALERT1(@"验证码不能为空!");
    }
}

@end
