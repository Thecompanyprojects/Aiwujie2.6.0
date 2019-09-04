//
//  LDGroupAtPersonViewController.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/5/11.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDGroupAtPersonViewController.h"
#import "LDGroupChatViewController.h"
#import "GroupMemberListModel.h"
#import "GroupAtPersonCell.h"

@interface LDGroupAtPersonViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int page;


@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation LDGroupAtPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _dataArray = [NSMutableArray array];
    
    self.navigationItem.title = @"选择群成员";
    
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
    
    GroupAtPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupAtPerson"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"GroupAtPersonCell" owner:self options:nil].lastObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    GroupMemberListModel *model = _dataArray[indexPath.section];
    
    cell.model = model;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
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
    
    GroupMemberListModel *model = _dataArray[indexPath.section];
    
    //此处为了演示写了一个用户信息
    RCUserInfo *user = [[RCUserInfo alloc]init];
    
    user.portraitUri = model.head_pic;

    user.name = model.nickname;
    
    user.userId = model.uid;
    
    self.block(user);
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)createGroupMemberData:(NSString *)str{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/getAtGroupMember"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if (_searchBar.text.length == 0) {
        
        _searchBar.text = @"";
        
    }
        
    parameters = @{@"gid":self.groupId,@"page":[NSString stringWithFormat:@"%d",_page],@"search":_searchBar.text};
 
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"%@",responseObject);
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
//                NSLog(@"%@",responseObject);
        if (integer != 2000) {
            
            if (integer == 4001) {
                
                if ([str intValue] == 1) {
                    
                    [_dataArray removeAllObjects];
                    
                    [self.tableView reloadData];
                    
                    self.tableView.mj_footer.hidden = YES;
                    
                }else{
                
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }
                
            }else{
                
                [self.tableView.mj_footer endRefreshing];
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"发生错误,请稍后重试~"];
                
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
    
    [_dataArray removeAllObjects];
    
    _page = 0;
    
    [self createGroupMemberData:@"1"];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = NO;
    
    searchBar.text = nil;
    
    [_dataArray removeAllObjects];
    
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
