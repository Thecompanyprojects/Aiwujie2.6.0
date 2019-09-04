//
//  LDMineViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/18.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDMineViewController.h"
#import "LDStampViewController.h"
#import "LDBulletinViewController.h"
#import "LDCollectionDynamicViewController.h"
#import "LDSetViewController.h"
#import "LDAttentionListViewController.h"
#import "LDOwnInformationViewController.h"
#import "LDMyWalletViewController.h"
#import "LDLookOrBeLookViewController.h"
#import "LDMemberViewController.h"
#import "LDGroupSpuareViewController.h"
#import "LDCertificateViewController.h"
#import "LDCertificateBeforeViewController.h"
#import "LDGroupNumberViewController.h"
#import "LDMyWalletPageViewController.h"
#import "HeaderTabViewController.h"
#import "LDMatchmakerViewController.h"
#import "AppDelegate.h"
#import "LDShareView.h"
#import "LDSignView.h"
#import "ShowBadgeCell.h"
#import "UITabBar+badge.h"

@interface LDMineViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backH;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backW;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerH;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *lookButton;
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *showView;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;

//@property (nonatomic,copy) NSString *url;
//@property (nonatomic,copy) NSString *titleString;

//广告展示的数组数据
@property (nonatomic,strong) NSMutableArray *slideArray;

//个人认证状态
@property (nonatomic,copy) NSString *status;

//访问记录红点数
@property (nonatomic,copy) NSString *lookBadge;

//分享视图
@property (nonatomic,strong) LDShareView *shareView;

@end

@implementation LDMineViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self createPersonInformationData];
    
    //获得查看人数
    _lookBadge = [[NSUserDefaults standardUserDefaults] objectForKey:@"lookBadge"];
    
    //判断有无人查看来控制红点的显示与隐藏
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"lookBadge"] intValue] == 0) {
        
        [self.tabBarController.tabBar hideBadgeOnItemIndex:4];
        
    }else{
        
        [self.tabBarController.tabBar showBadgeOnItemIndex:4];
    }
    
    //获取个人认证状态
    [self createCertificateData];
}

//获取个人认证信息
-(void)createCertificateData{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Other/getidstate"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //        NSLog(@"%@",responseObject);
        
        if (integer == 2000) {
            
            _status = @"已认证";
            
        }else if(integer == 2001){
            
            _status = @"正在审核";
            
        }else if (integer == 2002){
            
            _status = @"立即认证";
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headImageView.layer.cornerRadius = 35;
    self.headImageView.clipsToBounds = YES;
    
    _slideArray = [NSMutableArray array];
    
    [self createRightButton];
    
//    _dataArray = @[@[@"访问记录"],@[@"我的钱包"],@[@"VIP会员"],@[@"自拍认证"],@[@"分享APP"],@[@"设置"]];
    
    _dataArray = @[@[@"访问记录",@"充值礼物",@"斯慕邮票",@"会员中心",@"红娘牵线",@"自拍认证",@"分享APP",@"设置"]];
    
    //_dataArray = @[@[@"访问记录"],@[@"个人认证"],@[@"设置"]];
    
    [self createHeadData];
    
    _shareView = [[LDShareView alloc] init];
    
    //分享视图
    [self.tabBarController.view addSubview:[_shareView createBottomView:@"Mine" andNickName:nil andPicture:nil andId:nil]];
    
    //监听谁看过我
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lookFangBadge) name:@"lookBadge" object:nil];
    
}

/**
 * 有人查看我的监听方法
 */
-(void)lookFangBadge{
    
    _lookBadge = [[NSUserDefaults standardUserDefaults] objectForKey:@"lookBadge"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.tableView reloadData];
        
    });
 
}

-(void)createRightButton{

    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [rightButton setTitle:@"收藏" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightButton addTarget:self action:@selector(signButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    UIButton * liftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [liftButton setTitle:@"签到" forState:UIControlStateNormal];
    [liftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    liftButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    [liftButton setBackgroundImage:[UIImage imageNamed:@"签到图标"] forState:UIControlStateNormal];
    [liftButton addTarget:self action:@selector(liftButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* liftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:liftButton];
    self.navigationItem.leftBarButtonItem = liftBarButtonItem;
}

-(void)liftButtonOnClick{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Draw/getSignTimesInWeeks"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //        NSLog(@"%@",responseObject);
        
        if (integer == 2002) {
            
            LDSignView *signView = [[LDSignView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
            
            [signView getSignDays:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"signtimes"]] andsignState:@"未签到"];
            
            [self.tabBarController.view addSubview:signView];
            
        }else if (integer == 2001){
            
            LDSignView *signView = [[LDSignView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
            
            [signView getSignDays:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"signtimes"]] andsignState:@"已签到"];
            
            [self.tabBarController.view addSubview:signView];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        NSLog(@"%@",error);
        
    }];

}

-(void)signButtonOnClick{

    LDCollectionDynamicViewController *dvc = [[LDCollectionDynamicViewController alloc] init];
    
    dvc.title = @"我的收藏";
    
    [self.navigationController pushViewController:dvc animated:YES];
}

-(void)createHeadData{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Other/getSlideMore"];
    
    NSDictionary *parameters = @{@"type":@"4"};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
       // NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            self.headerH.constant = 0;
            
            self.backW.constant = WIDTH;
            
            self.backH.constant = self.backView.frame.size.height - 98;
            
            self.backView.frame = CGRectMake(0, 0, self.backW.constant, self.backH.constant);
            
            [self createPersonInformationData];
            
        }else{
            
            self.headerH.constant = ADVERTISEMENT;
            
            self.backW.constant = WIDTH;
            
            self.backH.constant = 155 + self.headerH.constant;
            
            self.backView.frame = CGRectMake(0, 0, self.backW.constant, 155 + self.headerH.constant);
            
            [_slideArray addObjectsFromArray:responseObject[@"data"]];
            
            NSMutableArray *pathArray = [NSMutableArray array];
            
            for (NSDictionary *dic in responseObject[@"data"]) {
               
                [pathArray addObject:dic[@"path"]];
                
            }
            
            SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, WIDTH, ADVERTISEMENT) delegate:self placeholderImage:[UIImage imageNamed:@"动态图片默认"]];
            cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            cycleScrollView.imageURLStringsGroup = pathArray;
            cycleScrollView.autoScrollTimeInterval = 3.0;
            [_headerImageView addSubview:cycleScrollView];
            
//            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"path"]]]];
//
//            _url = responseObject[@"data"][@"url"];
//            
//            _titleString = responseObject[@"data"][@"title"];
            
            UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 25, 5, 20, 20)];
            
            [deleteButton setBackgroundImage:[UIImage imageNamed:@"删除按钮"] forState:UIControlStateNormal];
            
            [deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
            [self.headerImageView addSubview:deleteButton];
            
        }
        
        [self createTableView];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        self.headerH.constant = 0;
        
        self.backW.constant = WIDTH;
        
        self.backH.constant = self.backView.frame.size.height - 98;
        
        self.backView.frame = CGRectMake(0, 0, self.backW.constant, self.backH.constant);
        
        [self createTableView];
        
        [self createPersonInformationData];
        
    }];

}

//删除上面的广告
-(void)deleteButtonClick{
    
    for (UIView *view in self.headerImageView.subviews) {
        
        [view removeFromSuperview];
        
    }
    
    self.headerH.constant = 0;
    
    self.backW.constant = WIDTH;
    
    self.backH.constant = 155;
    
    self.backView.frame = CGRectMake(0, 0, self.backW.constant, 155);
    
    self.tableView.tableHeaderView = self.backView;
    
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


-(void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX] - 49) style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.tableHeaderView = self.backView;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    if (@available(iOS 11.0, *)) {
        
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataArray[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShowBadgeCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ShowBadgeCell" owner:self options:nil].lastObject;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.headView.image = [UIImage imageNamed:_dataArray[indexPath.section][indexPath.row]];
    
    
    cell.nameLabel.text = _dataArray[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        if (_lookBadge.length != 0) {
            
            cell.badgeLabel.hidden = NO;
            
            if ([_lookBadge intValue] > 99) {
                
                cell.badgeLabel.text = @"99+";
                
            }else{
                
                cell.badgeLabel.text = _lookBadge;
                
            }

        }else{
        
            cell.badgeLabel.hidden = YES;
        }
        
    }else if (indexPath.section == 0 && indexPath.row == 5) {
        
        cell.detailLabel.text = _status;
        
        cell.detailLabel.font = [UIFont systemFontOfSize:15];
        
    }
    
//    else if (indexPath.section == 0 && indexPath.row == 4) {
//
//        cell.detailLabel.text = @"New~";
//        cell.detailLabel.font = [UIFont italicSystemFontOfSize:12];//设置字体为斜体
//
//        cell.detailLabel.textColor = [UIColor redColor];
//
//    }
    
    
    if (indexPath.row == 7) {
        
        cell.lineView.hidden = YES;
        
    }else{
        
        cell.lineView.hidden = NO;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            LDLookOrBeLookViewController *lvc = [[LDLookOrBeLookViewController alloc] init];
            
            [self.tabBarController.tabBar hideBadgeOnItemIndex:4];
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"lookBadge"] length] > 0) {
                
                _lookBadge = @"";
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"lookBadge"];
                
            }
            
            [self.navigationController pushViewController:lvc animated:YES];
            
        }else if (indexPath.row == 1) {
            
            LDMyWalletPageViewController *mvc = [[LDMyWalletPageViewController alloc] init];
            
            [self.navigationController pushViewController:mvc animated:YES];
            
        }else if (indexPath.row == 2){
            
            LDStampViewController *svc = [[LDStampViewController alloc] init];
            
            [self.navigationController pushViewController:svc animated:YES];
            
        }else if (indexPath.row == 3) {
            
            LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
            
            [self.navigationController pushViewController:mvc animated:YES];
            
        }else if (indexPath.row == 4){
            
            LDMatchmakerViewController *match = [[LDMatchmakerViewController alloc] init];
            
            [self.navigationController pushViewController:match animated:YES];
            
        }else if(indexPath.row == 5){
            
            if (![_status isEqualToString:@"正在审核"]) {
                
                if ([_status isEqualToString:@"立即认证"]) {
                    
                    LDCertificateBeforeViewController *cvc = [[LDCertificateBeforeViewController alloc] init];
                    
                    [self.navigationController pushViewController:cvc animated:YES];
                    
                }else if ([_status isEqualToString:@"已认证"]){
                    
                    LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
                    
                    cvc.type = @"2";
                    
                    [self.navigationController pushViewController:cvc animated:YES];
                }
                
            }
            
        }else if (indexPath.row == 6){
            
             [_shareView controlViewShowAndHide:(UIViewController *)self];
            
        }else if(indexPath.row == 7){
        
            LDSetViewController *svc = [[LDSetViewController alloc] init];
            
            [self.navigationController pushViewController:svc animated:YES];
        }
    }
}


- (IBAction)lookOwnButtonClick:(id)sender {
    
    LDOwnInformationViewController *ivc = [[LDOwnInformationViewController alloc] init];
    
    ivc.userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
    
    [self.navigationController pushViewController:ivc animated:YES];
}
- (IBAction)attentButtonClick:(id)sender {
    
    LDAttentionListViewController *avc = [[LDAttentionListViewController alloc] init];
    
    avc.type = @"0";
    
    avc.userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];;
    
    [self.navigationController pushViewController:avc animated:YES];
}
- (IBAction)fansButtonClick:(id)sender {
    
    LDAttentionListViewController *avc = [[LDAttentionListViewController alloc] init];
    
    avc.type = @"1";
    
    avc.userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];;
    
    [self.navigationController pushViewController:avc animated:YES];
    
}
- (IBAction)groupButtonClick:(id)sender {
    
    LDGroupNumberViewController *nvc = [[LDGroupNumberViewController alloc] init];
    
    nvc.userId = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]];
    
    [self.navigationController pushViewController:nvc animated:YES];
}

-(void)createPersonInformationData{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/users/getmineinfo"];
    
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
        }else{
            
            [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"head_pic"]]] placeholderImage:[UIImage imageNamed:@"默认头像"]];

            self.nameLabel.text = responseObject[@"data"][@"nickname"];
            
            self.attentionLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"follow_num"]];
            
            self.fansLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"fans_num"]];
            
            self.groupLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"group_num"]];
            
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
