//
//  LDSearchUserViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/20.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDSearchUserViewController.h"
#import "LDOwnInformationViewController.h"
#import "TableCell.h"
#import "TableModel.h"

@interface LDSearchUserViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) NSInteger integer;

@property (nonatomic,assign) int page;

@end

@implementation LDSearchUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"搜索用户";
    
    _dataArray = [NSMutableArray array];
    
    [self createTableView];
    
    _searchBar.text = self.searchString;
    
    [self searchBar:_searchBar textDidChange:self.searchString];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _page++;
        
        [self createData:@"2"];
        
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
    
    TableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Table"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil].lastObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    TableModel *model = _dataArray[indexPath.section];
    
    cell.integer = _integer;
    
    cell.model = model;
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 88;
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
    
    LDOwnInformationViewController *fvc = [[LDOwnInformationViewController alloc] init];
    
    TableModel *model = _dataArray[indexPath.section];
    
    fvc.userID = model.uid;
    
    [self.navigationController pushViewController:fvc animated:YES];
    
}


-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = YES;
    
    for(id cc in [searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
//            [btn setTitle:[AppLanguageProcess getLanguageWithKey:@"TEXT_CANCEL"]  forState:UIControlStateNormal];
            [btn setTitleColor:CDCOLOR forState:UIControlStateNormal];
        }
    }

   
    
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    _page = 0;
    
    [self createData:@"1"];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{

    searchBar.showsCancelButton = NO;
    
    searchBar.text = nil;
    
    [_dataArray removeAllObjects];
    
    [self.tableView reloadData];
    
    self.tableView.mj_footer.hidden = YES;
    
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

//搜索用户
-(void)createData:(NSString *)type{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/index/searchUserNewth"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"search":_searchBar.text};
        
    }else{
        
        parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"lat":@"",@"lng":@"",@"search":_searchBar.text};
    }
    
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        _integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //        NSLog(@"%@",responseObject);
        
        if (_integer != 2000 && _integer != 2001) {
            
            if ([type intValue] == 1) {
                
                [_dataArray removeAllObjects];
                
                [self.tableView reloadData];
                
                self.tableView.mj_footer.hidden = YES;
                
            }else if([type intValue] == 2 && _integer == 4001){
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            
            }else{
            
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                
            }
            
        }else{
            
            if ([type intValue] == 1) {
                
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
