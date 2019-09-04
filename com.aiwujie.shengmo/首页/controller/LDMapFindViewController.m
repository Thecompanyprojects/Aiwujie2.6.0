//
//  LDMapFindViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/25.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDMapFindViewController.h"
#import "CollectCell.h"
#import "CollectModel.h"
#import "LDBulletinViewController.h"
#import "LDOwnInformationViewController.h"

@interface LDMapFindViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *collectArray;

@property (nonatomic,strong) NSMutableArray *array;

@property (nonatomic,strong) NSMutableArray *storageArray;

@property (nonatomic,assign) int page;

@property (nonatomic,assign) NSInteger integer;

@property (nonatomic,copy) NSString *pathString;

@property (nonatomic,copy) NSString *urlString;

@property (nonatomic,copy) NSString *titleString;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationViewBottomY;

@property (nonatomic,strong) UIImageView *img;

@end

@implementation LDMapFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"地图找人";
    
    if (ISIPHONEX) {
        
        self.locationViewBottomY.constant = IPHONEXBOTTOMH;
    }
    
    self.locationLabel.text = self.location;
    
    _collectArray = [NSMutableArray array];
    
    _storageArray = [NSMutableArray array];
    
    _array = [NSMutableArray array];
    
    [self createCollectionView];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _page = 0;
        
        [self createData:@"1"];
        
    }];
    
    [self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _page++;
        
        [self createData:@"2"];
        
    }];
    
    
}

//地图找人
-(void)createData:(NSString *)str{
        
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/index/searchByMapNew"];
        
        NSDictionary *parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"lat":[NSString stringWithFormat:@"%lf",self.lat],@"lng":[NSString stringWithFormat:@"%lf",self.lng]};
        
        
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            _integer = [[responseObject objectForKey:@"retcode"] integerValue];
            
//            NSLog(@"%@",responseObject);
            
            if (_integer != 2000 && _integer != 2001) {
                
//                [_collectArray addObject:_storageArray];
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                
            }else{
                
                if ([str intValue] == 1) {
                    
                    [_collectArray removeAllObjects];
                    
                    [_array removeAllObjects];
                }
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    
                    CollectModel *model = [[CollectModel alloc] init];
                    
                    [model setValuesForKeysWithDictionary:dic];
                    
                    [_array addObject:model];
                }
                
                [_collectArray removeAllObjects];
                
                [_collectArray addObject:_array];
                    
                [self.collectionView reloadData];
                
            }
            
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            
            NSLog(@"%@",error);
            
        }];
        
    }


-(void)createCollectionView{
        
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 44) collectionViewLayout:layout];
        
    if (@available(iOS 11.0, *)) {
        
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
        
    self.collectionView.backgroundColor = [UIColor whiteColor];
        
//    self.collectionView.contentInset = UIEdgeInsetsMake(1.5, 0, 0, 0);
    
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    if (HEIGHT == 667){
        
        //设置每个item的大小
        layout.itemSize = CGSizeMake((int)(WIDTH - 2)/3,(int)(WIDTH - 2)/3);
        
        // 设置最小行间距
        layout.minimumLineSpacing = 1;
        
        // 设置垂直间距
        layout.minimumInteritemSpacing = 1;
        
    }else{
        
        //设置每个item的大小
        layout.itemSize = CGSizeMake((WIDTH - 2)/3,(WIDTH - 2)/3);
        
        // 设置最小行间距
        layout.minimumLineSpacing = 1;
        
        // 设置垂直间距
        layout.minimumInteritemSpacing = 1;
        
    }
        
    self.collectionView.alwaysBounceVertical = YES;
        
    self.collectionView.delegate =  self;
        
    self.collectionView.dataSource = self;
        
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectCell" bundle:nil] forCellWithReuseIdentifier:@"Collect"];
        
    [self.view addSubview:self.collectionView];
}
    
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
        
    return _collectArray.count;
}
    
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
        
    return [_collectArray[section] count];
}
    
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        
    CollectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Collect" forIndexPath:indexPath];
        
    if (!cell) {
            
        cell = [[NSBundle mainBundle] loadNibNamed:@"CollectCell" owner:self options:nil].lastObject;
    }
        
    CollectModel *model = _collectArray[indexPath.section][indexPath.row];
    
    cell.integer = _integer;
        
    cell.model = model;
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    
    CollectModel *model = _collectArray[indexPath.section][indexPath.row];
    
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
