//
//  LDMyWalletViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/8.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDMyWalletViewController.h"
#import "LDChargeCenterViewController.h"
#import "LDDepositViewController.h"
#import "LDBillViewController.h"

@interface LDMyWalletViewController ()

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *chargeButton;
@property (weak, nonatomic) IBOutlet UIButton *depositButton;

@property (nonatomic,copy) NSString *account;

@property (nonatomic,copy) NSString *balance;

@property (nonatomic,copy) NSString *scale;

@end

@implementation LDMyWalletViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    [self createData];
}

-(void)createData{

   AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Users/getmywallet"];
    
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];

            
        }else{
            
            self.balanceLabel.text = [NSString stringWithFormat:@"%@ 魔豆",responseObject[@"data"][@"wallet"]];
            
            _account = responseObject[@"data"][@"nickname"];
            
            _balance = responseObject[@"data"][@"wallet"];
            
            _scale = responseObject[@"data"][@"pay"];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的钱包";
    
    self.chargeButton.layer.cornerRadius = 2;
    self.chargeButton.clipsToBounds = YES;
    
    self.depositButton.layer.cornerRadius = 2;
    self.depositButton.clipsToBounds = YES;
    
    [self createButton];
}

-(void)createButton{
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setTitle:@"账单" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton addTarget:self action:@selector(rightButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)rightButtonOnClick{
    
    LDBillViewController *bvc = [[LDBillViewController alloc] init];
    
    [self.navigationController pushViewController:bvc animated:YES];
}


- (IBAction)chargeButtonClick:(id)sender {
    
    LDChargeCenterViewController *cvc = [[LDChargeCenterViewController alloc] init];
    
    [self.navigationController pushViewController:cvc animated:YES];
}

- (IBAction)depositButtonClick:(id)sender {
    
    LDDepositViewController *dvc = [[LDDepositViewController alloc] init];
    
    dvc.beanNumber = _balance;
    
    dvc.scale = _scale;
    
    [self.navigationController pushViewController:dvc animated:YES];
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
