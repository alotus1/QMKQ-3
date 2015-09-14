//
//  WebVC.m
//  QMKQ
//
//  Created by shangjin on 15/8/26.
//  Copyright (c) 2015年 skinner. All rights reserved.
//

#import "WebVC.h"

@interface WebVC ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftButtonItem];
    // Do any additional setup after loading the view.
    /**
     homepageIndex = "<null>";
     title = "doctor's news no.1";
     titlePic = "http://101.200.199.34/files/pics/homepage/top_1.jpg";
     url = "http://101.200.199.34/files/pics/homepage/top_1.jpg";
     */
    self.title = [self.homePageInfo objectForKey:@"title"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self.homePageInfo objectForKey:@"url"]]]];
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
