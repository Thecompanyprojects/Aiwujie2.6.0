//
//  LDCreateGroupFailViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/18.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDCreateGroupFailViewController.h"
#import "LDCertificateViewController.h"
#import "LDMemberViewController.h"
#import "LDStandardViewController.h"
#import "LDBindingPhoneNumViewController.h"

@interface LDCreateGroupFailViewController ()

@end

@implementation LDCreateGroupFailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"创建群组";
    
}
- (IBAction)certificationButtonClick:(id)sender {
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Other/getidstate"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //        NSLog(@"%@",responseObject);
        
        if (integer == 2000) {
            
            //审核通过
            
            LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
            
            cvc.type = @"2";
            
            [self.navigationController pushViewController:cvc animated:YES];
            
        }else if(integer == 2001){
            
            //正在审核
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"正在审核,请耐心等待~"];
            
        }else if (integer == 2002){
            
            //立即认证
            
            LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
            
            [self.navigationController pushViewController:cvc animated:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}

- (IBAction)bindPhoneNumButtonClick:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Users/getBindingState"];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //NSLog(@"%@",responseObject);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
        }else{
            
            NSString *phoneNum = [NSString string];
            
            if ([responseObject[@"data"][@"mobile"] length] == 0) {
                
                phoneNum = @"";
                
            }else{
                
                phoneNum = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"mobile"]];
                
            }
            
            LDBindingPhoneNumViewController * pvc = [[LDBindingPhoneNumViewController alloc] init];
            
            pvc.phoneNum = phoneNum;
            
            [self.navigationController pushViewController:pvc animated:YES];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

- (IBAction)vipButtonClick:(id)sender {
    
    LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
    
    [self.navigationController pushViewController:mvc animated:YES];
}

- (IBAction)HtmlButtonClick:(id)sender {
    
    LDStandardViewController *svc = [[LDStandardViewController alloc] init];
    
    svc.navigationItem.title = @"互联网群组信息服务管理规定";
    
    svc.state = @"互联网群组信息服务管理规定";
    
    [self.navigationController pushViewController:svc animated:YES];
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
