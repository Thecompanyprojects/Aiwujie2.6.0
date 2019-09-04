//
//  LDGiveGifListPageViewController.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/6/22.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDGiveGifListPageViewController.h"
#import "LDOwnInformationViewController.h"
#import "GiveGifCell.h"
#import "GiveGifModel.h"

@interface LDGiveGifListPageViewController ()<UITableViewDelegate,UITableViewDataSource>

//首页tableview及数据源
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

//分页page
@property (nonatomic,assign) int tablePage;


@end

@implementation LDGiveGifListPageViewController

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
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"api/dynamic/getPresentMsg"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    parameters = @{@"page":[NSString stringWithFormat:@"%d",_tablePage],@"type":self.content};
    //NSLog(@"%@",parameters);
    
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //        NSLog(@"%@",responseObject);
        
        if (integer != 2000 && integer != 2001) {
            
            if (integer == 4000) {
                
                if ([type intValue] == 1) {
                    
                    [_dataArray removeAllObjects];
                    
                    [_tableView reloadData];
                    
                    self.tableView.mj_footer.hidden = YES;
                    
                }else{
                
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }

            }else{
                
                 [self.tableView.mj_footer endRefreshing];
                
                 [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            }
            
        }else{
            
            if ([type intValue] == 1) {
                
                [_dataArray removeAllObjects];
            }
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                
                GiveGifModel *model = [[GiveGifModel alloc] init];
                
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 44) style:UITableViewStylePlain];
    
    self.tableView.backgroundColor = [UIColor blackColor];
    
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
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GiveGifCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GiveGif"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"GiveGifCell" owner:self options:nil].lastObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (_dataArray.count > 0) {
        
        GiveGifModel *model = _dataArray[indexPath.row];
        
        cell.model = model;
    }
    
    [cell.giveButton addTarget:self action:@selector(giveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.givenButton addTarget:self action:@selector(givenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)giveButtonClick:(UIButton *)button{

    GiveGifCell *cell = (GiveGifCell *) button.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    
    GiveGifModel *model = _dataArray[indexPath.row];
    
    ivc.userID = model.uid;
    
    [self.navigationController pushViewController:ivc animated:YES];
}

-(void)givenButtonClick:(UIButton *)button{

    GiveGifCell *cell = (GiveGifCell *) button.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    
    GiveGifModel *model = _dataArray[indexPath.row];
    
    ivc.userID = model.fuid;
    
    [self.navigationController pushViewController:ivc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 120;
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
