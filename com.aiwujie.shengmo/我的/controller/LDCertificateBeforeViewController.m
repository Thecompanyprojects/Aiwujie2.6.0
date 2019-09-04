//
//  LDCertificateBeforeViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/19.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDCertificateBeforeViewController.h"
#import "LDCertificateViewController.h"

@interface LDCertificateBeforeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *vipView;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;
@property (weak, nonatomic) IBOutlet UIButton *openButton;

@end

@implementation LDCertificateBeforeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"认证权限";
    
    if (ISIPHONEX) {
        
        self.openButton.frame = CGRectMake(0, self.openButton.frame.origin.y - 34, self.openButton.frame.size.width, self.openButton.frame.size.height);
    }
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"uid"],@"lat":[[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"]};
    
    [manager POST:[NSString stringWithFormat:@"%@%@",URL,@"Api/Other/getHeadAndNickname"] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        //                NSLog(@"%@",responseObject);
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
        }else{
            
            [self.backImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"head_pic"]]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
            
              [self.headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"head_pic"]]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"88888%@",error);
        
    }];
    
    self.backImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.backImageView.clipsToBounds = YES;
    
    self.headView.layer.cornerRadius = 40;
    self.headView.clipsToBounds = YES;
    
    self.oneLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self.oneLabel sizeToFit];
    
//    self.twoLabel.lineBreakMode = NSLineBreakByWordWrapping;
////
//    [self.twoLabel sizeToFit];
//    
//    self.threeLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    
//    [self.threeLabel sizeToFit];
    
    if (WIDTH == 320) {
        
        self.oneLabel.font = [UIFont systemFontOfSize:11];
        self.twoLabel.font = [UIFont systemFontOfSize:11];
        self.threeLabel.font = [UIFont systemFontOfSize:11];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 0) {
        
        self.vipView.image = [UIImage imageNamed:@"高级灰"];
        
    }else{
    
        self.vipView.image = [UIImage imageNamed:@"高级紫"];
    }
   
}
- (IBAction)openButtonClick:(id)sender {
    
    LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
    
    cvc.where = self.where;
    
    [self.navigationController pushViewController:cvc animated:YES];
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
