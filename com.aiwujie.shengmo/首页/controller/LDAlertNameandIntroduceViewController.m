//
//  LDAlertNameandIntroduceViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/7.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDAlertNameandIntroduceViewController.h"
#import "LDStandardViewController.h"

@interface LDAlertNameandIntroduceViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;

@end

@implementation LDAlertNameandIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.type intValue] == 1) {
        
        self.navigationItem.title = @"修改昵称";
        
        self.textView.text = self.content;
        
        self.warnLabel.hidden = NO;
        
        self.introduceLabel.text = @"昵称请勿使用露骨/有偿/多人等违规词汇";
        
        self.introduceLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self.introduceLabel sizeToFit];
        
        if (self.content.length == 0) {
            
            self.numberLabel.text = @"0/10";
            
            self.introduceLabel.hidden = NO;
            
            
        }else{
        
            self.numberLabel.text = [NSString stringWithFormat:@"%ld/10",(unsigned long)self.textView.text.length];
            
            self.introduceLabel.hidden = YES;
        }
        
        self.textView.returnKeyType = UIReturnKeyDone;
        
    }else{
    
        self.navigationItem.title = @"修改签名";
        
        self.textView.text = self.content;
        
        self.warnLabel.hidden = YES;
        
         self.introduceLabel.text = @"请勿使用露骨的项目词汇、大尺度文字描述、有偿收费描述、多人夫妻描述等！七年圣魔来之不易，需要同好们的共同呵护~";
        
        self.introduceLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        [self.introduceLabel sizeToFit];
        
        if (self.content.length == 0) {
            
            self.numberLabel.text = @"0/256";
            
            self.introduceLabel.hidden = NO;
            
        }else{
            
            self.numberLabel.text = [NSString stringWithFormat:@"%ld/256",(unsigned long)self.textView.text.length];
            
            self.introduceLabel.hidden = YES;

        }

    }
    
    [self createButton];
}

-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        
        self.introduceLabel.hidden = NO;
        
    }else{
        
        self.introduceLabel.hidden = YES;
    }
    
    if ([self.type intValue] == 1) {
        
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            if (textView.text.length >= 10) {
                
                textView.text = [textView.text substringToIndex:10];
                
                self.numberLabel.text = @"10/10";
                
            }else{
                
                self.numberLabel.text = [NSString stringWithFormat:@"%ld/10",(unsigned long)self.textView.text.length];
                
            }

        }
        
    }else{
        
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            if (textView.text.length >= 256) {
                
                textView.text = [textView.text substringToIndex:256];
                
                self.numberLabel.text = @"256/256";
                
            }else{
                
                self.numberLabel.text = [NSString stringWithFormat:@"%ld/256",(unsigned long)self.textView.text.length];
                
            }

            
        }

    }
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([_type intValue] == 1) {
        
        if ([text isEqualToString:@"\n"]) {
            
            [textView resignFirstResponder];
            
            return NO;
            
        }
    }
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    [self.view endEditing:YES];
}

-(void)createButton{
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}


-(void)backButtonOnClick:(UIButton *)button{
    
    if ([self isEmpty:self.textView.text] && [_type intValue] == 1) {
        
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"昵称中不能包含空格~"];
        
    }else{
        
        if ([_type intValue] == 1 && ([self.textView.text containsString:@"奴"] || [self.textView.text containsString:@"虐"] || [self.textView.text containsString:@"性"] || [self.textView.text containsString:@"狗"] || [self.textView.text containsString:@"畜"] || [self.textView.text containsString:@"贱"] || [self.textView.text containsString:@"骚"] || [self.textView.text containsString:@"淫"] || [self.textView.text containsString:@"阴"] || [self.textView.text containsString:@"肛"] || [self.textView.text containsString:@"SM"] || [self.textView.text containsString:@"sm"] || [self.textView.text containsString:@"Sm"] || [self.textView.text containsString:@"sM"])) {
            
            
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"很抱歉，您的昵称包含有禁止使用的字：奴、虐、性、狗、畜、贱、骚、淫、阴、肛、SM、sm、Sm、sM，请修改后重试~"];
            
            
        }else if ([_type intValue] == 1 && self.textView.text.length == 0){
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"昵称不能为空~"];
       
        
        }else if(self.textView.text.length == 0 && [_type intValue] == 2){
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"签名不能为空~"];
        
        }else{
        
            self.block(self.textView.text);
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

//判定昵称中是否包含空格
-(BOOL)isEmpty:(NSString *) str {
    NSRange range = [str rangeOfString:@" "];
    
    if (range.location != NSNotFound) {
        
        return YES; //yes代表包含空格
        
    }else {
        
        return NO; //反之
    }
}

//图文规范
- (IBAction)picAndWordButtonClick:(id)sender {
    
    LDStandardViewController *svc = [[LDStandardViewController alloc] init];
    
    svc.navigationItem.title = @"图文规范";
    
    svc.state = @"图文规范";
    
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
