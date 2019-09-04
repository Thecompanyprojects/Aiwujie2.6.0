//
//  LDGroupChatViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/20.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDGroupChatViewController.h"
#import "LDGroupAtPersonViewController.h"
#import "LDOwnInformationViewController.h"
#import "LDGroupInformationViewController.h"
#import "LDLookOtherGroupInformationViewController.h"

@interface LDGroupChatViewController ()

@end

@implementation LDGroupChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    [self createRefreshUserData:self.groupId];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createButton];
    
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

- (void)showChooseUserViewController:(void (^)(RCUserInfo *selectedUserInfo))selectedBlock cancel:(void (^)())cancelBlock{

    LDGroupAtPersonViewController *atPerson = [[LDGroupAtPersonViewController alloc] init];

    atPerson.groupId = self.groupId;

    atPerson.block = ^(RCUserInfo *user) {

        selectedBlock(user);

    };

    [self.navigationController pushViewController:atPerson animated:YES];
}

-(void)createButton{
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    [rightButton setBackgroundImage:[UIImage imageNamed:@"群组图标"] forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)backButtonOnClick:(UIButton *)button{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/getGroupinfo"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    parameters = @{@"gid":self.groupId,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    //    NSLog(@"%@",role);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
        //        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];

        }else{
            
            if ([responseObject[@"data"][@"userpower"] intValue] < 1) {
                
                LDLookOtherGroupInformationViewController *ivc = [[LDLookOtherGroupInformationViewController alloc] init];
                
                ivc.gid = self.groupId;
                
                [self.navigationController pushViewController:ivc animated:YES];
                
                
            }else{
                
                LDGroupInformationViewController *fvc = [[LDGroupInformationViewController alloc] init];
                
                fvc.gid = self.groupId;
                
                fvc.chatStsate = @"yes";
                
                [self.navigationController pushViewController:fvc animated:YES];
                
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
        
    }];

}

//点击聊天头像查看个人信息
- (void)didTapCellPortrait:(NSString *)userId{
    //    NSLog(@"%@",userId);
    
    [self createData:userId];
    
}

-(void)createRefreshUserData:(NSString *)groupId{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    //    NSLog(@"%@",groupId);
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        parameters = @{@"gid":groupId,@"lat":[[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"]};
        
    }else{
        
        parameters = @{@"gid":groupId,@"lat":@"",@"lng":@""};
    }

    
    //    NSLog(@"gsgggggdgdggdgsgssgdgs%@",groupId);
    
    [manager POST:[NSString stringWithFormat:@"%@%@",URL,@"Api/Other/getGroupinfo"] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        //        NSLog(@"%@",responseObject);
        if (integer == 2000) {
            
            //此处为了演示写了一个用户信息
            RCGroup *group = [[RCGroup alloc]init];
            group.groupId = groupId;
            group.groupName = responseObject[@"data"][@"groupname"];
            group.portraitUri = responseObject[@"data"][@"group_pic"];
            [[RCIM sharedRCIM] refreshGroupInfoCache:group withGroupId:groupId];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"88888%@",error);
        
    }];

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
