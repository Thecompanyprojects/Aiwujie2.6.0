//
//  LDGroupSpuarePageViewController.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/5/9.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDGroupSpuarePageViewController.h"
#import "LDGroupInformationViewController.h"
#import "LDLookOtherGroupInformationViewController.h"
#import "GroupSqureCell.h"
#import "GroupSqureModel.h"

@interface LDGroupSpuarePageViewController ()<UITextViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *mineArray;
@property (nonatomic,strong) NSMutableArray *joinArray;

@property (nonatomic,copy) NSString *type;

@property (nonatomic,assign) int page;
@property (nonatomic,assign) int integer;


@end

@implementation LDGroupSpuarePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _dataArray = [NSMutableArray array];
    _mineArray = [NSMutableArray array];
    _joinArray = [NSMutableArray array];
    
    [self createTableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = 0;
        
        if ([self.content intValue] == 4){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"groupNewDelete" object:nil];
        }
        
        if ([self.content intValue] == 2) {
            
            [self createSectionData:@"1"];
            
        }else{
        
            [self createData:@"1"];
            
        }
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _page++;
            
        [self createData:@"2"];
        
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(completeClick) name:@"wancheng" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(groupSelectScreenButtonClick) name:@"确定群组筛选" object:nil];
}

-(void)completeClick{

    if ([self.content intValue] == 2) {

        [self.tableView.mj_header beginRefreshing];
    }
}

-(void)groupSelectScreenButtonClick{

    if ([self.content intValue] != 2) {
        
        [self.tableView.mj_header beginRefreshing];
    }
}

-(void)createSectionData:(NSString *)str{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/getGroupListFilter"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        parameters = @{@"type":@"3",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]};
        
    }else{
        
        parameters = @{@"type":@"3",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":@"",@"lng":@""};
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
            
            [self.tableView reloadData];
            
            [self createData:str];
            
        }else{
        
            [_mineArray removeAllObjects];
            
            [_joinArray removeAllObjects];
            
            [_dataArray removeAllObjects];
            
            [self.tableView reloadData];
            
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
    
    if ([self.content intValue] != 2) {
        
        //判定群组筛选是否开启
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"群组筛选"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"群组筛选"] intValue] == 0) {
        
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
                
                parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":self.content,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]};
                
            }else{
                
                parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":self.content,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":@"",@"lng":@""};
            }

        
        }else{
            
            NSString *filterabnormal = [NSString string];
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSex"] intValue] == 1 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSexual"] intValue] == 1) {
                
                filterabnormal = @"2";
                
            }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSex"] intValue] == 2 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSexual"] intValue] == 2){
                
                filterabnormal = @"3";
                
            }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSex"] intValue] == 3){
                
                filterabnormal = @"4";
                
            }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSex"] intValue] == 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"newestSexual"] intValue] == 0){
                
                filterabnormal = @"0";
                
            }else{
                
                filterabnormal = @"1";
            }
        
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
                
                parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":self.content,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"filterabnormal":filterabnormal};
                
            }else{
                
                parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":self.content,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":@"",@"lng":@"",@"filterabnormal":filterabnormal};
            }

        }
        
    }else{
    
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
            
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":self.content,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]};
            
        }else{
            
            parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":self.content,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":@"",@"lng":@""};
        }

    }
    
        //NSLog(@"%@",role);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        _integer = [[responseObject objectForKey:@"retcode"] intValue];
        
        //NSLog(@"%@",responseObject);
        
        if (_integer != 2000 && _integer != 2001) {
            
            if (_integer == 4001) {
                
                if ([str intValue] == 1) {
                    
                    if ([str intValue] == 1 && [self.content intValue] != 2) {
                        
                        [_dataArray removeAllObjects];
                    }
                    
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
            
            if ([str intValue] == 1 && [self.content intValue] != 2) {
                
                [_dataArray removeAllObjects];
            }
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                
                GroupSqureModel *model = [[GroupSqureModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dic];
                
                if ([self.content intValue] == 2) {
                    
                    [_joinArray addObject:model];
                    
                }else{
                
                    [_dataArray addObject:model];
                    
                }
            }
            
            if ([self.content intValue] == 2) {
                
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 44) style:UITableViewStylePlain];
    
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
    
    self.tableView.tableFooterView =  [[UIView alloc] init];
    
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if ([self.content intValue] == 2) {
        
        return _dataArray.count;
    }
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([self.content intValue] == 2) {
        
        return [_dataArray[section] count];
    }
    
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupSqureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupSqure"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"GroupSqureCell" owner:self options:nil].lastObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GroupSqureModel *model = [[GroupSqureModel alloc] init];
    
    if ([self.content intValue] == 2) {
        
        model = _dataArray[indexPath.section][indexPath.row];
        
    }else{
    
        model = _dataArray[indexPath.row];
    }
    
    cell.integer = [NSString stringWithFormat:@"%d",_integer];
    
    cell.model = model;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 83;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if([self.content intValue] == 2){
            
        return 30;
    }
    
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if([self.content intValue] == 2){
        
        if (_mineArray.count != 0) {
            
            if (_joinArray.count == 0) {
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 25)];
                
                label.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
                
                label.textColor = [UIColor darkGrayColor];
                
                label.text = @"      我创建的群组";
                
                label.font = [UIFont systemFontOfSize:13];
                
                return label;
                
            }else{
            
                if (section == 0) {
                    
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 25)];
                    
                    label.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
                    
                    label.textColor = [UIColor darkGrayColor];
                    
                    label.text = @"      我创建的群组";
                    
                    label.font = [UIFont systemFontOfSize:13];
                    
                    return label;
                    
                }else{
                
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 25)];
                    
                    label.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
                    
                    label.textColor = [UIColor darkGrayColor];
                    
                    label.text = @"      我加入的群组";
                    
                    label.font = [UIFont systemFontOfSize:13];
                    
                    return label;
                }
            }
            
        }else{
        
            if (_joinArray.count != 0){
            
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 25)];
                
               label.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
                
                label.textColor = [UIColor darkGrayColor];
                
                label.text = @"      我加入的群组";
                
                label.font = [UIFont systemFontOfSize:13];
                
                return label;
            }
        }
    }

    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GroupSqureModel *model = [[GroupSqureModel alloc] init];
    
    if ([self.content intValue] == 2) {
        
        model = _dataArray[indexPath.section][indexPath.row];
        
    }else{
    
        model = _dataArray[indexPath.row];
    }
    
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
