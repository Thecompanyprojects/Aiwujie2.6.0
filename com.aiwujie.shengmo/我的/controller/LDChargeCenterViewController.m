//
//  LDChargeCenterViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/8.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDChargeCenterViewController.h"
#import <StoreKit/StoreKit.h>
#import <AFNetworkReachabilityManager.h>
#import "AppDelegate.h"

@interface LDChargeCenterViewController ()<SKPaymentTransactionObserver,SKProductsRequestDelegate>{

    MBProgressHUD *HUD;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeButton;


//12元
@property (weak, nonatomic) IBOutlet UIView *oneView;
//30元
@property (weak, nonatomic) IBOutlet UIView *twoView;
//50元
@property (weak, nonatomic) IBOutlet UIView *threeView;
//98元
@property (weak, nonatomic) IBOutlet UIView *fourView;
//298元
@property (weak, nonatomic) IBOutlet UIView *fiveView;
//588元
@property (weak, nonatomic) IBOutlet UIView *sixView;
//998元
@property (weak, nonatomic) IBOutlet UIView *sevenView;
//3998元
@property (weak, nonatomic) IBOutlet UIView *eightView;
//5898元
@property (weak, nonatomic) IBOutlet UIView *nineView;

//选择了哪个充值选项
@property (nonatomic,copy) NSString *subject;

//存储充值魔豆的内购id
@property (nonatomic,strong) NSArray *shopArray;
@property (weak, nonatomic) IBOutlet UIButton *exchangeBeansButton;

//选择了哪个充值选项
@property (nonatomic,copy) NSString *exchangeString;

@end

@implementation LDChargeCenterViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if (@available(iOS 11.0, *)) {
        
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self createData];
}

-(void)createData{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Users/getmywallet"];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};

    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
        }else{
            
            self.accountLabel.text = [NSString stringWithFormat:@"余额 %@ 魔豆",responseObject[@"data"][@"wallet"]];
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self.accountLabel.text];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:157/255.0 blue:0/255.0 alpha:1] range:NSMakeRange(3,[responseObject[@"data"][@"wallet"] length])];
            
            self.accountLabel.attributedText = str;
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"充值";
    
    self.scrollView.contentSize = CGSizeMake(WIDTH, self.changeButton.frame.origin.y + 120);
    
    _shopArray = @[@"bean1",@"bean2",@"bean3",@"bean4",@"bean5",@"bean6",@"pay6",@"bean7",@"bean8"];
    
    self.changeButton.layer.cornerRadius = 2;
    self.changeButton.clipsToBounds = YES;
    
    self.exchangeBeansButton.layer.cornerRadius = 2;
    self.exchangeBeansButton.clipsToBounds = YES;
    
    //有凭证未验证则再次验证
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"魔豆凭证"] length] != 0) {
        
        [self zaiciyanzhengpingzheng];
    }
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    for (int i = 0; i < 9; i++) {
        
        UIButton *button = (UIButton *)[self.view viewWithTag:30 + i];
        
        if (i == 0) {
            
            _subject = _shopArray[0];
            
            button.layer.borderWidth = 1;
            button.layer.borderColor = CDCOLOR.CGColor;
            button.layer.cornerRadius = 2;
            button.clipsToBounds = YES;
            
            UILabel *priceLabel = (UILabel *)[self.view viewWithTag:i + 10];
            
            priceLabel.textColor = CDCOLOR;
            
            UILabel *label = (UILabel *)[self.view viewWithTag:i + 20];
            
            label.textColor = CDCOLOR;
            
        }else{
        
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1].CGColor;
            button.layer.cornerRadius = 2;
            button.clipsToBounds = YES;
            
            UILabel *priceLabel = (UILabel *)[self.view viewWithTag:i + 10];
            
            priceLabel.textColor = [UIColor blackColor];
            
            UILabel *label = (UILabel *)[self.view viewWithTag:i + 20];
            
            label.textColor = [UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1];

        }
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

//如果有凭证未验证则再次验证
-(void)zaiciyanzhengpingzheng{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在验证,请耐心等待!";
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Ping/cz_ioshooks"];
    
    NSDictionary *parameters = @{@"receipt":[[NSUserDefaults standardUserDefaults] objectForKey:@"魔豆凭证"],@"order_no":[[NSUserDefaults standardUserDefaults] objectForKey:@"魔豆订单"],@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
//    NSLog(@"%@",parameters);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//        NSLog(@"%@",responseObject[@"data"]);
        
        if (integer != 2000) {
            
            hud.labelText = @"验证失败";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:3];
            
        }else{
            
            hud.labelText = @"购买成功";
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:3];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"魔豆凭证"];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"魔豆订单"];
            
            [self createData];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
        hud.labelText = @"网络请求超时";
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:3];
    
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

}
- (IBAction)chargeButtonClick:(id)sender {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"魔豆凭证"] length] != 0) {

        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您有支付凭证验证失败,暂时不能购买魔豆,请退出页面后重新进入验证或联系客服"];
        
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
        
        NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Ping/cz_ioshooks"];
        
        NSDictionary *parameters = @{@"receipt":productIdentifier,@"order_no":transaction.transactionIdentifier,@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
            
            //NSLog(@"%@",responseObject);
            
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
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"魔豆凭证"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"魔豆订单"];
                
                [self createData];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            
        }];

    }
}

//验证失败,存储本次购买的订单
-(void)cunchudingdan:(SKPaymentTransaction *)transaction{
    
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData=[NSData dataWithContentsOfURL:receiptUrl];
    
    NSString * productIdentifier = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    [[NSUserDefaults standardUserDefaults] setObject:productIdentifier forKey:@"魔豆凭证"];
    
    [[NSUserDefaults standardUserDefaults] setObject:transaction.transactionIdentifier forKey:@"魔豆订单"];
}

-(void)dealloc{

    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];

}

//- (IBAction)exchangeBeansButtonClick:(id)sender {
//    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"兑换邮票" message:nil    preferredStyle:UIAlertControllerStyleAlert];
//    
//    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//       
//        textField.placeholder = @"请输入兑换邮票张数";
//        
//        textField.keyboardType = UIKeyboardTypeNumberPad;
//        
//        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//        
//    }];
//    
//    UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定兑换" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
//        
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
//        hud.mode = MBProgressHUDModeIndeterminate;
//
//        if (_exchangeString.length == 0 || [_exchangeString intValue] == 0 || [[_exchangeString substringToIndex:1] intValue] == 0) {
//            
//            hud.labelText = @"请输入正确的兑换数量";
//            hud.removeFromSuperViewOnHide = YES;
//            [hud hide:YES afterDelay:1];
//            
//        }else{
//            
//            NSURL* url = [[NSURL alloc] init];
//            
//            NSDictionary *d = [NSDictionary dictionary];
//            
//            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@%@",URL,@"Api/Ping/stamp_baans"]]];
//                
//            d = @{@"num":_exchangeString,@"channel":@"0",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
//                
//            NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:url];
//            
//            NSData* da = [NSJSONSerialization dataWithJSONObject:d options:NSJSONWritingPrettyPrinted error:nil];
//            
//            NSString *bodyData = [[NSString alloc] initWithData:da encoding:NSUTF8StringEncoding];
//
//            [postRequest setHTTPBody:[NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])]];
//            
//            [postRequest setHTTPMethod:@"POST"];
//            
//            [postRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//            
//            //    ViewController * __weak weakSelf = self;
//            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//            
//            [NSURLConnection sendAsynchronousRequest:postRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//                //        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
//                //        NSLog(@"%ld",(long)httpResponse.statusCode);
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                    
//                    NSDictionary *responseDic = [self parseJSONStringToNSDictionary:result];
//                    
////                    NSLog(@"服务器返回：%@",responseDic);
//                    
//                    if ([responseDic[@"retcode"] intValue] == 2000) {
//                        
//                        hud.labelText = @"兑换成功";
//                        hud.removeFromSuperViewOnHide = YES;
//                        [hud hide:YES afterDelay:1];
//                        
//                        [self createData];
//                        
//                    }else{
//                        
//                        [hud hide:YES];
//                        
//                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[responseDic objectForKey:@"msg"]    preferredStyle:UIAlertControllerStyleAlert];
//                        
//                        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:nil];
//                        
//                        [alert addAction:action];
//                        
//                        [self presentViewController:alert animated:YES completion:nil];
//                
//                    }
//                    
//                });
//            }];
//        }
//    }];
//    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
//    
//    [alert addAction:cancelAction];
//    
//    [alert addAction:action];
//    
//    [self presentViewController:alert animated:YES completion:nil];
//
//    
//}
//
//-(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
//        
//    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
//        
//    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
//        
//    return responseJSON;
//}
//
//   
////监听输入框的内容变化
//-(void)textFieldDidChange:(UITextField *)textField{
//
//    _exchangeString = textField.text;
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
