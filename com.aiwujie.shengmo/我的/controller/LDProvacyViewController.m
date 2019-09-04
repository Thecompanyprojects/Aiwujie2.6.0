//
//  LDProvacyViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/4.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDProvacyViewController.h"
#import "LDPrivacyPhotoViewController.h"
#import "LDBlackListViewController.h"

@interface LDProvacyViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *attentSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *groupSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *locationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *loginTimeSwitch;

@property (weak, nonatomic) IBOutlet UILabel *blackLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *blackButton;
@property (weak, nonatomic) IBOutlet UIButton *privacyButton;

@property (nonatomic,copy) NSString *attentString;

@property (nonatomic,copy) NSString *groupString;

@property (nonatomic,copy) NSString *loginTimeString;

@property (nonatomic,copy) NSString *statusString;

@end

@implementation LDProvacyViewController

-(void)viewWillAppear:(BOOL)animated{

    [self createAlertStatusData];
}

-(void)createAlertStatusData{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/users/getSecretSit"];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
            
        }else{
            
            if ([responseObject[@"data"][@"photo_lock"] intValue] == 1) {
                
                self.statusLabel.text = @"已开放";
                
                _statusString = @"1";
                
            }else{
                
                self.statusLabel.text = @"未开放";
                
                _statusString = @"2";
            }
            
            
            self.blackLabel.text = responseObject[@"data"][@"black_limit"];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"%@",error);
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"隐私";
    
    [self createStatusData];
    
    [self createButton];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        _locationSwitch.on = YES;
        
    }else{
    
        _locationSwitch.on = NO;
    }
}


-(void)createStatusData{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/users/getSecretSit"];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];

            
        }else{
            
            if ([responseObject[@"data"][@"follow_list_switch"] intValue] == 0) {
                
                self.attentSwitch.on = YES;
                
                _attentString = @"0";
                
            }else{
            
                self.attentSwitch.on = NO;
                
                _attentString = @"1";
            }
      
            if ([responseObject[@"data"][@"group_list_switch"] intValue] == 0) {
                
                self.groupSwitch.on = YES;
                
                _groupString = @"0";
                
            }else{
                
                self.groupSwitch.on = NO;
                
                _groupString = @"1";
            }

            if ([responseObject[@"data"][@"photo_lock"] intValue] == 1) {
                
                self.statusLabel.text = @"已开放";
                
                _statusString = @"1";
                
            }else{
                
                self.statusLabel.text = @"未开放";
                
                _statusString = @"2";
            }
            
            if ([responseObject[@"data"][@"login_time_switch"] intValue] == 0) {
                
                self.loginTimeSwitch.on = YES;
                
                _loginTimeString = @"0";
                
            }else{
                
                self.loginTimeSwitch.on = NO;
                
                _loginTimeString = @"1";
            }

            
            self.blackLabel.text = responseObject[@"data"][@"black_limit"];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"%@",error);
    }];
}

- (IBAction)attentSwitchClick:(id)sender {
    
    if ([_attentString intValue] == 0) {
        
        self.attentSwitch.on = NO;
        
        _attentString = @"1";
        
    }else{
    
        self.attentSwitch.on = YES;
        
        _attentString = @"0";
        
    }
}
- (IBAction)groupSwitchClick:(id)sender {
    
    if ([_groupString intValue] == 0) {
        
        self.groupSwitch.on = NO;
        
        _groupString = @"1";
        
    }else{
    
        self.groupSwitch.on = YES;
        
        _groupString = @"0";
    }
}
- (IBAction)hideLocationSwitch:(id)sender {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        _locationSwitch.on = NO;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"hideLocation"];
        
    }else{
        
        _locationSwitch.on = YES;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"hideLocation"];
    }
    
}
- (IBAction)hideLoginTimeSwitch:(id)sender {
    
    if ([_loginTimeString intValue] == 0) {
        
        self.loginTimeSwitch.on = NO;
        
        _loginTimeString = @"1";
        
    }else{
        
        self.loginTimeSwitch.on = YES;
        
        _loginTimeString = @"0";
        
    }

    
}
- (IBAction)blackButtonClick:(id)sender {
    
    LDBlackListViewController *bvc = [[LDBlackListViewController alloc] init];
    
    [self.navigationController pushViewController:bvc animated:YES];
}
- (IBAction)privacyButtonClick:(id)sender {
        
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 0) {
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您现在还不是会员,不能设置相册的开启~"];
        
        
    }else if([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1){
        
        LDPrivacyPhotoViewController *pvc = [[LDPrivacyPhotoViewController alloc] init];
        
        pvc.privacyString = _statusString;
        
        pvc.attentString = _attentString;
        
        pvc.groupString = _groupString;
        
        [self.navigationController pushViewController:pvc animated:YES];
        
    }
}

-(void)createButton{

    UIButton * areaButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 36, 10, 14)];
    
    if (@available(iOS 11.0, *)) {
        
        [areaButton setImage:[UIImage imageNamed:@"back-11"] forState:UIControlStateNormal];
        
    }else{
        
        [areaButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }
    
    [areaButton addTarget:self action:@selector(backButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:areaButton];
    
    if (@available(iOS 11.0, *)) {
        
        leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 44);
    }
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

-(void)backButtonOnClick{
    
    if (_attentString.length != 0 && _groupString.length != 0 && _loginTimeString.length != 0) {
        
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/users/setSecretSit"];
        
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"follow_list_switch":_attentString,@"group_list_switch":_groupString,@"login_time_switch":_loginTimeString};
        
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
            
            //        NSLog(@"%@",responseObject);
            
            if (integer != 2000) {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[responseObject objectForKey:@"msg"]    preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
                [alert addAction:action];
                
                [self presentViewController:alert animated:YES completion:nil];
                
                
            }else{
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"因网络等原因修改失败"    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            
            [alert addAction:action];
            
            [self presentViewController:alert animated:YES completion:nil];
        }];

    }else{
    
        [self.navigationController popViewControllerAnimated:YES];
    }
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
