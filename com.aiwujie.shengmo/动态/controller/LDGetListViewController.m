//
//  LDGetListViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/24.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDGetListViewController.h"
#import "CommentedCell.h"
#import "CommentedModel.h"
#import "LDZanViewController.h"
#import "LDRewardViewController.h"
#import "LDOwnInformationViewController.h"
#import "LDDynamicDetailViewController.h"
#import "LDAtViewController.h"

@interface LDGetListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int page;

@property (nonatomic,assign) CGFloat cellH;
@property (weak, nonatomic) IBOutlet UILabel *zanLabel;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;
@property (weak, nonatomic) IBOutlet UILabel *atLabel;

@end

@implementation LDGetListViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.atLabel.text = [NSString stringWithFormat:@"刚刚有%lu人@了你",[[[NSUserDefaults standardUserDefaults] objectForKey:@"atPerson"] count]];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"动态信息";
    
    _dataArray = [NSMutableArray array];
    
    [self createButton];
    
    [self createUnreadData];
    
    [self createTableView];
    
    _page = 0;
    
    [self createCommentData];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _page++;
        
        [self createCommentData];
        
    }];

}


-(void)createUnreadData{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Dynamic/getUnreadNum"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"type":@"0"};
    //    NSLog(@"%@",role);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
        //NSLog(@"%@",responseObject);
        
        if (integer == 2000){
            
            self.zanLabel.text = [NSString stringWithFormat:@"刚刚有%d人赞过我",[responseObject[@"data"][@"laudnum"] intValue]];
            
            self.rewardLabel.text = [NSString stringWithFormat:@"刚刚有%d人打赏我",[responseObject[@"data"][@"rewardnum"] intValue]];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

-(void)createCommentData{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString string];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page]};
    
    url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Dynamic/getCommentedList"];
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
        //NSLog(@"%@",responseObject);
        
        if (integer == 2000){
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                
                CommentedModel *model = [[CommentedModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dic];
                
                [_dataArray addObject:model];
            }
            
            self.tableView.mj_footer.hidden = NO;
            
            [self.tableView reloadData];
            
            [self.tableView.mj_footer endRefreshing];
            
        }else if (integer == 4002){
        
           self.tableView.mj_footer.hidden = YES;
        
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.tableView.mj_footer endRefreshing];
        
        NSLog(@"%@",error);
        
    }];

}

-(void)createTableView{

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 193, WIDTH, [self getIsIphoneX:ISIPHONEX] - 193) style:UITableViewStyleGrouped];
    
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
    
    [self.view addSubview:self.tableView];
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

- (IBAction)zanButtonClick:(id)sender {
    
    LDZanViewController *zvc = [[LDZanViewController alloc] init];
    
    [self.navigationController pushViewController:zvc animated:YES];
}
- (IBAction)rewardButtonClick:(id)sender {
    
    LDRewardViewController *rvc = [[LDRewardViewController alloc] init];
    
    [self.navigationController pushViewController:rvc animated:YES];
}
- (IBAction)atButtonClick:(id)sender {
    
    LDAtViewController *avc = [[LDAtViewController alloc] init];
    
    [self.navigationController pushViewController:avc animated:YES];
}

-(void)createButton{
    
    UIButton * areaButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 36, 10, 14)];
    
    if (@available(iOS 11.0, *)) {
        
        [areaButton setImage:[UIImage imageNamed:@"back-11"] forState:UIControlStateNormal];
        
    }else{
        
        [areaButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }
    
    [areaButton addTarget:self action:@selector(backButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:areaButton];
    
    if (@available(iOS 11.0, *)) {
        
        leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 44);
    }
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

-(void)backButtonOnClick{
    
    if (self.hotDog) {
        
        [self clearData];
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)clearData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"api/dynamic/clearUnreadNumAll"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
         //NSLog(@"%@",responseObject[@"msg"]);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.navigationController popViewControllerAnimated:YES];
        
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
