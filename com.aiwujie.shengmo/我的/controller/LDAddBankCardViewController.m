//
//  LDAddBankCardViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/8.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDAddBankCardViewController.h"

@interface LDAddBankCardViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *bankField;
@property (weak, nonatomic) IBOutlet UITextField *bankCardField;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end

@implementation LDAddBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加银行卡";
    
    self.addButton.layer.cornerRadius = 2;
    
    self.addButton.clipsToBounds = YES;
    
    if (_dict != nil) {
        
        self.nameField.text = _dict[@"realname"];
        
        self.bankField.text = _dict[@"bankname"];
        
        self.bankCardField.text = _dict[@"bankcard"];
    }
    
    [_bankCardField addTarget:self action:@selector(bankCardFieldClick) forControlEvents:UIControlEventEditingChanged];
    
}

-(void)bankCardFieldClick{

    if (self.bankCardField.text.length >= 16) {
        
        [self createData];
        
    }else{
    
        self.bankField.text = nil;
    }
}

-(void)createData{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Users/getBanknameByBanknum"];
    
    
    NSDictionary *parameters = @{@"bankcard":self.bankCardField.text};
    
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
        }else{
            
            self.bankField.text = responseObject[@"data"];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}
- (IBAction)addButtonClick:(id)sender {
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Users/addbankcard"];
    
    if (self.nameField.text.length == 0) {
        
        self.nameField.text = @"";
        
    }
    
    if (self.bankField.text.length == 0) {
        
        self.bankField.text = @"";
    }
    
    if (self.bankCardField.text.length == 0) {
        
        self.bankCardField.text = @"";
    }
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if (_dict == nil) {
        
        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"bankcard":self.bankCardField.text,@"bankname":self.bankField.text,@"realname":self.nameField.text};
        
    }else{
    
        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"bankcard":self.bankCardField.text,@"bankname":self.bankField.text,@"realname":self.nameField.text,@"bid":_dict[@"bid"]};
    }
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
        }else{
            
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
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
