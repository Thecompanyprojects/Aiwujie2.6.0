//
//  LDPrivacyPhotoViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/4.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDPrivacyPhotoViewController.h"

@interface LDPrivacyPhotoViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (weak, nonatomic) IBOutlet UIButton *setPasswordButton;

@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,strong) UITextField *passwordField;
@property (nonatomic,strong) UITextField *oldpwdField;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@end

@implementation LDPrivacyPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"隐私相册";
    
    if ([_privacyString intValue] == 1) {
        
        self.switchButton.on = YES;
        
        self.backImageView.image = [UIImage imageNamed:@"密码开放"];
        
    }else{
    
        self.switchButton.on = NO;
        
        self.backImageView.image = [UIImage imageNamed:@"密码未开放"];
    }
    
    [self createButton];
}

-(void)createStatusData{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/users/judgePhotoPwd"];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//                NSLog(@"%@",responseObject);
        
        if (integer == 3000) {
            
            if ([_privacyString intValue] == 1) {
                
                self.switchButton.on = NO;
                
                self.backImageView.image = [UIImage imageNamed:@"密码未开放"];
                
                _privacyString = @"2";
                
            }else{
                
                self.switchButton.on = YES;
                
                self.backImageView.image = [UIImage imageNamed:@"密码开放"];
                
                _privacyString = @"1";
                
            }
        }else if(integer == 3001){
            
            _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
            _backgroundView.backgroundColor = [UIColor clearColor];
            _backgroundView.layer.cornerRadius = 2;
            _backgroundView.clipsToBounds = YES;
            [self.navigationController.view addSubview:_backgroundView];
            
            UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
            shadowView.backgroundColor = [UIColor blackColor];
            shadowView.alpha = 0.35;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
            [shadowView addGestureRecognizer:tap];
            [_backgroundView addSubview:shadowView];
            
            UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(50, HEIGHT/2 - 60, WIDTH - 100, 120)];
            alertView.backgroundColor = [UIColor whiteColor];
            alertView.layer.cornerRadius = 2;
            alertView.clipsToBounds = YES;
            [_backgroundView addSubview:alertView];
            
            _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, WIDTH - 120, 35)];
            _passwordField.placeholder = @"请输入相册密码(在1-16位之间)";
            _passwordField.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
            _passwordField.secureTextEntry = YES;
            _passwordField.font = [UIFont systemFontOfSize:14];
            _passwordField.delegate = self;
            
            [_passwordField addTarget:self action:@selector(textfieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            
            [alertView addSubview:_passwordField];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 75, WIDTH - 100, 1)];
            
            lineView.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
            
            [alertView addSubview:lineView];
            
            UIButton *alertButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 80, (WIDTH - 100)/2, 35)];
            
            [alertButton addTarget:self action:@selector(alertButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
            [alertButton setTitle:@"确定" forState:UIControlStateNormal];
            
            [alertButton setTitleColor:CDCOLOR forState:UIControlStateNormal];
            
            [alertView addSubview:alertButton];
            
            UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH - 100)/2, 80, (WIDTH - 100)/2, 35)];
            
            [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
            [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
            
            [cancelButton setTitleColor:CDCOLOR forState:UIControlStateNormal];
            
            [alertView addSubview:cancelButton];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
    }];

}

//textfield的代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    
    return YES;
}

//规定textField最多输入16个字
-(void)textfieldDidChange:(UITextField *)textField{
    
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        
        if(_passwordField.text.length >= 16 || _oldpwdField.text.length >= 16){
            
            _passwordField.text = [_passwordField.text substringToIndex:16];
            
            [_passwordField endEditing:YES];
            
            _oldpwdField.text = [_oldpwdField.text substringToIndex:16];
            
            [_oldpwdField endEditing:YES];
            
        }
        
    }
    
}

-(void)cancelButtonClick{

    if ([_privacyString intValue] == 1) {
        
        self.switchButton.on = YES;
        
        self.backImageView.image = [UIImage imageNamed:@"密码开放"];
        
    }else{
        
        self.switchButton.on = NO;
        
        self.backImageView.image = [UIImage imageNamed:@"密码未开放"];
    }

    [_backgroundView removeFromSuperview];
}

-(void)alertButtonClick{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/users/addPhotoPwd"];
    
    if (_passwordField.text.length == 0) {
        
        _passwordField.text = @"";
    }
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"newpwd":_passwordField.text};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
            if ([_privacyString intValue] == 1) {
                
                self.switchButton.on = YES;
                
                self.backImageView.image = [UIImage imageNamed:@"密码开放"];
                
            }else{
                
                self.switchButton.on = NO;
                
                self.backImageView.image = [UIImage imageNamed:@"密码未开放"];
                
            }
            
            [_backgroundView removeFromSuperview];
            
        }else{
            
            if ([_privacyString intValue] == 1) {
                
                self.switchButton.on = NO;
                
                self.backImageView.image = [UIImage imageNamed:@"密码未开放"];
                
                _privacyString = @"2";
                
            }else{
                
                self.switchButton.on = YES;
                
                self.backImageView.image = [UIImage imageNamed:@"密码开放"];
                
                _privacyString = @"1";
                
            }
            
            [_backgroundView removeFromSuperview];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
    }];

}

-(void)cancelClick{
    
    if ([_privacyString intValue] == 1) {
        
        self.switchButton.on = YES;
        
        self.backImageView.image = [UIImage imageNamed:@"密码开放"];
        
    }else{
        
        self.switchButton.on = NO;
        
        self.backImageView.image = [UIImage imageNamed:@"密码未开放"];
        
    }
    
    [_passwordField resignFirstResponder];
    
    [_oldpwdField resignFirstResponder];

    [_backgroundView removeFromSuperview];
}

- (IBAction)switchButtonClick:(id)sender {
    
    [self createStatusData];
    
}
- (IBAction)setPasswordButtonClick:(id)sender {
    
    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _backgroundView.backgroundColor = [UIColor clearColor];
    _backgroundView.layer.cornerRadius = 2;
    _backgroundView.clipsToBounds = YES;
    [self.navigationController.view addSubview:_backgroundView];
    
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    shadowView.backgroundColor = [UIColor blackColor];
    shadowView.alpha = 0.35;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
    [shadowView addGestureRecognizer:tap];
    [_backgroundView addSubview:shadowView];
    
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(50, HEIGHT/2 - 100, WIDTH - 100, 155)];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 2;
    alertView.clipsToBounds = YES;
    [_backgroundView addSubview:alertView];
    
    _oldpwdField = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, WIDTH - 120, 35)];
    _oldpwdField.placeholder = @"请输入原密码(在1-16位之间)";
    _oldpwdField.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    _oldpwdField.secureTextEntry = YES;
    _oldpwdField.font = [UIFont systemFontOfSize:14];
    _oldpwdField.delegate = self;
    
    [_oldpwdField addTarget:self action:@selector(textfieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [alertView addSubview:_oldpwdField];
    
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(10, 60, WIDTH - 120, 35)];
    _passwordField.placeholder = @"请输入新密码(在1-16位之间)";
    _passwordField.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    _passwordField.font = [UIFont systemFontOfSize:14];
    _passwordField.delegate = self;
    
    [_passwordField addTarget:self action:@selector(textfieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [alertView addSubview:_passwordField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, WIDTH - 100, 1)];
    
    lineView.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    
    [alertView addSubview:lineView];
    
    UIButton *alertButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 115, (WIDTH - 100)/2, 35)];
    
    [alertButton addTarget:self action:@selector(aginSetButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [alertButton setTitle:@"重置" forState:UIControlStateNormal];
    
    [alertButton setTitleColor:CDCOLOR forState:UIControlStateNormal];
    
    [alertView addSubview:alertButton];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH - 100)/2, 115, (WIDTH - 100)/2, 35)];
    
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    
    [cancelButton setTitleColor:CDCOLOR forState:UIControlStateNormal];
    
    [alertView addSubview:cancelButton];
}

-(void)aginSetButtonClick{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/users/editPhotoPwd"];
    
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"oldpwd":_oldpwdField.text,@"newpwd":_passwordField.text};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
            
        }else{
            
            [_backgroundView removeFromSuperview];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"因网络等原因修改失败"    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [_backgroundView removeFromSuperview];
        }];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }];

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
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/users/setSecretSit"];
    
//    NSLog(@"%@",_privacyString);
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"photo_lock":_privacyString};
    
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
            
            if ([self.type intValue] == 1) {
                
                self.block(_privacyString);
            }
            
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
