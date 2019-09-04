//
//  LDGroupNumberViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/21.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDGroupNumberViewController.h"
#import "GroupSqureCell.h"
#import "GroupSqureModel.h"
#import "LDLookOtherGroupInformationViewController.h"
#import "LDGroupInformationViewController.h"

@interface LDGroupNumberViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *mineArray;
@property (nonatomic,strong) NSMutableArray *joinArray;

@property (nonatomic,assign) int page;
@property (nonatomic,assign) int integer;

@property (nonatomic,strong) NSIndexPath *indexPath;

@end

@implementation LDGroupNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _dataArray = [NSMutableArray array];
    _mineArray = [NSMutableArray array];
    _joinArray = [NSMutableArray array];
    
    if ([self.userId intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        
        self.navigationItem.title = @"我的群组";
        
    }else{
        
        self.navigationItem.title = @"Ta的群组";
    }
    
    
    [self createTableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = 0;
        
        [self createSectionData:@"1"];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _page++;
        
        [self createData:@"2"];
        
    }];

}

-(void)createSectionData:(NSString *)str{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/getGroupListFilter"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        parameters = @{@"type":@"3",@"uid":self.userId,@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]};
        
    }else{
        
        parameters = @{@"type":@"3",@"uid":self.userId,@"lat":@"",@"lng":@""};
    }
    //NSLog(@"%@",role);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
//        NSLog(@"%@",responseObject);
        
        if (integer == 2000) {
            
            if ([str intValue] == 1) {
                
                [_mineArray removeAllObjects];
                
                [_joinArray removeAllObjects];
                
                [_dataArray removeAllObjects];
            }
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                
                GroupSqureModel *model = [[GroupSqureModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dic];
                
                [_mineArray addObject:model];
                
            }
            
            [_dataArray addObject:_mineArray];
            
            [self createData:str];
            
        }else{
            
            [_mineArray removeAllObjects];
            
            [_joinArray removeAllObjects];
            
            [_dataArray removeAllObjects];
            
            [self createData:str];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
    
}

-(void)createData:(NSString *)str{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/getGroupListFilter"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    //    NSLog(@"%@",role);
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"2",@"uid":self.userId,@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]};
        
    }else{
        
        parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"2",@"uid":self.userId,@"lat":@"",@"lng":@""};
    }

    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        _integer = [[responseObject objectForKey:@"retcode"] intValue];
        
//        NSLog(@"%@",responseObject);
        
        if (_integer != 2000 && _integer != 2001) {
            
            if (_integer == 4001) {
                
                if ([str intValue] == 1) {
                    
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
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                
                GroupSqureModel *model = [[GroupSqureModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dic];
                    
                [_joinArray addObject:model];
                    
            }
            
            if (_mineArray.count != 0) {
                
                if (_dataArray.count == 1) {
                    
                    [_dataArray addObject:_joinArray];
                    
                }else{
                    
                    [_dataArray replaceObjectAtIndex:1 withObject:_joinArray];
                }
                
            }else{
                
                if (_dataArray.count == 0) {
                    
                    [_dataArray addObject:_joinArray];
                    
                }else{
                    
                    [_dataArray replaceObjectAtIndex:0 withObject:_joinArray];
                }
                
            }

            self.tableView.mj_footer.hidden = NO;
            
            [self.tableView reloadData];
            
            [self.tableView.mj_footer endRefreshing];

        }
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
    
}

-(void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]) style:UITableViewStylePlain];
    
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
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataArray[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupSqureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupSqure"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"GroupSqureCell" owner:self options:nil].lastObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GroupSqureModel *model = _dataArray[indexPath.section][indexPath.row];
    
    cell.integer = [NSString stringWithFormat:@"%d",_integer];
    
    cell.model = model;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 83;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (_mineArray.count != 0) {
        
        if (_joinArray.count == 0) {
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 25)];
            
            label.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
            
            label.textColor = [UIColor darkGrayColor];
            
            if ([self.userId intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
                
                label.text = @"      我创建的群组";
                
            }else{
                
                label.text = @"      Ta创建的群组";
            }
            
            
            label.font = [UIFont systemFontOfSize:13];
            
            return label;
            
        }else{
            
            if (section == 0) {
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 25)];
                
                label.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
                
                label.textColor = [UIColor darkGrayColor];
                
                
                if ([self.userId intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
                    
                    label.text = @"      我创建的群组";
                    
                }else{
                    
                    label.text = @"      Ta创建的群组";
                }
                
                
                label.font = [UIFont systemFontOfSize:13];
                
                return label;
                
            }else{
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 25)];
                
                label.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
                
                label.textColor = [UIColor darkGrayColor];
                
                if ([self.userId intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
                    
                    label.text = @"      我加入的群组";
                    
                }else{
                    
                    label.text = @"      Ta加入的群组";
                }
                
                
                
                label.font = [UIFont systemFontOfSize:13];
                
                return label;
            }
        }
        
    }else{
        
        if (_joinArray.count != 0){
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 25)];
            
            label.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
            
            label.textColor = [UIColor darkGrayColor];
            
            if ([self.userId intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
                
                label.text = @"      我加入的群组";
                
            }else{
            
                label.text = @"      Ta加入的群组";
            }
            
            label.font = [UIFont systemFontOfSize:13];
            
            return label;
        }
    }

    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupSqureModel *model = _dataArray[indexPath.section][indexPath.row];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/getGroupinfo"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    parameters = @{@"gid":model.gid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    //    NSLog(@"%@",role);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
        //        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];

        }else{
            
            if ([responseObject[@"data"][@"userpower"] intValue] < 1) {
                
                LDLookOtherGroupInformationViewController *ivc = [[LDLookOtherGroupInformationViewController alloc] init];
                
                ivc.gid = model.gid;
                
                [self.navigationController pushViewController:ivc animated:YES];
                
                
            }else{
                
                LDGroupInformationViewController *fvc = [[LDGroupInformationViewController alloc] init];
                
                fvc.gid = model.gid;
                
                [self.navigationController pushViewController:fvc animated:YES];
                
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
        
    }];
    
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
