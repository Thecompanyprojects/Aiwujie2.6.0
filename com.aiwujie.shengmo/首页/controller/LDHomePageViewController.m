//
//  LDHomePageViewController.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/4/26.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDHomePageViewController.h"
#import "CollectCell.h"
#import "CollectModel.h"
#import "TableCell.h"
#import "TableModel.h"
#import "LDOwnInformationViewController.h"
#import "LDLookOrBeLookViewController.h"
#import "LDBulletinViewController.h"
#import "LDStandardViewController.h"
#import "HeaderTabViewController.h"
#import "LDMapViewController.h"
#import "LDSoundControlViewController.h"
#import "LDSearchUserViewController.h"
#import "LDWarnPersonViewController.h"

#define WARNHEIGNT 30
#define OTHERHEIGHT 30

@interface LDHomePageViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,SDCycleScrollViewDelegate,UITextFieldDelegate>

//首页tableview和collectView及数据源
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *collectArray;

@property (nonatomic,strong) NSMutableArray *array;

//状态码
@property (nonatomic,assign) NSInteger integer;

//上方广告路径及详情url
@property (nonatomic,copy) NSString *pathString;
@property (nonatomic,copy) NSString *urlString;
@property (nonatomic,copy) NSString *titleString;

//广告展示的数组数据
@property (nonatomic,strong) NSMutableArray *slideArray;

//分页page
@property (nonatomic,assign) int tablePage;
@property (nonatomic,assign) int collectPage;

//顶部视图
@property (nonatomic,strong) UIImageView *img;
@property (nonatomic,strong) UIView *headView;

//顶部视图搜索框
@property (nonatomic,strong) UITextField *searchTextField;

@end

@implementation LDHomePageViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"] intValue] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"] length] == 0){
        
        if (_collectionView.contentOffset.y == 0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"隐藏置顶附近按钮" object:nil];
            
        }else if(_collectionView.contentOffset.y > 0){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"显示置顶附近按钮" object:nil];
        }

        
    }else{
        
        if (_tableView.contentOffset.y == 0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"隐藏置顶附近按钮" object:nil];
            
        }else if(_tableView.contentOffset.y > 0){
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"显示置顶附近按钮" object:nil];
        }
        
    }

}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    
    return YES;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == _tableView) {
        
        if (scrollView.contentOffset.y > 0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"显示置顶附近按钮" object:nil];
        }
        
        if (scrollView.contentOffset.y == 0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"隐藏置顶附近按钮" object:nil];
        }

    }else if (scrollView == _collectionView){
    
        if (scrollView.contentOffset.y > 0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"显示置顶附近按钮" object:nil];
        }
        
        if (scrollView.contentOffset.y == 0) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"隐藏置顶附近按钮" object:nil];
        }
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _collectArray = [NSMutableArray array];
    
    _dataArray = [NSMutableArray array];
    
    _array = [NSMutableArray array];
    
    _slideArray = [NSMutableArray array];
    
    if ([self.content intValue] == 0) {
        
        //判断是不是有广告栏
        [self createHeaderViewData];
        
    }else{
        
        [self createTableAndCollectView];
    }
   
    //监听确定搜索
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sureScreen) name:@"screen" object:nil];
    
    //切换展示模式
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeModel) name:@"切换模式" object:nil];
    
    //附近榜单确定
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sureToScreen) name:@"附近榜单" object:nil];
    
    //置顶按钮点击监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topButtonClick:) name:@"置顶附近" object:nil];
}

/**
 * 点击置顶按钮的监听
 */
-(void)topButtonClick:(NSNotification *)user{
    
    //NSLog(@"%@,%@",user.userInfo[@"index"],self.content);
    
    if ([user.userInfo[@"index"] isEqualToString:self.content] || [user.userInfo[@"index"] intValue] == [self.content intValue] - 5) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"] intValue] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"] length] == 0){
        
            [_collectionView setContentOffset:CGPointMake(0,0) animated:YES];
            
        }else{
        
            [_tableView setContentOffset:CGPointMake(0,0) animated:YES];
   
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:@"隐藏置顶附近按钮" object:nil];
    }
}

/**
 * 附近榜单确定
 */
-(void)sureToScreen{

    if ([self.content intValue] == 0) {
        
        [self.tableView.mj_header beginRefreshing];
        
        [self.collectionView.mj_header beginRefreshing];
    }
    
}

/**
 * 切换展示模式
 */
-(void)changeModel{

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"] intValue] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"] length] == 0){
        
        self.collectionView.hidden = YES;
        
        self.tableView.hidden = NO;
        
        [self.tableView.mj_header beginRefreshing];

    }else{
        
        self.collectionView.hidden = NO;
        
        self.tableView.hidden = YES;
        
        [self.collectionView.mj_header beginRefreshing];
    }

}

/**
 * 点击了确定搜索后的监听方法
 */
-(void)sureScreen{
    
    if ([self.content intValue] == 1 || [self.content intValue] == 3 || [self.content intValue] == 7) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"] intValue] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"] length] == 0) {
            
            [self.collectionView.mj_header beginRefreshing];
            
        }else{
            
            [self.tableView.mj_header beginRefreshing];
        }

    }
}

/**
 * 判断上方是否有广告栏
 */
-(void)createHeaderViewData{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Other/getSlideMore"];
    
    NSDictionary *parameters = @{@"type":@"1"};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //                        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
           [self createTableAndCollectView];
            
        }else{
            
//            _pathString = responseObject[@"data"][@"path"];
//
//            _urlString = responseObject[@"data"][@"url"];
//
//            _titleString = responseObject[@"data"][@"title"];
            
            [_slideArray addObjectsFromArray:responseObject[@"data"]];
            
            [self createTableAndCollectView];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
       [self createTableAndCollectView];
    }];
}

-(void)createTableAndCollectView{

    [self createCollectionView];
    
    [self createTableView];
     
     self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         
         if ([self.content intValue] == 3) {
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"清除新人红点" object:nil];
             
         }
         
         [[NSNotificationCenter defaultCenter] postNotificationName:@"隐藏置顶附近按钮" object:nil];
        
        _collectPage = 0;
         
        [self createData:_collectPage type:@"1"];
        
    }];
     
     [self.collectionView.mj_header beginRefreshing];
     
     self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _collectPage++;
        
        [self createData:_collectPage type:@"2"];
        
    }];
     
     self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
         
         if ([self.content intValue] == 3) {
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"清除新人红点" object:nil];
         }
         
         [[NSNotificationCenter defaultCenter] postNotificationName:@"隐藏置顶附近按钮" object:nil];
        
        _tablePage = 0;
         
        [self createData:_tablePage type:@"1"];

    }];
     
     [self.tableView.mj_header beginRefreshing];
     
     self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _tablePage++;
        
        [self createData:_tablePage type:@"2"];
        
    }];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"] length] == 0) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"layout"];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"] intValue] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"] length] == 0) {
        
        self.collectionView.hidden = NO;
        
        self.tableView.hidden = YES;
        
    }else{
        
        self.collectionView.hidden = YES;
        
        self.tableView.hidden = NO;
        
    }

}

/**
 * 请求首页数据源
 */
-(void)createData:(int)page type:(NSString *)type{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/index/userListNewth"];
    
    //    NSLog(@"22222");
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"] length] == 0) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"layout"];
        
    }
    
    NSString *age = [NSString string];
    
    NSString *sex = [NSString string];
    
    NSString *sexual = [NSString string];
    
    NSString *role = [NSString string];
    
    NSString *education = [NSString string];
    
    NSString *month = [NSString string];
    
    NSString *online = [NSString string];
    
    NSString *real = [NSString string];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"searchSwitch"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"searchSwitch"] integerValue] == 0) {
        
        age = @"";
        sex = @"";
        sexual = @"";
        role = @"";
        education = @"";
        month = @"";
        online = @"";
        real = @"";
        
    }else{
        
        if ([self.content intValue] == 1 || [self.content intValue] == 3 || [self.content intValue] == 7) {
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sexButton"] length] == 0) {
                
                sex = @"0";
                
            }else{
                
                sex = [[NSUserDefaults standardUserDefaults] objectForKey:@"sexButton"];
                
            }
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sexualButton"] length] == 0) {
                
                sexual = @"0";
                
            }else{
                
                sexual = [[NSUserDefaults standardUserDefaults] objectForKey:@"sexualButton"];
            }
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"roleButton"] length] == 0) {
                
                role = @"0";
                
            }else{
                
                NSArray *roleArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"roleButton"] componentsSeparatedByString:@","];
                
                NSMutableArray *roleOtherArray = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < roleArray.count; i++) {
                    
                    if ([roleArray[i] integerValue] == 0) {
                        
                        [roleOtherArray addObject:@"0"];
                        
                    }else if ([roleArray[i] integerValue] == 1){
                        
                        [roleOtherArray addObject:@"S"];
                        
                    }else if ([roleArray[i] integerValue] == 2){
                        
                        [roleOtherArray addObject:@"M"];
                        
                    }else if ([roleArray[i] integerValue] == 3){
                        
                        [roleOtherArray addObject:@"SM"];
                        
                    }else if ([roleArray[i] integerValue] == 4){
                        
                        [roleOtherArray addObject:@"~"];
                    }
                }
                
                if (roleOtherArray.count == 1) {
                    
                    role = roleOtherArray[0];
                    
                }else if (roleOtherArray.count == 2){
                    
                    role = [NSString stringWithFormat:@"%@,%@",roleOtherArray[0],roleOtherArray[1]];
                    
                }else if (roleOtherArray.count == 3){
                    
                    role = [NSString stringWithFormat:@"%@,%@,%@",roleOtherArray[0],roleOtherArray[1],roleOtherArray[2]];
                    
                }else if (roleOtherArray.count == 4){
                    
                    role = [NSString stringWithFormat:@"%@,%@,%@,%@",roleOtherArray[0],roleOtherArray[1],roleOtherArray[2],roleOtherArray[3]];
                    
                }
            }
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hight"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hight"] integerValue] == 0) {
                
                education = @"";
                
                month = @"";
                
                real = @"";
                
                online = @"";
                
                age = @"";
                
            }else{
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screenEducation"] length] == 0) {
                    
                    education = @"";
                    
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screenEducation"] length] != 0){
                    
                    education = [[NSUserDefaults standardUserDefaults] objectForKey:@"educationRow"];
                    
                }
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screenMonth"] length] == 0) {
                    
                    month = @"";
                    
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screenMonth"] length] != 0){
                    
                    month = [[NSUserDefaults standardUserDefaults] objectForKey:@"monthRow"];
                    
                }
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"authen"] length] == 0) {
                    
                    real = @"";
                    
                }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"authen"] length] != 0){
                    
                    real = [[NSUserDefaults standardUserDefaults] objectForKey:@"authen"];
                }
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"online"] length]== 0) {
                    
                    online = @"";
                    
                }else{
                    
                    online = [[NSUserDefaults standardUserDefaults] objectForKey:@"online"];
                }
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screenAge"] length] != 0) {
                    
                    age = [NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"minAge"],[[NSUserDefaults standardUserDefaults] objectForKey:@"maxAge"]];
                    
                }else{
                    
                    age = @"";
                }
            }

        }else{
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] == 11 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] == 14514 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] == 14518) {
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sexButton"] length] == 0) {
                    
                    sex = @"0";
                    
                }else{
                    
                    sex = [[NSUserDefaults standardUserDefaults] objectForKey:@"sexButton"];
                    
                }
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sexualButton"] length] == 0) {
                    
                    sexual = @"0";
                    
                }else{
                    
                    sexual = [[NSUserDefaults standardUserDefaults] objectForKey:@"sexualButton"];
                }
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"roleButton"] length] == 0) {
                    
                    role = @"0";
                    
                }else{
                    
                    NSArray *roleArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"roleButton"] componentsSeparatedByString:@","];
                    
                    NSMutableArray *roleOtherArray = [[NSMutableArray alloc] init];
                    
                    for (int i = 0; i < roleArray.count; i++) {
                        
                        if ([roleArray[i] integerValue] == 0) {
                            
                            [roleOtherArray addObject:@"0"];
                            
                        }else if ([roleArray[i] integerValue] == 1){
                            
                            [roleOtherArray addObject:@"S"];
                            
                        }else if ([roleArray[i] integerValue] == 2){
                            
                            [roleOtherArray addObject:@"M"];
                            
                        }else if ([roleArray[i] integerValue] == 3){
                            
                            [roleOtherArray addObject:@"SM"];
                            
                        }else if ([roleArray[i] integerValue] == 4){
                            
                            [roleOtherArray addObject:@"~"];
                        }
                    }
                    
                    if (roleOtherArray.count == 1) {
                        
                        role = roleOtherArray[0];
                        
                    }else if (roleOtherArray.count == 2){
                        
                        role = [NSString stringWithFormat:@"%@,%@",roleOtherArray[0],roleOtherArray[1]];
                        
                    }else if (roleOtherArray.count == 3){
                        
                        role = [NSString stringWithFormat:@"%@,%@,%@",roleOtherArray[0],roleOtherArray[1],roleOtherArray[2]];
                        
                    }else if (roleOtherArray.count == 4){
                        
                        role = [NSString stringWithFormat:@"%@,%@,%@,%@",roleOtherArray[0],roleOtherArray[1],roleOtherArray[2],roleOtherArray[3]];
                        
                    }
                }
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hight"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hight"] integerValue] == 0) {
                    
                    education = @"";
                    
                    month = @"";
                    
                    real = @"";
                    
                    online = @"";
                    
                    age = @"";
                    
                }else{
                    
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screenEducation"] length] == 0) {
                        
                        education = @"";
                        
                    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screenEducation"] length] != 0){
                        
                        education = [[NSUserDefaults standardUserDefaults] objectForKey:@"educationRow"];
                        
                    }
                    
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screenMonth"] length] == 0) {
                        
                        month = @"";
                        
                    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screenMonth"] length] != 0){
                        
                        month = [[NSUserDefaults standardUserDefaults] objectForKey:@"monthRow"];
                        
                    }
                    
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"authen"] length] == 0) {
                        
                        real = @"";
                        
                    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"authen"] length] != 0){
                        
                        real = [[NSUserDefaults standardUserDefaults] objectForKey:@"authen"];
                    }
                    
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"online"] length]== 0) {
                        
                        online = @"";
                        
                    }else{
                        
                        online = [[NSUserDefaults standardUserDefaults] objectForKey:@"online"];
                    }
                    
                    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screenAge"] length] != 0) {
                        
                        age = [NSString stringWithFormat:@"%@,%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"minAge"],[[NSUserDefaults standardUserDefaults] objectForKey:@"maxAge"]];
                        
                    }else{
                        
                        age = @"";
                    }
                }
                
            }else{
            
                age = @"";
                sex = @"";
                sexual = @"";
                role = @"";
                education = @"";
                month = @"";
                online = @"";
                real = @"";
                
            }
        }
    }
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        if ([self.content intValue] == 0) {
            
            [_searchTextField resignFirstResponder];
            
            NSString *content = [NSString string];
            
            if (_selectButtonState.length == 0) {
                
                content = @"0";
                
            }else{
            
                content = _selectButtonState;
            }
            
            parameters = @{@"page":[NSString stringWithFormat:@"%d",page],@"layout":[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"],@"type":content,@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"onlinestate":online,@"realname":real,@"age":age,@"sex":sex,@"sexual":sexual,@"role":role,@"culture":education,@"monthly":month};
            
        }else{
        
            parameters = @{@"page":[NSString stringWithFormat:@"%d",page],@"layout":[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"],@"type":self.content,@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"onlinestate":online,@"realname":real,@"age":age,@"sex":sex,@"sexual":sexual,@"role":role,@"culture":education,@"monthly":month};
        }
        
        
    }else{
        
        if ([self.content intValue] == 0) {
            
            [_searchTextField resignFirstResponder];
            
            NSString *content = [NSString string];
            
            if (_selectButtonState.length == 0) {
                
                content = @"0";
                
            }else{
                
                content = _selectButtonState;
            }

            
             parameters = @{@"page":[NSString stringWithFormat:@"%d",page],@"layout":[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"],@"type":content,@"lat":@"",@"lng":@"",@"onlinestate":online,@"realname":real,@"age":age,@"sex":sex,@"sexual":sexual,@"role":role,@"culture":education,@"monthly":month};
            
        }else{
        
             parameters = @{@"page":[NSString stringWithFormat:@"%d",page],@"layout":[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"],@"type":self.content,@"lat":@"",@"lng":@"",@"onlinestate":online,@"realname":real,@"age":age,@"sex":sex,@"sexual":sexual,@"role":role,@"culture":education,@"monthly":month};
        }
 
    }
    
    //NSLog(@"%@",parameters);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        _integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//        NSLog(@"%@",responseObject);
        
        if (_integer != 2000 && _integer != 2001) {
            
            if ([type intValue] == 1 && _integer == 4001) {
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"] intValue] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"] length] == 0) {
                    
                    [_collectArray removeAllObjects];
                    
                    [_array removeAllObjects];
                    
                    [_collectionView reloadData];
                    
                }else{
                    
                    [_dataArray removeAllObjects];
                    
                    [_tableView reloadData];
                }

                
            }else{
            
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            }
            
        }else{
            
            if ([type intValue] == 1) {
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"] intValue] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"] length] == 0) {
                    
                    [_collectArray removeAllObjects];
                    
                    [_array removeAllObjects];
                    
                    
                }else{
                    
                    [_dataArray removeAllObjects];
                }
                
            }
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"] intValue] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"layout"] length] == 0) {
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    
                    CollectModel *model = [[CollectModel alloc] init];
                    
                    [model setValuesForKeysWithDictionary:dic];
                    
                    [_array addObject:model];
                }
                
                [_collectArray removeAllObjects];
                
                [_collectArray addObject:_array];
                
                [self.collectionView reloadData];
                
            }else{
                
                for (NSDictionary *dic in responseObject[@"data"]) {
                    
                    TableModel *model = [[TableModel alloc] init];
                    
                    [model setValuesForKeysWithDictionary:dic];
                    
                    [_dataArray addObject:model];
                }
                
                [self.tableView reloadData];
            }
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
    
}

-(void)createCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 49) collectionViewLayout:layout];
    
    if (@available(iOS 11.0, *)) {
        
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 1, 0);
    
    if ([self.content intValue] == 0) {
        
        [self.collectionView registerClass:[UICollectionReusableView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    }

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
    
    if (_collectArray.count > 0) {
        
        CollectModel *model = _collectArray[indexPath.section][indexPath.row];
        
        cell.integer = _integer;
        
        cell.model = model;
        
    }
    
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if ([self.content intValue] == 0) {
        
        CGFloat viewTopY = 7;

        if (_slideArray.count != 0) {
            
            if (kind == UICollectionElementKindSectionHeader){
                
                UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
                
                [_headView removeFromSuperview];
                
                _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, DYANDNERHEIGHT + OTHERHEIGHT + WARNHEIGNT + ADVERTISEMENT + 2)];
                
                //创建搜索用户,地图找人,声音控的view
                [self createSomeOtherView:ADVERTISEMENT + viewTopY andView:_headView];
                
                //创建富豪榜,魅力榜,粉丝榜的按钮
                [self createListButton:ADVERTISEMENT + OTHERHEIGHT + 10 andView:_headView];
                
                //创建提示的label
                [self createWarnLabelWithOrginY:DYANDNERHEIGHT + OTHERHEIGHT + ADVERTISEMENT andBackView:_headView];
                
                //创建顶部的轮播广告图
                [self createTopScrollPic:_headView];
                
                [headerView addSubview:_headView];
                
                reusableview = headerView;
                
                return reusableview;
                
            }
            
        }else{
            
            if (kind == UICollectionElementKindSectionHeader){
                
                UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
                
                [_headView removeFromSuperview];
                
                _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, DYANDNERHEIGHT + WARNHEIGNT + 2)];
                
                //创建搜索用户,地图找人,声音控的view
                [self createSomeOtherView:viewTopY andView:_headView];
                
                //创建富豪榜,魅力榜,粉丝榜的按钮
                [self createListButton:OTHERHEIGHT + 10 andView:_headView];
                
                //创建提示的label
                [self createWarnLabelWithOrginY:DYANDNERHEIGHT + OTHERHEIGHT andBackView:_headView];
                
                [headerView addSubview:_headView];
                
                reusableview = headerView;
                
                return reusableview;
            }
        }
    }
//    else{
//
//        if (_urlString.length != 0) {
//
//            if (kind == UICollectionElementKindSectionHeader){
//
//                UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
//
//                [_img removeFromSuperview];
//
//                _img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, ADVERTISEMENT)];
//
//                _img.userInteractionEnabled = YES;
//
//                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, ADVERTISEMENT)];
//
//                [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
//
//                [_img addSubview:button];
//
//                UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 25, 5, 20, 20)];
//
//                [deleteButton setBackgroundImage:[UIImage imageNamed:@"删除按钮"] forState:UIControlStateNormal];
//
//                [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
//
//                [_img addSubview:deleteButton];
//
//                [_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_pathString]]];
//
//                [headerView addSubview:_img];
//
//                reusableview = headerView;
//
//            }
//
//        }else{
//
//            if (kind == UICollectionElementKindSectionHeader){
//
//                UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
//
//                [_img removeFromSuperview];
//
//                reusableview = headerView;
//
//            }
//        }
//    }
 
    return nil;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    if ([self.content intValue] == 0) {
        
        if(_slideArray.count != 0){
            
            return CGSizeMake(WIDTH, DYANDNERHEIGHT + OTHERHEIGHT + WARNHEIGNT + ADVERTISEMENT + 2);
        }
        
        return CGSizeMake(WIDTH, DYANDNERHEIGHT + OTHERHEIGHT + WARNHEIGNT + 1);
    }
    
//    if(_urlString.length != 0){
//
//        return CGSizeMake(WIDTH, ADVERTISEMENT + 1);
//    }
    
    return CGSizeZero;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    
    CollectModel *model = _collectArray[indexPath.section][indexPath.row];
    
    ivc.userID = model.uid;
    
    [self.navigationController pushViewController:ivc animated:YES];
}

-(void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 49) style:UITableViewStyleGrouped];
    
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
    
    if (_dataArray.count > 0) {
        
        TableModel *model = _dataArray[indexPath.section];
        
        cell.integer = _integer;
        
        cell.content = [self.content intValue] > 2 ? self.content : nil;
        
        cell.model = model;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 88;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if ([self.content intValue] == 0 && section == 0) {
        
        if(_slideArray.count != 0){
            
            return DYANDNERHEIGHT + WARNHEIGNT + ADVERTISEMENT + OTHERHEIGHT + 2;
        }
        
        return DYANDNERHEIGHT + WARNHEIGNT + OTHERHEIGHT + 2;
    }
    
//    if (_pathString.length != 0 && section == 0) {
//
//        return ADVERTISEMENT + 2;
//    }
    
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView = [[UIView alloc] init];
    
    if ([self.content intValue] == 0  && section == 0) {
        
        CGFloat viewTopY = 7;
        
        if (_slideArray.count != 0) {
            
            UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, DYANDNERHEIGHT + WARNHEIGNT + ADVERTISEMENT + OTHERHEIGHT)];
            
            headView.backgroundColor = [UIColor whiteColor];
            
            [headerView addSubview:headView];
            
            //创建搜索用户,地图找人,声音控的view
            [self createSomeOtherView:ADVERTISEMENT + viewTopY andView:headView];
            
            //创建富豪榜,魅力榜,粉丝榜的按钮
            [self createListButton:ADVERTISEMENT + OTHERHEIGHT + 10 andView:headView];
            
            //创建提示的label
            [self createWarnLabelWithOrginY:DYANDNERHEIGHT + ADVERTISEMENT + OTHERHEIGHT andBackView:headView];
            
            //创建顶部的轮播广告图
            [self createTopScrollPic:headView];
            
            return headerView;
            
        }else{
            
            UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, DYANDNERHEIGHT + WARNHEIGNT + OTHERHEIGHT)];
            
            headView.backgroundColor = [UIColor whiteColor];
            
            [headerView addSubview:headView];
            
            //创建搜索用户,地图找人,声音控的view
            [self createSomeOtherView:viewTopY andView:headView];
            
            //创建富豪榜,魅力榜,粉丝榜的按钮
            [self createListButton:OTHERHEIGHT + 10 andView:headView];
            
            //创建提示的label
            [self createWarnLabelWithOrginY:DYANDNERHEIGHT + OTHERHEIGHT andBackView:headView];
            
            return headerView;
            
        }
        
    }
//    else{
//        
//        if (_pathString.length != 0 && section == 0) {
//            
//            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, ADVERTISEMENT)];
//            
//            [headerView addSubview:view];
//            
//            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, ADVERTISEMENT)];
//            
//            img.userInteractionEnabled = YES;
//            
//            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, ADVERTISEMENT)];
//            
//            [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
//            
//            [img addSubview:button];
//            
//            UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 25, 5, 20, 20)];
//            
//            [deleteButton setBackgroundImage:[UIImage imageNamed:@"删除按钮"] forState:UIControlStateNormal];
//            
//            [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
//            
//            [img addSubview:deleteButton];
//            
//            
//            [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_pathString]]];
//            
//            [view addSubview:img];
//            
//            return headerView;
//            
//        }
//        
//    }
//    
    
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 1;
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

/**
 * 创建顶部的轮播广告图
 */
-(void)createTopScrollPic:(UIView *)mainView{
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, ADVERTISEMENT)];
    
    img.userInteractionEnabled = YES;
    
    NSMutableArray *pathArray = [NSMutableArray array];
    
    for (NSDictionary *dic in _slideArray) {
        
        [pathArray addObject:dic[@"path"]];
        
    }
    
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, ADVERTISEMENT) delegate:self placeholderImage:[UIImage imageNamed:@"动态图片默认"]];
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.imageURLStringsGroup = pathArray;
    cycleScrollView.autoScrollTimeInterval = 3.0;
    [img addSubview:cycleScrollView];
    
    [mainView addSubview:img];
    
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 25, 5, 20, 20)];
    
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"删除按钮"] forState:UIControlStateNormal];
    
    [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [img addSubview:deleteButton];
    
    [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_pathString]]];
}

/**
 * 删除上面的广告
 */
-(void)deleteButtonClick{
    
    [_slideArray removeAllObjects];
    
    [self.collectionView reloadData];
    
    [self.tableView reloadData];
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    if ([_slideArray[index][@"link_type"] intValue] == 0) {
        
        LDBulletinViewController *bvc = [[LDBulletinViewController alloc] init];
        
        bvc.url = _slideArray[index][@"url"];
        
        bvc.title = _slideArray[index][@"title"];
        
        [self.navigationController pushViewController:bvc animated:YES];
        
    }else{
        
        HeaderTabViewController *tvc = [[HeaderTabViewController alloc] init];
        
        tvc.tid = [NSString stringWithFormat:@"%@",_slideArray[index][@"link_id"]];
        
        [self.navigationController pushViewController:tvc animated:YES];
    }
    
}

/**
 * 创建富豪榜,魅力榜,粉丝榜的按钮
 */
-(void)createListButton:(CGFloat)allButtonY andView:(UIView *)mainView{
    
    NSArray *imageName = @[@"首页富豪榜",@"首页魅力榜",@"首页粉丝榜",@"首页警示榜"];
    NSArray *titleName = @[@"富豪榜",@"魅力榜",@"粉丝榜",@"警示榜"];
    
    CGFloat itemW = WIDTH/5;
    CGFloat itemH = DYANDNERHEIGHT;
    CGFloat itemSpace = (WIDTH - itemW * imageName.count)/(imageName.count + 1);
    CGFloat plSpace = 5 * HEIGHTRADIO;
    CGFloat lableH = 20;
    CGFloat topBottomSpace = (itemH - itemW/2 - lableH - plSpace)/2;
    
    for (int i = 0; i < imageName.count; i++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(itemSpace + i * itemW + i * itemSpace, allButtonY, itemW, itemH)];
        [mainView addSubview:view];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((itemW - itemW/2)/2, topBottomSpace, itemW/2, itemW/2)];
        imgView.image = [UIImage imageNamed:imageName[i]];
        [view addSubview:imgView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, topBottomSpace + itemW/2 + plSpace, itemW, lableH)];
        label.tag = 2000 + i;
        label.text = titleName[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        [view addSubview:label];
        
        if ([_selectButtonState intValue] == 5 && i ==0) {
            
            label.textColor = [UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1];
            
        }else if ([_selectButtonState intValue] == 6 && i == 1){
            
            label.textColor = [UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1];
            
        }else if ([_selectButtonState intValue] == 2 && i == 2){
            
            label.textColor = [UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1];
            
        }else{
            
            label.textColor = [UIColor blackColor];
        }
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemW, itemH)];
        button.tag = 1000 + i;
        [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
    }
}

/**
 * 用户点击富豪榜,魅力榜,粉丝榜的点击事件
 */

-(void)titleButtonClick:(UIButton *)button{
    
    if (button.tag == 1000) {
        
        _selectButtonState = @"5";
        
        [self.tableView.mj_header beginRefreshing];
        
        [self.collectionView.mj_header beginRefreshing];
        
    }else if (button.tag == 1001){
        
        _selectButtonState = @"6";
        
        [self.tableView.mj_header beginRefreshing];
        
        [self.collectionView.mj_header beginRefreshing];
        
    }else if (button.tag == 1002){
        
        _selectButtonState = @"2";
        
        [self.tableView.mj_header beginRefreshing];
        
        [self.collectionView.mj_header beginRefreshing];
        
    }else{
        
        LDWarnPersonViewController *warn = [[LDWarnPersonViewController alloc] init];
        
        warn.title = @"警示榜";
        
        [self.navigationController pushViewController:warn animated:YES];
    }
    
}

/**
 * 创建搜索,地图找人,声音控view
 */
-(void)createSomeOtherView:(CGFloat)allViewY andView:(UIView *)mainView{
    
    CGFloat viewSpace = 15;
    CGFloat viewInSpace = 6;
    CGFloat imageW = 13;
    CGFloat imageH = 13;
    CGFloat leftSpace = 10;
    CGFloat rightSpace = 10;
    CGFloat inSpace = 5;
    
    //搜索用户
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    searchView.layer.cornerRadius = OTHERHEIGHT/2;
    searchView.layer.borderWidth = 1;
    searchView.layer.borderColor = [UIColor colorWithHexString:@"#999999" alpha:1].CGColor;
    searchView.clipsToBounds = YES;
    [mainView addSubview:searchView];
    
    //地图找人
    UIView *mapSearchView = [[UIView alloc] init];
    mapSearchView.layer.cornerRadius = OTHERHEIGHT/2;
    mapSearchView.layer.borderWidth = 1;
    mapSearchView.layer.borderColor = [UIColor colorWithHexString:@"#999999" alpha:1].CGColor;
    mapSearchView.clipsToBounds = YES;
    [mainView addSubview:mapSearchView];
    
    UIImageView *mapSearchImage = [[UIImageView alloc] initWithFrame:CGRectMake(leftSpace, (OTHERHEIGHT - imageH)/2, imageW, imageH)];
    mapSearchImage.image = [UIImage imageNamed:@"首页地图找人"];
    [mapSearchView addSubview:mapSearchImage];
    
    UIView *mapSearchLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(mapSearchImage.frame) + inSpace, (OTHERHEIGHT - imageH)/2, 1, imageH)];
    mapSearchLine.backgroundColor = [UIColor colorWithHexString:@"#999999" alpha:1];
    [mapSearchView addSubview:mapSearchLine];
    
    UILabel *mapSearchLabel = [[UILabel alloc] init];
    mapSearchLabel.text = @"地图找人";
    mapSearchLabel.textColor = [UIColor colorWithHexString:@"#999999" alpha:1];
    mapSearchLabel.font = [UIFont systemFontOfSize:12];
    [mapSearchLabel sizeToFit];
    mapSearchLabel.frame = CGRectMake(CGRectGetMaxX(mapSearchLine.frame) + inSpace, (OTHERHEIGHT - imageH)/2, mapSearchLabel.frame.size.width, imageH);
    [mapSearchView addSubview:mapSearchLabel];
    
    //声音控
    UIView *soundView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(mapSearchView.frame) + viewInSpace, allViewY, 80, OTHERHEIGHT)];
    soundView.layer.cornerRadius = OTHERHEIGHT/2;
    soundView.layer.borderWidth = 1;
    soundView.layer.borderColor = [UIColor colorWithHexString:@"#999999" alpha:1].CGColor;
    soundView.clipsToBounds = YES;
    [mainView addSubview:soundView];
    
    UIImageView *soundImage = [[UIImageView alloc] initWithFrame:CGRectMake(leftSpace, (OTHERHEIGHT - imageH)/2, imageW, imageH)];
    soundImage.image = [UIImage imageNamed:@"声音控"];
    [soundView addSubview:soundImage];
    
    UIView *soundLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(soundImage.frame) + inSpace, (OTHERHEIGHT - imageH)/2, 1, imageH)];
    soundLine.backgroundColor = [UIColor colorWithHexString:@"#999999" alpha:1];
    [soundView addSubview:soundLine];
    
    UILabel *soundLabel = [[UILabel alloc] init];
    soundLabel.text = @"声音控";
    soundLabel.textColor = [UIColor colorWithHexString:@"#999999" alpha:1];
    soundLabel.font = [UIFont systemFontOfSize:12];
    [soundLabel sizeToFit];
    soundLabel.frame = CGRectMake(CGRectGetMaxX(soundLine.frame) + inSpace, (OTHERHEIGHT - imageH)/2, soundLabel.frame.size.width, imageH);
    [soundView addSubview:soundLabel];
    
    //搜索框的frame
    searchView.frame = CGRectMake(viewSpace,allViewY, WIDTH - 2 * viewSpace - 2 * viewInSpace - CGRectGetMaxX(mapSearchLabel.frame) - rightSpace - CGRectGetMaxX(soundLabel.frame) - rightSpace, OTHERHEIGHT);
    
    //地图找人的frame
    mapSearchView.frame = CGRectMake(CGRectGetMaxX(searchView.frame) + viewInSpace, allViewY, CGRectGetMaxX(mapSearchLabel.frame) + rightSpace, OTHERHEIGHT);
    
    //地图找人的按钮点击
    UIButton *mapSearchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, mapSearchView.frame.size.width,mapSearchView.frame.size.height)];
    [mapSearchButton addTarget:self action:@selector(mapSearchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [mapSearchView addSubview:mapSearchButton];
    
    //声音控的frame
    soundView.frame = CGRectMake(CGRectGetMaxX(mapSearchView.frame) + viewInSpace, allViewY, CGRectGetMaxX(soundLabel.frame) + rightSpace, OTHERHEIGHT);
    
    //声音控的按钮点击
    UIButton *soundButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, soundView.frame.size.width,soundView.frame.size.height)];
    [soundButton addTarget:self action:@selector(soundButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [soundView addSubview:soundButton];
    
    //搜索框的内部控件
    UILabel *searchLabel = [[UILabel alloc] init];
    searchLabel.text = @"搜索";
    searchLabel.textColor = [UIColor colorWithHexString:@"#999999" alpha:1];
    searchLabel.font = [UIFont systemFontOfSize:12];
    [searchLabel sizeToFit];
    searchLabel.frame = CGRectMake(searchView.frame.size.width - rightSpace - searchLabel.frame.size.width, (OTHERHEIGHT - imageH)/2, searchLabel.frame.size.width, imageH);
    [searchView addSubview:searchLabel];
    
    UIView *searchLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(searchLabel.frame) - inSpace - 1, (OTHERHEIGHT - imageH)/2, 1, imageH)];
    searchLine.backgroundColor = [UIColor colorWithHexString:@"#999999" alpha:1];
    [searchView addSubview:searchLine];
    
    UIImageView *searchImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(searchLine.frame) - inSpace - imageW, (OTHERHEIGHT - imageH)/2, imageW, imageH)];
    searchImage.image = [UIImage imageNamed:@"输入框搜索"];
    [searchView addSubview:searchImage];
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(searchImage.frame), 0, searchView.frame.size.width - CGRectGetMinX(searchImage.frame), OTHERHEIGHT)];
    [searchButton addTarget:self action:@selector(SearchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchButton];
    
    
    if (_searchTextField != nil) {
        
        _searchTextField = nil;
    }
    
    _searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(leftSpace, (OTHERHEIGHT - imageH)/2, CGRectGetMinX(searchImage.frame) - leftSpace - inSpace, imageH)];
    _searchTextField.font = [UIFont systemFontOfSize:12];
    _searchTextField.delegate = self;
    _searchTextField.returnKeyType = UIReturnKeySearch;
    _searchTextField.textAlignment = NSTextAlignmentLeft;
    _searchTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [searchView addSubview:_searchTextField];
}

-(void)SearchButtonClick{
    
    if (_searchTextField.text.length == 0) {
        
        [_searchTextField resignFirstResponder];
        
    }else{
        
        [_searchTextField resignFirstResponder];
        
        LDSearchUserViewController *svc = [[LDSearchUserViewController alloc] init];
        
        svc.searchString = _searchTextField.text;
        
        [self.navigationController pushViewController:svc animated:YES];
    }

}

#pragma textField的代理方法

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.text.length == 0) {
        
        [textField resignFirstResponder];
        
    }else{
        
        [textField resignFirstResponder];
        
        LDSearchUserViewController *svc = [[LDSearchUserViewController alloc] init];
        
        svc.searchString = textField.text;
        
        [self.navigationController pushViewController:svc animated:YES];
    }

    return YES;
}

-(void)mapSearchButtonClick{
    
    LDMapViewController *mvc = [[LDMapViewController alloc] init];
    
    [self.navigationController pushViewController:mvc animated:YES];
}

-(void)soundButtonClick{
    
    LDSoundControlViewController *svc = [[LDSoundControlViewController alloc] init];
    
    [self.navigationController pushViewController:svc animated:YES];
    
}

/**
 * 创建提示的label
 */
-(void)createWarnLabelWithOrginY:(CGFloat)labelY andBackView:(UIView *)headView{
    
    UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, labelY, WIDTH, WARNHEIGNT)];
    
    warnLabel.backgroundColor = [UIColor whiteColor];
    
    if ([_selectButtonState intValue] == 5 ) {
        
        warnLabel.text = @"【富豪榜】充值最多者排名最前";
        
    }else if ([_selectButtonState intValue] == 6){
        
        warnLabel.text = @"【魅力榜】获赏最多者排名最前";
        
    }else if ([_selectButtonState intValue] == 2){
        
        warnLabel.text = @"【粉丝榜】粉丝最多者排名最前";
        
    }else{
        
        warnLabel.text = @"排序:推荐←年SVIP←SVIP←年VIP←VIP←认证";
    }
    
    warnLabel.textColor = [UIColor lightGrayColor];
    
    warnLabel.font = [UIFont systemFontOfSize:13];
    
    warnLabel.userInteractionEnabled = YES;
    
    warnLabel.textAlignment = NSTextAlignmentCenter;
    
    [headView addSubview:warnLabel];
    
    UIButton *warnButton = [[UIButton alloc] initWithFrame:warnLabel.bounds];
    [warnButton addTarget:self action:@selector(warnButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [warnLabel addSubview:warnButton];
    
}
/**
 * 提示语可点击
 */
-(void)warnButtonClick{
    
    LDStandardViewController *svc = [[LDStandardViewController alloc] init];
    
    svc.navigationItem.title = @"用户排名规则";
    
    svc.state = @"排名规则";
    
    [self.navigationController pushViewController:svc animated:YES];
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
