//
//  PersonChatViewController.m
//  yupaopao
//
//  Created by a on 16/8/14.
//  Copyright © 2016年 xiaoxuan. All rights reserved.
//

#import "PersonChatViewController.h"
#import "LDOwnInformationViewController.h"
#import "LDLookOtherGroupInformationViewController.h"
#import "LDGroupInformationViewController.h"

@interface PersonChatViewController ()

@property (strong, nonatomic) UIView *upView;

@end

@implementation PersonChatViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
//    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    if (_type != personIsNormal) {
        
        //更改导航栏的标题文字
        [self changeNavigationTitle];
    }

    if ([self.state intValue] == 2) {
        
        self.conversationMessageCollectionView.frame = CGRectMake(0, 120, WIDTH, HEIGHT - 120);
        
        _upView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, 56)];
        
        _upView.backgroundColor = [UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1];
        
        [self.view addSubview:_upView];
        
        UILabel *showLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, 209, 20)];
        showLabel1.text = @"对方已关注你，是否关注对方?";
        showLabel1.textColor = [UIColor whiteColor];
        showLabel1.font = [UIFont systemFontOfSize:15];
        [_upView addSubview:showLabel1];
        
        UILabel *showLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(8, 29, 209, 20)];
        showLabel2.text = @"互相关注即为好友";
        showLabel2.textColor = [UIColor whiteColor];
        showLabel2.font = [UIFont systemFontOfSize:11];
        [_upView addSubview:showLabel2];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH - 35, 21, 1, 17)];
        lineView.backgroundColor = [UIColor whiteColor];
        [_upView addSubview:lineView];
        
        
        UIButton *attentButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 90, 17, 43, 23)];
        [attentButton setTitle:@"关注" forState:UIControlStateNormal];
        [attentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [attentButton addTarget:self action:@selector(attentButtonClick) forControlEvents:UIControlEventTouchUpInside];
        attentButton.titleLabel.font = [UIFont systemFontOfSize:13];
        attentButton.layer.borderWidth = 1;
        attentButton.layer.borderColor = [UIColor whiteColor].CGColor;
        attentButton.layer.cornerRadius = 2;
        attentButton.clipsToBounds = YES;
        [_upView addSubview:attentButton];
        
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 30, 16, 25, 25)];
        [deleteButton setTitle:@"×" forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
        deleteButton.titleLabel.font = [UIFont systemFontOfSize:22];
        [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_upView addSubview:deleteButton];
        
    }
 
    [self createButton];
    
}

/**
  * 更改导航栏的标题文字
 */
-(void)changeNavigationTitle{
    
    UIColor *navTitleColor = [[UIColor alloc] init];
    
    UIImage *navTitleImage = [[UIImage alloc] init];
    
    if (_type == personIsVIP) {
        
        navTitleColor = CDCOLOR;
        
        navTitleImage = [UIImage imageNamed:@"高级紫"];
        
    }else if (_type == personIsSVIP){
        
        navTitleColor = [UIColor redColor];
        
        navTitleImage = [UIImage imageNamed:@"svip标识"];
    }
    
    UILabel *textLabel = [[UILabel alloc] init];
    
    // 创建一个富文本
    NSMutableAttributedString *attri =  [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",self.title]];
    // 修改富文本中的不同文字的样式
    [attri addAttribute:NSForegroundColorAttributeName value:navTitleColor range:NSMakeRange(0, attri.length)];
    
    // 添加表情
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    attch.image = navTitleImage;
    // 设置图片大小
    attch.bounds = CGRectMake(0, -3, 18, 18);
    
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];
    
    // 用label的attributedText属性来使用富文本
    textLabel.attributedText = attri;
    
    [textLabel sizeToFit];
    
    textLabel.frame = CGRectMake(0, 0, CGRectGetWidth(textLabel.frame), CGRectGetHeight(textLabel.frame));
    
    self.navigationItem.titleView = textLabel;
}

- (void)didTapUrlInMessageCell:(NSString *)url model:(RCMessageModel *)model{
    
    if ([model.content isKindOfClass:[RCRichContentMessage class]]) {
        
        RCRichContentMessage *message = (RCRichContentMessage *)model.content;
        
        NSArray *array = [message.extra componentsSeparatedByString:@","];
        
        NSString *gidStr = [array[0] componentsSeparatedByString:@":"][1] ;
        
        NSString *gid = [gidStr substringWithRange:NSMakeRange(1, gidStr.length - 2)];
        
        NSString *state = [[array[1] componentsSeparatedByString:@":"][1] substringToIndex:1];
        
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/getGroupinfo"];
        
        NSDictionary *parameters = [NSDictionary dictionary];
        
        parameters = @{@"gid":gid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        //    NSLog(@"%@",role);
        
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
            
//            NSLog(@"%@",responseObject);
            
            if (integer != 2000) {
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                
                
            }else{
                
                if ([responseObject[@"data"][@"userpower"] intValue] < 1) {
                    
                    if ([responseObject[@"data"][@"userpower"] intValue] == 0) {
                        
                        LDLookOtherGroupInformationViewController *ivc = [[LDLookOtherGroupInformationViewController alloc] init];
                        
                        ivc.gid = gid;
                        
                        [self.navigationController pushViewController:ivc animated:YES];
                        
                    }else if([responseObject[@"data"][@"userpower"] intValue] == -1){
                        
                        LDLookOtherGroupInformationViewController *ivc = [[LDLookOtherGroupInformationViewController alloc] init];
                        
                        ivc.state = state;
                        
                        ivc.gid = gid;
                        
                        [self.navigationController pushViewController:ivc animated:YES];
                        
                    }
                    
                }else{
                    
                    LDGroupInformationViewController *fvc = [[LDGroupInformationViewController alloc] init];
                    
                    fvc.gid = gid;
                    
                    [self.navigationController pushViewController:fvc animated:YES];
                    
                }
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"%@",error);
            
        }];
        
    }else{
        
        [super didTapUrlInMessageCell:url model:model];
    }
}

//关注成为好友
-(void)attentButtonClick{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":self.mobile};
    
    [manager POST:[NSString stringWithFormat:@"%@%@",URL,@"Api/friend/followOneBox"] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
        }else{
                
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            self.conversationMessageCollectionView.frame = CGRectMake(0, 64, WIDTH, HEIGHT - 114);
            
            [_upView removeFromSuperview];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"%@",error);
        
    }];
    
}

//删除上方view
-(void)deleteButtonClick{

    self.conversationMessageCollectionView.frame = CGRectMake(0, 64, WIDTH, HEIGHT - 114);
    
    [_upView removeFromSuperview];
}

- (void)willDisplayMessageCell:(RCMessageBaseCell *)cell

                   atIndexPath:(NSIndexPath *)indexPath{

    RCMessageCell *messageCell = (RCMessageCell *)cell;
    
    if ([messageCell respondsToSelector:@selector(messageHasReadStatusView)]) {
        
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"已读"]];
        
        img.frame = CGRectMake(-2, 2, 17, 10);
        
        [messageCell.messageHasReadStatusView addSubview:img];
    }
}

-(void)createButton{
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    [rightButton setBackgroundImage:[UIImage imageNamed:@"个人图标"] forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)backButtonOnClick:(UIButton *)button{
    
    LDOwnInformationViewController *avc = [[LDOwnInformationViewController alloc] init];
    
    avc.userID = self.mobile;
    
    [self.navigationController pushViewController:avc animated:YES];
}

//点击聊天头像查看个人信息

- (void)didTapCellPortrait:(NSString *)userId{
//        NSLog(@"%@",userId);
    
    [self createData:userId];
    
}


-(void)createData:(NSString *)userId{

    LDOwnInformationViewController *avc = [[LDOwnInformationViewController alloc] init];
    
    avc.userID = userId;
    
    [self.navigationController pushViewController:avc animated:YES];
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
