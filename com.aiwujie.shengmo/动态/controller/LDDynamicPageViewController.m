//
//  LDDynamicPageViewController.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/4/28.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDDynamicPageViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "LDOwnInformationViewController.h"
#import "LDDynamicDetailViewController.h"
#import "LDBulletinViewController.h"
#import "LDChargeCenterViewController.h"
#import "LDMyWalletPageViewController.h"
#import "LDMemberViewController.h"
#import "LDCertificateViewController.h"
#import "TopicCell.h"
#import "TopicModel.h"
#import "DynamicModel.h"
#import "DynamicCell.h"
#import "LDRewardRankingViewController.h"
#import "LDMoreTopicViewController.h"
#import "LDGetListViewController.h"
#import "LDPopularityRankingViewController.h"
#import "HeaderTabViewController.h"

@interface LDDynamicPageViewController ()<UITableViewDelegate,UITableViewDataSource,DynamicDelegate,UIScrollViewDelegate,YBAttributeTapActionDelegate,SDCycleScrollViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,assign) int page;
@property (nonatomic,assign) NSInteger integer;

@property (nonatomic,strong) NSArray *picArray;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) DynamicModel *model;
@property (nonatomic,strong) DynamicCell *cell;
@property(nonatomic,strong) NSMutableArray *sectionArray;

//动态未读消息
@property (strong, nonatomic) UILabel *unreadLabel;

//动态没有查看权限的view
@property (strong, nonatomic) UIView *noLookView;

//动态好友没有动态的view
@property (strong, nonatomic) UIView *friendNoLookView;

//广告展示的数组数据
@property (nonatomic,strong) NSMutableArray *slideArray;

//话题数组
@property (strong, nonatomic) NSMutableArray *topicArray;

//保存tableview的偏移量
@property (nonatomic,assign) CGFloat lastScrollOffset;

//礼物界面
@property (nonatomic,strong) GifView *gif;

@end

@implementation LDDynamicPageViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    if ([self.content intValue] == 0) {
        
        //获取动态有几条未读消息
        [self createUnreadData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recieveClick) name:@"消息接收" object:nil];
    }
    
    if (_tableView.contentOffset.y == 0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"隐藏置顶按钮" object:nil];
        
    }else if(_tableView.contentOffset.y > 0){
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"显示置顶按钮" object:nil];
    }
}

//获取动态有几条未读消息
-(void)createUnreadData{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Dynamic/getUnreadNum"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    NSString *uid = [NSString string];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] length] == 0) {
        
        uid = @"";
        
    }else{
    
        uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    }
    
    parameters = @{@"uid":uid,@"type":@"1"};
    //    NSLog(@"%@",role);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
        //NSLog(@"%@",responseObject);
        
        if (integer == 2000){
            
            //NSLog(@"%@",mvc.tabBar.items);
            
            NSInteger badge = [responseObject[@"data"][@"allnum"] integerValue] + [[[NSUserDefaults standardUserDefaults] objectForKey:@"atPerson"] count];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (badge <= 0) {
                    
                    self.unreadLabel.hidden = YES;
                    
                }else{
                    
                    self.unreadLabel.hidden = NO;

                }
            });
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

//消息接受监听
-(void)recieveClick{
    
    [self createUnreadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _dataArray = [NSMutableArray array];
    
    _sectionArray = [NSMutableArray array];
    
    _topicArray = [NSMutableArray array];
    
    _slideArray = [NSMutableArray array];
    
    if ([self.content intValue] == 0) {
        
        [self createTopicData];
        
    }
    
    if ([self.content intValue] >= 3) {
        
        [self createTableView];
        
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            _page = 0;
            
            [self createDatatype:@"1"];
            
        }];
        
        [self.tableView.mj_header beginRefreshing];
        
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            _page++;
            
            [self createDatatype:@"2"];
            
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topButtonClick:) name:@"置顶动态" object:nil];
        
        self.lastScrollOffset = 0;
        
    }else{
        
        //请求数据
        [self compeleteDataRepuest];
    }
}

/**
 * 创建话题页的数据请求
 */
- (void)createDatatype:(NSString *)type {
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"api/dynamic/getTopicList"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if ([self.content intValue] == 3) {
        
        parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"1",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        
    }else{
        
        parameters = @{@"page":[NSString stringWithFormat:@"%d",_page],@"type":@"0",@"pid":[NSString stringWithFormat:@"%d",[self.content intValue] - 3],@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    }
    
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//        NSLog(@"%@",responseObject);
        
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
                
                TopicModel *model = [[TopicModel alloc] init];
                
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

//热帖和广场判断本人不是认证会员和会员的时候展示提示开通或认证的界面搭建
-(void)createVipAndRealnameView{

    _noLookView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 108)];
    _noLookView.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:_noLookView];
    
    UIImageView *lockImageView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - WIDTH/8)/2, (HEIGHT - WIDTH/8 - 230)/2, WIDTH/8, WIDTH/8 + 5)];
    lockImageView.image = [UIImage imageNamed:@"动态锁"];
    [_noLookView addSubview:lockImageView];
    
    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"仅限VIP会员可见"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, [@"仅限VIP会员可见" length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1] range:NSMakeRange(2, 5)];
//    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1] range:NSMakeRange(7, 5)];
    
    UILabel *warnLabel = [[UILabel alloc] init];
    warnLabel.attributedText = attributedString;
    [warnLabel sizeToFit];
    warnLabel.frame = CGRectMake((WIDTH -  warnLabel.frame.size.width - 40)/2, CGRectGetMaxY(lockImageView.frame) + 20, warnLabel.frame.size.width + 40, 30);
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    warnLabel.layer.cornerRadius = 15;
    warnLabel.clipsToBounds = YES;
     [_noLookView addSubview:warnLabel];
    
    [warnLabel yb_addAttributeTapActionWithStrings:@[@"VIP会员"] delegate:self];
    
    warnLabel.enabledTapEffect = NO;
    
}

//点击文字跳转的代理
- (void)yb_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index
{

    if ([string isEqualToString:@"认证会员"]) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"realname"] intValue] == 1) {
            
            LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
            
            cvc.type = @"2";
            
            [self.navigationController pushViewController:cvc animated:YES];
            
        }else{
            
            AFHTTPSessionManager *manager = [LDAFManager sharedManager];
            
            NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Other/getidstate"];
            
            NSDictionary *parameters = [NSDictionary dictionary];
            
            parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
            [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
                
                //        NSLog(@"%@",responseObject);
                
                if (integer == 2000) {
                    
                    LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
                    
                    cvc.type = @"2";
                    
                    [self.navigationController pushViewController:cvc animated:YES];
                    
                }else if(integer == 2001){
                    
                     [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"正在审核,请耐心等待~"];
                    
                    
                }else if (integer == 2002){
                    
                    LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
                    
                    cvc.where = @"4";
                    
                    [self.navigationController pushViewController:cvc animated:YES];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                NSLog(@"%@",error);
                
            }];
            
        }

        
    }else if([string isEqualToString:@"VIP会员"]){
    
        LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
        
        [self.navigationController pushViewController:mvc animated:YES];
    }
    
}

//用于请求数据,添加监听
-(void)compeleteDataRepuest{
    
    if ([self.content intValue] == 0) {
        
        [self createHeaderViewData];
        
    }else{
        
        [self createTableViewAndRefresh];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topButtonClick:) name:@"置顶动态" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dynamicScreenButtonClick) name:@"确定动态筛选" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rewardSuccess:) name:@"打赏成功" object:nil];
    
    //起始偏移量为0
    self.lastScrollOffset = 0;
    
}

/**
 * 获取推荐页的话题
 */
-(void)createTopicData{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"api/dynamic/getTopicDyHead"];
    
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//        NSLog(@"%@",responseObject);
        
        if (integer == 4000) {
            
            [_topicArray removeAllObjects];
            
        }else{
            
            if (_topicArray.count != 0) {
                
                [_topicArray removeAllObjects];
            }
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                
                [_topicArray addObject:dic];
                
            }
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

//监听打赏成功
-(void)rewardSuccess:(NSNotification *)user{
    
    if (_dataArray.count >= [user.userInfo[@"section"] integerValue] + 1){
    
        DynamicModel *model = _dataArray[[user.userInfo[@"section"] integerValue]];
        
        model.rewardnum = [NSString stringWithFormat:@"%d",[model.rewardnum intValue] + 1];
        
        [_dataArray replaceObjectAtIndex:[user.userInfo[@"section"] integerValue] withObject:model];
        
        _cell.rewardLabel.text = [NSString stringWithFormat:@"%@",model.rewardnum];

    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    // 获取开始拖拽时tableview偏移量
    self.lastScrollOffset = self.tableView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.tableView) {
        
        if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y + HEIGHT < self.tableView.contentSize.height) {
            
            CGFloat y = scrollView.contentOffset.y;
            
            if (y >= self.lastScrollOffset) {
                //用户往上拖动，也就是屏幕内容向下滚动
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"发布动态按钮隐藏" object:nil];
                
            } else if(y < self.lastScrollOffset){
                //用户往下拖动，也就是屏幕内容向上滚动
            
                [[NSNotificationCenter defaultCenter] postNotificationName:@"发布动态按钮显示" object:nil];
            }
            
        }else{
            
            if (self.lastScrollOffset == 0) {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"发布动态按钮显示" object:nil];
                
            }
        }
    }
}


//确定动态筛选的按钮
-(void)dynamicScreenButtonClick{

    if ([self.content intValue] == 1) {
        
        [self.tableView.mj_header beginRefreshing];
    }
}

//点击置顶按钮的监听
-(void)topButtonClick:(NSNotification *)user{
    
    if ([user.userInfo[@"index"] isEqualToString:self.content]) {
        
        [_tableView setContentOffset:CGPointMake(0,0) animated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"隐藏置顶按钮" object:nil];
    }
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{

    return YES;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if (scrollView.contentOffset.y > 0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"显示置顶按钮" object:nil];
    }
    
    if (_tableView.contentOffset.y == 0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"隐藏置顶按钮" object:nil];
    }
}


-(void)createHeaderViewData{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Other/getSlideMore"];
    
    NSDictionary *parameters = @{@"type":@"2"};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
           [self createTableViewAndRefresh];
            
        }else{
            
            [_slideArray addObjectsFromArray:responseObject[@"data"]];
            
            [self createTableViewAndRefresh];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self createTableViewAndRefresh];
       
    }];
}

-(void)createTableViewAndRefresh{

    [self createTableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if ([self.content intValue] == 1) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"清除最新红点" object:nil];
            
        }else if ([self.content intValue] == 2){
        
            [[NSNotificationCenter defaultCenter] postNotificationName:@"清除关注红点" object:nil];
            
        }else if ([self.content intValue] == 0){
        
            [[NSNotificationCenter defaultCenter] postNotificationName:@"清除推荐红点" object:nil];
        }
//        
//        _page = 0;
//        
//        [self createDataType:@"1"];
        
        if ([self.content intValue] == 0) {
            
            //获取推荐页的话题
            [self createTopicData];
            
        }
        
        if ([self.content intValue] == 1) {
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1) {
                
                _page = 0;
                
                [self createDataType:@"1"];
                
            }else{
                
                [_dataArray removeAllObjects];
                
                [self.tableView reloadData];
                
                [self.tableView.mj_header endRefreshing];
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                
                if (_noLookView == nil) {
                    
                    [self createVipAndRealnameView];
                }
            }

        }else{
        
            _page = 0;
            
            [self createDataType:@"1"];
        }
 
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        _page++;
        
        [self createDataType:@"2"];
        
    }];
  
}


-(void)createDataType:(NSString *)type{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString string];
    
    url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Dynamic/getDynamicListNewFive"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if ([self.content intValue] == 1) {
        
        //判定动态筛选是否开启
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"动态筛选"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"动态筛选"] intValue] == 0) {
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
                
                if ([self.content intValue] != 1) {
                    
                    NSString *firsttime = [NSString string];
                    
                    if (_page == 0) {
                        
                        firsttime = @"0";
                        
                    }else{
                        
                        if (_dataArray.count > 0) {
                            
                            firsttime = [_dataArray[0] commenttime];
                            
                        }else{
                            
                            firsttime = @"0";
                        }
                    }
                    
                    parameters = @{@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"firsttime":firsttime,@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
                    
                }else{
                    
                    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"type":[NSString stringWithFormat:@"%d",[self.content intValue]],@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
                    
                }
                
            }else{
                
                if ([self.content intValue] != 1) {
                    
                    NSString *firsttime = [NSString string];
                    
                    if (_page == 0) {
                        
                        firsttime = @"0";
                        
                    }else{
                        
                        if (_dataArray.count > 0) {
                            
                            firsttime = [_dataArray[0] commenttime];
                            
                        }else{
                            
                            firsttime = @"0";
                        }
                    }
                    
                    parameters = @{@"lat":@"",@"lng":@"",@"firsttime":firsttime,@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
                    
                }else{
                    
                    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":@"",@"lng":@"",@"type":[NSString stringWithFormat:@"%d",[self.content intValue]],@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
                    
                    
                }
                
            }
            
        }else{
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
                
                if ([self.content intValue] != 1) {
                    
                    NSString *firsttime = [NSString string];
                    
                    if (_page == 0) {
                        
                        firsttime = @"0";
                        
                    }else{
                        
                        if (_dataArray.count > 0) {
                            
                            firsttime = [_dataArray[0] commenttime];
                            
                        }else{
                            
                            firsttime = @"0";
                        }
                    }
                    
                    //                    NSLog(@"%@",firsttime);
                    
                    parameters = @{@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"firsttime":firsttime,@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"sex":[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSex"],@"sexual":[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSexual"]};
                    
                }else{
                    
                    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"type":[NSString stringWithFormat:@"%d",[self.content intValue]],@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"sex":[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSex"],@"sexual":[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSexual"]};
                    
                    
                }
            }else{
                
                if ([self.content intValue] != 1) {
                    
                    NSString *firsttime = [NSString string];
                    
                    if (_page == 0) {
                        
                        firsttime = @"0";
                        
                    }else{
                        
                        if (_dataArray.count > 0) {
                            
                            firsttime = [_dataArray[0] commenttime];
                            
                        }else{
                            
                            firsttime = @"0";
                        }
                    }
                    
                    parameters = @{@"lat":@"",@"lng":@"",@"firsttime":firsttime,@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"sex":[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSex"],@"sexual":[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSexual"]};
                    
                }else{
                    
                    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":@"",@"lng":@"",@"type":[NSString stringWithFormat:@"%d",[self.content intValue]],@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"sex":[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSex"],@"sexual":[[NSUserDefaults standardUserDefaults] objectForKey:@"dynamicSexual"]};
                    
                    
                }
            }
        }
        
    }else{
        
        NSString *content = [NSString string];
        
        if ([self.content intValue] == 0) {
            
            content = @"0";
            
        }else{
            
//            content = [NSString stringWithFormat:@"%d",[self.content intValue] - 1];
            
            content = [NSString stringWithFormat:@"%d",[self.content intValue]];
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
            
            parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"type":content,@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
        }else{
            
            parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":@"",@"lng":@"",@"type":content,@"page":[NSString stringWithFormat:@"%d",_page],@"loginuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        }
    }


    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        _integer = [[responseObject objectForKey:@"retcode"] intValue];
        
//        NSLog(@"%@",responseObject);
        
        if (_integer != 2000 && _integer != 2001) {
            
            if (_integer == 4001) {
                
                if ([type intValue] == 1) {
                    
                    [_dataArray removeAllObjects];
                    
                    [self.tableView reloadData];
                    
                }
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];

            }else{
                
                if ([self.content intValue] == 2 && (_integer == 4344 || _integer == 4343)) {
                    
                    [_dataArray removeAllObjects];
                    
                    [self.tableView reloadData];
                    
                    [self.tableView.mj_header endRefreshing];
                    
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                    if (_friendNoLookView == nil) {
                        
                          [self createFriendNoDynamicView];
                    }

                }else{
                    
                    [self.tableView.mj_footer endRefreshing];
                    
                     [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                }
            }
            
        }else{
            
            if ([type intValue] == 1) {
                
                [_dataArray removeAllObjects];
            }
            
            if (_friendNoLookView != nil) {
                
                [_friendNoLookView removeFromSuperview];
            }
            
            if (_noLookView != nil) {
                
                [_noLookView removeFromSuperview];
            }
            
            for (NSDictionary *dic in responseObject[@"data"]) {
                
                DynamicModel *model = [[DynamicModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dic];
                
                [_dataArray addObject:model];
            }
            
            [self.tableView reloadData];
            
            [self.tableView.mj_footer endRefreshing];
        }
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        NSLog(@"%@",error);
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

//当好友没有动态的时候创建
-(void)createFriendNoDynamicView{

    _friendNoLookView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _friendNoLookView.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:_friendNoLookView];
    
    UIImageView *lockImageView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - WIDTH/5)/2, (HEIGHT - WIDTH/5 - 230)/2, WIDTH/5, WIDTH/5)];
    lockImageView.image = [UIImage imageNamed:@"好友无动态"];
    [_friendNoLookView addSubview:lockImageView];
    
    UILabel *warnLabel = [[UILabel alloc] init];
    warnLabel.text = @"没有好友或好友未发布动态~";
    [warnLabel sizeToFit];
    warnLabel.font = [UIFont systemFontOfSize:15];
    warnLabel.frame = CGRectMake((WIDTH -  warnLabel.frame.size.width - 40)/2, CGRectGetMaxY(lockImageView.frame) + 20, warnLabel.frame.size.width + 40, 30);
    warnLabel.textAlignment = NSTextAlignmentCenter;
    warnLabel.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    warnLabel.layer.cornerRadius = 15;
    warnLabel.clipsToBounds = YES;
    [_friendNoLookView addSubview:warnLabel];
}

-(void)createTableView{
    
    if ([self.content intValue] >= 3) {
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 49 - 40) style:UITableViewStyleGrouped];
        
    }else{
        
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 49) style:UITableViewStyleGrouped];
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
    
    //    self.tableView.fd_debugLogEnabled = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DynamicCell" bundle:nil] forCellReuseIdentifier:@"DynamicCell"];
    
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
    
    if ([self.content intValue] >= 3) {
        
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
    
    DynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicCell" forIndexPath:indexPath];
    
    cell.delegate = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.integer = _integer;
    
    cell.indexPath = indexPath;
    
    [_sectionArray addObject:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    [cell.zanButton addTarget:self action:@selector(zanButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.rewardButton addTarget:self action:@selector(rewardButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.headButton addTarget:self action:@selector(headButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}


- (void)configureCell:(DynamicCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
        
    DynamicModel *model = _dataArray[indexPath.section];
        
    cell.model = model;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.content intValue] >= 3) {
        
        return 85;
    }
    
    return [tableView fd_heightForCellWithIdentifier:@"DynamicCell" cacheByIndexPath:indexPath configuration:^(DynamicCell *cell) {
        
        [self configureCell:cell atIndexPath:indexPath];
        
    }];
    
}

//点击动态头像
-(void)headButtonClick:(UIButton *)button{
    
    DynamicCell *cell = (DynamicCell *)button.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    DynamicModel *model = _dataArray[indexPath.section];
    
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    
    ivc.userID = model.uid;
    
    [self.navigationController pushViewController:ivc animated:YES];
}

#pragma 点击文字的danamicDelegate
-(void)transmitClickModel:(DynamicModel *)model{

    HeaderTabViewController *tvc = [[HeaderTabViewController alloc] init];
    
    tvc.tid = [NSString stringWithFormat:@"%@",model.tid];
    
    [self.navigationController pushViewController:tvc animated:YES];
}

#pragma 点击图片看大图danamicDelegate
-(void)tap:(UITapGestureRecognizer *)tap{
    
    UIImageView *img = (UIImageView *)tap.view;
    
    __weak typeof(self) weakSelf=self;
    
    [ImageBrowserViewController show:self type:PhotoBroswerVCTypeModal index:img.tag - img.tag/100 * 100 imagesBlock:^NSArray *{
        
        DynamicModel *model = _dataArray[img.tag/100];
        
        if (model.sypic.count == 0) {
            
            _picArray = model.pic;
            
        }else{
            
            _picArray = model.sypic;
            
        }
        
        return weakSelf.picArray;
    }];
    
    
}

//点击动态评论按钮
-(void)commentButtonClick:(UIButton *)button{
    
    DynamicCell *cell = (DynamicCell *)button.superview.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    DynamicModel *model = _dataArray[indexPath.section];
    
    LDDynamicDetailViewController *dvc = [[LDDynamicDetailViewController alloc] init];
    
    dvc.did = model.did;
    
    dvc.ownUid = model.uid;
    
    _indexPath = indexPath;
    
    dvc.clickState = @"comment";
    
    [self.navigationController pushViewController:dvc animated:YES];
}

//点击动态打赏按钮
-(void)rewardButtonClick:(UIButton *)button{
    
    DynamicCell *cell = (DynamicCell *)button.superview.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    DynamicModel *model = _dataArray[indexPath.section];
    
    _cell = cell;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] == [model.uid intValue]) {
        
         [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"不能对自己打赏~"];
        
        
    }else{
        
        _gif = [[GifView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) :^{
        
            LDMyWalletPageViewController *cvc = [[LDMyWalletPageViewController alloc] init];
            
            cvc.type = @"0";
            
            [self.navigationController pushViewController:cvc animated:YES];
        
        }];
        
        [_gif getDynamicDid:model.did andIndexPath:indexPath andSign:@"动态" andUIViewController:self];
        
        [self.tabBarController.view addSubview:_gif];
    }
}

//点击动态点赞按钮
-(void)zanButtonClick:(UIButton *)button{
    
    DynamicCell *cell = (DynamicCell *)button.superview.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    DynamicModel *model = _dataArray[indexPath.section];
    
    if ([model.laudstate intValue] == 0) {
        
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Dynamic/laudDynamicNewrd"];
        
        NSDictionary *parameters = [NSDictionary dictionary];
        
        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"did":model.did};
        //    NSLog(@"%@",role);
        
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
            
            //        NSLog(@"%@",responseObject);
            
            if (integer != 2000) {
                
                 [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                
                
            }else{
                
                cell.zanLabel.text = [NSString stringWithFormat:@"%d",[cell.zanLabel.text intValue] + 1];
                
                cell.zanImageView.image = [UIImage imageNamed:@"赞紫"];
                
                model.laudstate = @"1";
                
                model.laudnum = [NSString stringWithFormat:@"%d",[cell.zanLabel.text intValue]];
                
                [_dataArray replaceObjectAtIndex:indexPath.section withObject:model];
                
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
        }];
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if ([self.content intValue] == 0 && section == 0) {
        
        if(_slideArray.count != 0){
            
            if (_topicArray.count == 0) {
                
                return DYANDNERHEIGHT + ADVERTISEMENT;
            }
            
            return DYANDNERHEIGHT + ADVERTISEMENT + 50;
        }
        
        if (_topicArray.count == 0) {
            
            return DYANDNERHEIGHT;
        }
        
        return DYANDNERHEIGHT + 50;
        
    }
    
    if (section == 0 && _slideArray.count == 0) {
        
        return 0.1;
    }
    
    if ([self.content intValue] >= 3) {
        
        return 2;
    }
 
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if ([self.content intValue] == 0  && section == 0) {
        
//        NSArray *imageName = @[@"动态打赏榜",@"动态人气榜",@"动态活跃榜",@"动态话题",@"动态消息"];
//        NSArray *titleName = @[@"打赏榜",@"人气榜",@"活跃榜",@"话题",@"动态消息"];
        
        NSArray *imageName = @[@"动态打赏榜",@"动态人气榜",@"动态活跃榜",@"动态消息"];
        NSArray *titleName = @[@"打赏榜",@"人气榜",@"活跃榜",@"动态消息"];
        
        CGFloat itemW = WIDTH/5;
        CGFloat itemH = DYANDNERHEIGHT;
        CGFloat plSpace = 5 * HEIGHTRADIO;
        CGFloat itemSpace = (WIDTH - itemW * imageName.count)/(imageName.count + 1);
        CGFloat lableH = 20;
        CGFloat topBottomSpace = (itemH - itemW/2 - lableH - plSpace)/2;
        
        if (_slideArray.count != 0) {
            
            UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, DYANDNERHEIGHT + ADVERTISEMENT + 2)];
            
            UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(0, ADVERTISEMENT, WIDTH, itemH)];
            showView.backgroundColor = [UIColor whiteColor];
            [headView addSubview:showView];
            
            for (int i = 0; i < imageName.count; i++) {
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(itemSpace + i * itemW + i * itemSpace, 0, itemW, itemH)];
                view.backgroundColor = [UIColor whiteColor];
                [showView addSubview:view];
                
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((itemW - itemW/2)/2, topBottomSpace, itemW/2, itemW/2)];
                imgView.image = [UIImage imageNamed:imageName[i]];
                [view addSubview:imgView];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, topBottomSpace + itemW/2 + plSpace, itemW, lableH)];
                label.text = titleName[i];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:12];
                [view addSubview:label];
                
                if (i == imageName.count - 1) {
                    
                    _unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemW/2 - 4, -2, 8, 8)];
                    _unreadLabel.backgroundColor = [UIColor redColor];
                    _unreadLabel.layer.cornerRadius = 4;
                    _unreadLabel.clipsToBounds = YES;
                    _unreadLabel.hidden = YES;
                    [imgView addSubview:_unreadLabel];
                    
                    [self createUnreadData];
                }
                
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemW, itemH)];
                button.tag = 1000 + i;
                [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
            }
            
            if (_topicArray.count != 0) {
            
                [self createTopicView:headView andHeight:DYANDNERHEIGHT + ADVERTISEMENT];
                
            }
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, ADVERTISEMENT)];
            img.userInteractionEnabled = YES;
            [headView addSubview:img];
            
            NSMutableArray *pathArray = [NSMutableArray array];
            
            for (NSDictionary *dic in _slideArray) {
                
                [pathArray addObject:dic[@"path"]];
                
            }
            
            SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, ADVERTISEMENT) delegate:self placeholderImage:[UIImage imageNamed:@"动态图片默认"]];
            cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            cycleScrollView.imageURLStringsGroup = pathArray;
            cycleScrollView.autoScrollTimeInterval = 3.0;
            [img addSubview:cycleScrollView];

            UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 25, 5, 20, 20)];
            
            [deleteButton setBackgroundImage:[UIImage imageNamed:@"删除按钮"] forState:UIControlStateNormal];
            
            [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
            [img addSubview:deleteButton];
            
            return headView;
            
        }else{
            
            UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, DYANDNERHEIGHT + 2)];
            
            UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, DYANDNERHEIGHT)];
            showView.backgroundColor = [UIColor whiteColor];
            [headView addSubview:showView];
            
            for (int i = 0; i < imageName.count; i++) {
                
                UIView *view = [[UIView alloc] initWithFrame:CGRectMake(itemSpace + i * itemSpace + i * itemW, 0, DYANDNERHEIGHT, DYANDNERHEIGHT)];
                view.backgroundColor = [UIColor whiteColor];
                [showView addSubview:view];
                
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake((itemW - itemW/2)/2, topBottomSpace, itemW/2, itemW/2)];
                imgView.image = [UIImage imageNamed:imageName[i]];
                [view addSubview:imgView];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, topBottomSpace + itemW/2 + plSpace, itemW, lableH)];
                label.text = titleName[i];
                label.textAlignment = NSTextAlignmentCenter;
                label.font = [UIFont systemFontOfSize:12];
                [view addSubview:label];
                
                if (i == imageName.count - 1) {
                    
                    _unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(itemW/2 - 4, -2, 8, 8)];
                    _unreadLabel.backgroundColor = [UIColor redColor];
                    _unreadLabel.layer.cornerRadius = 4;
                    _unreadLabel.layer.masksToBounds = YES;
                    _unreadLabel.hidden = YES;
                    [imgView addSubview:_unreadLabel];
                    
                    [self createUnreadData];
                }
                
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemW, itemH)];
                button.tag = 1000 + i;
                [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:button];
            }
            
            if (_topicArray.count != 0) {
                
                [self createTopicView:headView andHeight:DYANDNERHEIGHT];
                
            }
            return headView;
        }
        
    }

    return [[UIView alloc] init];
}


//删除上面的广告
-(void)deleteButtonClick{
    
    [_slideArray removeAllObjects];
    
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
 创建动态第一页的话题
 */
-(void)createTopicView:(UIView *)headView andHeight:(CGFloat)heightH{

    CGFloat btnX = 5;
    
    NSArray *colorArray = @[@"0xff0000",@"0xb73acb",@"0x0000ff",@"0x18a153",@"0xf39700",@"0xff00ff",@"0x00a0e9"];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, heightH + 3, WIDTH, 44)];
    
    scrollView.backgroundColor = [UIColor whiteColor];
    
    scrollView.showsHorizontalScrollIndicator = NO;
    
    [headView addSubview:scrollView];
    
    UIImageView *recommendView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 30, 30)];
    recommendView.image = [UIImage imageNamed:@"推荐话题"];
    [scrollView addSubview:recommendView];
    
    for (int i = 0; i < _topicArray.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        
        [btn setTitle:[NSString stringWithFormat:@"#%@#",_topicArray[i][@"title"]] forState:UIControlStateNormal];
        
        [btn setTitleColor:UIColorFromRGB(strtoul([colorArray[i%7] UTF8String], 0, 0)) forState:UIControlStateNormal];
        
        btn.tag = 100 + i;
        
        [btn addTarget:self action:@selector(btnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //重要的是下面这部分哦！
        CGSize titleSize = [[NSString stringWithFormat:@"#%@#",_topicArray[i][@"title"]] sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:btn.titleLabel.font.fontName size:btn.titleLabel.font.pointSize]}];
        
        titleSize.height = 44;
        titleSize.width += 20;
        
        btn.frame = CGRectMake(btnX + 40, 0, titleSize.width, titleSize.height);
        
        btnX = btnX + titleSize.width;
        
        if (i == _topicArray.count - 1) {
            
            scrollView.contentSize = CGSizeMake(btnX + 10 + 40 , 44);
        }
        
        [scrollView addSubview:btn];
    }
}

-(void)btnButtonClick:(UIButton *)button{

    HeaderTabViewController *tvc = [[HeaderTabViewController alloc] init];
    
    tvc.tid = [NSString stringWithFormat:@"%@",_topicArray[button.tag%100][@"tid"]];
    
    [self.navigationController pushViewController:tvc animated:YES];
}

-(void)titleButtonClick:(UIButton *)button{

    if (button.tag == 1000) {
        
        LDRewardRankingViewController *rvc = [[LDRewardRankingViewController alloc] init];
        
        [self.navigationController pushViewController:rvc animated:YES];
        
    }else if (button.tag == 1001){
    
        LDPopularityRankingViewController *rvc = [[LDPopularityRankingViewController alloc] init];
        
        rvc.rankType = @"popularity";
        
        [self.navigationController pushViewController:rvc animated:YES];
        
    }else if (button.tag == 1002){
    
        LDPopularityRankingViewController *rvc = [[LDPopularityRankingViewController alloc] init];
        
        rvc.rankType = @"diligence";
        
        [self.navigationController pushViewController:rvc animated:YES];
        
    }else if (button.tag == 1003){
        
        LDGetListViewController *lvc = [[LDGetListViewController alloc] init];
        
        lvc.hotDog = !self.unreadLabel.hidden;
        
        [self.navigationController pushViewController:lvc animated:YES];
    
        
//        LDMoreTopicViewController *tvc = [[LDMoreTopicViewController alloc] init];
//
//        [self.navigationController pushViewController:tvc animated:YES];
        
    }
//    else if (button.tag == 1004){
//
//
//
//    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if ([self.content intValue] >= 3) {
        
        if (_dataArray.count != 0 && _dataArray.count == section + 1) {
            
            return 2;
        }
        
        return 0.1;
    }
    
    DynamicModel *model = _dataArray[section];
    
    if (model.comArr.count != 0) {
        
        if (model.comArr.count == 2) {
            
            return 80;
            
        }else if (model.comArr.count == 1){
            
            return 60;
        }
    }
    
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if ([self.content intValue] >= 3) {
        
        return [[UIView alloc] init];
    }
    
    DynamicModel *model = _dataArray[section];
    
    if (model.comArr.count != 0) {
        
        if (model.comArr.count == 2) {
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
            
            view.backgroundColor = [UIColor whiteColor];
            
            UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 15, WIDTH - 16, 15)];
            
            if ([model.comArr[0][@"otheruid"] intValue] != 0) {
                
                oneLabel.text = [NSString stringWithFormat:@"%@回复%@: %@",model.comArr[0][@"nickname"],model.comArr[0][@"othernickname"],model.comArr[0][@"content"]];
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:oneLabel.text];
                [str addAttribute:NSForegroundColorAttributeName value:CDCOLOR range:NSMakeRange(0,[model.comArr[0][@"nickname"] length])];
                
                [str addAttribute:NSForegroundColorAttributeName value:CDCOLOR range:NSMakeRange([model.comArr[0][@"nickname"] length] + 2,[model.comArr[0][@"othernickname"] length])];
                
                oneLabel.attributedText = str;
                
            }else{
                
                oneLabel.text = [NSString stringWithFormat:@"%@: %@",model.comArr[0][@"nickname"],model.comArr[0][@"content"]];
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:oneLabel.text];
                [str addAttribute:NSForegroundColorAttributeName value:CDCOLOR range:NSMakeRange(0,[model.comArr[0][@"nickname"] length])];
                
                oneLabel.attributedText = str;
            }
            
            oneLabel.font = [UIFont systemFontOfSize:13];
            
            [view addSubview:oneLabel];
            
            UILabel *twoLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 35, WIDTH - 16, 15)];
            
            if ([model.comArr[1][@"otheruid"] intValue] != 0) {
                
                twoLabel.text = [NSString stringWithFormat:@"%@回复%@: %@",model.comArr[1][@"nickname"],model.comArr[1][@"othernickname"],model.comArr[1][@"content"]];
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:twoLabel.text];
                [str addAttribute:NSForegroundColorAttributeName value:CDCOLOR range:NSMakeRange(0,[model.comArr[1][@"nickname"] length])];
                
                [str addAttribute:NSForegroundColorAttributeName value:CDCOLOR range:NSMakeRange([model.comArr[1][@"nickname"] length] + 2,[model.comArr[1][@"othernickname"] length])];
                
                twoLabel.attributedText = str;
                
            }else{
                
                twoLabel.text = [NSString stringWithFormat:@"%@: %@",model.comArr[1][@"nickname"],model.comArr[1][@"content"]];
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:twoLabel.text];
                [str addAttribute:NSForegroundColorAttributeName value:CDCOLOR range:NSMakeRange(0,[model.comArr[1][@"nickname"] length])];
                
                twoLabel.attributedText = str;
            }
            
            twoLabel.font = [UIFont systemFontOfSize:13];
            
            [view addSubview:twoLabel];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
            
            line.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
            
            [view addSubview:line];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(8, 55, WIDTH - 16, 15)];
            
            [button setTitle:@"更多评论>" forState:UIControlStateNormal];
            
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            [view addSubview:button];
            
            UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
            
            [moreButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            moreButton.tag = section;
            
            moreButton.titleLabel.font = [UIFont systemFontOfSize:13];
            
            [moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            [view addSubview:moreButton];
            
            return view;
            
        }else if (model.comArr.count == 1){
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
            
            view.backgroundColor = [UIColor whiteColor];
            
            UILabel *oneLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 15, WIDTH - 16, 15)];
            
            if ([model.comArr[0][@"otheruid"] intValue] != 0) {
                
                oneLabel.text = [NSString stringWithFormat:@"%@回复%@: %@",model.comArr[0][@"nickname"],model.comArr[0][@"othernickname"],model.comArr[0][@"content"]];
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:oneLabel.text];
                [str addAttribute:NSForegroundColorAttributeName value:CDCOLOR range:NSMakeRange(0,[model.comArr[0][@"nickname"] length])];
                
                [str addAttribute:NSForegroundColorAttributeName value:CDCOLOR range:NSMakeRange([model.comArr[0][@"nickname"] length] + 2,[model.comArr[0][@"othernickname"] length])];
                
                oneLabel.attributedText = str;
                
                
            }else{
                
                oneLabel.text = [NSString stringWithFormat:@"%@: %@",model.comArr[0][@"nickname"],model.comArr[0][@"content"]];
                
                NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:oneLabel.text];
                [str addAttribute:NSForegroundColorAttributeName value:CDCOLOR range:NSMakeRange(0,[model.comArr[0][@"nickname"] length])];
                
                oneLabel.attributedText = str;
            }
            
            oneLabel.font = [UIFont systemFontOfSize:13];
            
            [view addSubview:oneLabel];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
            
            line.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
            
            [view addSubview:line];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(8, 35, WIDTH - 16, 15)];
            
            [button setTitle:@"更多评论>" forState:UIControlStateNormal];
            
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            [view addSubview:button];
            
            UIButton *moreButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 60)];
            
            [moreButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            moreButton.tag = section;
            
            moreButton.titleLabel.font = [UIFont systemFontOfSize:13];
            
            [moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            [view addSubview:moreButton];
            
            return view;
            
        }
        
    }
    
    return nil;
}

-(void)moreButtonClick:(UIButton *)button{
    
    DynamicModel *model = _dataArray[button.tag];
    
    LDDynamicDetailViewController *dvc = [[LDDynamicDetailViewController alloc] init];
    
    dvc.did = model.did;
    
    dvc.ownUid = model.uid;
    
    _indexPath = _sectionArray[button.tag];
    
    [self.navigationController pushViewController:dvc animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.content intValue] >= 3) {
        
        HeaderTabViewController *tvc = [[HeaderTabViewController alloc] init];
        
        TopicModel *model = _dataArray[indexPath.section];
        
        tvc.tid = [NSString stringWithFormat:@"%@",model.tid];
        
        tvc.index = [self.content integerValue] - 3;
        
        [self.navigationController pushViewController:tvc animated:YES];
        
    }else{
        
        LDDynamicDetailViewController *dvc = [[LDDynamicDetailViewController alloc] init];
        
        DynamicModel *model = _dataArray[indexPath.section];
        
        DynamicCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        dvc.did = model.did;
        
        dvc.ownUid = model.uid;
        
        dvc.block = ^(NSString *zanNum,NSString *zanState){
            
            if ([zanState intValue] == 1) {
                
                model.laudstate = zanState;
                
                model.laudnum = [NSString stringWithFormat:@"%d",[zanNum intValue]];
                
                cell.zanImageView.image = [UIImage imageNamed:@"赞紫"];
                
                cell.zanLabel.text = [NSString stringWithFormat:@"%@",model.laudnum];
                
            }else{
                
                model.laudstate = zanState;
                
                model.laudnum = [NSString stringWithFormat:@"%d",[zanNum intValue]];
                
                cell.zanImageView.image = [UIImage imageNamed:@"赞灰"];
                
                cell.zanLabel.text = [NSString stringWithFormat:@"%@",model.laudnum];
            }
        };
        
        dvc.commentBlock = ^(NSString *commentNum){
            
            cell.contentLabel.text = commentNum;
        };
        
        dvc.rewordBlock = ^(NSString *rewordNum){
            
            cell.rewardLabel.text = rewordNum;
        };
        
        dvc.deleteBlock = ^(){
            
            [_dataArray removeObject:model];
            
            [self.tableView reloadData];
        };
        
        [self.navigationController pushViewController:dvc animated:YES];
        
    }
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    if (_gif) {
        
        [_gif removeView];
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
