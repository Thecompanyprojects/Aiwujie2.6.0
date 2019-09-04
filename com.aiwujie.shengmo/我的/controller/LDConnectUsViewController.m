//
//  LDConnectUsViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/14.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDConnectUsViewController.h"

@interface LDConnectUsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *shengmoLabel;

@end

@implementation LDConnectUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"联系我们";
    
    [self createData];
    
}

-(void)createData{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Other/getCallAct"];
    
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//        NSLog(@"%@",responseObject);
        
        if (integer == 2000) {
            
            self.emailLabel.text = responseObject[@"data"][@"EMAIL"];
            
            self.mobileLabel.text = responseObject[@"data"][@"KFDH"];
            
            self.phoneLabel.text = responseObject[@"data"][@"KFSJ"];
            
            self.companyLabel.text = responseObject[@"data"][@"QYQQ"];
            
            self.shengmoLabel.text = responseObject[@"data"][@"SMQQ"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}

- (IBAction)mobileButtonClick:(id)sender {
    
    UIWebView *webView = [[UIWebView alloc]init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_mobileLabel.text]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];

}
- (IBAction)phoneButtonClick:(id)sender {
    
    UIWebView *webView = [[UIWebView alloc]init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phoneLabel.text]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:webView];

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
