//
//  LDGroupMemberListViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/17.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDGroupMemberListViewController.h"
#import "GroupMemberListModel.h"
#import "GroupMemberListCell.h"
#import "LDOwnInformationViewController.h"

@interface LDGroupMemberListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int page;

@property (nonatomic,assign) int integer;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation LDGroupMemberListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _dataArray = [NSMutableArray array];
    
    self.navigationItem.title = @"群组成员";
    
    [self createTableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = 0;
        
        [self createGroupMemberData:@"1"];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _page++;
        
        [self createGroupMemberData:@"2"];
        
    }];

    
}

-(void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, WIDTH, [self getIsIphoneX:ISIPHONEX] - 44) style:UITableViewStyleGrouped];
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupMemberListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupMemberList"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"GroupMemberListCell" owner:self options:nil].lastObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GroupMemberListModel *model = _dataArray[indexPath.section];
    
    cell.integer = [NSString stringWithFormat:@"%d",_integer];
    
    cell.model = model;
    
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.type  intValue] == 1) {
        
        return NO;
        
    }else{
        
        GroupMemberListModel *model = _dataArray[indexPath.section];
    
        if ([self.state intValue] <= [model.state intValue]) {
            
            return NO;
            
        }else{
        
            return YES;
        }
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupMemberListModel *model = _dataArray[indexPath.section];
    
    NSString *title = [NSString string];
    
    if ([model.gagstate intValue] == 0) {
        
        title = @"禁言";
        
    }else{
    
        title = @"解除禁言";
    }
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"踢出" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        
            AFHTTPSessionManager *manager = [LDAFManager sharedManager];
            
            NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/shotOffone"];
            
            NSDictionary *parameters = [NSDictionary dictionary];
            
            //            NSLog(@"%@",model.ugid);
            
            parameters = @{@"ugid":model.ugid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
            [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                //     NSLog(@"%@",responseObject);
                
                NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
                
                //        NSLog(@"%@",responseObject);
                
                if (integer != 2000) {
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                    
                    
                }else{
                    
                    [_dataArray removeObjectAtIndex:indexPath.section];
                    
                    [self.tableView reloadData];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                
            }];
        
    }];
    
    UITableViewRowAction *gagAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:title handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {

        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        if ([model.gagstate intValue] == 0) {//禁言群成员
            
            AFHTTPSessionManager *manager = [LDAFManager sharedManager];
            
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 10.f;
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            
            NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/gagSomeOne"];
            
            NSDictionary *parameters = [NSDictionary dictionary];
            
            //            NSLog(@"%@",model.ugid);
            
            parameters = @{@"ugid":model.ugid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
            [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                //                NSLog(@"%@",responseObject);
                
                NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
                
                //        NSLog(@"%@",responseObject);
                
                if (integer != 2000) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                    
                    
                }else{
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    model.gagstate = @"1";
                    
                    [_dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                    
                    [self.tableView reloadData];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"设置超时,请稍后重试~"];
                
            }];

        }else{//解除禁言
        
            AFHTTPSessionManager *manager = [LDAFManager sharedManager];
            
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            manager.requestSerializer.timeoutInterval = 10.f;
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            
            NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/removeGagSomeOne"];
            
            NSDictionary *parameters = [NSDictionary dictionary];
            
            //            NSLog(@"%@",model.ugid);
            
            parameters = @{@"ugid":model.ugid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
            [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                //        NSLog(@"%@",responseObject);
                
                NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
                
                //        NSLog(@"%@",responseObject);
                
                if (integer != 2000) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                    
                    
                }else{
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    model.gagstate = @"0";
                    
                    [_dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                    
                    [self.tableView reloadData];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"设置超时,请稍后重试~"];
                
            }];

        }
        
        
    }];

    editAction.backgroundColor = [UIColor redColor];
    
    return @[editAction,gagAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    editingStyle = UITableViewCellEditingStyleDelete;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 97;
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.type intValue] == 1) {
        
        GroupMemberListModel *model = _dataArray[indexPath.section];
        
//        NSLog(@"%@",model.state);
        
        if ([model.state intValue] == 2) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否取消此管理员"    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                
                AFHTTPSessionManager *manager = [LDAFManager sharedManager];
                
                NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/cancelManager"];
                
                NSDictionary *parameters = [NSDictionary dictionary];
                
                parameters = @{@"ugid":model.ugid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
                
                [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    //        NSLog(@"%@",responseObject);
                    
                    NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
                    
                    //        NSLog(@"%@",responseObject);
                    
                    if (integer != 2000) {
                        
                        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                        
                        
                    }else{
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    
                }];
                
            }];
            
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
            
            if (PHONEVERSION.doubleValue >= 8.3) {
            
                [action setValue:CDCOLOR forKey:@"_titleTextColor"];
                
                [cancelAction setValue:CDCOLOR forKey:@"_titleTextColor"];
            }
            
            
            [alert addAction:action];
            
            [alert addAction:cancelAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
        }else if([model.state intValue] == 1){
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否将此成员设置成管理员"    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                
                AFHTTPSessionManager *manager = [LDAFManager sharedManager];
                
                NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/setManager"];
                
                NSDictionary *parameters = [NSDictionary dictionary];
                
                parameters = @{@"ugid":model.ugid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
                
                [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    //        NSLog(@"%@",responseObject);
                    
                    NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
                    
                    //        NSLog(@"%@",responseObject);
                    
                    if (integer != 2000) {
                        
                        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                        
                        
                    }else{
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    
                }];
                
            }];
            
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
            
            if (PHONEVERSION.doubleValue >= 8.3) {
            
                [action setValue:CDCOLOR forKey:@"_titleTextColor"];
                
                [cancelAction setValue:CDCOLOR forKey:@"_titleTextColor"];
            }
            
            
            [alert addAction:action];
            
            [alert addAction:cancelAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }

    }else{
    
        GroupMemberListModel *model = _dataArray[indexPath.section];
        
        LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
        
        ivc.userID = model.uid;
        
        [self.navigationController pushViewController:ivc animated:YES];
        
    }
}


-(void)createGroupMemberData:(NSString *)str{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/getGroupMember"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if (_searchBar.text.length == 0) {
        
        _searchBar.text = @"";
        
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        parameters = @{@"gid":self.gid,@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"page":[NSString stringWithFormat:@"%d",_page],@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"search":_searchBar.text};
        
    }else{
        
        parameters = @{@"gid":self.gid,@"lat":@"",@"lng":@"",@"page":[NSString stringWithFormat:@"%d",_page],@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"search":_searchBar.text};
    }
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"%@",responseObject);
        
        _integer = [[responseObject objectForKey:@"retcode"] intValue];
        
        //        NSLog(@"%@",responseObject);
        
        if (_integer != 2000 && _integer != 2001) {
            
            if (_integer == 4001) {
                
                if ([str intValue] == 1) {
                    
                    [_dataArray removeAllObjects];
                    
                    [self.tableView reloadData];
                    
                    self.tableView.mj_footer.hidden = YES;
                    
                }else{
                
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }

            }else{
                
                 [self.tableView.mj_footer endRefreshing];
            
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                
            }
            
        }else{
            
            if ([str intValue] == 1) {
                
                [_dataArray removeAllObjects];
            }
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                
                GroupMemberListModel *model = [[GroupMemberListModel alloc] init];
                
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

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = YES;
    
    for(id cc in [searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            
            [btn setTitleColor:CDCOLOR forState:UIControlStateNormal];
        }
    }
    
    
    
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    _page = 0;
    
    [self createGroupMemberData:@"1"];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = NO;
    
    searchBar.text = nil;
    
    _page = 0;
    
    [self createGroupMemberData:@"1"];
    
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
    
    for(id cc in [searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
           
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
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
