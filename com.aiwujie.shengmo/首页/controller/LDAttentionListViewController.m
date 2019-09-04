//
//  LDAttentionListViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/1.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDAttentionListViewController.h"
#import "LDOwnInformationViewController.h"
#import "attentionCell.h"
#import "TableModel.h"
#import "TableCell.h"

@interface LDAttentionListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) UIButton *nearButton;
@property (nonatomic,strong) UIButton *hotButton;
@property (nonatomic,strong) UIButton *friendButton;

@property (nonatomic,strong) UIView *nearView;
@property (nonatomic,strong) UIView *hotView;
@property (nonatomic,strong) UIView *friendView;
@property (nonatomic,strong) UIView *navView;

@property (nonatomic,assign) int page;
@property (nonatomic,assign) NSInteger integer;


@end

@implementation LDAttentionListViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    _navView.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self createNavButtn];
    
    _dataArray = [NSMutableArray array];
    
//    self.type = @"0";
    
    [self createTableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = 0;
        
        [self createData:@"1"];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _page++;
        
        [self createData:@"2"];
        
    }];
    
    if ([self.type intValue] == 0) {
        
        [_nearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _nearView.hidden = NO;
        
    }else if ([self.type intValue] == 1){
    
        [_hotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        _hotView.hidden = NO;

    }

}

-(void)createNavButtn{
    
    if (ISIPHONEX) {
        
        _navView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, WIDTH - 160, 88)];
        
    }else{
        
        _navView = [[UIView alloc] initWithFrame:CGRectMake(80, 0, WIDTH - 160, 64)];
    }
    
    _navView.backgroundColor = [UIColor clearColor];
    
    [self.navigationController.view addSubview:_navView];
    
    CGFloat spotH = 2;
    CGFloat spotW = 38;
    
    _nearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, [self getIsIphoneXNAV:ISIPHONEX], _navView.frame.size.width/3, 30)];
    
    [_nearButton setTitle:@"关注" forState:UIControlStateNormal];
    
    [_nearButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [_nearButton addTarget:self action:@selector(nearButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _nearButton.titleLabel.font = [UIFont systemFontOfSize:17];
    
    [_navView addSubview:_nearButton];
    
    _nearView = [[UIView alloc] initWithFrame:CGRectMake(_navView.frame.size.width/6 - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH)];
    
    _nearView.backgroundColor = [UIColor blackColor];
    
    _nearView.layer.cornerRadius = spotH/2;
    
    _nearView.hidden = YES;
    
    _nearView.clipsToBounds = YES;
    
    [_navView addSubview:_nearView];
    
    
    _hotButton = [[UIButton alloc] initWithFrame:CGRectMake(_navView.frame.size.width/3, [self getIsIphoneXNAV:ISIPHONEX],_navView.frame.size.width/3, 30)];
    
    [_hotButton setTitle:@"粉丝" forState:UIControlStateNormal];
    
    _hotButton.titleLabel.font = [UIFont systemFontOfSize:17];
    
    [_hotButton addTarget:self action:@selector(hotButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_hotButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [_navView addSubview:_hotButton];
    
    _hotView = [[UIView alloc] initWithFrame:CGRectMake(_navView.frame.size.width/3 + _navView.frame.size.width/6 - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH)];
    
    _hotView.backgroundColor = [UIColor blackColor];
    
    _hotView.layer.cornerRadius = spotH/2;
    
    _hotView.hidden = YES;
    
    _hotView.clipsToBounds = YES;
    
    [_navView addSubview:_hotView];
    
    _friendButton = [[UIButton alloc] initWithFrame:CGRectMake(_navView.frame.size.width/3 * 2, [self getIsIphoneXNAV:ISIPHONEX],_navView.frame.size.width/3, 30)];
    
    [_friendButton setTitle:@"好友" forState:UIControlStateNormal];
    
    _friendButton.titleLabel.font = [UIFont systemFontOfSize:17];
    
    [_friendButton addTarget:self action:@selector(friendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_friendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [_navView addSubview:_friendButton];
    
    _friendView = [[UIView alloc] initWithFrame:CGRectMake(_navView.frame.size.width/3 * 2 + _navView.frame.size.width/6 - spotW/2, [self getIsIphoneXNAVBottom:ISIPHONEX], spotW, spotH)];
    
    _friendView.backgroundColor = [UIColor blackColor];
    
    _friendView.layer.cornerRadius = spotH/2;
    
    _friendView.hidden = YES;
    
    _friendView.clipsToBounds = YES;
    
    [_navView addSubview:_friendView];
    
}

-(void)nearButtonClick{
    
    self.type = @"0";
    
    [self.tableView.mj_header beginRefreshing];
    
    [_nearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _nearView.hidden = NO;
    
    [_hotButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _hotView.hidden = YES;
    
    [_friendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _friendView.hidden = YES;
    
}

-(void)hotButtonClick{
    
    self.type = @"1";
    
    [self.tableView.mj_header beginRefreshing];
    
    [_hotButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _hotView.hidden = NO;
    
    [_nearButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _nearView.hidden = YES;
    
    [_friendButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _friendView.hidden = YES;
}

-(void)friendButtonClick{

    self.type = @"2";
    
    [self.tableView.mj_header beginRefreshing];
    
    [_hotButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _hotView.hidden = YES;
    
    [_nearButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _nearView.hidden = YES;
    
    [_friendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    _friendView.hidden = NO;
}

-(void)createData:(NSString *)str{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/getFollewingListFilter"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if ([self.type intValue] == 0 || [self.type intValue] == 1) {
        
        parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":self.type,@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userID};
        
    }else{
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":self.type,@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userID,@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]};
            
        }else{
        
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":self.type,@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userID,@"lat":@"",@"lng":@""};
        }
    
        
    }
    //    NSLog(@"%@",role);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        _integer = [[responseObject objectForKey:@"retcode"] intValue];
        
//        NSLog(@"%@",responseObject);
        
        if (_integer != 2000 && _integer != 2001) {
            
            if (_integer == 4001 || _integer == 4002) {
                
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
                
                TableModel *model = [[TableModel alloc] init];
                
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

-(void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]) style:UITableViewStyleGrouped];
    
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
    
    if ([self.type intValue] == 0 || [self.type intValue] == 1) {
        
        attentionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attention"];
        
        if (!cell) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"attentionCell" owner:self options:nil].lastObject;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        TableModel *model = _dataArray[indexPath.section];
        
        cell.type = self.type;
        
        cell.model = model;
        
        if ([self.type intValue] == 0) {
            
            [cell.attentButton addTarget:self action:@selector(attentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if ([self.type intValue] == 1){
            
            [cell.attentButton addTarget:self action:@selector(fansButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return cell;
    }
    
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Table"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil].lastObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    TableModel *model = _dataArray[indexPath.section];
    
    cell.type = self.type;
    
    cell.integer = _integer;
    
    cell.model = model;
    
    return cell;

    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if ([self.type intValue] != 2 && section == 0) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
        label.text = @"不显示违规用户";
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor lightGrayColor];
        
        return label;
    }
    
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] init];
}

-(void)fansButtonClick:(UIButton *)button{

    attentionCell *cell = (attentionCell *)button.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    TableModel *model = _dataArray[indexPath.section];
    
    if ([model.state intValue] == 0) {
        
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        
        NSString *url = [NSString string];
        
        url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/followOneBox"];
        
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":model.uid};
        
        
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
            
//                    NSLog(@"%@",responseObject);
            
            if (integer != 2000) {
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                
            }else{
                
                model.state = @"1";
                
                [_dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                
                [self.tableView reloadData];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"%@",error);
            
        }];

        
    }else{
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定不再关注此人"    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            AFHTTPSessionManager *manager = [LDAFManager sharedManager];
            
            NSString *url = [NSString string];
            
            url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/overfollow"];
            
            NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":model.uid};
            
            
            [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
                
                //        NSLog(@"%@",responseObject);
                
                if (integer != 2000) {
                    
                   [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                    
                }else{
                    
                    model.state = @"0";
                    
                    [_dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                    
                    [self.tableView reloadData];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            
        }];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
        
        [alert addAction:action];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];

        
    }
}

-(void)attentButtonClick:(UIButton *)button{
    
    attentionCell *cell = (attentionCell *)button.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    TableModel *model = _dataArray[indexPath.section];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定不再关注此人"    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        
        NSString *url = [NSString string];
            
        url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/overfollow"];
            
        NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":model.uid};
        
        
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
            
            //        NSLog(@"%@",responseObject);
            
            if (integer != 2000) {
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                
            }else{
            
                [_dataArray removeObject:model];
                
                [self.tableView reloadData];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];

    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
    
    [alert addAction:action];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 88;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if ([self.type intValue] != 2 && section == 0) {
        
        return 40;
    }
    
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    
    TableModel *model = _dataArray[indexPath.section];
    
    ivc.userID = model.uid;
    
    [self.navigationController pushViewController:ivc animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    _navView.hidden = YES;
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
