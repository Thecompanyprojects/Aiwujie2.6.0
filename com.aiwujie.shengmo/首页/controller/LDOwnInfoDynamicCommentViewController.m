//
//  LDOwnInfoDynamicCommentViewController.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/10/17.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDOwnInfoDynamicCommentViewController.h"
#import "CommentedCell.h"
#import "CommentedModel.h"
#import "LDDynamicDetailViewController.h"
#import "LDOwnInformationViewController.h"
#import "LDMemberViewController.h"
#import "LDMyTopicViewController.h"

@interface LDOwnInfoDynamicCommentViewController ()<UITableViewDelegate,UITableViewDataSource,YBAttributeTapActionDelegate>


@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int page;

@property (nonatomic,assign) CGFloat cellH;

//提示的view
@property (nonatomic,strong) UIView *warnView;

//发布的话题
@property (nonatomic,strong) NSMutableArray *plublishArray;
@property (nonatomic,strong) UILabel *plublishLabel;
@property (nonatomic,copy) NSString *c_topic;

//参与的话题
@property (nonatomic,strong) NSMutableArray *joinArray;
@property (nonatomic,strong) UILabel *joinLabel;
@property (nonatomic,copy) NSString *j_topic;

//加好友接口
@property (nonatomic,copy) NSString *url;

@end

@implementation LDOwnInfoDynamicCommentViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _dataArray = [NSMutableArray array];
    
    _plublishArray = [NSMutableArray array];
    
    _joinArray = [NSMutableArray array];
    
    [self createTableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if ([self.personUid intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
            
            _page = 0;
            
            [self createDataType:@"1"];
            
        }else{
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1) {
                
                _page = 0;
                
                [self createDataType:@"1"];
                
            }else{
                
                AFHTTPSessionManager *manager = [LDAFManager sharedManager];
                
                NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Power/getAchievePower"];
                
                NSDictionary *parameters = [NSDictionary dictionary];
                
                parameters = @{@"uid":self.personUid,@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
                //NSLog(@"%@",parameters);
                
                [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
                    
                    //NSLog(@"%@",responseObject[@"msg"]);
                    
                    if (integer == 2002) {
                        
                        [_dataArray removeAllObjects];
                        
                        [self.tableView reloadData];
                        
                        _warnView = [[UIView alloc] initWithFrame:CGRectMake(0, self.tableView.tableHeaderView.frame.size.height + 2, WIDTH, self.tableView.frame.size.height)];
                        _warnView.backgroundColor = [UIColor whiteColor];
                        [self.tableView addSubview:_warnView];
                        
                        // 调整行间距
                        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"评论限互为好友/VIP会员可见"];
                        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                        [paragraphStyle setLineSpacing:5];
                        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, [@"评论限互为好友/VIP会员可见" length])];
                        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1] range:NSMakeRange(3, 4)];
                        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1] range:NSMakeRange(8, 5)];
                        
                        UILabel *warnLabel = [[UILabel alloc] init];
                        warnLabel.attributedText = attributedString;
                        [warnLabel sizeToFit];
                        warnLabel.frame = CGRectMake((WIDTH -  warnLabel.frame.size.width - 40)/2, 20, warnLabel.frame.size.width + 40, 30);
                        warnLabel.textAlignment = NSTextAlignmentCenter;
                        warnLabel.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
                        warnLabel.layer.cornerRadius = 15;
                        warnLabel.clipsToBounds = YES;
                        [_warnView addSubview:warnLabel];
                        
                        [warnLabel yb_addAttributeTapActionWithStrings:@[@"互为好友",@"VIP会员"] delegate:self];
                        warnLabel.enabledTapEffect = NO;
                        
                        [self.tableView.mj_header endRefreshing];
                        
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                        
                    }else if(integer == 2001){
                        
                        _page = 0;
                        
                        [self createDataType:@"1"];
                        
                    }else{
                        
                        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请求发生错误~"];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    
                }];
            }
        }
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _page++;
        
        [self createDataType:@"2"];
        
    }];

    
}


//富文本文字可点击delegate
- (void)yb_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index
{
    
    if ([string isEqualToString:@"VIP会员"]){
        
        LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
        
        [self.navigationController pushViewController:mvc animated:YES];
        
    }else if ([string isEqualToString:@"互为好友"]){
        
        [self attentButtonClickState:_attentStatus];
    }
}

//关注按钮
-(void)attentButtonClickState:(BOOL)state{
    
    if (state) {
        
        _url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/overfollow"];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否取消关注此人"    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [self blackData];
        }];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
        
        if (PHONEVERSION.doubleValue >= 8.3) {
            
            [action setValue:CDCOLOR forKey:@"_titleTextColor"];
            
            [cancelAction setValue:CDCOLOR forKey:@"_titleTextColor"];
        }
        
        [alert addAction:action];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }else{
        
        _url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/followOneBox"];
        
        [self blackData];
        
    }
}

-(void)blackData{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":self.personUid};
    
    [manager POST:_url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //                NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES];
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
        }else{
            
            if (_attentStatus) {
                
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [responseObject objectForKey:@"msg"];
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:3];
                
                _attentStatus = NO;
                
            }else{
                
                if ([responseObject[@"data"] intValue] == 1) {
                    
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"已互为好友，可以免费无限畅聊了~";
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:3];
                    
                }else{
                    
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"已关注成功！互为好友即可免费畅聊~";
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:3];
                }
                
                _attentStatus = YES;
                
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES];
        
        NSLog(@"%@",error);
        
    }];
}


-(void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]) style:UITableViewStyleGrouped];
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:self.tableView];
}

-(void)createDataType:(NSString *)type{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"api/dynamic/getCommentedListOnUserInfo"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
        
    parameters = @{@"uid":self.personUid,@"page":[NSString stringWithFormat:@"%d",_page],@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};

    //NSLog(@"%@",parameters);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
        //NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            if (integer == 4002) {
                
                if ([type intValue] == 1) {
                    
                    [_dataArray removeAllObjects];
                    
                    [self.tableView reloadData];
                    
                    self.tableView.mj_footer.hidden = YES;
                    
                }else{
                    
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }
                
            }else{
                    
                [self.tableView.mj_footer endRefreshing];
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请求发生错误~"];

            }
            
        }else{
            
            if ([type intValue] == 1) {
                
                [_dataArray removeAllObjects];
                
            }
            
            if (_warnView != nil) {
                
                [_warnView removeFromSuperview];
            }
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                
                CommentedModel *model = [[CommentedModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dic];
                
                [_dataArray addObject:model];
            }
            
            self.tableView.mj_footer.hidden = NO;
            
            [self.tableView reloadData];
            
            [self.tableView.mj_footer endRefreshing];
            
        }
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentedCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Commented"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"CommentedCell" owner:self options:nil].lastObject;
    }
    
    CommentedModel *model = _dataArray[indexPath.section];
    
    cell.type = @"1";
    
    cell.model = model;
    
    _cellH = cell.contentView.frame.size.height;
    
    [cell.headButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.lookDynamicButton addTarget:self action:@selector(lookDynamicButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

-(void)lookDynamicButtonClick:(UIButton *)button{
    
    CommentedCell *cell = (CommentedCell *)button.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    CommentedModel *model = _dataArray[indexPath.section];
    
    LDDynamicDetailViewController *dvc = [[LDDynamicDetailViewController alloc] init];
    
    dvc.did = model.did;
    
    dvc.ownUid = model.duid;
    
    [self.navigationController pushViewController:dvc animated:YES];
}

-(void)headButtonClick:(UIButton *)button{
    
    CommentedCell *cell = (CommentedCell *)button.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    CommentedModel *model = _dataArray[indexPath.section];
    
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    
    ivc.userID = model.uid;
    
    [self.navigationController pushViewController:ivc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return _cellH;
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
