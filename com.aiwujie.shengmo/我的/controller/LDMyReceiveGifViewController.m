//
//  LDMyReceiveGifViewController.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/6/23.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDMyReceiveGifViewController.h"
#import "MyWalletCell.h"
#import "MyWalletModel.h"

@interface LDMyReceiveGifViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

//首页tableview和collectView及数据源
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *collectArray;

@property (weak, nonatomic) IBOutlet UIView *headView;

//收到礼物数的展示label
@property (nonatomic,strong) UILabel *numLabel;

//收到礼物的总价值label
@property (nonatomic,strong) UILabel *accountLabel;

//兑换邮票按钮
@property (weak, nonatomic) IBOutlet UIButton *exchangeButton;

//选择了哪个充值选项
@property (nonatomic,copy) NSString *exchangeString;

//礼物数量
@property (nonatomic,copy) NSString *num;

//礼物魔豆数
@property (nonatomic,copy) NSString *amount;

//礼物可用魔豆数
@property (nonatomic,copy) NSString *useAmount;

@end

@implementation LDMyReceiveGifViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.exchangeButton.layer.cornerRadius = 2;
    self.exchangeButton.clipsToBounds = YES;
    
    [self createCollectionView];
    
    _collectArray = [NSMutableArray array];
        
    [self createData];
        
}


//创建collectionView
-(void)createCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [self getIsIphoneX:ISIPHONEX]) collectionViewLayout:layout];
    
    if (@available(iOS 11.0, *)) {
        
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.collectionView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 2, 1, 2);
    
    [self.collectionView registerClass:[UICollectionReusableView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
     layout.headerReferenceSize=CGSizeMake(WIDTH, 161);
    
    if (HEIGHT == 667){
        
        //设置每个item的大小
        layout.itemSize = CGSizeMake((int)(WIDTH - 8)/3,120);
        
        // 设置最小行间距
        layout.minimumLineSpacing = 2;
        
        // 设置垂直间距
        layout.minimumInteritemSpacing = 2;
        
    }else{
        
        //设置每个item的大小
        layout.itemSize = CGSizeMake((WIDTH - 8)/3,120);
        
        // 设置最小行间距
        layout.minimumLineSpacing = 2;
        
        // 设置垂直间距
        layout.minimumInteritemSpacing = 2;
        
    }
    
    self.collectionView.alwaysBounceVertical = YES;
    
    self.collectionView.delegate =  self;
    
    self.collectionView.dataSource = self;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyWalletCell" bundle:nil] forCellWithReuseIdentifier:@"MyWallet"];
    
    [self.view addSubview:self.collectionView];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_collectArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MyWalletCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyWallet" forIndexPath:indexPath];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"MyWalletCell" owner:self options:nil].lastObject;
    }
    
    if (_collectArray.count > 0) {
        
        MyWalletModel *model = _collectArray[indexPath.row];
        
        cell.model = model;
        
    }
    
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
 
    if (kind == UICollectionElementKindSectionHeader){
        
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        if (headerView.subviews.count != 0) {
            
            for (UIView *view in headerView.subviews) {
                
                [view removeFromSuperview];
            }
        }
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 161)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - 84)/2, 15, 84, 90)];
        
        imageView.image = [UIImage imageNamed:@"我的礼物"];
        
        [view addSubview:imageView];
        
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, WIDTH, 21)];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.font = [UIFont systemFontOfSize:15];
        [view addSubview:_numLabel];
        
        _accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 133, WIDTH, 21)];
        _accountLabel.textAlignment = NSTextAlignmentCenter;
        _accountLabel.font = [UIFont systemFontOfSize:15];
        [view addSubview:_accountLabel];
        
        if (_num.length == 0) {
            
            _num = @"0";
        }
        
        if (_amount.length == 0) {
            
            _amount = @"0";
        }
        
        if (_useAmount.length == 0) {
            
            _useAmount = @"0";
        }
        
        _numLabel.text = [NSString stringWithFormat:@"共%@份",_num];
        
        _accountLabel.text = [NSString stringWithFormat:@"总价值%@魔豆(可用%@魔豆)",_amount,_useAmount];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:_numLabel.text];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:157/255.0 blue:0/255.0 alpha:1] range:NSMakeRange(1,_num.length)];
        _numLabel.attributedText = str;
        
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:_accountLabel.text];
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:157/255.0 blue:0/255.0 alpha:1] range:NSMakeRange(3,_amount.length)];
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:157/255.0 blue:0/255.0 alpha:1] range:NSMakeRange(8 + _amount.length,_useAmount.length)];
        _accountLabel.attributedText = str1;
        
        [headerView addSubview:view];
        
        reusableview = headerView;
        
    }
    
    return reusableview;
}


//请求首页数据源
-(void)createData{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Users/getMyPresent"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    //NSLog(@"%@",parameters);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
         NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//        NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            if (integer == 4001) {
                
                _num = @"0";
                
                _amount = @"0";
                
                _useAmount = @"0";
                
                [_collectArray removeAllObjects];
                    
                [_collectionView reloadData];
                    
            }else{
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            }
            
        }else{
            
            _num = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"allnum"]];
            _amount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"allamount"]];
            
            _useAmount = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"useableBeans"]];
            
            NSArray *amountArray = @[@"7",@"35",@"70",@"350",@"520",@"700",@"1888",@"2888",@"3888",@"2",@"6",@"10",@"38",@"99",@"88",@"123",@"166",@"199",@"520",@"666",@"250",@"777",@"888",@"999",@"1314",@"1666",@"1999",@"666",@"999",@"1888",@"2899",@"3899",@"6888",@"9888",@"52000",@"99999",@"1",@"3",@"5",@"10",@"8"];
            
            //对数组进行排序
            NSArray *result = [responseObject[@"data"][@"giftArr"] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                
                int number1;
                int number2;
                
                if (amountArray.count >= [obj1[@"type"] intValue]) {
                    
                    number1 = [amountArray[[obj1[@"type"] intValue] - 1] intValue];
                    
                }else{
                    
                    number1 = 0;
                }
                
                if (amountArray.count >= [obj2[@"type"] intValue]) {
                    
                    number2 = [amountArray[[obj2[@"type"] intValue] - 1] intValue];
                    
                }else{
                    
                    number2 = 0;
                }
                
                if (number1 > number2) {
                    
                    return (NSComparisonResult)NSOrderedAscending;
                    
                }else if (number1 < number2){
                    
                    return (NSComparisonResult)NSOrderedDescending
                    ;
                }else{
                    
                    return (NSComparisonResult)NSOrderedSame
                    ;
                }
            }];


            for (NSDictionary *dic in result) {
                
                MyWalletModel *model = [[MyWalletModel alloc] init];
                
                [model setValuesForKeysWithDictionary:dic];
                
                [_collectArray addObject:model];
            }
            
            [self.collectionView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}
//- (IBAction)exchangeButtonClick:(id)sender {
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
//            d = @{@"num":_exchangeString,@"channel":@"1",@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
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
