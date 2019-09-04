//
//  LDBillViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/12.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDBillViewController.h"
#import "BillCell.h"
#import "BillModel.h"

@interface LDBillViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSString *buttonState;

//充值界面的赠送记录和兑换记录
@property (weak, nonatomic) IBOutlet UIView *chargeView;
@property (weak, nonatomic) IBOutlet UIButton *chargeGiveButton;
@property (weak, nonatomic) IBOutlet UIButton *chargeExchangeButton;

//礼物和邮票的兑换记录
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIButton *detailExchangeButton;
@property (weak, nonatomic) IBOutlet UIButton *detailGiveButton;
@property (weak, nonatomic) IBOutlet UIButton *detailDepositButton;

@end

@implementation LDBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if ([_index intValue] == 0 && [self.content intValue] == 1) {
//        
//        _chargeView.hidden = NO;
//        
//        _buttonState = @"1";
//        
//        
//    }else if ([_index intValue] == 1 && [self.content intValue] == 2){
//    
//        _detailView.hidden = NO;
//        
        _buttonState = @"1";
//    }
    
    _dataArray = [NSMutableArray array];
    
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

}

-(void)createData:(NSString *)type{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString string];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if ([_index intValue] == 0) {
        
        if ([self.content intValue] == 1) {
            
            if ([_buttonState intValue] == 1) {
                
                url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Users/getGivePsRerond"];
                
                parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"0"};
                
            }else{
                
                url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Users/getExchangeRecord"];
                
                parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"0"};
            }

        }else if ([self.content intValue] == 0){
        
            url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Users/getWalletRecord"];
            
            parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page]};
        }
        
    }else if ([self.index intValue] == 1) {
        
        if ([self.content intValue] == 0) {
            
            url = [NSString stringWithFormat:@"%@%@",URL,@"Api/users/getReceivePresent"];
            
            parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page]};
            
            
        }else if([self.content intValue] == 1){
        
            url = [NSString stringWithFormat:@"%@%@",URL,@"Api/users/getBasicGiveRecord"];
            
            parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page]};
            
        }else if ([self.content intValue] == 2){
        
            if ([_buttonState intValue] == 1) {
                
                url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Users/getGivePsRerond"];
                
                parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"1"};
                
            }else if ([_buttonState intValue] == 2){
            
                url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Users/getExchangeRecord"];
                
                parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"1"};
                
            }
//            else if ([_buttonState intValue] == 3){
            
//                url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Users/getWithdrawedRecord"];
//
//                parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page]};
//            }
        }

    }else if([_index intValue] == 2){

        if ([self.content intValue] == 0) {
            
            url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Users/getStampPaymentRs"];
            
            parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page]};
            
        }else if([self.content intValue] == 1){
        
            url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Users/getBasicStampGiveRs"];
            
            parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page]};
            
        }else if ([self.content intValue] == 2){
        
            url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Users/getStampUsedRs"];
            
            parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"page":[NSString stringWithFormat:@"%d",_page]};
        }
    }
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            if (integer == 4001 || integer == 3000) {
                
                if ([type intValue] == 1) {
                    
                    [_dataArray removeAllObjects];
                    
                    [self.tableView reloadData];
                    
                     self.tableView.mj_footer.hidden = YES;
                    
                }else{
                    
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                
                [self.tableView.mj_footer endRefreshing];
            
            }
            
        }else{
            
            if ([type intValue] == 1) {
                
                [_dataArray removeAllObjects];
            }
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                
                BillModel *model = [[BillModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dic];
                
                [_dataArray addObject:model];
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
    
    if (([_index intValue] == 0 && [self.content intValue] == 1) || ([_index intValue] == 1 && [self.content intValue] == 2) ) {
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 41, WIDTH, [self getIsIphoneX:ISIPHONEX] - 52 - 41) style:UITableViewStylePlain];
        
    }else{
    
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 52) style:UITableViewStylePlain];
    }
    
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
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.tableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    BillCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Bill"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"BillCell" owner:self options:nil].lastObject;
    }
    
    BillModel *model = _dataArray[indexPath.row];
    
    if ([_index intValue] == 1) {
        
        if ([self.content intValue] == 0) {
            
            cell.type = @"收到的礼物";
            
        }else if ([self.content intValue] == 1){
        
            cell.type = @"礼物系统赠送";
        
        }else if ([self.content intValue] == 2){
        
            if ([_buttonState intValue] == 1) {
                
                cell.type = @"礼物赠送记录";
                
            }else if ([_buttonState intValue] == 2){
                
                cell.type = @"礼物兑换记录";
                
            }
//            else if([_buttonState intValue] == 3){
//
//                cell.type = @"礼物提现记录";
//            }

        }
        
    }else if ([_index intValue] == 0){
    
        if ([self.content intValue] == 0) {
            
            cell.type = @"充值记录";
            
        }else if ([self.content intValue] == 1){
        
            if ([_buttonState intValue] == 1) {
                
                cell.type = @"充值赠送记录";
                
            }else if ([_buttonState intValue] == 2){
            
                cell.type = @"充值兑换记录";
            
            }
        }
    }else if ([_index intValue] == 2){
    
        if ([self.content intValue] == 0) {
            
            cell.type = @"邮票购买记录";
            
        }else if ([self.content intValue] == 1){
        
            cell.type = @"邮票系统赠送记录";
           
        }else if([self.content intValue] == 2){
        
            cell.type = @"邮票使用记录";
        }

    }
    
    cell.model = model;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 75;
    
}
- (IBAction)giveButtonClick:(UIButton *)sender {
    
    [_chargeGiveButton setTitleColor:CDCOLOR forState:UIControlStateNormal];
    [_chargeExchangeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _buttonState = @"1";
    [self.tableView.mj_header beginRefreshing];
    
    
}
- (IBAction)chargeExchangeButtonClick:(UIButton *)sender {
    
    [_chargeExchangeButton setTitleColor:CDCOLOR forState:UIControlStateNormal];
    [_chargeGiveButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    _buttonState = @"2";
    [self.tableView.mj_header beginRefreshing];

}
//- (IBAction)detailGiveButtonClick:(id)sender {
//
//    [_detailGiveButton setTitleColor:CDCOLOR forState:UIControlStateNormal];
//    [_detailDepositButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [_detailExchangeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    _buttonState = @"1";
//    [self.tableView.mj_header beginRefreshing];
//}
//- (IBAction)detailExchangeButtonClick:(id)sender {
//
//    [_detailGiveButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [_detailDepositButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [_detailExchangeButton setTitleColor:CDCOLOR forState:UIControlStateNormal];
//    _buttonState = @"2";
//    [self.tableView.mj_header beginRefreshing];
//}
//- (IBAction)detailDepositButtonClick:(id)sender {
//
//    [_detailGiveButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [_detailDepositButton setTitleColor:CDCOLOR forState:UIControlStateNormal];
//    [_detailExchangeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    _buttonState = @"3";
//    [self.tableView.mj_header beginRefreshing];
//}

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
