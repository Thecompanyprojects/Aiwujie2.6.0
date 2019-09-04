//
//  LDGroupUpViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/19.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDGroupUpViewController.h"
#import "LDCertificateBeforeViewController.h"

@interface LDGroupUpViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (nonatomic,copy) NSString *status;

@end

@implementation LDGroupUpViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Other/getidstate"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //        NSLog(@"%@",responseObject);
        
        if (integer == 2000) {
            
            _status = @"已认证";
            
            [self.sureButton setTitle:@"已认证" forState:UIControlStateNormal];
            
            self.sureButton.userInteractionEnabled = NO;
            
        }else if(integer == 2001){
            
            _status = @"正在审核";
            
            [self.sureButton setTitle:@"正在审核" forState:UIControlStateNormal];
            
            self.sureButton.userInteractionEnabled = NO;
            
        }else if (integer == 2002){
            
            _status = @"立即认证";
            
            [self.sureButton setTitle:@"去认证" forState:UIControlStateNormal];
            
            self.sureButton.userInteractionEnabled = YES;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"升级群";
    
    self.headView.layer.cornerRadius = 25;
    self.headView.clipsToBounds = YES;
    
    self.sureButton.layer.cornerRadius = 2;
    self.sureButton.clipsToBounds = YES;
    
    [self.headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.headpic]] placeholderImage:[UIImage imageNamed:@"群默认头像"]];
    
    
}

- (IBAction)sureButtonClick:(id)sender {
    
    LDCertificateBeforeViewController *bvc = [[LDCertificateBeforeViewController alloc] init];
    
    bvc.where = @"1";
    
    [self.navigationController pushViewController:bvc animated:YES];
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
