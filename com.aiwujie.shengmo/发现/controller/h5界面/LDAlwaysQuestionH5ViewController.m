//
//  LDAlwaysQuestionH5ViewController.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/10/20.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDAlwaysQuestionH5ViewController.h"

@interface LDAlwaysQuestionH5ViewController ()

@end

@implementation LDAlwaysQuestionH5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX])];
    
    if (@available(iOS 11.0, *)) {
        
        web.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.url]]];
    
    [web loadRequest:request];
    
    web.scalesPageToFit = YES;
    
    [self.view addSubview:web];
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
