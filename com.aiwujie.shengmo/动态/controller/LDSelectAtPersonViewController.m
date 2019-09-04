//
//  LDSelectAtPersonViewController.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/5/2.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDSelectAtPersonViewController.h"
#import "SelectAtCell.h"
#import "TableModel.h"

@interface LDSelectAtPersonViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic,strong) NSMutableArray * selectArray;

@property (nonatomic,assign) int page;

@end

@implementation LDSelectAtPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"提醒谁看";
    
    _dataArray = [NSMutableArray array];
    
    _selectArray = [NSMutableArray array];
    
    [self createTableView];
    
    [self createButton];
    
    _page = 0;
    
    [self createData:@"1"];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _page++;
        
        [self createData:@"2"];
        
    }];

    
}

-(void)createButton{
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton addTarget:self action:@selector(completeButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)completeButtonOnClick{
    
    NSString *string = [NSString string];
    
    if (_selectArray.count == 0) {
        
        string = @"";
        
        self.block(string, 0);
        
    }else if (_selectArray.count == 1){
    
        string = _selectArray[0];
        
        self.block(string, 1);
        
    }else{
        
        string = _selectArray[0];
        
        for (int i = 1; i < _selectArray.count; i++) {
            
            string = [NSString stringWithFormat:@"%@,%@",string,_selectArray[i]];
        }
        
        self.block(string, _selectArray.count);
        
    }
    

    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)createData:(NSString *)str{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/getFollewingListFilter"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
        
    parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"1",@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        
     //    NSLog(@"%@",role);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
//        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            if (integer == 4001 || integer == 4002) {
                
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
    
            for (NSDictionary *dic in responseObject[@"data"]) {
                
                TableModel *model = [[TableModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dic];
                
                model.select = NO;
                
                [_dataArray addObject:model];
            }
            
            self.tableView.mj_footer.hidden = NO;
            
            [self.tableView reloadData];
            
            [self.tableView.mj_footer endRefreshing];
        }
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
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
    
    _tableView.rowHeight = 88;
    
    [self.view addSubview:_tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    SelectAtCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectAt"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"SelectAtCell" owner:self options:nil].lastObject;

    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    TableModel *model = _dataArray[indexPath.row];
    
    cell.model = model;
    
    if (model.select) {
        
        cell.selectView.image = [UIImage imageNamed:@"shiguanzhu"];
        
    }else{
        
        cell.selectView.image = [UIImage imageNamed:@"kongguanzhu"];
        
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SelectAtCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    TableModel *model = _dataArray[indexPath.row];
    
    NSString *uid = model.uid;
    
    if (model.select) {
        
        [_selectArray removeObject:uid];
        
        cell.selectView.image = [UIImage imageNamed:@"kongguanzhu"];
        
        model.select = NO;
        
    }else{
    
        [_selectArray addObject:uid];
        
        cell.selectView.image = [UIImage imageNamed:@"shiguanzhu"];
        
        model.select = YES;

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
