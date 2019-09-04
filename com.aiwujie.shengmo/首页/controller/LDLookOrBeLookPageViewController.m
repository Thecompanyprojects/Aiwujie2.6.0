//
//  LDLookOrBeLookPageViewController.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/10/9.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDLookOrBeLookPageViewController.h"
#import "LDOwnInformationViewController.h"
#import "LDMemberViewController.h"
#import "TableCell.h"
#import "TableModel.h"

@interface LDLookOrBeLookPageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int integer;
@property (nonatomic,assign) int page;

@property (nonatomic,copy) NSString *typeString;

@end

@implementation LDLookOrBeLookPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createTableView];
    
    _dataArray = [NSMutableArray array];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = 0;
        
        [self createDataState:@"1"];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _page++;
        
        [self createDataState:@"2"];
        
    }];
}

-(void)createDataState:(NSString *)state{
    
    if ([self.content intValue] == 0) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1) {
            
            //请求相应的数据
            [self requestData:state];
            
        }else{
            
            [_dataArray removeAllObjects];
            
            [self.tableView reloadData];
            
            [self.tableView.mj_header endRefreshing];
            self.tableView.mj_footer.hidden = YES;
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"查看来访记录仅VIP会员可用哦~"    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"开通会员" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                
                
                LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
                
                [self.navigationController pushViewController:mvc animated:YES];
                
                
            }];
            
            UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
            
            [alert addAction:cancelAction];
            
            [alert addAction:action];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
    }else{
        
        //请求相应的数据
        [self requestData:state];
    }
}

/**
 * 请求相应的数据
 */
-(void)requestData:(NSString *)state{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/getReadList"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":self.content,@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        
    }else{
        
        parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":self.content,@"lat":@"",@"lng":@"",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        
    }
    
    //    NSLog(@"%@",role);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        _integer = [[responseObject objectForKey:@"retcode"] intValue];
        
        //                NSLog(@"%@",responseObject);
        
        if (_integer != 2000 && _integer != 2001) {
            
            if (_integer == 4001) {
                
                if ([state intValue] == 1) {
                    
                    [_dataArray removeAllObjects];
                    
                    [self.tableView reloadData];
                    
                    self.tableView.mj_footer.hidden = YES;
                    
                }else{
                
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }
                
                
            }else{
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                
            }
            
        }else{
            
            if ([state intValue] == 1) {
                
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
    
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    
    TableModel *model = _dataArray[indexPath.section];
    
    ivc.userID = model.uid;
    
    [self.navigationController pushViewController:ivc animated:YES];
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
