//
//  LDSelectTopicViewController.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/10/13.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDSelectTopicViewController.h"
#import "TopicCell.h"
#import "TopicModel.h"

@interface LDSelectTopicViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

//分页page
@property (nonatomic,assign) int tablePage;

@end

@implementation LDSelectTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _dataArray = [NSMutableArray array];
    
    [self createTableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _tablePage = 0;
        
        [self createDatatype:@"1"];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _tablePage++;
        
        [self createDatatype:@"2"];
        
    }];

}

-(void)createDatatype:(NSString *)type{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"api/dynamic/getTopicList"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
            
    parameters = @{@"page":[NSString stringWithFormat:@"%d",_tablePage],@"type":@"0",@"pid":self.pid,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};

    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            if (integer == 3000) {
                
                if ([type intValue] == 1) {
                    
                    [_dataArray removeAllObjects];
                    
                    [_tableView reloadData];
                    
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
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                
                if ([dic[@"is_admin"] intValue] == 0) {
                    
                    TopicModel *model = [[TopicModel alloc] init];
                    
                    [model setValuesForKeysWithDictionary:dic];
                    
                    [_dataArray addObject:model];
                }
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]) style:UITableViewStylePlain];
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_tableView];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TopicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Topic"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"TopicCell" owner:self options:nil].lastObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    TopicModel *model = _dataArray[indexPath.section];
    
    cell.indexPath = indexPath;
    
    cell.model = model;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TopicModel *model = _dataArray[indexPath.section];
    
    if(self.block){
    
        _block(model.title,model.tid);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 85;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (_dataArray.count != 0 && _dataArray.count == section + 1) {
        
        return 2;
    }
    
    return 0;
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
