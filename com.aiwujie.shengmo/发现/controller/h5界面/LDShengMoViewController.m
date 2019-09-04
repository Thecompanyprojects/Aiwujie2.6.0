//
//  LDShengMoViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/25.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDShengMoViewController.h"

@interface LDShengMoViewController ()

@end

@implementation LDShengMoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = self.name;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self.type intValue] > 0) {
        
        [self createOtherH5:self.type];

    }else{
    
       [self createData];
    }

}

-(void)createOtherH5:(NSString *)type{

    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX])];
    
    if (@available(iOS 11.0, *)) {
        
        web.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    NSURLRequest *request = [[NSURLRequest alloc] init];
    
    if ([type intValue] == 1) {
        
        request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL,@"Home/info/recruit"]]];
        
    }else if ([type intValue] == 2){
    
        request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL,@"Home/info/volunteer"]]];
        
    }else if ([type intValue] == 3){
    
        request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL,@"Home/info/greensm"]]];
    }
    
    [web loadRequest:request];
    
    web.scalesPageToFit = YES;
    
    [self.view addSubview:web];

}

-(void)createData{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Other/getFindUrl"];
    
    NSDictionary *parameters = @{@"type":self.state};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//        NSLog(@"%@",responseObject);
        
        if (integer == 2000) {
            
            UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX])];
            
            if (@available(iOS 11.0, *)) {
                
                web.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
                
            }else {
                
                self.automaticallyAdjustsScrollViewInsets = NO;
            }
            
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"url"]]]];
            
            [web loadRequest:request];
            
            web.scalesPageToFit = YES;
            
            [self.view addSubview:web];
            
        }else{
        
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

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
