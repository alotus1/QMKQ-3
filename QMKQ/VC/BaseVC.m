//
//  BaseVC.m
//  QMKQ
//
//  Created by shangjin on 15/8/8.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout=UIRectEdgeBottom;
    }
    [self hideLine];
    
//    UIBarButtonItem*item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"<--1"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    self.navigationItem.backBarButtonItem=item;
    
}

- (void)hideLine
{
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                NSArray *list2=imageView.subviews;
                for (id obj2 in list2) {
                    if ([obj2 isKindOfClass:[UIImageView class]]) {
                        UIImageView *imageView2=(UIImageView *)obj2;
                        imageView2.hidden=YES;
                    }
                }
            }
        }
    }
}

- (void)setLeftButtonItem
{
    UIButton*bt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [bt setImage:[UIImage imageNamed:@"<--1"] forState:UIControlStateNormal];
    [bt setImage:[UIImage imageNamed:@"<--2"] forState:UIControlStateHighlighted];
    [bt setImageEdgeInsets:UIEdgeInsetsMake(20, 5, 14, 23)];
    [bt addTarget:self action:@selector(__back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:bt];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)__back
{
    if ([self.navigationController popViewControllerAnimated:YES]) {
        
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addKeyboardNotifi
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)showKeyboard:(NSNotification*)notifi
{
    
}

- (void)hideKeyboard:(NSNotification*)notifi
{
    
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

@end
