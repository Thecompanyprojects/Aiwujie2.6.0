//
//  LDLookOtherGroupInformationViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/15.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDLookOtherGroupInformationViewController.h"
#import "LDAddGroupVerifyViewController.h"
#import "LDGroupMemberListViewController.h"
#import "LDReportViewController.h"
#import "LDOwnInformationViewController.h"

@interface LDLookOtherGroupInformationViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *groupImageView;
@property (weak, nonatomic) IBOutlet UIImageView *groupVipView;
@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupMemberLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupIntroduceLabel;
@property (weak, nonatomic) IBOutlet UIView *introduceView;
@property (weak, nonatomic) IBOutlet UILabel *groupAddressLabel;
@property (weak, nonatomic) IBOutlet UIView *groupAddressView;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
@property (weak, nonatomic) IBOutlet UIView *reportView;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;
@property (weak, nonatomic) IBOutlet UIImageView *managerView1;
@property (weak, nonatomic) IBOutlet UIImageView *managerView2;
@property (weak, nonatomic) IBOutlet UIImageView *managerView3;
@property (weak, nonatomic) IBOutlet UIImageView *managerView4;
@property (weak, nonatomic) IBOutlet UIImageView *managerView5;

@property (nonatomic,copy) NSString *member;

@property (nonatomic,copy) NSString *maxMember;

@property (nonatomic,copy) NSString *userpower;

@property (nonatomic,copy) NSString *reportId;

@property (nonatomic,strong) NSMutableArray *groupMemberArrary;

@end

@implementation LDLookOtherGroupInformationViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self createGroupMemberData];
    
    if (ISIPHONEX) {
        
        self.applyButton.frame = CGRectMake(0, self.applyButton.frame.origin.y - IPHONEXBOTTOMH, self.applyButton.frame.size.width, self.applyButton.frame.size.height);
        
        self.scrollView.frame = CGRectMake(0, 0,self.scrollView.frame.size.width, self.scrollView.frame.size.height - IPHONEXBOTTOMH);
        
    }
    
    self.groupImageView.layer.cornerRadius = 30;
    
    self.groupImageView.clipsToBounds = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"群组信息";
    
    if (@available(iOS 11.0, *)) {
        
        _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self createGroupData];

    _groupMemberArrary = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(submitSuccess) name:@"提交成功" object:nil];
}

-(void)submitSuccess{

    [self.applyButton setTitle:@"已申请加入该群" forState:UIControlStateNormal];
    
    self.applyButton.userInteractionEnabled = NO;
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        
//        NSLog(@"%@",responseObject);
        
        if (integer != 2000 && integer != 2001) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];

        }else{
            
            [_groupMemberArrary removeAllObjects];
            
            _reportId = responseObject[@"data"][0][@"uid"];
            
            [_groupMemberArrary addObjectsFromArray:responseObject[@"data"]];
            
            for (int i = 0; i < 6; i++) {
                
                UIImageView *img = (UIImageView *)[self.view viewWithTag:10 + i];
                
                if ((i + 1) <= [responseObject[@"data"] count]) {
                    
                    [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][i][@"head_pic"]]]  placeholderImage:[UIImage imageNamed:@"默认头像"]];
                    
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

                    if (i == 5) {
                        
                        if ([responseObject[@"data"][i][@"state"] intValue] == 2) {
                            
                            self.managerView5.hidden = NO;
                            
                        }else{
                        
                            self.managerView5.hidden = YES;
                        }
                        
                    }
                
                }else{
                    
                    img.hidden = YES;
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
        
    }];
    
}
- (IBAction)tapGroupMember:(UITapGestureRecognizer *)sender {
    
    UIImageView *img = (UIImageView *)sender.view;
    
    LDOwnInformationViewController *fvc = [[LDOwnInformationViewController alloc] init];
    
    fvc.userID = _groupMemberArrary[img.tag - 10][@"uid"];
    
    [self.navigationController pushViewController:fvc animated:YES];
}

-(void)createGroupData{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/getGroupinfo"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    parameters = @{@"gid":self.gid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    //    NSLog(@"%@",role);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
//                NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
        }else{
            
            if ([responseObject[@"data"][@"group_pic"] isEqualToString:@"http://59.110.28.150:888/"]) {
                
                _groupImageView.image = [UIImage imageNamed:@"群默认头像"];
                
            }else{
                
                [_groupImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"group_pic"]]]];
            }
            
            self.groupNameLabel.text = responseObject[@"data"][@"groupname"];
            
            self.groupNumberLabel.text = [NSString stringWithFormat:@"群号:%@",responseObject[@"data"][@"group_num"]];
            
            if ([responseObject[@"data"][@"group_num"] length] <= 5) {
                
                self.groupVipView.hidden = NO;
                
            }else{
                
                self.groupVipView.hidden = YES;
            }
            
            self.groupMemberLabel.text = [NSString stringWithFormat:@"%@/%@",responseObject[@"data"][@"member"],responseObject[@"data"][@"max_member"]];
            
            _member = responseObject[@"data"][@"member"];
            
            _maxMember = responseObject[@"data"][@"max_member"];
            
            self.groupAddressLabel.text = [NSString stringWithFormat:@"%@  %@",responseObject[@"data"][@"province"],responseObject[@"data"][@"city"]];
            
            _userpower = responseObject[@"data"][@"userpower"];
            
            if ([self.state intValue] == 1) {
                
                [self.applyButton setTitle:@"同意加入该群" forState:UIControlStateNormal];
                
                self.applyButton.userInteractionEnabled = YES;
                
            }else{
            
                if ([responseObject[@"data"][@"userpower"] intValue] == 0) {
                    
                    [self.applyButton setTitle:@"已申请加入该群" forState:UIControlStateNormal];
                    
                    self.applyButton.userInteractionEnabled = NO;
                    
                }else if ([responseObject[@"data"][@"userpower"] intValue] == -1){
                    
                    [self.applyButton setTitle:@"申请加入" forState:UIControlStateNormal];
                    
                    self.applyButton.userInteractionEnabled = YES;
                }

            }
            
            self.groupIntroduceLabel.text = responseObject[@"data"][@"introduce"];
            
            self.groupIntroduceLabel.numberOfLines = 0;
            
            self.groupIntroduceLabel.lineBreakMode = NSLineBreakByWordWrapping;
            
            [self.groupIntroduceLabel sizeToFit];
            
            self.introduceView.frame = CGRectMake(0, self.introduceView.frame.origin.y, WIDTH, 63 + self.groupIntroduceLabel.frame.size.height);
            
            self.groupAddressView.frame = CGRectMake(0, self.groupAddressView.frame.origin.y, WIDTH, self.groupAddressView.frame.size.height);
            
            self.reportView.frame = CGRectMake(0, self.introduceView.frame.origin.y + self.introduceView.frame.size.height + 1, WIDTH, self.reportView.frame.size.height);
            
            self.scrollView.contentSize = CGSizeMake(WIDTH, self.reportView.frame.origin.y + self.reportView.frame.size.height + 50);
           
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
        
    }];
    
}

- (IBAction)applyButtonClick:(id)sender {
    
    if ([_member isEqualToString:_maxMember]) {
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"该群已满员~"];
        
       
    }else{
        
        if ([self.state intValue] == 1) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            AFHTTPSessionManager *manager = [LDAFManager sharedManager];
            
            NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/agreeIntoGroupOne"];
            
            NSDictionary *parameters = [NSDictionary dictionary];
            
            parameters = @{@"gid":self.gid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            //    NSLog(@"%@",role);
            
            [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
                
                //                NSLog(@"%@",responseObject);
                
                if (integer != 2000) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                    
                    
                }else{
                    
                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                NSLog(@"%@",error);
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }];

        }else{
        
            self.applyButton.userInteractionEnabled = NO;
            
            LDAddGroupVerifyViewController *avc = [[LDAddGroupVerifyViewController alloc] init];
            
            avc.gid = self.gid;
            
            [self.navigationController pushViewController:avc animated:YES];

        }
        
    }
    
}
- (IBAction)reportButtonClick:(id)sender {
    
    LDReportViewController *rvc = [[LDReportViewController alloc] init];
    
    rvc.reportId = _reportId;
    
    [self.navigationController pushViewController:rvc animated:YES];
}

- (IBAction)groupMemberButtonClick:(id)sender {
    
    LDGroupMemberListViewController *lvc = [[LDGroupMemberListViewController alloc] init];
    
    lvc.gid = self.gid;
    
    lvc.state = _userpower;
    
    [self.navigationController pushViewController:lvc animated:YES];
}
- (IBAction)tapGroupHeadClick:(id)sender {
    
    [XWScanImage scanBigImageWithImageView:self.groupImageView];
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
