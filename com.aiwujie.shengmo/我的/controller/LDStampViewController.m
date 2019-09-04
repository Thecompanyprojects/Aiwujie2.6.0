//
//  LDStampViewController.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/6/23.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDStampViewController.h"
#import "LDDetailPageViewController.h"
#import "LDDynamicViewController.h"
#import "LDSetViewController.h"
#import "LDShareView.h"
#import "StampCell.h"
#import <StoreKit/StoreKit.h>
#import <AFNetworkReachabilityManager.h>
#import "AppDelegate.h"
#import "LDMemberViewController.h"
#import "LDCertificateViewController.h"

@interface LDStampViewController ()<UITableViewDelegate,UITableViewDataSource,SKPaymentTransactionObserver,SKProductsRequestDelegate,SKStoreProductViewControllerDelegate>{
    
    MBProgressHUD *HUD;
}


@property (weak, nonatomic) IBOutlet UIView *headView;

@property (nonatomic,strong)  UITableView *tableView;
@property (nonatomic,strong)  NSArray *dataArray;

@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UIView *threeView;
@property (weak, nonatomic) IBOutlet UIView *fourView;
@property (weak, nonatomic) IBOutlet UIView *fiveView;
@property (weak, nonatomic) IBOutlet UIView *sixView;
@property (weak, nonatomic) IBOutlet UIView *sevenView;
@property (weak, nonatomic) IBOutlet UIView *eightView;
@property (weak, nonatomic) IBOutlet UIView *nineView;

//选择了哪个充值选项,用来存储内购
@property (nonatomic,strong)  NSArray *shopArray;
@property (nonatomic,copy) NSString *subject;

//选择了哪个充值选项,用来存储魔豆购买
@property (nonatomic,strong)  NSArray *numArray;
@property (nonatomic,copy) NSString *num;

@property (weak, nonatomic) IBOutlet UILabel *walletLabel;
//获赠邮票的label
@property (weak, nonatomic) IBOutlet UILabel *getFreeStampLabel;

//男票,女票,CD票
@property (nonatomic,copy) NSString *basicstampX;
@property (weak, nonatomic) IBOutlet UILabel *basicstampXLabel;
@property (nonatomic,copy) NSString *basicstampY;
@property (weak, nonatomic) IBOutlet UILabel *basicstampYLabel;
@property (nonatomic,copy) NSString *basicstampZ;
@property (weak, nonatomic) IBOutlet UILabel *basicstampZLabel;

//发布动态数
@property (nonatomic,copy) NSString *senddynamic;
//评论动态数
@property (nonatomic,copy) NSString *commentdynamic;
//点赞动态数
@property (nonatomic,copy) NSString *lauddynamic;
//分享动态数
@property (nonatomic,copy) NSString *shareapp;
//送礼物魔豆数
@property (nonatomic,copy) NSString *rewarddynamic;
//appstore好评
@property (nonatomic,copy) NSString *commentappstate;
//绑定手机号
@property (nonatomic,copy) NSString *mobile;
//普通用户每日的领取状态
@property (nonatomic,copy) NSString *narmaluser;
//会员用户的每日领取状态
@property (nonatomic,copy) NSString *vipuser;

@end

@implementation LDStampViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self createData];
 
}

-(void)createData{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Restrict/getStampPageInfo"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    //NSLog(@"%@",parameters);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
                
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];

          
        }else{
            
            _walletLabel.text = [NSString stringWithFormat:@"共购买 %@ 张通用邮票(永久有效)",responseObject[@"data"][@"wallet_stamp"]];
            [self changeWordColorTitle:_walletLabel.text andLoc:4 andLen:[responseObject[@"data"][@"wallet_stamp"] length] andLabel:_walletLabel];
            
            _basicstampX = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"basicstampX"]];
            _basicstampY = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"basicstampY"]];
            _basicstampZ = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"basicstampZ"]];
            _getFreeStampLabel.text = [NSString stringWithFormat:@"共获赠 %d 张任务邮票(当日有效)",[_basicstampX intValue] + [_basicstampY intValue] + [_basicstampZ intValue]];
            [self changeWordColorTitle:_getFreeStampLabel.text andLoc:4 andLen:[[NSString stringWithFormat:@"%d",[_basicstampX intValue] + [_basicstampY intValue] + [_basicstampZ intValue]] length] andLabel:_getFreeStampLabel];
            
            _basicstampXLabel.text = [NSString stringWithFormat:@"男票 %@ 张",responseObject[@"data"][@"basicstampX"]];
            _basicstampYLabel.text = [NSString stringWithFormat:@"女票 %@ 张",responseObject[@"data"][@"basicstampY"]];
            _basicstampZLabel.text = [NSString stringWithFormat:@"CDTS票 %@ 张",responseObject[@"data"][@"basicstampZ"]];
            [self changeWordColorTitle:_basicstampXLabel.text andLoc:3 andLen:_basicstampX.length andLabel:_basicstampXLabel];
            [self changeWordColorTitle:_basicstampYLabel.text andLoc:3 andLen:_basicstampY.length andLabel:_basicstampYLabel];
            [self changeWordColorTitle:_basicstampZLabel.text andLoc:6 andLen:_basicstampZ.length andLabel:_basicstampZLabel];
            
            _lauddynamic = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"lauddynamic"]];
            _commentdynamic = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"commentdynamic"]];
            _senddynamic = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"senddynamic"]];
            _shareapp = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"shareapp"]];
            _rewarddynamic = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"rewarddynamic"]];
            
            _commentappstate = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"commentappstate"]];
            _mobile = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"mobile"]];
            
            _narmaluser = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"narmaluser"]];
            _vipuser = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"vipuser"]];
            
            [self.tableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

//更改某个字体的颜色
-(void)changeWordColorTitle:(NSString *)str andLoc:(NSUInteger)loc andLen:(NSUInteger)len andLabel:(UILabel *)attributedLabel{
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:157/255.0 blue:0/255.0 alpha:1] range:NSMakeRange(loc,len)];
    attributedLabel.attributedText = attributedStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataArray = @[@[@"认证用户每日可领取3张邮票",@"VIP会员每日可领取3张邮票"],@[@"每日动态点赞20个赠3张邮票",@"每日动态评论5条赠3张邮票",@"每日发布2篇动态赠3张邮票",@"每日分享APP一次赠3张邮票",@"每日送礼物单次满100魔豆赠3张邮票"],@[@"绑定手机号赠9张邮票",@"应用商店好评赠9张邮票"],@[]];
    
    _shopArray = @[@"stamp1",@"stamp2",@"stamp3",@"stamp4",@"stamp5",@"stamp6",@"stamp7",@"stamp8",@"stamp9"];
    
    _numArray = @[@"3",@"7",@"11",@"23",@"38",@"65",@"105",@"200",@"385"];
    
    self.title = @"斯慕邮票";
    
    [self createRightButton];
    
    [self createTableView];
    
    //有凭证未验证则再次验证
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"邮票凭证"] length] != 0) {
        
        [self zaiciyanzhengpingzheng];
    }
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    for (int i = 0; i < 9; i++) {
        
        UIButton *button = (UIButton *)[self.view viewWithTag:30 + i];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1].CGColor;
        button.layer.cornerRadius = 2;
        button.clipsToBounds = YES;
        
        UILabel *priceLabel = (UILabel *)[self.view viewWithTag:i + 10];
        
        priceLabel.textColor = [UIColor blackColor];
        
        UILabel *label = (UILabel *)[self.view viewWithTag:i + 20];
        
        label.textColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1];
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

-(void)createRightButton{
    
    //右侧下拉列表
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [rightButton setTitle:@"明细" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonOnClic) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)rightButtonOnClic{
    
    LDDetailPageViewController *pvc = [[LDDetailPageViewController alloc] init];
    
    pvc.index = 2;
    
    [self.navigationController pushViewController:pvc animated:YES];
}

//如果有凭证未验证则再次验证
-(void)zaiciyanzhengpingzheng{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在验证,请耐心等待!";
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Ping/stamp_ioshooks"];
    
    NSDictionary *parameters = @{@"receipt":[[NSUserDefaults standardUserDefaults] objectForKey:@"邮票凭证"],@"order_no":[[NSUserDefaults standardUserDefaults] objectForKey:@"邮票订单"],@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    //    NSLog(@"%@",parameters);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//                NSLog(@"%@",responseObject[@"data"]);
        
        if (integer != 2000) {
            
            hud.labelText = @"验证失败";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:3];
            
        }else{
            
            hud.labelText = @"购买成功";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:3];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"邮票凭证"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"邮票订单"];
            
            [self createData];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


-(void)buttonClick:(UIButton *)button{
    
    for (int i = 0; i < 9; i++) {
        
        UIButton *btn = (UIButton *)[self.view viewWithTag:30 + i];
        
        if (btn.tag == button.tag) {
            
            button.layer.borderWidth = 1;
            button.layer.borderColor = CDCOLOR.CGColor;
            button.layer.cornerRadius = 2;
            button.clipsToBounds = YES;
            
            UILabel *priceLabel = (UILabel *)[self.view viewWithTag:button.tag - 20];
            
            priceLabel.textColor = CDCOLOR;
            
            UILabel *label = (UILabel *)[self.view viewWithTag:button.tag - 10];
            
            label.textColor = CDCOLOR;
            
            _subject = _shopArray[i];
            
            _num = _numArray[i];
            
        }else{
            
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1].CGColor;
            btn.layer.cornerRadius = 2;
            btn.clipsToBounds = YES;
            
            UILabel *priceLabel = (UILabel *)[self.view viewWithTag:i + 10];
            
            priceLabel.textColor = [UIColor blackColor];
            
            UILabel *label = (UILabel *)[self.view viewWithTag:i + 20];
            
            label.textColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1];
        }
    }
    
    [self createAlertViewController];
    
}

-(void)createAlertViewController{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction * action = [UIAlertAction actionWithTitle:@"购买邮票" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"邮票凭证"] length] != 0) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您有支付凭证验证失败,暂时不能购买邮票,请退出本页面后重新进入验证或联系客服"];
            
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
                        
                        [self requestProductData:_subject];
                        
                    }else{
                        
                        NSLog(@"不允许程序内付费");
                        
                        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的手机没有打开程序内付费购买" delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
                        
                        [alerView show];
                    }
                    
                }else{
                    
                    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的手机网络状况不佳,请稍后再试" delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];
                    [alerView show];
                }
                
            }];
            
        }

        
    }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
    
        [action setValue:CDCOLOR forKey:@"_titleTextColor"];
        [cancel setValue:CDCOLOR forKey:@"_titleTextColor"];
    }
    
    [alert addAction:cancel];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
//    
//    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
//    
//    return responseJSON;
//}

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
        
        if([pro.productIdentifier isEqualToString:_subject]){
            
            p = pro;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    
    NSLog(@"发送购买请求");
    
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
                NSLog(@"交易完成");
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
    
    if ([productIdentifier length] > 0) {
        // 向自己的服务器验证购买凭证
        
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Ping/stamp_ioshooks"];
        NSDictionary *parameters = @{@"receipt":productIdentifier,@"order_no":transaction.transactionIdentifier,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
            
//            NSLog(@"%@",responseObject[@"data"]);
            
            if (integer != 2000) {
                
                //验证失败,存储本次购买的订单
                [self cunchudingdan:transaction];
                
                HUD.labelText = @"购买失败";
                HUD.removeFromSuperViewOnHide = YES;
                [HUD hide:YES afterDelay:3];
                
            }else{
                
                
                HUD.labelText = @"购买成功";
                HUD.removeFromSuperViewOnHide = YES;
                [HUD hide:YES afterDelay:3];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"邮票凭证"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"邮票订单"];
                
                [self createData];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
            NSLog(@"%@",error);
        }];
        
    }
}

//验证失败,存储本次购买的订单
-(void)cunchudingdan:(SKPaymentTransaction *)transaction{
    
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
    
    NSString * productIdentifier = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    [[NSUserDefaults standardUserDefaults] setObject:productIdentifier forKey:@"邮票凭证"];
    
    [[NSUserDefaults standardUserDefaults] setObject:transaction.transactionIdentifier forKey:@"邮票订单"];
}

-(void)dealloc{

    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
}

-(void)createTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]) style:UITableViewStylePlain];
    
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
    
    self.tableView.tableHeaderView = _headView;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    
    self.tableView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataArray[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StampCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Stamp"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"StampCell" owner:self options:nil].lastObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.nameLabel.text = [NSString stringWithFormat:@"· %@",_dataArray[indexPath.section][indexPath.row]];
    
    if (indexPath.section == 0) {
        
        cell.numLabel.text = @"男/女/CDTS票各1张";
        
        cell.completeLabel.hidden = YES;

        if (indexPath.row == 0) {
            
            cell.lineView.hidden = NO;
            
            if ([_narmaluser intValue] == 0) {
                
                [self goComplete:cell andTitle:@"领取"];
            
            }else{
            
                [self didComplete:cell andTitle:@"已领取"];
            }
            
        }else if(indexPath.row == 1){
        
            cell.lineView.hidden = YES;
            
            if ([_vipuser intValue] == 0) {
                
                [self goComplete:cell andTitle:@"领取"];
                
            }else{
                
                [self didComplete:cell andTitle:@"已领取"];
            }
        }
    }else if (indexPath.section == 1) {
        
        cell.numLabel.text = @"男/女/CDTS票各1张";
        
        cell.completeLabel.hidden = NO;
        
        if (indexPath.row == 4) {
            
            cell.lineView.hidden = YES;
            
        }else{
            
            cell.lineView.hidden = NO;
        }
        
        if (indexPath.row == 0) {
            
            if ([_lauddynamic intValue] >= 20) {
                
                [self didComplete:cell andTitle:@"已完成"];
                
                cell.completeLabel.text = [NSString stringWithFormat:@"20/20"];
                
            }else{
                
                [self goComplete:cell andTitle:@"去完成"];
            
                cell.completeLabel.text = [NSString stringWithFormat:@"%@/20",_lauddynamic];
            }
            
        }else if (indexPath.row == 1){
            
            if ([_commentdynamic intValue] >= 5) {
                
                [self didComplete:cell andTitle:@"已完成"];
                
                cell.completeLabel.text = [NSString stringWithFormat:@"5/5"];
                
            }else{
                
               [self goComplete:cell andTitle:@"去完成"];
            
                cell.completeLabel.text = [NSString stringWithFormat:@"%@/5",_commentdynamic];
            }

        }else if (indexPath.row == 2){
            
            if ([_senddynamic intValue] >= 2) {
                
                [self didComplete:cell andTitle:@"已完成"];
                
                cell.completeLabel.text = [NSString stringWithFormat:@"2/2"];
       
                
            }else{
                
                [self goComplete:cell andTitle:@"去完成"];
            
                cell.completeLabel.text = [NSString stringWithFormat:@"%@/2",_senddynamic];
            }
            
        }else if (indexPath.row == 3){
            
            if ([_shareapp intValue] >= 1) {
                
                [self didComplete:cell andTitle:@"已完成"];
                
                cell.completeLabel.text = [NSString stringWithFormat:@"1/1"];
                
            }else{
            
               [self goComplete:cell andTitle:@"去完成"];
                
                cell.completeLabel.text = [NSString stringWithFormat:@"%@/1",_shareapp];
                
            }

        }else if (indexPath.row == 4){
            
            if ([_rewarddynamic intValue] >= 1) {
                
                [self didComplete:cell andTitle:@"已完成"];
                
                cell.completeLabel.text = [NSString stringWithFormat:@"1/1"];

                
            }else{
                
                [self goComplete:cell andTitle:@"去完成"];
            
                cell.completeLabel.text = [NSString stringWithFormat:@"%@/1",_rewarddynamic];
            }
        }
        
    }else if (indexPath.section == 2){
        
        if (indexPath.row == 1) {
            
            if ([_commentappstate intValue] == 0) {
                
                [self goComplete:cell andTitle:@"去完成"];
                
            }else{
            
                [self didComplete:cell andTitle:@"已完成"];
            }
            
            cell.lineView.hidden = YES;
            
        }else{
            
            if (_mobile.length == 0) {
                
                [self goComplete:cell andTitle:@"去完成"];
                
            }else{
                
                [self didComplete:cell andTitle:@"已完成"];
            }
            
            cell.lineView.hidden = NO;
        }
    
        cell.numLabel.text = @"男/女/CDTS票各3张";
        
        cell.completeLabel.hidden = YES;
    }
    
    [self changeWordColorTitle:cell.nameLabel.text andLoc:[cell.nameLabel.text length] - 4 andLen:2 andLabel:cell.nameLabel];
    
    [cell.goButton addTarget:self action:@selector(goButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}
/**
 * 去完成按钮设置
 */
-(void)goComplete:(StampCell *)cell andTitle:(NSString *)buttonTitle{
    
    [cell.goButton setTitle:buttonTitle forState:UIControlStateNormal];
    [cell.goButton setTitleColor:[UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1] forState:UIControlStateNormal];
    cell.goButton.backgroundColor = [UIColor clearColor];
    cell.goButton.userInteractionEnabled = YES;
}
/**
 * 已完成按钮设置
 */
-(void)didComplete:(StampCell *)cell andTitle:(NSString *)buttonTitle{
    
    [cell.goButton setTitle:buttonTitle forState:UIControlStateNormal];
    
    [cell.goButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    cell.goButton.backgroundColor = [UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1];
    
    cell.goButton.userInteractionEnabled = NO;
}

-(void)goButtonClick:(UIButton *)button{

    StampCell *cell = (StampCell *)button.superview.superview;
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"realname"] intValue] == 1) {
                
                //领取邮票
                [self userGetBasicStamp:[NSString stringWithFormat:@"%@%@",URL,@"Api/Restrict/narmalUserGetBasicStamp"]];

            }else{
                
                AFHTTPSessionManager *manager = [LDAFManager sharedManager];
                
                NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Other/getidstate"];
                
                NSDictionary *parameters = [NSDictionary dictionary];
                
                parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
                
                [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
                    
                    //NSLog(@"%@",responseObject);
                    
                    if (integer == 2000) {
                        
                        //领取邮票
                        [self userGetBasicStamp:[NSString stringWithFormat:@"%@%@",URL,@"Api/Restrict/narmalUserGetBasicStamp"]];
                        
                    }else if(integer == 2001){
                        
                        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"正在审核,请耐心等待审核通过后领取~"];
                        
                       
                        
                    }else if (integer == 2002){
                        
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"限认证用户免费领取~"    preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction * action = [UIAlertAction actionWithTitle:@"去认证" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                            
                            LDCertificateViewController *cvc = [[LDCertificateViewController alloc] init];
                            
                            cvc.where = @"4";
                            
                            [self.navigationController pushViewController:cvc animated:YES];
                            
                        }];
                        
                        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
                        
                        [alert addAction:cancelAction];
                        
                        [alert addAction:action];
                        
                        [self presentViewController:alert animated:YES completion:nil];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    NSLog(@"%@",error);
                    
                }];

            }

        }else if (indexPath.row == 1){
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1) {
                
                //领取邮票
                [self userGetBasicStamp:[NSString stringWithFormat:@"%@%@",URL,@"Api/Restrict/vipUserGetBasicStamp"]];
            
            }else{
            
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"限VIP会员免费领取~"    preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction * action = [UIAlertAction actionWithTitle:@"去开通" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                    
                    LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
                    
                    [self.navigationController pushViewController:mvc animated:YES];
                }];
                
                UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
                
                [alert addAction:cancelAction];
                
                [alert addAction:action];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        
    }else if (indexPath.section == 1) {
        
        if (indexPath.row == 0  || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 4) {
            
           self.tabBarController.selectedIndex = 3;

           [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            
            self.tabBarController.selectedIndex = 4;
        
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if(indexPath.section == 2){
    
        if (indexPath.row == 0) {
            
            LDSetViewController *svc = [[LDSetViewController alloc] init];
            
            [self.navigationController pushViewController:svc animated:YES];
            
        }else if (indexPath.row == 1){
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
            SKStoreProductViewController *storeProductVC =[[SKStoreProductViewController alloc] init];
            storeProductVC.delegate = self;
            //第一个参数为应用标识id构成的字典。第二个参数是一个block回调。
            [storeProductVC loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:@"1206232446"} completionBlock:^(BOOL result, NSError *error) {
                
                if (result) {
                    
                    [self presentViewController:storeProductVC animated:YES completion:^{
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                       
//                        NSLog(@"完成");
                    }];
                    
                }else{
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"跳转失败" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    
                }
            }];
        }
    }
}

/**
 * 领取邮票
 */
-(void)userGetBasicStamp:(NSString *)url{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //        NSLog(@"%@",responseObject);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
        }else{
            
            [self createData];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
//        NSLog(@"%@",error);
        
    }];
}

//SKStoreProductViewController代理方法
-(void)productViewControllerDidFinish:(SKStoreProductViewController*)viewController

{
    //返回上一个页面
    [self dismissViewControllerAnimated:YES completion:nil];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Users/getCMAppStamp"];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
        }else{
            
            [self createData];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        NSLog(@"%@",error);
        
    }];

    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    
    view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    
    if (section == 0) {
        
        label.text = @"    限时体验⭐️免费领邮票";
        
    }else if (section == 1) {
        
        label.text = @"    每日任务⭐️免费领邮票";
        
    }else if(section == 2){
    
        label.text = @"    单次任务⭐️免费领邮票";
    }
    
    label.font = [UIFont systemFontOfSize:14];
    [view addSubview:label];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 65;
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
