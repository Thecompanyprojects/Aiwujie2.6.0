//
//  LDGroupInformationViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/15.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDGroupInformationViewController.h"
#import "LDAlertHeadAndNameViewController.h"
#import "LDAlertNameViewController.h"
#import "LDGroupMemberListViewController.h"
#import "LDGroupUpViewController.h"
#import "LDGroupChatViewController.h"
#import "LDReportViewController.h"
#import "RCDGroupAnnouncementViewController.h"
#import "LDOwnInformationViewController.h"
#import "LDShareView.h"
#import "LDInvitationMemberViewController.h"

@interface LDGroupInformationViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupMemberLabel;
@property (weak, nonatomic) IBOutlet UIButton *groupMemberButton;
@property (weak, nonatomic) IBOutlet UILabel *groupAddressLabel;
@property (weak, nonatomic) IBOutlet UISwitch *messageSwitch;
@property (weak, nonatomic) IBOutlet UIButton *deleteInformationButton;
@property (weak, nonatomic) IBOutlet UILabel *groupManagerLabel;
@property (weak, nonatomic) IBOutlet UIButton *groupManagerButton;
@property (weak, nonatomic) IBOutlet UILabel *groupUpLabel;
@property (weak, nonatomic) IBOutlet UIButton *groupUpButton;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UIButton *introduceButton;
@property (weak, nonatomic) IBOutlet UIView *introduceView;
@property (weak, nonatomic) IBOutlet UIButton *dissmissButton;
@property (weak, nonatomic) IBOutlet UIImageView *managerView1;
@property (weak, nonatomic) IBOutlet UIImageView *managerView2;
@property (weak, nonatomic) IBOutlet UIImageView *managerView3;
@property (weak, nonatomic) IBOutlet UIImageView *managerView4;
@property (weak, nonatomic) IBOutlet UIImageView *managerView5;
@property (weak, nonatomic) IBOutlet UIButton *beginButton;
@property (weak, nonatomic) IBOutlet UIImageView *groupVipView;

@property (nonatomic,copy) NSString *headUrl;
@property (nonatomic,copy) NSString *userpower;
@property (nonatomic,copy) NSString *ownpic;
@property (nonatomic,assign) BOOL status;
@property (nonatomic,copy) NSString *reportId;
@property (nonatomic,strong) NSMutableArray *groupMemberArrary;

@property (weak, nonatomic) IBOutlet UIView *atView;
@property (weak, nonatomic) IBOutlet UIView *closeVoiceView;
@property (weak, nonatomic) IBOutlet UIView *deleteChatView;
@property (weak, nonatomic) IBOutlet UIView *setManagerView;
@property (weak, nonatomic) IBOutlet UIView *groupUpView;

//分享视图
@property (nonatomic,strong) LDShareView *shareView;


@end

@implementation LDGroupInformationViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    self.managerView1.hidden = YES;
    self.managerView2.hidden = YES;
    self.managerView3.hidden = YES;
    self.managerView4.hidden = YES;
    self.managerView5.hidden = YES;
    
    if (ISIPHONEX) {
        
        self.beginButton.frame = CGRectMake(0, self.beginButton.frame.origin.y - IPHONEXBOTTOMH, self.beginButton.frame.size.width, self.beginButton.frame.size.height);
        
        self.scrollView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height - IPHONEXBOTTOMH);
    }
    
    [self createGroupMemberData];
    
    [self createGroupData];
}

-(void)createGroupMemberData{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/getGroupMember"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        parameters = @{@"gid":self.gid,@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"pagetype":@"1",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        
    }else{
        
        parameters = @{@"gid":self.gid,@"lat":@"",@"lng":@"",@"pagetype":@"1",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    }

    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
//       NSLog(@"%@",responseObject);
        
        if (integer != 2000 && integer != 2001) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
            
        }else{
            
            [_groupMemberArrary removeAllObjects];
            
            _ownpic = responseObject[@"data"][0][@"head_pic"];
            
            _reportId = responseObject[@"data"][0][@"uid"];
            
            [_groupMemberArrary addObjectsFromArray:responseObject[@"data"]];
            
            if ([responseObject[@"data"] count] >= 5) {
                
                for (int i = 0; i < 5; i++) {
                    
                    UIImageView *img = (UIImageView *)[self.view viewWithTag:10 + i];
                    
                    [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][i][@"head_pic"]]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
                    
                    img.layer.cornerRadius = 22;
                    
                    img.clipsToBounds = YES;
                    
                    if (i == 1) {
                        
                        if ([responseObject[@"data"][i][@"state"] intValue] == 2) {
                            
                            self.managerView1.hidden = NO;
                            
                        }else{
                            
                            self.managerView1.hidden = YES;
                        }
                        
                    }
                    
                    if (i == 2) {
                        
                        if ([responseObject[@"data"][i][@"state"] intValue] == 2) {
                            
                            self.managerView2.hidden = NO;
                            
                        }else{
                            
                            self.managerView2.hidden = YES;
                        }
                        
                    }
                    
                    if (i == 3) {
                        
                        if ([responseObject[@"data"][i][@"state"] intValue] == 2) {
                            
                            self.managerView3.hidden = NO;
                            
                        }else{
                            
                            self.managerView3.hidden = YES;
                        }
                        
                    }
                    
                    if (i == 4) {
                        
                        if ([responseObject[@"data"][i][@"state"] intValue] == 2) {
                            
                            self.managerView4.hidden = NO;
                            
                        }else{
                            
                            self.managerView4.hidden = YES;
                        }

                    }
                    
                    self.managerView5.hidden = YES;
                    UIImageView *addImag = (UIImageView *)[self.view viewWithTag:15];
                    addImag.image = [UIImage imageNamed:@"群拉人"];
                    addImag.layer.cornerRadius = 22;
                    addImag.clipsToBounds = YES;
     
                }
                
            }else{
            
                for (int i = 0; i < 6; i++) {
                    
                    UIImageView *img = (UIImageView *)[self.view viewWithTag:10 + i];
                    
                    img.layer.cornerRadius = 22;
                    
                    img.clipsToBounds = YES;
                    
                    if ((i + 1) <= [responseObject[@"data"] count] + 1) {
                        
                        if (i + 1 == [responseObject[@"data"] count] + 1) {
                            
                            img.image = [UIImage imageNamed:@"群拉人"];
                            
                        }else{
                        
                            [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][i][@"head_pic"]]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
                            
                            if (i == 1) {
                                
                                if ([responseObject[@"data"][i][@"state"] intValue] == 2) {
                                    
                                    self.managerView1.hidden = NO;
                                    
                                }else{
                                    
                                    self.managerView1.hidden = YES;
                                }
                                
                            }
                            
                            if (i == 2) {
                                
                                if ([responseObject[@"data"][i][@"state"] intValue] == 2) {
                                    
                                    self.managerView2.hidden = NO;
                                    
                                }else{
                                    
                                    self.managerView2.hidden = YES;
                                }
                                
                            }
                            
                            if (i == 3) {
                                
                                if ([responseObject[@"data"][i][@"state"] intValue] == 2) {
                                    
                                    self.managerView3.hidden = NO;
                                    
                                }else{
                                    
                                    self.managerView3.hidden = YES;
                                }
                                
                            }
                            
                            if (i == 4) {
                                
                                if ([responseObject[@"data"][i][@"state"] intValue] == 2) {
                                    
                                    self.managerView4.hidden = NO;
                                    
                                }else{
                                    
                                    self.managerView4.hidden = YES;
                                }
                                
                            }
                            
                        if (i == 5) {
                                
                            if ([responseObject[@"data"][i][@"state"] intValue] == 2) {
                                    
                                self.managerView5.hidden = NO;
                                    
                            }else{
                                    
                                self.managerView5.hidden = YES;
                            }
                        }
                    }
                        
                        
                }else{
                        
                        img.hidden = YES;
                    }
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
        
    }];

}

- (IBAction)tapGroupMember:(UITapGestureRecognizer *)sender {
    
    if (_groupMemberArrary.count >= 5) {
        
        UIImageView *img = (UIImageView *)sender.view;
        
        if (img.tag == 15) {
            
            LDInvitationMemberViewController *mvc = [[LDInvitationMemberViewController alloc] init];
            
            mvc.gid = self.gid;
            
            [self.navigationController pushViewController:mvc animated:YES];
            
        }else{
        
            LDOwnInformationViewController *fvc = [[LDOwnInformationViewController alloc] init];
            
            fvc.userID = _groupMemberArrary[img.tag - 10][@"uid"];
            
            [self.navigationController pushViewController:fvc animated:YES];
        }
        
    }else if (_groupMemberArrary.count < 5){
    
        UIImageView *img = (UIImageView *)sender.view;
        
        if (img.tag - 10 == _groupMemberArrary.count) {
            
            LDInvitationMemberViewController *mvc = [[LDInvitationMemberViewController alloc] init];
            
            mvc.gid = self.gid;
            
            [self.navigationController pushViewController:mvc animated:YES];
            
        }else{
        
            LDOwnInformationViewController *fvc = [[LDOwnInformationViewController alloc] init];
            
            fvc.userID = _groupMemberArrary[img.tag - 10][@"uid"];
            
            [self.navigationController pushViewController:fvc animated:YES];
        }
    }
}


-(void)createGroupData{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/getGroupinfo"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    parameters = @{@"gid":self.gid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    //    NSLog(@"%@",role);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
//        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
            
        }else{
            
            _shareView = [[LDShareView alloc] init];
            //分享视图
            
            NSString *pic = [NSString string];
            
            if ([responseObject[@"data"][@"group_pic"] isEqualToString:@"http://59.110.28.150:888/"]) {
                
                pic = @"http://hao.shengmo.org/nopic.png";
                
            }else{
                
                pic = responseObject[@"data"][@"group_pic"];
            }
            
            [self.navigationController.view addSubview:[_shareView createBottomView:@"Group" andNickName:responseObject[@"data"][@"groupname"] andPicture:pic andId:self.gid]];
            
            if ([responseObject[@"data"][@"group_pic"] isEqualToString:@"http://59.110.28.150:888/"]) {
                
                _headView.image = [UIImage imageNamed:@"群默认头像"];
                
            }else{
            
                [_headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"group_pic"]]]];
            }
            
            _headUrl = responseObject[@"data"][@"group_pic"];
            
            self.groupNameLabel.text = responseObject[@"data"][@"groupname"];
            
            self.groupNumberLabel.text = [NSString stringWithFormat:@"群号:%@",responseObject[@"data"][@"group_num"]];
            
            if ([responseObject[@"data"][@"group_num"] length] <= 5) {
                
                self.groupVipView.hidden = NO;
                
            }else{
                
                self.groupVipView.hidden = YES;
            }
            
            self.groupMemberLabel.text = [NSString stringWithFormat:@"%@/%@",responseObject[@"data"][@"member"],responseObject[@"data"][@"max_member"]];
            
            self.groupAddressLabel.text = [NSString stringWithFormat:@"%@  %@",responseObject[@"data"][@"province"],responseObject[@"data"][@"city"]];
            
            self.groupManagerLabel.text = [NSString stringWithFormat:@"%@%@",responseObject[@"data"][@"manager"],responseObject[@"data"][@"managerStr"]];
            
            
            //群介绍
            self.introduceLabel.text = responseObject[@"data"][@"introduce"];
            
            self.introduceLabel.numberOfLines = 0;
            
            self.introduceLabel.lineBreakMode = NSLineBreakByWordWrapping;
            
            CGSize size = [self.introduceLabel sizeThatFits:CGSizeMake(WIDTH - 25, 0)];
            
            self.introduceLabel.frame = CGRectMake(self.introduceLabel.frame.origin.x, self.introduceLabel.frame.origin.y, size.width, size.height);
            
            self.introduceView.frame = CGRectMake(0, self.introduceView.frame.origin.y, WIDTH, 63 + self.introduceLabel.frame.size.height);

            
            _userpower = responseObject[@"data"][@"userpower"];
            
            if ([responseObject[@"data"][@"userpower"] intValue] == 3) {
                
                [self.dissmissButton setTitle:@"解散群组" forState:UIControlStateNormal];
                
                self.atView.frame = CGRectMake(0, self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 1, WIDTH, self.atView.frame.size.height);
                
                self.closeVoiceView.frame = CGRectMake(0, self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 44, WIDTH, self.closeVoiceView.frame.size.height);
                
                self.deleteChatView.frame = CGRectMake(0,self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 87, WIDTH, self.deleteChatView.frame.size.height);
                
                self.setManagerView.frame = CGRectMake(0, self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 130, WIDTH, self.setManagerView.frame.size.height);
                
                self.groupUpView.frame = CGRectMake(0, self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 173, WIDTH, self.groupUpView.frame.size.height);
                
                self.dissmissButton.frame = CGRectMake(0,self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 216, WIDTH, self.dissmissButton.frame.size.height);

                
            }else if([responseObject[@"data"][@"userpower"] intValue] == 2){
            
                [self.dissmissButton setTitle:@"退出群组" forState:UIControlStateNormal];
                
                self.groupUpView.hidden = YES;
                
                self.setManagerView.hidden = YES;
                
                self.atView.hidden = NO;
                
                self.atView.frame = CGRectMake(0, self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 1, WIDTH, self.atView.frame.size.height);
                
                self.closeVoiceView.frame = CGRectMake(0, self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 44, WIDTH, self.closeVoiceView.frame.size.height);
                
                self.deleteChatView.frame = CGRectMake(0,self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 87, WIDTH, self.deleteChatView.frame.size.height);
                
                self.dissmissButton.frame = CGRectMake(0,self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 130, WIDTH, self.dissmissButton.frame.size.height);

                
            }else{
            
                [self.dissmissButton setTitle:@"退出群组" forState:UIControlStateNormal];
                
                self.groupManagerButton.userInteractionEnabled = NO;
                
                self.headButton.userInteractionEnabled = NO;
                
                self.introduceButton.userInteractionEnabled = NO;
                
                self.setManagerView.hidden = YES;
                
                self.atView.hidden = YES;
                
                self.groupUpView.hidden = YES;
                
                self.closeVoiceView.frame = CGRectMake(0, self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 1, WIDTH, self.closeVoiceView.frame.size.height);
                
                self.deleteChatView.frame = CGRectMake(0,self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 44, WIDTH, self.deleteChatView.frame.size.height);
                
                self.dissmissButton.frame = CGRectMake(0,self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 87, WIDTH, self.dissmissButton.frame.size.height);
               
            }
           
            self.scrollView.contentSize = CGSizeMake(WIDTH, self.dissmissButton.frame.origin.y + self.dissmissButton.frame.size.height + 50);

        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
        
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"群组信息";
    
    if ([self.chatStsate isEqualToString:@"yes"]) {
        
        self.beginButton.hidden = YES;
    }
    
    _groupMemberArrary = [NSMutableArray array];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"miandarao"] length] == 0) {
        
        self.messageSwitch.on = NO;
        
        _status = NO;
        
        [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:self.gid isBlocked:NO success:^(RCConversationNotificationStatus nStatus) {
            
            
        } error:^(RCErrorCode status) {
            
            
        }];
        
    }else{
        
        [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:self.gid isBlocked:YES success:^(RCConversationNotificationStatus nStatus) {
            
            
        } error:^(RCErrorCode status) {
            
            
        }];
    
        self.messageSwitch.on = YES;
        
        _status = YES;
    }
    
    [self createButton];
    
    self.headView.layer.cornerRadius = 30;
    
    self.headView.clipsToBounds = YES;
    
    if (@available(iOS 11.0, *)) {
        
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (IBAction)allPeopleButtonClick:(id)sender {
    
    if ([_userpower intValue] == 3 || [_userpower intValue] == 2) {
        
        RCDGroupAnnouncementViewController *avc = [[RCDGroupAnnouncementViewController alloc] init];
        
        avc.GroupId = self.gid;
        
        [self.navigationController pushViewController:avc animated:YES];
    }
    
}


- (IBAction)headButtonClick:(id)sender {
    
    LDAlertHeadAndNameViewController *nvc = [[LDAlertHeadAndNameViewController alloc] init];
    
    nvc.headUrl = _headUrl;
    
    nvc.groupName = self.groupNameLabel.text;
    
    nvc.gid = self.gid;
    
    [self.navigationController pushViewController:nvc animated:YES];
}

- (IBAction)messageSwitchClick:(id)sender {
    
    if (_status) {
        
        [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:self.gid isBlocked:NO success:^(RCConversationNotificationStatus nStatus) {
            
            self.messageSwitch.on = NO;
            
            _status = NO;
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"miandarao"];
            
        } error:^(RCErrorCode status) {
            
            
        }];
        
    }else{
        
        [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_GROUP targetId:self.gid isBlocked:YES success:^(RCConversationNotificationStatus nStatus) {
            
            self.messageSwitch.on = YES;
            
            _status = YES;
            
            [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"miandarao"];

            
        } error:^(RCErrorCode status) {
            
            
        }];
    
    }
}

- (IBAction)groupMemberButtonClick:(id)sender {
    
    LDGroupMemberListViewController *lvc = [[LDGroupMemberListViewController alloc] init];
    
    lvc.gid = self.gid;
    
    lvc.state = _userpower;
    
    [self.navigationController pushViewController:lvc animated:YES];
}

- (IBAction)deleteButtonClick:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"是否清空聊天记录" preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[RCIMClient sharedRCIMClient] clearRemoteHistoryMessages:ConversationType_GROUP targetId:self.gid recordTime:[[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970] * 1000] longLongValue] success:^{
            
             [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_GROUP targetId:self.gid];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            });
            
        } error:^(RCErrorCode status) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            });
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"清空聊天记录失败"];
            
        }];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:nil];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
    
        [cancelAction setValue:CDCOLOR forKey:@"_titleTextColor"];
        
        [action setValue:CDCOLOR forKey:@"_titleTextColor"];
    }
    
    [alertController addAction:action];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];

}
- (IBAction)groupManagerButtonClick:(id)sender {
    
    LDGroupMemberListViewController *lvc = [[LDGroupMemberListViewController alloc] init];
    
    lvc.gid = self.gid;
    
    lvc.type = @"1";
    
    [self.navigationController pushViewController:lvc animated:YES];

}
- (IBAction)groupUpButtonClick:(id)sender {
    
    if ([_userpower intValue] == 3) {
        
        LDGroupUpViewController *uvc = [[LDGroupUpViewController alloc] init];
        
        uvc.headpic = _headUrl;
        
        uvc.ownpic = _ownpic;
        
        [self.navigationController pushViewController:uvc animated:YES];
        
    }
}


- (IBAction)dissmissButtonClick:(id)sender {
    
    if ([_userpower intValue] == 3) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否解散此群"    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            AFHTTPSessionManager *manager = [LDAFManager sharedManager];
            
            NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/delGroup"];
            
            NSDictionary *parameters = [NSDictionary dictionary];
            
            parameters = @{@"gid":self.gid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
            [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
                
                //            NSLog(@"%@",responseObject);
                
                if (integer != 2000) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                    
                    
                }else{
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"wancheng" object:nil];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                NSLog(@"%@",error);
                
                
            }];
            
        }];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
        
        if (PHONEVERSION.doubleValue >= 8.3) {
        
            [action setValue:CDCOLOR forKey:@"_titleTextColor"];
            
            [cancelAction setValue:CDCOLOR forKey:@"_titleTextColor"];
        }

        [alert addAction:cancelAction];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];

    }else if ([_userpower intValue] == 2 || [_userpower intValue] == 1){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否退出此群"    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            AFHTTPSessionManager *manager = [LDAFManager sharedManager];
            
            NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/exitGroup"];
            
            NSDictionary *parameters = [NSDictionary dictionary];
            
            parameters = @{@"gid":self.gid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
            [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
                
                //            NSLog(@"%@",responseObject);
                
                if (integer != 2000) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                    
                    
                }else{
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"wancheng" object:nil];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                NSLog(@"%@",error);
                
                
            }];
            
        }];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
        
        if (PHONEVERSION.doubleValue >= 8.3) {
        
            [action setValue:CDCOLOR forKey:@"_titleTextColor"];
            
            [cancelAction setValue:CDCOLOR forKey:@"_titleTextColor"];
        }
        
        [alert addAction:cancelAction];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];

    }
}
- (IBAction)introduceButtonClick:(id)sender {
    
    LDAlertNameViewController *nvc = [[LDAlertNameViewController alloc] init];
    
    nvc.groupName = self.introduceLabel.text;
    
    nvc.gid = self.gid;
    
    nvc.type = @"1";
    
    [self.navigationController pushViewController:nvc animated:YES];
}
- (IBAction)startChatButtonClick:(id)sender {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ableOrDisable"] intValue] == 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"ableOrDisable"] length] != 0) {
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您因违规被系统禁用聊天功能,解封时间请查看系统通知,如有疑问请与客服联系!"];
        
        
    }else{
    
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        
        //    NSLog(@"%@",groupId);
        
        NSDictionary *parameters = @{@"gid":self.gid};
        
        //    NSLog(@"gsgggggdgdggdgsgssgdgs%@",groupId);
        
        [manager POST:[NSString stringWithFormat:@"%@%@",URL,@"Api/Other/getGroupinfo"] parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
            //        NSLog(@"%@",responseObject);
            if (integer == 2000) {
                
                LDGroupChatViewController *cvc = [[LDGroupChatViewController alloc] init];
                
                cvc.conversationType = ConversationType_GROUP;
                
                cvc.targetId = self.gid;
                
                cvc.title = responseObject[@"data"][@"groupname"];
                
                cvc.groupId = self.gid;
                
                [self.navigationController pushViewController:cvc animated:YES];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"88888%@",error);
            
        }];

    }
}

-(void)createButton{
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setImage:[UIImage imageNamed:@"其他"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(backButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)backButtonOnClick:(UIButton *)button{
        
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        LDReportViewController *rvc = [[LDReportViewController alloc] init];
        
        rvc.reportId = _reportId;
        
        [self.navigationController pushViewController:rvc animated:YES];
        
    }];
    
    UIAlertAction * shareAction = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [_shareView controlViewShowAndHide:nil];
        
    }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
    
        [action setValue:CDCOLOR forKey:@"_titleTextColor"];
        
        [shareAction setValue:CDCOLOR forKey:@"_titleTextColor"];
        
        [cancel setValue:CDCOLOR forKey:@"_titleTextColor"];
    }

    
    [alert addAction:cancel];
    
    [alert addAction:shareAction];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)tapGroupHeadClick:(id)sender {
    
    [XWScanImage scanBigImageWithImageView:self.headView];
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
