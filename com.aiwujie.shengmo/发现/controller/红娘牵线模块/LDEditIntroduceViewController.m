//
//  LDEditIntroduceViewController.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/12/22.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDEditIntroduceViewController.h"

@interface LDEditIntroduceViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *editTextView;

@end

@implementation LDEditIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.introduce.length != 0) {
        
        self.editTextView.text = self.introduce;
        
    }
    
    
}

- (IBAction)submitButtonClick:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString string];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if ([self.fid length] == 0) {
        
        url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Power/editMatchMarkerIntroduce"];
        
        parameters = @{@"uid":self.userId,@"login_uid": [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"match_makerintroduce":self.editTextView.text};
        
    }else{
        
        url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Power/editRemarks"];
        
        parameters = @{@"id":self.fid,@"login_uid": [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"remarks":self.editTextView.text};
    }
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//        NSLog(@"%@",responseObject);
        
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (integer == 2000) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
            if (self.fid.length == 0) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"红娘荐语编辑成功" object:nil];
                
            }else{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"红娘展开介绍编辑成功" object:nil];
            }

        }else{
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"编辑资料失败~"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"网络连接失败,请检查网络设置~"];
    }];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
        
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
