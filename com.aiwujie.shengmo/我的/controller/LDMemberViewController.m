//
//  LDMemberViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/10.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDMemberViewController.h"
#import "LDProtocolViewController.h"
#import "LDOwnInformationViewController.h"
#import "LDMemberPageViewController.h"
#import <StoreKit/StoreKit.h>
#import <AFNetworkReachabilityManager.h>

@interface LDMemberViewController ()<SKPaymentTransactionObserver,SKProductsRequestDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource>{
    
    MBProgressHUD *HUD;
}

@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *memberLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipMemberLabel;

//翻页控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
@property (nonatomic, strong) LDMemberPageViewController *memberPageViewController;

//存放按钮和下划线的view
@property (weak, nonatomic) IBOutlet UIView *topView;

//赠送会员
@property (weak, nonatomic) IBOutlet UIView *giveView;
@property (weak, nonatomic) IBOutlet UIImageView *giveHeadView;
@property (weak, nonatomic) IBOutlet UIImageView *givedHeadView;

//本人购买会员
@property (weak, nonatomic) IBOutlet UIView *buyView;

//显示目前在哪个界面
@property (nonatomic,assign) NSInteger index;

//存储选择充值哪个会员
@property (nonatomic,copy) NSString *buttonString;

//订单凭证
@property (nonatomic,copy) NSString *receipt;

//订单号
@property (nonatomic,copy) NSString *order_no;

//订单号
@property (nonatomic,copy) NSString *VIPIndex;

//存储会员的内购id
@property (nonatomic,strong) NSArray *shopArray;

//存储超级会员的内购id
@property (nonatomic,strong) NSArray *svipArray;

@end

@implementation LDMemberViewController

- (NSArray *)pageContentArray {
    
    if (!_pageContentArray) {
        
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        
        LDMemberPageViewController *v1 = [[LDMemberPageViewController alloc] init];
        LDMemberPageViewController *v2 = [[LDMemberPageViewController alloc] init];
        
        [arrayM addObject:v1];
        [arrayM addObject:v2];
        
        _pageContentArray = [[NSArray alloc] initWithArray:arrayM];
        
    }
    return _pageContentArray;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.type isEqualToString:@"give"]) {
        
        self.navigationItem.title = @"赠送会员";
        
        [self.givedHeadView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_headUrl]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        
        self.givedHeadView.layer.cornerRadius = 30;
        self.givedHeadView.clipsToBounds = YES;
        
        self.giveHeadView.layer.cornerRadius = 30;
        self.giveHeadView.clipsToBounds = YES;
        
        self.buyView.hidden = YES;
        
    }else{
    
        self.navigationItem.title = @"会员中心";
        
        self.headView.layer.cornerRadius = 35;
        self.headView.clipsToBounds = YES;
        
        self.giveView.hidden = YES;

        [self createInfoData];
    }
    
    _shopArray = @[@"pay7",@"pay8",@"pay9",@"pay10"];
    
    _svipArray = @[@"pay11",@"pay12",@"pay13",@"pay14"];
    
    _index = 0;
    
    //验证会员的购买凭证
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"会员凭证"] length] != 0) {
    
        [self zaiciyanzhengpingzheng];
        
   }
    
//    for (int i = 0; i < 4; i++) {
//        
//        UIButton *button = (UIButton *)[self.view viewWithTag:10 + i];
//        
//        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    //获取头部的头像
    [self createHeadViewData];
    
    //生成翻页控制器
    [self createPageViewController];
    
    //创建购买的按钮
    [self createBuyButton];
}

/**
 * 创建购买的按钮
 */
-(void)createBuyButton{
    
    UIButton *buyButton = [[UIButton alloc] initWithFrame:CGRectMake(0, [self getIsIphoneX:ISIPHONEX] - 44, WIDTH, 44)];
    [buyButton setBackgroundColor:CDCOLOR];
    [buyButton setTitle:@"确认支付" forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(buyButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:buyButton];
}

/**
 * 点击确认支付按钮
 */
-(void)buyButtonClick{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"会员凭证"] length] != 0) {
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您有支付凭证验证失败,暂时不能购买会员,请退出页面后重新进入验证或联系客服"];
        
    }else{
        
        //1.创建网络状态监测管理者
        AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
        //开启监听，记得开启，不然不走block
        [manger startMonitoring];
        //2.监听改变
        [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            /*
             AFNetworkReachabilityStatusUnknown = -1,
             AFNetworkReachabilityStatusNotReachable = 0,
             AFNetworkReachabilityStatusReachableViaWWAN = 1,
             AFNetworkReachabilityStatusReachableViaWiFi = 2,
             */
            
            if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi) {
                
                if([SKPaymentQueue canMakePayments]){
                    
                    LDMemberPageViewController *member = [self viewControllerAtIndex:_index];
                    
                    if (_index == 0) {
                        
                        _buttonString = [NSString stringWithFormat:@"%@",_shopArray[member.vipNum]];
                        
                    }else{
                        
                        _buttonString = [NSString stringWithFormat:@"%@",_svipArray[member.svipNum]];
                    }
                    
//                    NSLog(@"%@",_buttonString);
                    
                    [self requestProductData:_buttonString];
                    
                }else{
                    
//                    NSLog(@"不允许程序内付费");
                    
                    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的手机没有打开程序内付费购买" delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
                    
                    [alerView show];
                }
                
            }else{
                
                UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的手机网络状况不佳,请稍后再试" delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
                [alerView show];
            }
            
        }];
        
    }
}

/**
 * 生成翻页控制器
 */
-(void)createPageViewController{
    
    // 设置UIPageViewController的配置项
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(1)};
    //    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    
    // 根据给定的属性实例化UIPageViewController
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal options:options];
    // 设置UIPageViewController代理和数据源
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    LDMemberPageViewController *initialViewController = [self viewControllerAtIndex:0];// 得到第一页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = CGRectMake(0, 148, self.view.frame.size.width, self.view.frame.size.height);
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDMemberPageViewController *)viewController];
    
    if ((index == 0) || (index == NSNotFound)) {
        
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

#pragma mark 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDMemberPageViewController *)viewController];
    
    if (index == NSNotFound) {
        
        return nil;
    }
    
    index++;
    
    if (index == [self.pageContentArray count]) {
        
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

//翻页视图控制器将要翻页时执行的方法
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    
    _memberPageViewController = (LDMemberPageViewController *)pendingViewControllers[0];
    
}
//翻页动画执行完成后回调的方法
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if (finished) {
        
        if (completed) {
            
            NSInteger index = [self.pageContentArray indexOfObject:_memberPageViewController];
            
            _index = index;
            
            [self changeLineHidden:index];
            
        }else{
            
            NSInteger index = [self.pageContentArray indexOfObject:previousViewControllers[0]];
            
            _index = index;
            
            [self changeLineHidden:index];
        }
        
    }
}

#pragma mark - 根据index得到对应的UIViewController

- (LDMemberPageViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        
        return nil;
    }
    
    LDMemberPageViewController *contentVC = self.pageContentArray[index];
    
    contentVC.content = [NSString stringWithFormat:@"%lu",index];
    
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(LDMemberPageViewController *)viewController {
    
    return [viewController.content integerValue];
    
}

//按钮点击时间切换页面
- (IBAction)topButtonClick:(UIButton *)sender {
    
    [self changeLineHidden:sender.tag - 20];
    
    LDMemberPageViewController *initialViewController = [self viewControllerAtIndex:sender.tag - 20];// 得到对应页
    
    _index = sender.tag - 20;
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

//改变文字下细线的显示隐藏
-(void)changeLineHidden:(NSInteger)index{
    
    for (int i = 0; i < _pageContentArray.count; i++) {
        
        UIView *view = (UIView *)[self.topView viewWithTag:i + 10];
        
        if (view.tag == index + 10) {
            
            view.hidden = NO;
            
        }else{
            
            view.hidden = YES;
        }
    }
}

//如果有凭证未验证则再次验证
-(void)zaiciyanzhengpingzheng{
    
    _receipt = [[NSUserDefaults standardUserDefaults] objectForKey:@"会员凭证"];
    _order_no = [[NSUserDefaults standardUserDefaults] objectForKey:@"会员订单"];
    _VIPIndex = [[NSUserDefaults standardUserDefaults] objectForKey:@"VIPIndex"];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"会员凭证"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"会员订单"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"VIPIndex"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在验证,请耐心等待!";
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString string];
    
    if ([_VIPIndex intValue] == 0) {
        
        url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Ping/vip_ioshooks"];
        
    }else{
        
        url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Ping/svip_ioshooks"];
    }
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"赠送会员"] length] != 0){
        
        if ([_VIPIndex intValue] == 0) {
            
            parameters = @{@"receipt":_receipt,@"order_no":_order_no,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"赠送会员"],@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
        }else{
            
            parameters = @{@"receipt":_receipt,@"order_no":_order_no,@"vuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"赠送会员"],@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        }
        
    }else{
        
        if ([_VIPIndex intValue] == 0) {
            
            parameters = @{@"receipt":_receipt,@"order_no":_order_no,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            
        }else{
            
            parameters = @{@"receipt":_receipt,@"order_no":_order_no,@"vuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        }
    }
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
//
//        NSLog(@"%@,%@,%@",responseObject,responseObject[@"msg"],responseObject[@"data"]);
        
        if (integer != 2000) {
            
            if ([_VIPIndex intValue] == 0) {
                
                if (integer == 4000 && [responseObject[@"data"] intValue] == 5000) {
                    //存储失败的订单
                    [[NSUserDefaults standardUserDefaults] setObject:_receipt forKey:@"会员凭证"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:_order_no forKey:@"会员订单"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:_VIPIndex forKey:@"VIPIndex"];
                }
                
            }else{
                
                if (integer == 4000 || integer == 4001) {
                    //存储失败的订单
                    [[NSUserDefaults standardUserDefaults] setObject:_receipt forKey:@"会员凭证"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:_order_no forKey:@"会员订单"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:_VIPIndex forKey:@"VIPIndex"];
                   
                }
            }
            
            hud.labelText = @"验证失败";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:3];
            
        }else{
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"赠送会员"] length] != 0){
                
                hud.labelText = @"赠送成功";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:3];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"赠送会员"];
                
            }else{
                
                hud.labelText = @"购买成功";
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:3];
                
                if ([_VIPIndex intValue] == 0) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"vip"];
                    
                }else{
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"vip"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"svip"];
                }
                
                [self createInfoData];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"会员凭证"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"会员订单"];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"VIPIndex"];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        NSLog(@"%@",error);
        
        hud.labelText = @"网络请求超时";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:3];
        
    }];
    
}

-(void)createHeadViewData{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Other/getHeadAndNickname"];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
        }else{
            
            if ([self.type isEqualToString:@"give"]) {
                
                [self.giveHeadView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"head_pic"]]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
                
            }else{
            
                [self.headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"head_pic"]]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}

/**
 * 获取会员的到期时间
 */
-(void)createInfoData{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Vip/getVipOverTimeNew"];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};

    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"获取会员到期时间失败~"];
            
        }else{
            
            CGRect showFrame = self.showLabel.frame;
            CGRect memberFrame = self.memberLabel.frame;
            
            if ([responseObject[@"data"][@"svip"] intValue] == 0 && [responseObject[@"data"][@"vip"] intValue] == 0) {
                
                showFrame.origin.y = 24;
                self.showLabel.frame = showFrame;
                
                memberFrame.origin.y = 58;
                self.memberLabel.frame = memberFrame;
                
                self.vipMemberLabel.hidden = YES;
                
                self.memberLabel.text = @"点亮身份标识";
                
            }else if([responseObject[@"data"][@"svip"] intValue] != 0 && [responseObject[@"data"][@"vip"] intValue] == 0){
                
                showFrame.origin.y = 24;
                self.showLabel.frame = showFrame;
                
                memberFrame.origin.y = 58;
                self.memberLabel.frame = memberFrame;
                
                self.vipMemberLabel.hidden = YES;
                
                self.memberLabel.text = [NSString stringWithFormat:@"SVIP到期时间 : %@",responseObject[@"data"][@"svipovertime"]];
                
            }else if ([responseObject[@"data"][@"svip"] intValue] == 0 && [responseObject[@"data"][@"vip"] intValue] != 0){
                
                showFrame.origin.y = 24;
                self.showLabel.frame = showFrame;
                
                memberFrame.origin.y = 58;
                self.memberLabel.frame = memberFrame;
                
                self.vipMemberLabel.hidden = YES;
                
                self.memberLabel.text = [NSString stringWithFormat:@"VIP到期时间 : %@",responseObject[@"data"][@"vipovertime"]];
                
            }else{
                
                showFrame.origin.y = 17;
                self.showLabel.frame = showFrame;
                
                memberFrame.origin.y = 65;
                self.memberLabel.frame = memberFrame;
                
                self.vipMemberLabel.hidden = NO;
                
                self.vipMemberLabel.text = [NSString stringWithFormat:@"VIP到期时间 : %@",responseObject[@"data"][@"vipovertime"]];
                self.memberLabel.text = [NSString stringWithFormat:@"SVIP到期时间 : %@",responseObject[@"data"][@"svipovertime"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];

}

//请求商品
- (void)requestProductData:(NSString *)type{
    
    NSLog(@"-------------请求对应的产品信息----------------");
    
    HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"正在请求商品信息";
    
    NSArray *product = [[NSArray alloc] initWithObjects:type, nil];
    
    NSSet *nsset = [NSSet setWithArray:product];
    
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
    
    request.delegate = self;
    
    [request start];
    
}

//收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    
    NSLog(@"--------------收到产品反馈消息---------------------");
    NSArray *product = response.products;
    
    if([product count] == 0){
        
        NSLog(@"--------------没有商品------------------");
        
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有商品" delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
        
        [alerView show];
        
        [HUD removeFromSuperview];
        
        return;
    }
    
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    //    NSLog(@"产品付费数量:%d",[product count]);
    
    SKProduct *p = nil;
    
    for (SKProduct *pro in product) {
        
        NSLog(@"%@", [pro description]);
        
        NSLog(@"%@", [pro localizedTitle]);
        
        NSLog(@"%@", [pro localizedDescription]);
        
        NSLog(@"%@", [pro price]);
        
        NSLog(@"%@", [pro productIdentifier]);
        
        if([pro.productIdentifier isEqualToString:_buttonString]){
            
            p = pro;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    
//    NSLog(@"发送购买请求");
    
    HUD.labelText = @"";
    
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    
    HUD.labelText = @"请求失败";
    HUD.removeFromSuperViewOnHide = YES;
    [HUD hide:YES afterDelay:3];
    
    NSLog(@"------------------错误-----------------:%@", error);
}

- (void)requestDidFinish:(SKRequest *)request{
    
    NSLog(@"------------反馈信息结束-----------------");
}


//监听购买结果
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transaction{
    
    for(SKPaymentTransaction *tran in transaction){
        
        switch (tran.transactionState) {
                
            case SKPaymentTransactionStatePurchased:
                //NSLog(@"交易完成");
                HUD.labelText = @"正在验证,请耐心等待!";
                [self completeTransaction:tran];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"已经购买过商品");
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:
                
                NSLog(@"交易失败");
                [self failExchange:tran];
                [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                
                break;
                
            default:
                break;
        }
    }
}

//交易失败
-(void)failExchange:(SKPaymentTransaction *)transaction{
    
    [HUD hide:YES];
    
    switch (transaction.error.code) {
            
        case SKErrorUnknown:
            
            NSLog(@"SKErrorUnknown");
            
            [self warning:transaction];
            
            break;
            
        case SKErrorClientInvalid:
            
            NSLog(@"SKErrorClientInvalid");
            [self warning:transaction];
            
            break;
            
        case SKErrorPaymentCancelled:
            
            NSLog(@"SKErrorPaymentCancelled");
            
            break;
            
        case SKErrorPaymentInvalid:
            
            NSLog(@"SKErrorPaymentInvalid");
            
            [self warning:transaction];
            
            break;
            
        case SKErrorPaymentNotAllowed:
            
            NSLog(@"SKErrorPaymentNotAllowed");
            
            [self warning:transaction];
            
            break;
            
        default:
            
            NSLog(@"No Match Found for error");
            
            [self warning:transaction];
            
            break;
    }
}

-(void)warning:(SKPaymentTransaction *)transaction{
    
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:transaction.error.userInfo[@"NSLocalizedDescription"] delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
    
    [alerView show];
}

//交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{
    NSLog(@"交易结束");
    
    //[SVProgressHUD dismiss];
    
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
    
    NSString * productIdentifier = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
//    NSLog(@"%@",productIdentifier);
    
    if ([productIdentifier length] > 0) {
        // 向自己的服务器验证购买凭证
        
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        
        NSString *url = [NSString string];
        
        if (_index == 0) {
            
            url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Ping/vip_ioshooks"];
            
        }else{
            
            url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Ping/svip_ioshooks"];
        }
        
        NSDictionary *parameters = [NSDictionary dictionary];
        
        if ([self.type isEqualToString:@"give"]){
            
            if (_index == 0) {
                
                parameters = @{@"receipt":productIdentifier,@"order_no":transaction.transactionIdentifier,@"uid":self.userID,@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
                
            }else{
                
                parameters = @{@"receipt":productIdentifier,@"order_no":transaction.transactionIdentifier,@"vuid":self.userID,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            }

        }else{
            
            if (_index == 0) {
                
                parameters = @{@"receipt":productIdentifier,@"order_no":transaction.transactionIdentifier,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
                
            }else{
                
                parameters = @{@"receipt":productIdentifier,@"order_no":transaction.transactionIdentifier,@"vuid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
            }
            
        }
        
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
            
            if (integer != 2000) {
                
                if (_index == 0) {
                    
                    if (integer == 4000 && [responseObject[@"data"] intValue] == 5000) {
                        //存储失败的订单
                        [self cunchudingdan:transaction];
                    }
                    
                }else{
                    
                    if (integer == 4000 || integer == 4001) {
                        //存储失败的订单
                        [self cunchudingdan:transaction];
                    }
                }
                
//                NSLog(@"%@,%@,%@",responseObject,responseObject[@"msg"],responseObject[@"data"]);

                HUD.labelText = @"购买失败";
                HUD.removeFromSuperViewOnHide = YES;
                [HUD hide:YES afterDelay:3];
                
            }else{
                
                if ([self.type isEqualToString:@"give"]){
                    
                    HUD.labelText = @"赠送成功";
                    HUD.removeFromSuperViewOnHide = YES;
                    [HUD hide:YES afterDelay:3];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"赠送会员"];
                    
                }else{
                    
                    HUD.labelText = @"购买成功";
                    HUD.removeFromSuperViewOnHide = YES;
                    [HUD hide:YES afterDelay:3];
                    
                    if (_index == 0) {
                        
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"vip"];
                        
                    }else{
                        
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"svip"];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"vip"];
                    }
                    
                     [self createInfoData];
                }
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"会员凭证"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"会员订单"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"VIPIndex"];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            //NSLog(@"%@",error);
            
            HUD.labelText = @"网络异常,购买失败";
            HUD.removeFromSuperViewOnHide = YES;
            [HUD hide:YES afterDelay:3];
            
        }];
        
    }
}

//存储失败的订单
-(void)cunchudingdan:(SKPaymentTransaction *)transaction{
    
    if ([self.type isEqualToString:@"give"]){
        
        [[NSUserDefaults standardUserDefaults] setObject:self.userID forKey:@"赠送会员"];
        
    }else{
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"赠送会员"];
    }
    
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    
    NSString * productIdentifier = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    [[NSUserDefaults standardUserDefaults] setObject:productIdentifier forKey:@"会员凭证"];
    
    [[NSUserDefaults standardUserDefaults] setObject:transaction.transactionIdentifier forKey:@"会员订单"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",_index] forKey:@"VIPIndex"];
}


- (void)dealloc{
    
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (IBAction)giveHeadClick:(id)sender {
    
    LDOwnInformationViewController *fvc = [[LDOwnInformationViewController alloc] init];
    
    fvc.userID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]];
    
    [self.navigationController pushViewController:fvc animated:YES];
}

- (IBAction)givedHeadClick:(id)sender {
    
    LDOwnInformationViewController *fvc = [[LDOwnInformationViewController alloc] init];
    
    fvc.userID = [NSString stringWithFormat:@"%@",self.userID];
    
    [self.navigationController pushViewController:fvc animated:YES];
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
