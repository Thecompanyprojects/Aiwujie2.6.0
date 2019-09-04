//
//  LDOwnInformationViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/27.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDOwnInformationViewController.h"
#import "LDBindingPhoneNumViewController.h"
#import "LDAttentionListViewController.h"
#import "LDEditViewController.h"
#import "LDAttentOtherViewController.h"
#import "PersonChatViewController.h"
#import "LDGroupNumberViewController.h"
#import "LDGroupSpuareViewController.h"
#import "LDBulletinViewController.h"
#import "LDPublishDynamicViewController.h"
#import "LDReportViewController.h"
#import "RecordViewController.h"
#import "LDCertificateViewController.h"
#import "LDCertificateBeforeViewController.h"
#import "LDMemberViewController.h"
#import "LDShengMoViewController.h"
#import "LDMemberViewController.h"
#import "LDStampViewController.h"
#import "LDMyWalletPageViewController.h"
#import "LDEditViewController.h"
#import "LDStampChatView.h"
#import "LDShareView.h"
#import "GifView.h"
#import "LDownInfoDynamicViewController.h"
#import "LDOwnInfoDynamicCommentViewController.h"
#import "LDChargeCenterViewController.h"
#import "LDLookGifListViewController.h"
#import <Accelerate/Accelerate.h>

@interface LDOwnInformationViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,StampChatDelete,YBAttributeTapActionDelegate>

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) AVPlayer *audioPlayer;//音频播放器，用于播放录音文件

//保存tableview的偏移量
@property (nonatomic,assign) CGFloat lastScrollOffset;

//获取头像下vip标识的状态
@property (nonatomic,copy) NSString *vipTypeString;

@property (nonatomic,copy) NSString *lock;
@property (nonatomic,strong) UIView *backgroundView;

//个人主页的tableView头视图
@property (weak, nonatomic) IBOutlet UIView *headBackView;

//头像的url
@property (nonatomic,copy) NSString *headUrl;

//是会员查看时间
@property (nonatomic,copy) NSString  *lastTime;

//个人主页的tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopY;

//个人主页上方背景图片
@property (weak, nonatomic) IBOutlet UIImageView *backGroundView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backGroundViewH;

//个人主页上方的透明遮挡
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backAlhpaH;

//个人主页的录音按钮
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

//个人主页播放按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playButtonY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playButtonX;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

//个人主页的时间展示label
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondW;

//上方图片展示的信息
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageViewY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageViewX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageViewH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageButtonX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageButtonY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageButtonW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headImageButtonH;

//个人主页姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameX;

//个人主页的认证状态
@property (weak, nonatomic) IBOutlet UIImageView *idImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idviewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idViewY;

//个人主页在线状态
@property (weak, nonatomic) IBOutlet UIView *onlineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *onlineViewY;

//个人主页VIP图片
@property (weak, nonatomic) IBOutlet UIImageView *vipView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipViewW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipViewY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipViewX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipButtonX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipButtonY;

//个人主页展示姓名性别的View
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewY;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
//个人主页的性取向
@property (weak, nonatomic) IBOutlet UILabel *sexualLabel;

//个人主页查看时间的按钮
@property (weak, nonatomic) IBOutlet UIButton *lookTimeButton;

//个人主页的登录时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeViewX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeViewY;
@property (weak, nonatomic) IBOutlet UIView *timeView;

//个人主页的位置信息
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationW;
@property (weak, nonatomic) IBOutlet UIView *locationView;

//个人主页的城市信息
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIView *cityView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cityW;

//个人主页展示关注，粉丝，群组
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attentionViewH;
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fansViewH;
@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UIButton *fansButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *groupViewH;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (weak, nonatomic) IBOutlet UIButton *groupButton;

//个人主页展示照片
@property (weak, nonatomic) IBOutlet UIView *picBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picH;
@property (strong, nonatomic)  UIScrollView *scrollView;

//个人主页展示个人介绍
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introduceH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introduceLineH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introduceTopLineH;
@property (weak, nonatomic) IBOutlet UILabel *introduceTopLineLabel;

//个人主页的个人资料填写
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *starLabel;
@property (weak, nonatomic) IBOutlet UILabel *psexualLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *experenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *wantLabel;
@property (weak, nonatomic) IBOutlet UILabel *cultureLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;

//存储个人相册的图片
@property (nonatomic,strong) NSArray *picArray;

//下方按钮

//赠送给某人礼物
@property (weak, nonatomic) IBOutlet UIButton *giveGifButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giveGifW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *giveGifH;

//关注
@property (weak, nonatomic) IBOutlet UIButton *attentButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attentW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *attentH;

//聊天
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chatH;

//发布动态
@property (weak, nonatomic) IBOutlet UIButton *publishButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *publishW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *publishH;

//是否可以发布动态
@property (nonatomic,copy) NSString *publishComment;

//是否关注对方
@property (nonatomic,assign) BOOL attentStatus;

//好友状态
@property (nonatomic,copy) NSString *followState;

//可以用户状态
@property (nonatomic,copy) NSString *is_likeliar;

//可以用户上方展示的view
@property (nonatomic,strong) UIView *likeliarView;

@property (nonatomic,strong) UIButton * shareButton;
@property (nonatomic,strong) UIButton *rightButton;
@property (nonatomic,strong) UITextField *passwordField;

@property (nonatomic,copy) NSString *blackState;

@property (nonatomic,copy) NSString *url;

//认证照片的展示按钮
@property (weak, nonatomic) IBOutlet UIButton *picPublicButton;

//认证照片的展示状态
@property (nonatomic,copy) NSString *realpicstate;

//录音的路径
@property (nonatomic,copy) NSString *mediaStrng;

//添加个性签名button
@property (nonatomic,strong) UIButton *addSignButton;

//访客显示
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateShowLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateY;

//标签显示的颜色
@property (nonatomic,strong) UIColor *signColor;

//动态的相关数目显示
@property (weak, nonatomic) IBOutlet UIView *totalNumView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalNumH;
@property (weak, nonatomic) IBOutlet UILabel *dynamicNumLabel;

//动态评论数的显示
@property (weak, nonatomic) IBOutlet UIView *dynamicCommentNumView;
@property (weak, nonatomic) IBOutlet UILabel *dynamicCommentNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dynamicCommentNumH;

//提示语的展示
@property (weak, nonatomic) IBOutlet UILabel *introduceWarnLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introduceWarnH;

//添加财富和魅力值的显示
@property (weak, nonatomic) IBOutlet UIView *wealthView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wealthW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wealthSpace;
@property (weak, nonatomic) IBOutlet UILabel *wealthLabel;
@property (weak, nonatomic) IBOutlet UIView *charmView;
@property (weak, nonatomic) IBOutlet UILabel *charmLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *charmW;

//分享视图
@property (nonatomic,strong) LDShareView *shareView;

//礼物界面
@property (nonatomic,strong) GifView *gif;

//聊天邮票界面
@property (nonatomic,strong) LDStampChatView *stampView;

//我的礼物
@property (weak, nonatomic) IBOutlet UIView *gifView;
@property (weak, nonatomic) IBOutlet UILabel *gifNumLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gifNumW;

//个人主页拉黑
@property (weak, nonatomic) IBOutlet UIView *blackView;
@property (weak, nonatomic) IBOutlet UILabel *blackLabel;

@property (nonatomic,strong) UIButton *blackButton;

//记录状态
@property (nonatomic,assign) BOOL isRecord;

@end

@implementation LDOwnInformationViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    if ([self.userID intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
    
        //获取判断是否可以发布动态的状态
        [self createPublishCommentData];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"个人主页";
    
    if (ISIPHONEPLUS) {
        
        self.giveGifW.constant = (self.giveGifButton.frame.size.width / 375) * WIDTH;
        self.giveGifH.constant = (self.giveGifButton.frame.size.height / 667) * HEIGHT;
        
        self.chatW.constant = (self.chatButton.frame.size.width / 375) * WIDTH;
        self.chatH.constant = (self.chatButton.frame.size.height / 667) * HEIGHT;
        
        self.attentW.constant = (self.attentButton.frame.size.width / 375) * WIDTH;
        self.attentH.constant = (self.attentButton.frame.size.height / 667) * HEIGHT;
        
        self.publishW.constant = (self.publishButton.frame.size.width / 375) * WIDTH;
        self.publishH.constant = (self.publishButton.frame.size.height / 667) * HEIGHT;
        
        //背景的高度改变
        self.backAlhpaH.constant = 280;
        self.backGroundViewH.constant = 280;
        
        //头像的x,y的改变
        self.headImageViewX.constant = 26;
        self.headImageViewY.constant = 35;
        self.headImageViewH.constant = 100;
        self.headImageViewW.constant = 100;
        self.headImageView.layer.cornerRadius = 50;
        self.headImageView.clipsToBounds = YES;
        
        self.headImageButtonX.constant = 26;
        self.headImageButtonY.constant = 35;
        self.headImageButtonH.constant = 100;
        self.headImageButtonW.constant = 100;
        
        //vip的x,y的改变
        self.vipViewX.constant = 98;
        self.vipViewY.constant = 112;
        self.vipButtonX.constant = 97;
        self.vipButtonY.constant = 104;
        self.vipViewH.constant = 25;
        self.vipViewW.constant = 25;
        
        //姓名的x,y的改变
        self.nameX.constant = 27;
        self.nameY.constant = 40;
        
        //认证的y的改变
        self.idViewY.constant = 44;
        
        //在线的y的改变
        self.onlineViewY.constant = 47;
        
        //姓名性别x,y的改变
        self.backViewX.constant = 27;
        self.backViewY.constant = 26;
        
        //录音相关x,y的改变
        self.playButtonX.constant = 27;
        self.playButtonY.constant = 26;
        
        //显示登录时间的x的改变
        self.timeViewX.constant = 48;
        self.timeViewY.constant = 26;
        self.dateX.constant = 48;
        self.dateY.constant = 26;
        
        //关注,粉丝,群组的高度改变
        self.attentionViewH.constant = 60;
        self.fansViewH.constant = 60;
        self.groupViewH.constant = 60;
        
            
    }else{
        
        self.headImageView.layer.cornerRadius = 40;
        self.headImageView.clipsToBounds = YES;
    }
    
    self.backView.layer.cornerRadius = 2;
    self.backView.clipsToBounds = YES;
    
    self.sexualLabel.layer.cornerRadius = 2;
    self.sexualLabel.clipsToBounds = YES;
    
    self.onlineView.layer.cornerRadius = 4;
    self.onlineView.clipsToBounds = YES;
    
    self.timeView.layer.cornerRadius = 2;
    self.timeView.clipsToBounds = YES;
    
    self.locationView.layer.cornerRadius = 2;
    self.locationView.clipsToBounds = YES;
    
    self.cityView.layer.cornerRadius = 2;
    self.cityView.clipsToBounds = YES;
    
    [self createRightButton];
    
    _dataArray = [[NSMutableArray alloc] init];
    
    _picArray = [NSArray array];
    
    _isRecord = NO;

    [self createTableView];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self createOwnInformationData];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.lastScrollOffset = 0;
    
    //监听修改了个人资料
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertOwnInformation) name:@"修改了个人资料" object:nil];

    //监听绑定手机号成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bindPhoneNumSuccess) name:@"绑定手机号码成功" object:nil];
}

/**
 * 绑定手机号码成功的监听方法
 */

-(void)bindPhoneNumSuccess{
    
    _publishComment = @"YES";
}

//修改了个人资料后得到监听修改资料
-(void)alertOwnInformation{

    [self createOwnInformationData];
}


//移除通知
-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
                
                if ([self.userID intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
                    
                    _publishButton.hidden = YES;
                    
                }else{
                    
                    self.chatButton.hidden = YES;
                    
                    self.attentButton.hidden = YES;
                    
                    self.giveGifButton.hidden = YES;
                }
                
            } else if(y < self.lastScrollOffset){
                //用户往下拖动，也就是屏幕内容向上滚动
                
                if ([self.userID intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
                    
                    _publishButton.hidden = NO;
                    
                }else{
                    
                    self.chatButton.hidden = NO;
                    
                    self.attentButton.hidden = NO;
                    
                    self.giveGifButton.hidden = NO;
                }
            }
            
        }
    }
}

-(void)createTableView{
    
    if (ISIPHONEX) {
        
        self.tableViewBottomY.constant = 34;
        
    }else{
        
        self.tableViewBottomY.constant = 0;
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
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.showsHorizontalScrollIndicator = NO;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}


- (IBAction)attentionButtonClick:(id)sender {
    
    if ([self.userID intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        
        LDAttentionListViewController *avc = [[LDAttentionListViewController alloc] init];
        
        avc.type = @"0";
        
        avc.userID = self.userID;
        
        [self.navigationController pushViewController:avc animated:YES];
        
    }else if ([self.userID intValue] != [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]){
    
        LDAttentOtherViewController *ovc = [[LDAttentOtherViewController alloc] init];
        
        ovc.type = @"0";
        
        ovc.userID = self.userID;
        
        [self.navigationController pushViewController:ovc animated:YES];
    }
    
    
}


- (IBAction)fansButtonClick:(id)sender {
    
    if ([self.userID intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        
        LDAttentionListViewController *avc = [[LDAttentionListViewController alloc] init];
        
        avc.type = @"1";
        
        avc.userID = self.userID;
        
        [self.navigationController pushViewController:avc animated:YES];

        
    }else if ([self.userID intValue] != [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]){
        
        LDAttentOtherViewController *ovc = [[LDAttentOtherViewController alloc] init];
        
        ovc.type = @"1";
        
        ovc.userID = self.userID;
        
        [self.navigationController pushViewController:ovc animated:YES];
    }
    
}

/**
 * 获取判断是否可以发布动态的状态
 */

-(void)createPublishCommentData{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Dynamic/judgeDynamicNewrd"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    
    //    NSLog(@"%@",role);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
        //        NSLog(@"%@",responseObject);
        
        if (integer == 4003  || integer == 4004) {
            
            _publishComment = [NSString stringWithFormat:@"%@",[responseObject objectForKey:@"retcode"]];
            
        }else  if(integer == 2000){
            
            _publishComment = @"YES";
            
        }else if(integer == 3001){
            
            _publishComment = @"";
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        _publishComment = @"NO";
        
    }];
    
}


- (IBAction)publishButtonClick:(id)sender {
    
    if (_publishComment.length == 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"根据国家网信部《互联网跟帖评论服务管理规定》要求，需要绑定手机号后才可以发布动态~"    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"立即绑定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            LDBindingPhoneNumViewController *bpnc = [[LDBindingPhoneNumViewController alloc] init];
            
            [self.navigationController pushViewController:bpnc animated:YES];
            
        }];
        
        
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
        
        if (PHONEVERSION.doubleValue >= 8.3) {
            
            [action setValue:CDCOLOR forKey:@"_titleTextColor"];
            
            [cancel setValue:CDCOLOR forKey:@"_titleTextColor"];
        }
        
        [alert addAction:cancel];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }else{
        
        if ([_publishComment intValue] == 4003) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您好,您因违规暂时不能发布动态,具体解封时间请查看系统通知或与客服联系~"];
            
        }else if ([_publishComment intValue] == 4004) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您好,普通用户每日发布动态限10条,VIP会员每日发布动态限30条~"];
            
        }else if ([_publishComment isEqualToString:@"YES"]){
          
            LDPublishDynamicViewController *dvc = [[LDPublishDynamicViewController alloc] init];
            
            [self.navigationController pushViewController:dvc animated:YES];

        }else{
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"发生错误,请退出软件后重试~"];
        }
    }

}

-(void)createRightButton{
    
    if ([self.userID intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        
        _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [_shareButton setImage:[UIImage imageNamed:@"编辑个人资料"] forState:UIControlStateNormal];
        
        [_shareButton addTarget:self action:@selector(shareButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* shareButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_shareButton];

        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_rightButton setImage:[UIImage imageNamed:@"其他"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonShareButtonClick) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
        
        self.navigationItem.rightBarButtonItems = @[rightBarButtonItem,shareButtonItem];
        
    }else{
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1) {
            
            _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
            [_shareButton setImage:[UIImage imageNamed:@"编辑个人资料"] forState:UIControlStateNormal];
            
            [_shareButton addTarget:self action:@selector(shareButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem* shareButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_shareButton];
            
            _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            [_rightButton setImage:[UIImage imageNamed:@"其他"] forState:UIControlStateNormal];
            [_rightButton addTarget:self action:@selector(rightButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
            
            self.navigationItem.rightBarButtonItems = @[rightBarButtonItem,shareButtonItem];
            
          
        }else{
        
            _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            [_rightButton setImage:[UIImage imageNamed:@"其他"] forState:UIControlStateNormal];
            [_rightButton addTarget:self action:@selector(rightButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
            
            self.navigationItem.rightBarButtonItems = @[rightBarButtonItem];
        }
    }
}

//分享
-(void)shareButtonOnClick{

    LDEditViewController *evc = [[LDEditViewController alloc] init];
    
    evc.userID = self.userID;
    
    [self.navigationController pushViewController:evc animated:YES];
}

//进入个人主页时创建的分享按钮
-(void)rightButtonShareButtonClick{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * shareButton = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [_shareView controlViewShowAndHide:nil];
        
    }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
        
        [shareButton setValue:CDCOLOR forKey:@"_titleTextColor"];
        
        [cancel setValue:CDCOLOR forKey:@"_titleTextColor"];
    }
    [alert addAction:cancel];
    
    [alert addAction:shareButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

//其他，拉黑等功能
-(void)rightButtonOnClick{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString *blackTitle = [NSString string];
    
    if ([_blackState intValue] == 1) {
        
        blackTitle = @"取消拉黑";

    }else{
        
        blackTitle = @"拉黑";
    }
    
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:blackTitle style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self blackButtonClick];
        
    }];
    
    UIAlertAction * report = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self reportButtonClick];
        
    }];
    
    
    UIAlertAction * shareButton = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [_shareView controlViewShowAndHide:nil];
        
    }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
    
    [alert addAction:cancel];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1) {
        
        UIAlertAction *titleAction = [UIAlertAction actionWithTitle:@"永久封号" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            AFHTTPSessionManager *manager = [LDAFManager sharedManager];
            
            NSString *url = [NSString string];
            
            url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Power/getAllUserStatus"];
            
            NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userID};
            
            [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
                
                //                NSLog(@"%@",responseObject);
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                if (integer == 2000) {
                    
                    if ([responseObject[@"data"][@"status"] intValue] == 1) {
                        
                        [self unenableUse:@"1" andBlockingAlong:@"0"];
                        
                    }else{
                        
                        [self enableUse:@"1"];
                    }
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"操作成功~"];
                    
                }else{
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"操作失败~"];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }];
            
        }];
        
        NSString *likeliar = [NSString string];
        
        if ([_is_likeliar intValue] == 0) {
            
            likeliar = @"可疑用户";
            
        }else{
            
            likeliar = @"取消可疑用户";
        }
        
        //Suspicious user
        UIAlertAction *SuspiciousUserAction = [UIAlertAction actionWithTitle:likeliar style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            AFHTTPSessionManager *manager = [LDAFManager sharedManager];
            
            NSString *url = [NSString string];
            
            if ([_is_likeliar intValue] == 0) {
                
                url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Power/setLikeLiarState/method/setone"];
                
            }else{
                
                url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Power/setLikeLiarState/method/removeone"];
            }
            
            NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userID};
            
            [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
                
                //                NSLog(@"%@",responseObject);
                
                if (integer != 2000) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"操作失败"];
                    
                }else{
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    if ([_is_likeliar intValue] == 0) {
                        
                        _is_likeliar = @"1";
                        
                    }else{
                        
                        _is_likeliar = @"0";
                    }
                    
                    [self.tableView.mj_header beginRefreshing];
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"操作成功"];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }];
        }];
        
        UIAlertAction *delHeadAction = [UIAlertAction actionWithTitle:@"违规头像" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [self deleteWeiGuiUser:@"1"];
        }];
        
        UIAlertAction *delNickNameAction = [UIAlertAction actionWithTitle:@"违规昵称" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [self deleteWeiGuiUser:@"2"];
        }];
        
        UIAlertAction *delSignAction = [UIAlertAction actionWithTitle:@"违规签名" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [self deleteWeiGuiUser:@"3"];
        }];
        
        UIAlertAction *delPicAction = [UIAlertAction actionWithTitle:@"违规相册" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [self deleteWeiGuiUser:@"4"];
        }];
        
        UIAlertAction *titleDynamicAction = [UIAlertAction actionWithTitle:@"★ 管理员权限" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            AFHTTPSessionManager *manager = [LDAFManager sharedManager];
            
            NSString *url = [NSString string];
            
            url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Power/getAllUserStatus"];
            
            NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userID};
            
            [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
                
//                NSLog(@"%@",responseObject);
                
                if (integer == 2000) {
                    
                    [self createAdminOperationlertAction:responseObject[@"data"]];
                    
                }else{
                    
                    [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"获取失败~"];
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }];
            
        }];
        
        if (PHONEVERSION.doubleValue >= 8.3) {
            
            [titleAction setValue:CDCOLOR forKey:@"_titleTextColor"];
            [SuspiciousUserAction setValue:CDCOLOR forKey:@"_titleTextColor"];
            [delHeadAction setValue:CDCOLOR forKey:@"_titleTextColor"];
            [delNickNameAction setValue:CDCOLOR forKey:@"_titleTextColor"];
            [delSignAction setValue:CDCOLOR forKey:@"_titleTextColor"];
            [delPicAction setValue:CDCOLOR forKey:@"_titleTextColor"];
            [titleDynamicAction setValue:CDCOLOR forKey:@"_titleTextColor"];
        }
        
        [alert addAction:titleAction];
        [alert addAction:SuspiciousUserAction];
        [alert addAction:delHeadAction];
        [alert addAction:delPicAction];
        [alert addAction:delNickNameAction];
        [alert addAction:delSignAction];
        [alert addAction:titleDynamicAction];
    }
    
    if (PHONEVERSION.doubleValue >= 8.3) {
        
        [action setValue:CDCOLOR forKey:@"_titleTextColor"];
        
        [report setValue:CDCOLOR forKey:@"_titleTextColor"];
        
        [shareButton setValue:CDCOLOR forKey:@"_titleTextColor"];
        
        [cancel setValue:CDCOLOR forKey:@"_titleTextColor"];
    }
    
    [alert addAction:shareButton];
    
    [alert addAction:report];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 * 创建黑V的操作按钮
 */
-(void)createAdminOperationlertAction:(NSDictionary *)dic{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString *titleAccount = [NSString string];
    
    if ([dic[@"status"] intValue] == 1) {
        
        titleAccount = @"封禁账号";
        
    }else{
        
        titleAccount = @"启用账号";
    }
    
    UIAlertAction *titleAccountAction = [UIAlertAction actionWithTitle:titleAccount style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        if ([dic[@"status"] intValue] == 1) {
            
             [self setStopTime:@"1"];
            
        }else{
            
            [self enableUse:@"1"];
        }
    }];
    
    NSString *titleDynamic = [NSString string];
    
    if ([dic[@"dynamicstatus"] intValue] == 1) {
        
        titleDynamic = @"封禁动态";
        
    }else{
        
        titleDynamic = @"启用动态";
    }
    
    UIAlertAction *titleDynamicAction = [UIAlertAction actionWithTitle:titleDynamic style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        if ([dic[@"dynamicstatus"] intValue] == 1) {
            
            [self setStopTime:@"2"];
            
        }else{
            
            [self enableUse:@"2"];
        }
    }];
    
    NSString *titleMessage = [NSString string];
    
    if ([dic[@"chatstatus"] intValue] == 1) {
        
        titleMessage = @"封禁消息";
        
    }else{
        
        titleMessage = @"启用消息";
    }
    
    UIAlertAction *titleMessageAction = [UIAlertAction actionWithTitle:titleMessage style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        if ([dic[@"chatstatus"] intValue] == 1) {
           
            [self setStopTime:@"4"];
            
        }else{
            
            [self enableUse:@"4"];
        }
        
    }];
    
    NSString *titleInfo = [NSString string];
    
    if ([dic[@"infostatus"] intValue] == 1) {
        
        titleInfo = @"封禁资料";
        
    }else{
        
        titleInfo = @"启用资料";
    }
    
    UIAlertAction *titleInfomationAction = [UIAlertAction actionWithTitle:titleInfo style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        if ([dic[@"infostatus"] intValue] == 1) {
            
            [self setStopTime:@"3"];
            
        }else{
            
            [self enableUse:@"3"];
        }
        
    }];
    
    NSString *titleDevice = [NSString string];
    
    if ([dic[@"devicestatus"] intValue] == 1) {
        
        titleDevice = @"封禁设备";
        
    }else{
        
        titleDevice = @"启用设备";
    }
    
    UIAlertAction *titleDeviceAction = [UIAlertAction actionWithTitle:titleDevice style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        
        NSString *url = [NSString string];
        
        if ([dic[@"devicestatus"] intValue] == 1) {
            
            url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Power/changeDeviceStatus/method/forbid"];
            
        }else{
            
            url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Power/changeDeviceStatus/method/resume"];
            
        }
        
        NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userID};
        
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
            
//            NSLog(@"%@",responseObject);
            
            if (integer != 2000) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"操作失败"];
                
            }else{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"操作成功"];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }];
       
    }];
    
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
    
    
    [alert addAction:cancel];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
        
         [titleAccountAction setValue:CDCOLOR forKey:@"_titleTextColor"];
        [titleDynamicAction setValue:CDCOLOR forKey:@"_titleTextColor"];
        [titleMessageAction setValue:CDCOLOR forKey:@"_titleTextColor"];
        [titleInfomationAction setValue:CDCOLOR forKey:@"_titleTextColor"];
        [titleDeviceAction setValue:CDCOLOR forKey:@"_titleTextColor"];
        [cancel setValue:CDCOLOR forKey:@"_titleTextColor"];
    }
    [alert addAction:titleAccountAction];
    [alert addAction:titleDynamicAction];
    [alert addAction:titleMessageAction];
    [alert addAction:titleInfomationAction];
    [alert addAction:titleDeviceAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 * 封禁时间的弹框提示
 */

-(void)setStopTime:(NSString *)type{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil    preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *titleOneDayAction = [UIAlertAction actionWithTitle:@"1天" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self unenableUse:type andBlockingAlong:@"1"];
        
    }];
    
    UIAlertAction *titleTwoDayAction = [UIAlertAction actionWithTitle:@"3天" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self unenableUse:type andBlockingAlong:@"3"];
        
    }];
    
    UIAlertAction *titleOneWeekAction = [UIAlertAction actionWithTitle:@"1周" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self unenableUse:type andBlockingAlong:@"7"];
        
    }];
    
    UIAlertAction *titleTwoWeekAction = [UIAlertAction actionWithTitle:@"2周" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self unenableUse:type andBlockingAlong:@"14"];
        
    }];
    
    UIAlertAction *titleOneMonthAction = [UIAlertAction actionWithTitle:@"1月" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self unenableUse:type andBlockingAlong:@"30"];
        
    }];
    
    UIAlertAction *titleForeverAction = [UIAlertAction actionWithTitle:@"永久" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        [self unenableUse:type andBlockingAlong:@"0"];
        
    }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
    
    
    [alert addAction:cancel];
    
    if (PHONEVERSION.doubleValue >= 8.3) {
        
        [titleOneDayAction setValue:CDCOLOR forKey:@"_titleTextColor"];
        [titleTwoDayAction setValue:CDCOLOR forKey:@"_titleTextColor"];
        [titleOneWeekAction setValue:CDCOLOR forKey:@"_titleTextColor"];
        [titleTwoWeekAction setValue:CDCOLOR forKey:@"_titleTextColor"];
        [titleOneMonthAction setValue:CDCOLOR forKey:@"_titleTextColor"];
        [titleForeverAction setValue:CDCOLOR forKey:@"_titleTextColor"];
        [cancel setValue:CDCOLOR forKey:@"_titleTextColor"];
    }
    [alert addAction:titleOneDayAction];
    [alert addAction:titleTwoDayAction];
    [alert addAction:titleOneWeekAction];
    [alert addAction:titleTwoWeekAction];
    [alert addAction:titleOneMonthAction];
    [alert addAction:titleForeverAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 * 封禁的用户相应的权限
 */

-(void)unenableUse:(NSString *)type andBlockingAlong:(NSString *)blockingalong{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString string];
    
    url = [NSString stringWithFormat:@"%@%@%@",URL,@"Api/Power/changeAllUserStatus/method/",type];
    
    NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userID,@"blockingalong":blockingalong};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //                NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"操作失败"];
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"操作成功"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

/**
 * 启用封禁的用户相应的权限
 */

-(void)enableUse:(NSString *)type{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString string];
    
    url = [NSString stringWithFormat:@"%@%@%@",URL,@"Api/Power/recoverAllUserStatus/method/",type];
    
    NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userID};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //                NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"操作失败"];
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"操作成功"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

/**
 * 删除违规的头像,昵称,签名,相册
 */
-(void)deleteWeiGuiUser:(NSString *)type{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString string];
    
    url = [NSString stringWithFormat:@"%@%@%@",URL,@"Api/Power/delIllegallyUserInfo/type/",type];
    
    NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userID};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //                NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
             [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"操作失败"];
            
        }else{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
             [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"操作成功"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

/**
 * 获取个人资料信息
 */
-(void)createOwnInformationData{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];

    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/getUserInfo"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        parameters = @{@"uid":self.userID,@"lat":[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"],@"lng":[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"],@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
        
    }else{
        
        parameters = @{@"uid":self.userID,@"lat":@"",@"lng":@"",@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    }
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        
        if (integer == 2001) {
            
            self.tableView.scrollEnabled = NO;
            
            self.blackView.hidden = NO;
            self.blackLabel.layer.cornerRadius = 16;
            self.blackLabel.clipsToBounds = YES;
            
            [self showBasicData:responseObject[@"data"] andIsShow:YES];
            
            _headBackView.hidden = NO;
            
            [self.tableView.mj_header endRefreshing];

            UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(0, self.backGroundViewH.constant, WIDTH, HEIGHT - self.backGroundViewH.constant)];
            showView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
            [self.headBackView addSubview:showView];
            
            UIButton *reportButton = [[UIButton alloc] initWithFrame:CGRectMake(20 * WIDTHRADIO, 20 * WIDTHRADIO, WIDTH - 2 * (20 * WIDTHRADIO), 40 * WIDTHRADIO)];
            reportButton.backgroundColor = [UIColor whiteColor];
            [reportButton addTarget:self action:@selector(reportButtonClick) forControlEvents:UIControlEventTouchUpInside];
            reportButton.layer.cornerRadius = reportButton.frame.size.height/2;
            reportButton.clipsToBounds = YES;
            [reportButton setTitle:@"举报" forState:UIControlStateNormal];
            [reportButton setTitleColor:CDCOLOR forState:UIControlStateNormal];
            [showView addSubview:reportButton];
            
            _blackButton = [[UIButton alloc] initWithFrame:CGRectMake(20 * WIDTHRADIO, CGRectGetMaxY(reportButton.frame) + 20 * WIDTHRADIO, WIDTH - 2 * (20 * WIDTHRADIO), 40 * WIDTHRADIO)];
            _blackButton.backgroundColor = [UIColor whiteColor];
            [_blackButton addTarget:self action:@selector(blackButtonClick) forControlEvents:UIControlEventTouchUpInside];
            _blackButton.layer.cornerRadius = _blackButton.frame.size.height/2;
            _blackButton.clipsToBounds = YES;
            
            if ([_blackState intValue] == 1) {
                
                [_blackButton setTitle:@"取消拉黑" forState:UIControlStateNormal];
                
            }else{
                
                [_blackButton setTitle:@"拉黑" forState:UIControlStateNormal];
            }
        
            [_blackButton setTitleColor:CDCOLOR forState:UIControlStateNormal];
            [showView addSubview:_blackButton];
            

        }else if (integer == 2000){
            
            self.blackView.hidden = YES;
            
            [self showBasicData:responseObject[@"data"] andIsShow:NO];
           
            if ([responseObject[@"data"][@"realname"] intValue] == 0) {
                
                self.picPublicButton.hidden = YES;
                
            }else{
                
                self.picPublicButton.hidden = NO;

            }
            
            //认证照的查看权限的设置
            _realpicstate = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"realpicstate"]];
            
            if ([_realpicstate intValue] == 1) {
                
                [self.picPublicButton setBackgroundImage:[UIImage imageNamed:@"个人主页认证照vip可见"] forState:UIControlStateNormal];
                
            }else{
                
                [self.picPublicButton setBackgroundImage:[UIImage imageNamed:@"个人主页认证照未公开"] forState:UIControlStateNormal];
            }
            
            self.attentionLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"follow_num"]];
            
            self.fansLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"fans_num"]];
            
            self.groupLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"group_num"]];
            
            _picArray = responseObject[@"data"][@"photo"];
            
            //创建个人主页个性签名
            [self createOwnInfoSign:responseObject];
            
            //创建个人主页个人相册scroll
            [self createOwnInfoPic:responseObject];
            
            //标签显示
            [self createLabel:self.heightLabel andString:[NSString stringWithFormat:@" 身高: %@ ",responseObject[@"data"][@"tall"]]];
            
            [self createLabel:self.weightLabel andString:[NSString stringWithFormat:@" 体重: %@ ",responseObject[@"data"][@"weight"]]];
            
            [self createLabel:self.starLabel andString:[NSString stringWithFormat:@" 星座: %@ ",responseObject[@"data"][@"starchar"]]];
            
            [self createLabel:self.psexualLabel andString:[NSString stringWithFormat:@" 取向: %@ ",responseObject[@"data"][@"sexual"]]];
            
            [self createLabel:self.contactLabel andString:[NSString stringWithFormat:@" 接触: %@ ",responseObject[@"data"][@"along"]]];
            
            [self createLabel:self.experenceLabel andString:[NSString stringWithFormat:@" 实践: %@ ",responseObject[@"data"][@"experience"]]];

            [self createLabel:self.levelLabel andString:[NSString stringWithFormat:@" 程度: %@ ",responseObject[@"data"][@"level"]]];
            
            [self createLabel:self.wantLabel andString:[NSString stringWithFormat:@" 想找: %@ ",responseObject[@"data"][@"want"]]];
        
            [self createLabel:self.cultureLabel andString:[NSString stringWithFormat:@" 学历: %@ ",responseObject[@"data"][@"culture"]]];
            
            [self createLabel:self.monthLabel andString:[NSString stringWithFormat:@" 月薪: %@ ",responseObject[@"data"][@"monthly"]]];

            
            _mediaStrng = responseObject[@"data"][@"media"];
            
            if ([responseObject[@"data"][@"media"] length] == 0) {
                
                [self.playButton setBackgroundImage:[UIImage imageNamed:@"录音灰"] forState:UIControlStateNormal];
                
                self.playButton.userInteractionEnabled = NO;
                
            }else{
            
                [self.playButton setBackgroundImage:[UIImage imageNamed:@"录音"] forState:UIControlStateNormal];
                
                self.playButton.userInteractionEnabled = YES;
            }
            
            if ([responseObject[@"data"][@"uid"] intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
                
                self.publishButton.hidden = NO;
                
                self.recordButton.hidden = NO;
                
            }else if ([responseObject[@"data"][@"uid"] intValue] != [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]){
            
                self.chatButton.hidden = NO;
                
                self.attentButton.hidden = NO;
                
                self.giveGifButton.hidden = NO;
                
            }
            
            if ([responseObject[@"data"][@"mediaalong"] intValue] == 0) {
                
                self.secondLabel.text = @"";
                
                self.secondW.constant = 0;
                
            }else{
            
                self.secondLabel.text = [NSString stringWithFormat:@"\%@\"",responseObject[@"data"][@"mediaalong"]];
                
                self.secondW.constant = 24;
            }
            
            _followState = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"follow_state"]];
            
            if ([responseObject[@"data"][@"follow_state"] intValue] == 2) {
                
                [self.attentButton setBackgroundImage:[UIImage imageNamed:@"关注好友"] forState:UIControlStateNormal];
                
                _attentStatus = NO;
                
            }else if([responseObject[@"data"][@"follow_state"] intValue] == 1){
                
                [self.attentButton setBackgroundImage:[UIImage imageNamed:@"已关注"] forState:UIControlStateNormal];
                
                _attentStatus = YES;
                
            }else if ([responseObject[@"data"][@"follow_state"] intValue] == 3){
                
                [self.attentButton setBackgroundImage:[UIImage imageNamed:@"互为好友"] forState:UIControlStateNormal];
                
                _attentStatus = YES;
                
            }else if ([responseObject[@"data"][@"follow_state"] intValue] == 4){
                
                [self.attentButton setBackgroundImage:[UIImage imageNamed:@"个人主页被关注"] forState:UIControlStateNormal];
                
                _attentStatus = NO;
            }
            
            self.dateLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"reg_time"]];
            
            [self.dateLabel sizeToFit];
            
            if ([responseObject[@"data"][@"dynamic_num"] intValue] == 0) {
                
                self.totalNumView.hidden = YES;
                
                self.totalNumH.constant = 0;
                
            }else{
                
                self.totalNumView.hidden = NO;

                self.totalNumH.constant = 40;
            
                self.dynamicNumLabel.text = [NSString stringWithFormat:@"发布的动态(%@)",responseObject[@"data"][@"dynamic_num"]];
                
            }
            
            if ([responseObject[@"data"][@"comment_num"] intValue] == 0) {
                
                self.dynamicCommentNumView.hidden = YES;
                
                self.dynamicCommentNumH.constant = 0;
                
                
            }else{
                
                self.dynamicCommentNumView.hidden = NO;
                
                self.dynamicCommentNumH.constant = 40;
                
                self.dynamicCommentNumLabel.text = [NSString stringWithFormat:@"参与的评论(%@)",responseObject[@"data"][@"comment_num"]];
                
            }
        
            //获取礼物的接口
            [self getPersonReceiveGifData];
            
        }else{
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"请求发生错误~"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        
    }];

}

/**
 * 被拉黑时的拉黑某人的按钮点击事件
 */
- (void)blackButtonClick{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString string];
    
    if ([_blackState intValue] == 1) {
        
        url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/cancelBlackState"];
        
    }else{
        
        url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/setOneToBlacklist"];
    }
    
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":self.userID};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //                NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES];
            
            if ([_blackState intValue] == 1) {
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"取消拉黑失败,请重试~"];
                
            }else{
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"拉黑失败,请重试~"];
            }
            
        }else{
            
            if ([_blackState intValue] == 1) {
                
                _blackState = @"0";
                
                if (_blackState != nil) {
                    
                    [_blackButton setTitle:@"拉黑" forState:UIControlStateNormal];
                }

                [[NSNotificationCenter defaultCenter] postNotificationName:@"weilahei" object:nil];
                
            }else{
                
                _blackState = @"1";
                
                if (_blackState != nil) {
                    
                     [_blackButton setTitle:@"取消拉黑" forState:UIControlStateNormal];
                }

                [[NSNotificationCenter defaultCenter] postNotificationName:@"lahei" object:nil];
                
            }
            
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [responseObject objectForKey:@"msg"];
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES];
        
    }];
}

/**
 * 被拉黑时的举报某人的按钮点击事件
 */
- (void)reportButtonClick{
    
    LDReportViewController *rvc = [[LDReportViewController alloc] init];
    
    rvc.reportId = self.userID;
    
    [self.navigationController pushViewController:rvc animated:YES];
}

/**
 * 顶部视图被拉黑与正常的情况均显示数据
 */
-(void)showBasicData:(NSDictionary *)dic andIsShow:(BOOL)show{
    
    //显示隐藏不必要的控件
    self.playButton.hidden = show;
    self.secondLabel.hidden = show;
    self.recordButton.hidden = show;
    self.timeView.hidden = show;
    self.locationView.hidden = show;
    self.cityView.hidden = show;
    self.dateShowLabel.hidden = show;
    self.dateLabel.hidden = show;
    self.picPublicButton.hidden = show;
    
    //分享视图
    _shareView = [[LDShareView alloc] init];
    
    NSString *pic = [NSString string];
    
    if ([dic[@"head_pic"] length] == 0) {
        
        pic = @"http://hao.shengmo.org/nopeople.png";
        
    }else{
        
        pic = dic[@"head_pic"];
    }
    
    [self.navigationController.view addSubview:[_shareView createBottomView:@"Infomation" andNickName:dic[@"nickname"] andPicture:pic andId:self.userID]];
    
    //存储拉黑时的状态
     _blackState = dic[@"black_state"];
    
    //可以用户的设置
    _is_likeliar = [NSString stringWithFormat:@"%@",dic[@"is_likeliar"]];
    
    if ([dic[@"is_likeliar"] intValue] == 1) {
        
        self.tableViewTopY.constant = 40;
        
        if (_likeliarView == nil) {
            
            _likeliarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
            _likeliarView.backgroundColor = [UIColor colorWithHexString:@"#ff3434" alpha:1];
            [self.view addSubview:_likeliarView];
            
            // 调整行间距
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"可疑用户!【自拍认证】后此提醒消失"];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:5];
            UIFont *font = [[UIFont alloc] init];
            if (WIDTH >= 375) {
                
                font = [UIFont systemFontOfSize:15];
                
            }else{
                
                font = [UIFont systemFontOfSize:13];
            }
            
            [attributedString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, [@"可疑用户!【自拍认证】后此提醒消失" length])];
            UILabel *warnLabel = [[UILabel alloc] init];
            warnLabel.attributedText = attributedString;
            [warnLabel sizeToFit];
            warnLabel.frame = CGRectMake((WIDTH -  warnLabel.frame.size.width)/2, 0, warnLabel.frame.size.width, 40);
            warnLabel.textAlignment = NSTextAlignmentCenter;
            warnLabel.textColor = [UIColor whiteColor];
            [_likeliarView addSubview:warnLabel];
            
            [warnLabel yb_addAttributeTapActionWithStrings:@[@"【自拍认证】"] delegate:self];
            
            warnLabel.enabledTapEffect = NO;
            
        }
        
    }else{
        
        if (_likeliarView != nil) {
            
            [_likeliarView removeFromSuperview];
        }
        
        self.tableViewTopY.constant = 0;
    }
    
    
    //展示用户信息的view的设置
    _headUrl = dic[@"head_pic"];
    
    [self.backGroundView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"head_pic"]]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dic[@"head_pic"]]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    self.backGroundView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.backGroundView.clipsToBounds = YES;
    
    self.nameLabel.text = dic[@"nickname"];
    
    CGSize size = [self.nameLabel.text sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    CGSize labelSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    self.nameW.constant = labelSize.width;;
    
    if ([dic[@"realname"] intValue] == 0) {
        
        if ([self.userID intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]){
            
            self.idImageView.image = [UIImage imageNamed:@"认证灰"];
            
            self.idImageView.hidden = NO;
            
            self.idviewW.constant = 19;
            
        }else{
            
            self.idImageView.hidden = YES;
            
            self.idviewW.constant = 0;
        }
        
    }else{
        
        self.idImageView.image = [UIImage imageNamed:@"认证"];
        
        self.idImageView.hidden = NO;
        
        self.idviewW.constant = 19;
    }
    
    if ([dic[@"role"] isEqualToString:@"S"]) {
        
        self.sexualLabel.text = @"斯";
        
        self.sexualLabel.backgroundColor = BOYCOLOR;
        
    }else if ([dic[@"role"] isEqualToString:@"M"]){
        
        self.sexualLabel.text = @"慕";
        
        self.sexualLabel.backgroundColor = GIRLECOLOR;
        
        
    }else if ([dic[@"role"] isEqualToString:@"SM"]){
        
        self.sexualLabel.text = @"双";
        
        self.sexualLabel.backgroundColor = CDCOLOR;
        
    }else{
        
        self.sexualLabel.text = @"~";
        
        self.sexualLabel.backgroundColor = [UIColor colorWithRed:84/255.0 green:185/255.0 blue:36/255.0 alpha:1];
    }
    
    
    if ([dic[@"sex"] intValue] == 1) {
        
        self.sexImageView.image = [UIImage imageNamed:@"男"];
        
        self.backView.backgroundColor = BOYCOLOR;
        
        _signColor = BOYCOLOR;
        
    }else if ([dic[@"sex"] intValue] == 2){
        
        self.sexImageView.image = [UIImage imageNamed:@"女"];
        
        self.backView.backgroundColor = GIRLECOLOR;
        
        _signColor = GIRLECOLOR;
        
    }else{
        
        self.sexImageView.image = [UIImage imageNamed:@"双性"];
        
        self.backView.backgroundColor = CDCOLOR;
        
        _signColor = CDCOLOR;
    }
    
    self.ageLabel.text = [NSString stringWithFormat:@"%@",dic[@"age"]];
    
    //判断获取的时间是不是NSNull,如果是NSNull则显示隐身
    if ([dic[@"last_login_time"] isEqual:[NSNull null]]) {
        
        _lastTime = @"隐身";
        
    }else{
        
        _lastTime = dic[@"last_login_time"];
    }
    
    if ([dic[@"login_time_switch"] intValue] == 0) {
        
        if ([dic[@"timePoorState"] intValue] == 1) {
            
            self.timeLabel.text = _lastTime;
            
        }else{
            
            self.timeLabel.text = @"查看时间";
            
            [_lookTimeButton addTarget:self action:@selector(lookTimeButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }else{
        
        self.timeLabel.text = @"隐身";
    }
    
    self.timeW.constant = 18 + [self fitLabelWidth:self.timeLabel.text].width;
    
    self.locationLabel.text = [NSString stringWithFormat:@"%@",dic[@"distance"]];
    
    self.locationW.constant = 18 + [self fitLabelWidth:self.locationLabel.text].width;
    
    if (show == NO) {
        
        if ([self.locationLabel.text isEqualToString:@"隐身"]) {
            
            self.cityView.hidden = YES;
            
        }else{
            
            if ([dic[@"city"] length] == 0) {
                
                if ([dic[@"province"] length] == 0) {
                    
                    self.cityView.hidden = YES;
                    
                }else{
                    
                    self.cityView.hidden = NO;
                    
                    self.cityLabel.text = [NSString stringWithFormat:@"%@",dic[@"province"]];
                }
                
            }else{
                
                self.cityView.hidden = NO;
                
                if ([dic[@"province"] length] == 0) {
                    
                    self.cityLabel.text = [NSString stringWithFormat:@"%@",dic[@"city"]];
                    
                }else{
                    
                    if ([dic[@"province"] isEqualToString:dic[@"city"]]) {
                        
                        self.cityLabel.text = [NSString stringWithFormat:@"%@",dic[@"province"]];
                        
                    }else{
                        
                        self.cityLabel.text = [NSString stringWithFormat:@"%@ %@",dic[@"province"],dic[@"city"]];
                    }
                }
            }
        }
        
        self.cityW.constant = 18 + [self fitLabelWidth:self.cityLabel.text].width;
    }
    
    if ([dic[@"is_volunteer"] intValue] == 1) {
        
        _vipTypeString = @"is_volunteer";
        
        self.vipView.hidden = NO;
        
        self.vipView.image = [UIImage imageNamed:@"志愿者标识"];
        
    }else if ([dic[@"is_admin"] intValue] == 1) {
        
        _vipTypeString = @"is_admin";
        
        self.vipView.hidden = NO;
        
        self.vipView.image = [UIImage imageNamed:@"官方认证"];
        
    }else{
        
        if ([dic[@"svipannual"] intValue] == 1) {
            
            _vipTypeString = @"";
            
            self.vipView.hidden = NO;
            
            self.vipView.image = [UIImage imageNamed:@"年svip标识"];
            
        }else if ([dic[@"svip"] intValue] == 1){
            
            _vipTypeString = @"";
            
            self.vipView.hidden = NO;
            
            self.vipView.image = [UIImage imageNamed:@"svip标识"];
            
        }else if ([dic[@"vipannual"] intValue] == 1) {
            
            _vipTypeString = @"";
            
            self.vipView.hidden = NO;
            
            self.vipView.image = [UIImage imageNamed:@"年费会员"];
            
        }else{
            
            if ([dic[@"vip"] intValue] == 1) {
                
                _vipTypeString = @"";
                
                self.vipView.hidden = NO;
                
                self.vipView.image = [UIImage imageNamed:@"高级紫"];
                
            }else{
                
                _vipTypeString = @"";
                
                self.vipView.image = [UIImage imageNamed:@"高级灰"];
                
            }
        }
    }
    
    if ([dic[@"onlinestate"] intValue] == 0) {
        
        self.onlineView.hidden = YES;
        
    }else{
        
        self.onlineView.hidden = NO;
    }
    
    //获取展示的财富值和魅力值
    [self getWealthAndCharmState:_wealthLabel andView:_wealthView andText:dic[@"wealth_val"] andNSLayoutConstraint:_wealthW andType:@"财富"];
    
    [self getWealthAndCharmState:_charmLabel andView:_charmView andText:dic[@"charm_val"] andNSLayoutConstraint:_charmW andType:@"魅力"];
}

/**
 * 点击认证照公开不公开按钮
 */
- (IBAction)picPublicButtonClick:(id)sender {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] == [self.userID intValue]) {
        
        //获取用户认证头像
        [self getUserCodePic];
        
    }else{
        
        if ([_realpicstate intValue] == 1) {
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1) {
                
                //获取用户认证头像
                [self getUserCodePic];
                
            }else{
                
                //提示用户去开通VIP
                [self createUpdateVIP:@"认证照限VIP会员可见"];
            }
            
        }else{
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"该用户未公开认证照~"];
            
        }
    }
}

/**
 * 获取用户的认证头像
 */
-(void)getUserCodePic{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Other/getidstate"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    parameters = @{@"uid":self.userID};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //        NSLog(@"%@",responseObject);
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (integer == 2000) {
            
            [XWScanImage scanBigImageWithUrl:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"card_face"]]];
            
        }else{
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"发生错误,请稍后再试~"];

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"%@",error);
        
    }];
}

/**
 * 创建个人主页个性签名
 */
-(void)createOwnInfoSign:(NSDictionary *)responseObject{
    
    CGFloat introduceLabelH = 50;
    CGFloat extraH = 25;
    //如果是查看自己的信息,无自我介绍时显示编辑签名
    if ([responseObject[@"data"][@"uid"] intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        
        if ([responseObject[@"data"][@"introduce"] length] == 0) {
            
            self.introduceLabel.text = @"";
            
            if (_addSignButton == nil) {
                
                _addSignButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.introduceLabel.frame.size.width, introduceLabelH)];
                
                [_addSignButton setTitle:@"编辑个性签名" forState:UIControlStateNormal];
                
                _addSignButton.titleLabel.font = [UIFont systemFontOfSize:13];
                
                [_addSignButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                
                [_addSignButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
                
                UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(self.introduceLabel.frame.size.width/2 - 53, 20, 10, 10)];
                
                img.image = [UIImage imageNamed:@"编辑个性签名"];
                
                [_addSignButton addSubview:img];
                
                [_introduceLabel addSubview:_addSignButton];
                
            }else{
                
                _addSignButton.hidden = NO;
                
                self.introduceH.constant = introduceLabelH;
            }
            
        }else{
            
            if (_addSignButton != nil) {
                
                _addSignButton.hidden = YES;
            }
            
            self.introduceLabel.text = responseObject[@"data"][@"introduce"];
            
            [self.introduceLabel sizeToFit];
            
            if (self.introduceLabel.frame.size.height + extraH <= introduceLabelH) {
                
                self.introduceH.constant = introduceLabelH;
                
            }else{
                
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.introduceLabel.text];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:5];
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.introduceLabel.text length])];
                self.introduceLabel.attributedText = attributedString;
                
                self.introduceLabel.isCopyable = YES;
                
                self.introduceLabel.lineBreakMode = NSLineBreakByWordWrapping;
                
                [self.introduceLabel sizeToFit];
                
                self.introduceH.constant = self.introduceLabel.frame.size.height + extraH + 20;
                
            }
        }
    }else{
        
        if (_addSignButton != nil) {
            
            _addSignButton.hidden = YES;
        }
        
        if ([responseObject[@"data"][@"introduce"] length] == 0){
            
            self.introduceH.constant = 0;
            
            self.introduceWarnH.constant = 0;
            
            self.introduceTopLineH.constant = 0;
            
            self.introduceTopLineLabel.hidden = YES;
            
        }else{
            
            self.introduceTopLineH.constant = 25;
            
            self.introduceTopLineLabel.hidden = NO;
            
//            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1 || [responseObject[@"data"][@"follow_state"] intValue] == 3 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"realname"] intValue] == 1) {
            
            self.introduceWarnLabel.hidden = YES;
            
            self.introduceLabel.text = responseObject[@"data"][@"introduce"];
            
            [self.introduceLabel sizeToFit];
                
            if (self.introduceLabel.frame.size.height + extraH <= introduceLabelH) {
                
                self.introduceH.constant = introduceLabelH;
                
            }else{
                
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.introduceLabel.text];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setLineSpacing:5];
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.introduceLabel.text length])];
                self.introduceLabel.attributedText = attributedString;
                
                self.introduceLabel.isCopyable = YES;
                
                self.introduceLabel.lineBreakMode = NSLineBreakByWordWrapping;
                
                [self.introduceLabel sizeToFit];
                
                self.introduceH.constant = self.introduceLabel.frame.size.height + extraH + 20;
                
            }
                
//            }else{
//
//                self.introduceH.constant = introduceLabelH;
//
//                self.introduceWarnH.constant = introduceLabelH;
//
//                self.introduceWarnLabel.hidden = NO;
//
//                self.introduceLabel.text = @"";
//
//                // 调整行间距
//                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.introduceWarnLabel.text];
//                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//                [paragraphStyle setLineSpacing:0];
//                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.introduceWarnLabel.text length])];
//                [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [self.introduceWarnLabel.text length])];
//                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1] range:NSMakeRange(5, 4)];
//                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1] range:NSMakeRange(10, 4)];
//                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1] range:NSMakeRange(15, 5)];
//                self.introduceWarnLabel.attributedText = attributedString;
//
//                [self.introduceWarnLabel yb_addAttributeTapActionWithStrings:@[@"互为好友",@"VIP会员",@"认证用户"] delegate:self];
//                self.introduceWarnLabel.enabledTapEffect = NO;
//
//            }
        }
    }
    
    self.introduceLabel.frame = CGRectMake(self.introduceLabel.frame.origin.x, self.introduceLabel.frame.origin.y, self.introduceLabel.frame.size.width, self.introduceH.constant);
}

/**
 * 创建个人主页个人相册scroll
 */
-(void)createOwnInfoPic:(NSDictionary *)responseObject{
    
    CGFloat bothPicSpace = 6;
    int picScrollH = (WIDTH - 3 * bothPicSpace)/3.5;
    CGFloat picViewH = picScrollH + 4 * bothPicSpace;
    CGFloat picScrollY = (picViewH - picScrollH)/2;

    
    if (_scrollView == nil) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, picScrollY, WIDTH, picScrollH)];
        
        [_picBackView addSubview:_scrollView];
    }

    for (UIImageView *view in _scrollView.subviews) {
        
        if ([view isKindOfClass:[UIImageView class]]) {
            
            [view removeFromSuperview];
        }
    }
    
    //如果是自己查看自己的资料可以添加图片
    if ([responseObject[@"data"][@"uid"] intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        
        if ([responseObject[@"data"][@"photo"] count] == 0) {
            
            self.picH.constant = picViewH + self.introduceTopLineH.constant;
            
            UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, picScrollH, picScrollH)];
            
            [addButton setBackgroundImage:[UIImage imageNamed:@"添加图片"] forState:UIControlStateNormal];
            
            [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
            
            [_scrollView addSubview:addButton];
            
        }else{
            
            _lock = responseObject[@"data"][@"photo_lock"];
            
            self.picH.constant = picViewH + self.introduceTopLineH.constant;
            
            _scrollView.contentSize = CGSizeMake(picScrollH * [responseObject[@"data"][@"photo"] count] + bothPicSpace * ([responseObject[@"data"][@"photo"] count] - 1), picScrollH);
            
            [self createShowPicView:responseObject[@"data"][@"photo"] andPicScrollH:picScrollH andBothPicSpace:bothPicSpace andType:1];
        }
        
    }else{
        
        if ([responseObject[@"data"][@"photo"] count] == 0) {
            
            self.picH.constant = self.introduceTopLineH.constant;
            
        }else{
            
            _lock = responseObject[@"data"][@"photo_lock"];
            
            self.picH.constant = picViewH + self.introduceTopLineH.constant;
            
            _scrollView.contentSize = CGSizeMake(picScrollH * [responseObject[@"data"][@"photo"] count] + bothPicSpace * ([responseObject[@"data"][@"photo"] count] - 1), picScrollH);
            
            [self createShowPicView:responseObject[@"data"][@"photo"] andPicScrollH:picScrollH andBothPicSpace:bothPicSpace andType:2];
        }
    }
}
/**
 * 创建个人主页个人相册的展示
 */
-(void)createShowPicView:(NSArray *)picArray andPicScrollH:(int)picScrollH andBothPicSpace:(CGFloat)bothPicSpace andType:(int)type{
    
    for (int i = 0; i < picArray.count; i++) {
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(picScrollH * i + bothPicSpace * i, 0, picScrollH, picScrollH)];
        
        [img sd_setImageWithURL:[NSURL URLWithString:picArray[i]] placeholderImage:[UIImage imageNamed:@"动态图片默认"] ];
        
        img.userInteractionEnabled = YES;
        
        img.tag = 10 + i;
        
        img.contentMode = UIViewContentModeScaleAspectFill;
        
        img.clipsToBounds = YES;
        
        if (type == 2) {
            
            /**
             *  创建需要的毛玻璃特效类型
             */
            UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            /**
             *  毛玻璃view 视图
             */
            UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            effectView.frame = img.bounds;
            [img addSubview:effectView];
            
            effectView.alpha = .92f;
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPic:)];
        
        [img addGestureRecognizer:tap];
        
        [_scrollView addSubview:img];
    }
}

#pragma 富文本文字点击delegate
- (void)yb_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index
{
    
    if ([string isEqualToString:@"VIP会员"]){
        
        LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
        
        [self.navigationController pushViewController:mvc animated:YES];
        
    }else if ([string isEqualToString:@"互为好友"]){
        
        [self attentButtonClickState:_attentStatus];
        
    }else if([string isEqualToString:@"认证用户"] || [string isEqualToString:@"【自拍认证】"]){
    
        //判断用户是否是认证用户
        [self createRealNameState];
        
    }else if ([string isEqualToString:@"【绑定手机】"]){
        
        LDBindingPhoneNumViewController *bpnc = [[LDBindingPhoneNumViewController alloc] init];
        
        [self.navigationController pushViewController:bpnc animated:YES];
        
    }
}

/**
 * 财富值/魅力值的自适应及展示
 */
-(void)getWealthAndCharmState:(UILabel *)label andView:(UIView *)backView  andText:(NSString *)text andNSLayoutConstraint:(NSLayoutConstraint *)constraint andType:(NSString *)type{
    
    if ([type isEqualToString:@"财富"]) {
        
        if ([text intValue] == 0) {
            
            self.wealthSpace.constant = 0;
            
            backView.hidden = YES;
            
            constraint.constant = 0;
            
        }else{
            
            self.wealthSpace.constant = 5;
            
            backView.hidden = NO;
            
            label.text = [NSString stringWithFormat:@"%@",text];
            label.textColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1];
            backView.layer.borderColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1].CGColor;
            
            constraint.constant = 27 + [self fitLabelWidth:label.text].width;
        }
        
    }else{
        
        if ([text intValue] == 0) {
            
            backView.hidden = YES;
            
        }else{
            
            backView.hidden = NO;
            
            label.text = [NSString stringWithFormat:@"%@",text];
            label.textColor = [UIColor colorWithRed:245/255.0 green:102/255.0 blue:132/255.0 alpha:1];
            backView.layer.borderColor = [UIColor colorWithRed:245/255.0 green:102/255.0 blue:132/255.0 alpha:1].CGColor;
            
            constraint.constant = 27 + [self fitLabelWidth:label.text].width;
        }
    }
    
    backView.layer.borderWidth = 1;
    backView.layer.cornerRadius = 2;
    backView.clipsToBounds = YES;
}

/**
 * 获取个人收到的礼物列表,并计算头视图的高度
 */
-(void)getPersonReceiveGifData{
    
    NSArray *colorArray = @[@"握手紫",@"黄瓜紫",@"玫瑰紫",@"送吻紫",@"红酒紫",@"对戒紫",@"蛋糕紫",@"跑车紫",@"游轮紫" ,@"棒棒糖",@"狗粮",@"秋裤",@"黄瓜",@"心心相印",@"香蕉",@"口红",@"亲一个",@"玫瑰花",@"眼罩",@"心灵束缚",@"黄金",@"拍之印",@"鞭之痕",@"老司机",@"一生一世",@"水晶高跟",@"恒之光",@"666",@"红酒",@"蛋糕",@"钻戒",@"皇冠",@"跑车",@"直升机",@"游轮",@"城堡",@"幸运草",@"糖果",@"玩具狗",@"内内",@"TT"];
    
    NSArray *amountArray = @[@"7",@"35",@"70",@"350",@"520",@"700",@"1888",@"2888",@"3888",@"2",@"6",@"10",@"38",@"99",@"88",@"123",@"166",@"199",@"520",@"666",@"250",@"777",@"888",@"999",@"1314",@"1666",@"1999",@"666",@"999",@"1888",@"2899",@"3899",@"6888",@"9888",@"52000",@"99999",@"1",@"3",@"5",@"10",@"8"];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Users/getMyPresent"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    parameters = @{@"uid":self.userID};
    //NSLog(@"%@",parameters);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//                NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            if (integer == 4001) {
                
                self.gifView.hidden = YES;
                self.gifNumW.constant = 0;
                
            }else{
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            }
            
        }else{
            
            if (_picArray.count == 0 && [self.userID intValue] != [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
                
                self.picH.constant = self.introduceTopLineH.constant + 10;
            }
            
            self.gifNumW.constant = 70;
            
            self.gifView.hidden = NO;
            
            self.gifNumLabel.text = [NSString stringWithFormat:@"%@份",responseObject[@"data"][@"allnum"]];
            
            NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self.gifNumLabel.text];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1] range:NSMakeRange(0,[responseObject[@"data"][@"allnum"] length])];
            _gifNumLabel.attributedText = attributedStr;
            
            //对数组进行排序
            NSArray *result = [responseObject[@"data"][@"giftArr"] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                
                int number1;
                int number2;
                
                if (colorArray.count >= [obj1[@"type"] intValue]) {
                    
                    number1 = [amountArray[[obj1[@"type"] intValue] - 1] intValue];
                    
                }else{
                
                    number1 = 0;
                }
                
                if (colorArray.count >= [obj2[@"type"] intValue]) {
                    
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
            
            if ([result count] <= 4) {
                
                for (int i = 0; i < [result count]; i++) {
                    
                    UIImageView *gifImageView = (UIImageView *)[_gifView viewWithTag:1000 + i];
                    
                    if (colorArray.count >= [result[i][@"type"] intValue]) {
                        
                        gifImageView.image = [UIImage imageNamed:colorArray[[result[i][@"type"] intValue] - 1]];
                        
                    }else{
                        
                        gifImageView.image = [UIImage imageNamed:@"未知礼物"];
                    }
                    
                }
            }else{
                
                for (int i = 0; i < 4; i++) {
                    
                    UIImageView *gifImageView = (UIImageView *)[_gifView viewWithTag:1000 + i];
                    
                    if (colorArray.count >= [result[i][@"type"] intValue]) {
                        
                        gifImageView.image = [UIImage imageNamed:colorArray[[result[i][@"type"] intValue] - 1]];
                        
                    }else{
                        
                        gifImageView.image = [UIImage imageNamed:@"未知礼物"];
                    }
                }
            }
        }
        
        _headBackView.hidden = NO;
        
        [self.tableView.mj_header endRefreshing];
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            self.headBackView.frame = CGRectMake(0, 0, WIDTH, CGRectGetMaxY(self.dynamicCommentNumView.frame));
            
            self.tableView.tableHeaderView = self.headBackView;
            
        });
        
        if (!_isRecord) {
            
            //判定是否写入记录
            [self recordComerData];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

/**
 * 写入浏览记录
 */
-(void)recordComerData{
    
    _isRecord = YES;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"writeVisitRecord"] length] != 0){
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSTimeInterval interval = - [[formatter dateFromString:[[NSUserDefaults standardUserDefaults] objectForKey:@"writeVisitRecord"]] timeIntervalSinceNow];
        
        if (interval >= 5) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"writeVisitRecord"];
        }
        
    }else{
        
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"api/friend/writeVisitRecord"];
        
        NSDictionary *parameters = @{@"login_uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"uid":self.userID};
        
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
            
            //NSLog(@"%@",responseObject);
            
            if (integer == 2000) {
                
                NSDate *date = [NSDate date];
                
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                
                [[NSUserDefaults standardUserDefaults] setObject:[formatter stringFromDate:date] forKey:@"writeVisitRecord"];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
    }
}

/**
 * 点击参与的评论跳转到相应的列表
 */
- (IBAction)dynamicCommentButtonClick:(id)sender {
    
    LDOwnInfoDynamicCommentViewController *info = [[LDOwnInfoDynamicCommentViewController alloc] init];
    
    info.personUid = self.userID;
    
    info.attentStatus = _attentStatus;
    
    info.navigationItem.title = self.nameLabel.text;
    
    [self.navigationController pushViewController:info animated:YES];
    
}
/**
 * 点击发布的动态跳转到相应的列表
 */
- (IBAction)ownInfoDynamicButtonClick:(id)sender {
    
    LDownInfoDynamicViewController *dvc = [[LDownInfoDynamicViewController alloc] init];
    
    dvc.personUid = self.userID;
    
    dvc.attentStatus = _attentStatus;
    
    dvc.navigationItem.title = self.nameLabel.text;
    
    [self.navigationController pushViewController:dvc animated:YES];
}

//获取并剪裁标签
-(void)createLabel:(UILabel *)label andString:(NSString *)str{
    
    label.text = str;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = _signColor;
    [label sizeToFit];
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, 24);
    label.layer.cornerRadius = 2;
    label.clipsToBounds = YES;
}

//查看个人资料时如果没有照片显示添加照片按钮
-(void)addButtonClick{

    LDEditViewController *evc = [[LDEditViewController alloc] init];
    
    evc.userID = self.userID;
    
    [self.navigationController pushViewController:evc animated:YES];
}

//判断是否是会员,是会员查看时间,不是提示
-(void)lookTimeButtonClick{

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1) {
        
        self.timeLabel.text = _lastTime;
        
    }else{
        
        //提示用户去开通VIP
        [self createUpdateVIP:@"登录时间限VIP会员可见"];
    }
}

/**
 * 提示用户去开通Vip
 */
-(void)createUpdateVIP:(NSString *)titleString{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:titleString    preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * action = [UIAlertAction actionWithTitle:@"开通VIP" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        
        LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
        
        [self.navigationController pushViewController:mvc animated:YES];
        
        
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
    
    [alert addAction:cancelAction];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:nil];

}

//label的宽度自适应
-(CGSize)fitLabelWidth:(NSString *)string{

    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.0]}];
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    CGSize labelSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    return labelSize;

}

#pragma 点击关注按钮
- (IBAction)attentButtonClick:(id)sender {

    [self attentButtonClickState:_attentStatus];
    
}

#pragma 点击认证图标
- (IBAction)idTapClick:(id)sender {
        
    //判断用户是否是认证用户
    [self createRealNameState];

}

/**
 * 判断用户是否是认证用户
 */
-(void)createRealNameState{

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
            
            LDCertificateBeforeViewController *cvc = [[LDCertificateBeforeViewController alloc] init];
            
            cvc.where = @"2";
            
            [self.navigationController pushViewController:cvc animated:YES];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (IBAction)vipButtonClick:(id)sender {
    
    if ([_vipTypeString isEqualToString:@"is_volunteer"]) {
        
        LDShengMoViewController *mvc = [[LDShengMoViewController alloc] init];
        
        mvc.name = @"志愿者";
        
        mvc.type = @"2";
        
        [self.navigationController pushViewController:mvc animated:YES];
        
    }else if ([_vipTypeString isEqualToString:@"is_admin"]){
        
        LDShengMoViewController *mvc = [[LDShengMoViewController alloc] init];
        
        mvc.name = @"全职招聘";
        
        mvc.type = @"1";
        
        [self.navigationController pushViewController:mvc animated:YES];
    }else{
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] == [self.userID intValue]) {
            
            LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
            
            [self.navigationController pushViewController:mvc animated:YES];
            
        }else{
            
            LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
            
            mvc.type = @"give";
            
            mvc.headUrl = self.headUrl;
            
            mvc.userID = self.userID;
            
            [self.navigationController pushViewController:mvc animated:YES];
        }
    }
}

//点击聊天
- (IBAction)chatButtonClick:(id)sender {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"ableOrDisable"] intValue] == 0 && [[[NSUserDefaults standardUserDefaults] objectForKey:@"ableOrDisable"] length] != 0) {
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"您因违规被系统禁用聊天功能,解封时间请查看系统通知,如有疑问请与客服联系~"];
        
    }else{
    
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 10.f;
        
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Restrict/getOpenChatRestrictSvip"];
        
        NSDictionary *parameters = [NSDictionary dictionary];
        
        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"otheruid":self.userID};
        
        //    NSLog(@"%@",parameters);
        
        [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
            
            //        NSLog(@"%@",responseObject);
            
            if (integer == 2000 || integer == 2001) {
                
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                
                PersonChatViewController *conversationVC = [[PersonChatViewController alloc]init];
                [RCIM sharedRCIM].globalConversationAvatarStyle=RC_USER_AVATAR_CYCLE;
                [RCIM sharedRCIM].globalMessageAvatarStyle=RC_USER_AVATAR_CYCLE;
                conversationVC.conversationType = ConversationType_PRIVATE;
                conversationVC.targetId = self.userID;
                conversationVC.mobile = self.userID;
                
                if (integer == 2000) {
                    
                    conversationVC.state = [NSString stringWithFormat:@"%d",[responseObject[@"data"][@"filiation"] intValue]];
                }
                
                if ([responseObject[@"data"][@"svip"] integerValue] == 1) {
                    
                    conversationVC.type = personIsSVIP;
                    
                }else if ([responseObject[@"data"][@"vip"] integerValue] == 1){
                    
                    conversationVC.type = personIsVIP;
                    
                }else{
                    
                    conversationVC.type = personIsNormal;
                }
                
                conversationVC.title = self.nameLabel.text;
                [self.navigationController pushViewController:conversationVC animated:YES];
               
            }else if(integer == 3001){
                
                 [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                    
                _stampView = [[LDStampChatView alloc] initWithFrame:CGRectMake(0, 0 , WIDTH, HEIGHT)];
                
                _stampView.viewController = self;
                
                _stampView.data = responseObject[@"data"];
                
                _stampView.delegate = self;
                
                [self.navigationController.view addSubview:_stampView];
                
            }else{
                
                 [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
        }];
    }
}

#pragma  stampChat的代理方法
-(void)didSelectStamp:(NSString *)stamptype{

    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 10.f;
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Restrict/useStampToChat"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    //NSLog(@"%@",stamptype);
    
    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"otheruid":self.userID,@"stamptype":stamptype};
    
    //    NSLog(@"%@",parameters);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//                NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
            if (integer == 4001 || integer == 3000) {
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];

            }else{
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"发生错误,请稍后再试~"];
            }
            
        }else if(integer == 2000){
            
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
            PersonChatViewController *conversationVC = [[PersonChatViewController alloc]init];
            [RCIM sharedRCIM].globalConversationAvatarStyle=RC_USER_AVATAR_CYCLE;
            [RCIM sharedRCIM].globalMessageAvatarStyle=RC_USER_AVATAR_CYCLE;
            conversationVC.conversationType = ConversationType_PRIVATE;
            conversationVC.targetId = self.userID;
            conversationVC.mobile = self.userID;
            conversationVC.state = [NSString stringWithFormat:@"%d",[responseObject[@"data"] intValue]];
            conversationVC.title = self.nameLabel.text;
            [self.navigationController pushViewController:conversationVC animated:YES];

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }];
}

#pragma 选择邮票聊天界面的代理
-(void)didSelectOtherButton{

    LDStampViewController *wvc = [[LDStampViewController alloc] init];
    
    [self.navigationController pushViewController:wvc animated:YES];
}

-(void)didSelectAttentButton:(UIView *)backView andButton:(UIButton *)button{

    _url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/followOneBox"];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:backView animated:YES];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":self.userID};
    
    [manager POST:_url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
        //NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES];
            
            button.userInteractionEnabled = NO;
            
            if (integer == 4787 || integer == 4002) {
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"已关注对方,请不要重复操作~"];
                
                
            }else{
                
                [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
                
            }
            
        }else{
            
            if (_attentStatus) {
                
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [responseObject objectForKey:@"msg"];
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:3];
                
                if ([responseObject[@"data"] intValue] == 0){
                    
                    [self.attentButton setBackgroundImage:[UIImage imageNamed:@"关注好友"] forState:UIControlStateNormal];
                    
                }else{
                    
                    [self.attentButton setBackgroundImage:[UIImage imageNamed:@"个人主页被关注"] forState:UIControlStateNormal];
                }

                self.fansLabel.text = [NSString stringWithFormat:@"%d",[self.fansLabel.text intValue] - 1];
                
                _attentStatus = NO;
                
            }else{
                
                if ([responseObject[@"data"] intValue] == 1) {
                    
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"已互为好友，可以免费无限畅聊了~";
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:3];
                    
                    [self.attentButton setBackgroundImage:[UIImage imageNamed:@"互为好友"] forState:UIControlStateNormal];
                    
                }else{
                    
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"已关注成功！互为好友即可免费畅聊~";
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:3];
                    [self.attentButton setBackgroundImage:[UIImage imageNamed:@"已关注"] forState:UIControlStateNormal];
                }
                
                self.fansLabel.text = [NSString stringWithFormat:@"%d",[self.fansLabel.text intValue] + 1];
                
                _attentStatus = YES;
                
                [button setTitle:@"已关注" forState:UIControlStateNormal];
                
                button.userInteractionEnabled = NO;
                
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        button.userInteractionEnabled = NO;
        
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES];
        
    }];

}

//点击去开通按钮跳转到会员页面
-(void)stampOpenSvipButtonClick{
    
    LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
    
    [self.navigationController pushViewController:mvc animated:YES];
}

//关注按钮
-(void)attentButtonClickState:(BOOL)state{

    if (state) {
        
        _url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/overfollow"];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否取消关注此人"    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [self blackData];
        }];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
        
        if (PHONEVERSION.doubleValue >= 8.3) {
        
            [action setValue:CDCOLOR forKey:@"_titleTextColor"];
            
            [cancelAction setValue:CDCOLOR forKey:@"_titleTextColor"];
        }
        
        [alert addAction:action];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];

        
    }else{
    
        _url = [NSString stringWithFormat:@"%@%@",URL,@"Api/friend/followOneBox"];
            
        [self blackData];
    }
}

//查看加入的群组
- (IBAction)groupButtonClick:(id)sender {
    
    if ([self.userID intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        
        LDGroupNumberViewController *nvc = [[LDGroupNumberViewController alloc] init];
        
        nvc.userId = self.userID;
        
        [self.navigationController pushViewController:nvc animated:YES];
        
    }else{
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1 || [_followState intValue] == 3 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"realname"] intValue] == 1) {
            
            LDGroupNumberViewController *nvc = [[LDGroupNumberViewController alloc] init];
            
            nvc.userId = self.userID;
            
            [self.navigationController pushViewController:nvc animated:YES];
            
        }else{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"群组限互为好友/认证用户/VIP会员可见~"    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * addFriendAction = [UIAlertAction actionWithTitle:@"加好友" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                
                [self attentButtonClickState:_attentStatus];
                
            }];
            
            UIAlertAction * vipAction = [UIAlertAction actionWithTitle:@"开通VIP" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                
                LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
                
                [self.navigationController pushViewController:mvc animated:YES];
                
            }];
            
            UIAlertAction * realNameAction = [UIAlertAction actionWithTitle:@"免费认证" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                
                //判断用户是否认证
                [self createRealNameState];
                
            }];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
            
            if (PHONEVERSION.doubleValue >= 8.3) {
                
                [action setValue:[UIColor lightGrayColor] forKey:@"_titleTextColor"];
                
                [vipAction setValue:CDCOLOR forKey:@"_titleTextColor"];
                
                [addFriendAction setValue:CDCOLOR forKey:@"_titleTextColor"];
                
                [realNameAction setValue:CDCOLOR forKey:@"_titleTextColor"];
            }
            
            
            [alert addAction:action];
            [alert addAction:addFriendAction];
            [alert addAction:realNameAction];
            [alert addAction:vipAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

-(void)blackData{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];

    NSDictionary *parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"fuid":self.userID};
    
    [manager POST:_url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//       NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES];
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:[responseObject objectForKey:@"msg"]];
            
        }else{
            
            if (_attentStatus) {
                
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [responseObject objectForKey:@"msg"];
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:3];
                
                if ([responseObject[@"data"] intValue] == 0){
                    
                    [self.attentButton setBackgroundImage:[UIImage imageNamed:@"关注好友"] forState:UIControlStateNormal];
                    
                }else{
                    
                    [self.attentButton setBackgroundImage:[UIImage imageNamed:@"个人主页被关注"] forState:UIControlStateNormal];
                }
                
                self.fansLabel.text = [NSString stringWithFormat:@"%d",[self.fansLabel.text intValue] - 1];
                
                _attentStatus = NO;
                
            }else{
                
                if ([responseObject[@"data"] intValue] == 1) {
                    
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"已互为好友，可以免费无限畅聊了~";
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:3];
                    
                    [self.attentButton setBackgroundImage:[UIImage imageNamed:@"互为好友"] forState:UIControlStateNormal];
                    
                }else{
                
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"已关注成功！互为好友即可免费畅聊~";
                    hud.removeFromSuperViewOnHide = YES;
                    [hud hide:YES afterDelay:3];

                    [self.attentButton setBackgroundImage:[UIImage imageNamed:@"已关注"] forState:UIControlStateNormal];
                }
                
                self.fansLabel.text = [NSString stringWithFormat:@"%d",[self.fansLabel.text intValue] + 1];
                
                _attentStatus = YES;
                
            }  
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        hud.removeFromSuperViewOnHide = YES;
        
        [hud hide:YES];
        
    }];
}

-(void)createPasswordView:(NSInteger)imgTag{

    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _backgroundView.backgroundColor = [UIColor clearColor];
    _backgroundView.layer.cornerRadius = 2;
    _backgroundView.clipsToBounds = YES;
    [self.navigationController.view addSubview:_backgroundView];
    
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    shadowView.backgroundColor = [UIColor blackColor];
    shadowView.alpha = 0.35;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
    [shadowView addGestureRecognizer:tap];
    [_backgroundView addSubview:shadowView];
    
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake(50, HEIGHT/2 - 60, WIDTH - 100, 120)];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 2;
    alertView.clipsToBounds = YES;
    [_backgroundView addSubview:alertView];
    
    _passwordField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, WIDTH - 120, 35)];
    _passwordField.placeholder = @"请输入相册密码";
    _passwordField.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    _passwordField.font = [UIFont systemFontOfSize:14];
    _passwordField.delegate = self;
    [alertView addSubview:_passwordField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 75, WIDTH - 100, 1)];
    
    lineView.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    
    [alertView addSubview:lineView];
    
    UIButton *alertButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 80, WIDTH - 100, 35)];
    
    [alertButton addTarget:self action:@selector(alertButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    alertButton.tag = imgTag;
    
    [alertButton setTitle:@"确定" forState:UIControlStateNormal];
    
    [alertButton setTitleColor:CDCOLOR forState:UIControlStateNormal];
    
    [alertView addSubview:alertButton];
}

//收回键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    
    return YES;
}

-(void)alertButtonClick:(UIButton *)button{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/users/chargePhotoPwd"];
    
    NSDictionary *parameters = @{@"uid":self.userID,@"photo_pwd":_passwordField.text};
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
        
//                NSLog(@"%@",responseObject);
        
        if (integer != 2000) {
            
            [_backgroundView removeFromSuperview];
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"密码错误"    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"重试" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                
                [self createPasswordView:button.tag];
            }];
            
             UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault  handler:nil];
            
            if (PHONEVERSION.doubleValue >= 8.3) {
            
                [action setValue:CDCOLOR forKey:@"_titleTextColor"];
                
                [cancelAction setValue:CDCOLOR forKey:@"_titleTextColor"];
                
            }

            [alert addAction:action];
            
            [alert addAction:cancelAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{
            
            [_backgroundView removeFromSuperview];
            
            __weak typeof(self) weakSelf=self;
            
            [ImageBrowserViewController show:self type:PhotoBroswerVCTypeModal index:button.tag - 10 imagesBlock:^NSArray *{
                
                return weakSelf.picArray;
            }];

        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"因网络等原因修改失败"    preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
            
            [_backgroundView removeFromSuperview];
        }];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }];

}

-(void)cancelClick{
    
    [_passwordField resignFirstResponder];

    [_backgroundView removeFromSuperview];
}

-(void)tapPic:(UITapGestureRecognizer *)tap{
    
    if ([self.userID intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        
        UIImageView *img = (UIImageView *)tap.view;
        
        __weak typeof(self) weakSelf = self;
        
        [ImageBrowserViewController show:self type:PhotoBroswerVCTypeModal index:img.tag - 10 imagesBlock:^NSArray *{
            
            return weakSelf.picArray;
        }];

    }else{
    
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1 || [_followState intValue] == 3 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"is_admin"] intValue] == 1) {
            
            if ([_lock intValue] == 2) {
                
                UIImageView *img = (UIImageView *)tap.view;
                
                [self createPasswordView:img.tag];
                
            }else{
            
                UIImageView *img = (UIImageView *)tap.view;
                
                __weak typeof(self) weakSelf=self;
                
                [ImageBrowserViewController show:self type:PhotoBroswerVCTypeModal index:img.tag - 10 imagesBlock:^NSArray *{
                    
                    return weakSelf.picArray;
                }];

            }
            
        }else{
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"相册限互为好友、VIP会员可见~"    preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * addFriendAction = [UIAlertAction actionWithTitle:@"加好友" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                
                [self attentButtonClickState:_attentStatus];
                
            }];
            
            UIAlertAction * vipAction = [UIAlertAction actionWithTitle:@"开通VIP" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
                
                LDMemberViewController *mvc = [[LDMemberViewController alloc] init];
                
                [self.navigationController pushViewController:mvc animated:YES];
                
            }];
            UIAlertAction * action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:nil];
            
            if (PHONEVERSION.doubleValue >= 8.3) {
                
                [action setValue:[UIColor lightGrayColor] forKey:@"_titleTextColor"];
                
                [vipAction setValue:CDCOLOR forKey:@"_titleTextColor"];
                
                [addFriendAction setValue:CDCOLOR forKey:@"_titleTextColor"];
            }

            
            [alert addAction:action];
            [alert addAction:addFriendAction];
            [alert addAction:vipAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

- (IBAction)recordButtonClick:(id)sender {
    
    RecordViewController *rvc = [[RecordViewController alloc] init];
    
    rvc.mediaString = _mediaStrng;
    
    [self.navigationController pushViewController:rvc animated:YES];
}

- (IBAction)playButtonClick:(id)sender {
    
    if (_audioPlayer == nil) {
        
        self.audioPlayer = [self myAudioPlayer];
        
        [self addDistanceNotification];
        [self setAudioSessionPlay];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [_playButton setBackgroundImage:[UIImage imageNamed:@"正在播放"] forState:UIControlStateNormal];
        
        [self.audioPlayer play];
        
        //播放完毕发出通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playDidFinish) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
    }else{
    
        if (_audioPlayer.rate == 1) {
            
            [_playButton setBackgroundImage:[UIImage imageNamed:@"播放暂停"] forState:UIControlStateNormal];
            
            [_audioPlayer pause];
            
        }else if (_audioPlayer.rate == 0){
            
            [_playButton setBackgroundImage:[UIImage imageNamed:@"正在播放"] forState:UIControlStateNormal];
            
            [_audioPlayer play];
        }

    }
}

/**
 *  设置音频会话
 */
-(void)setAudioSessionPlay{
    
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
}

-(void)playDidFinish{
    
    _audioPlayer = nil;
    
    [_playButton setBackgroundImage:[UIImage imageNamed:@"录音"] forState:UIControlStateNormal];
    
     [self removeDistanceNotification];
    
    NSLog(@"播放完毕");
}

/**
 *  创建播放器
 *
 *  @return 播放器
 */
-(AVPlayer *)myAudioPlayer{
    
    NSLog(@"AVPlayer初始化了");
    NSError *error = nil;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (error || _mediaStrng.length == 0) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.playButton.userInteractionEnabled = YES;
        
        [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"创建播放器过程中发生错误~"];
        
        NSLog(@"创建播放器过程中发生错误，错误信息：%@",error.localizedDescription);
        return nil;
        
    }
    
    _audioPlayer = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_mediaStrng]]];
    
    return _audioPlayer;
}

/**
 *  添加距离通知
 */
- (void)addDistanceNotification{
    //添加近距离事件监听，添加前先设置为YES，如果设置完后还是NO的读话，说明当前设备没有近距离传感器
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:)name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
}

/**
 *  删除距离通知
 */
- (void)removeDistanceNotification{
    //添加近距离事件监听，添加前先设置为YES，如果设置完后还是NO的读话，说明当前设备没有近距离传感器
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    
    if ([UIDevice currentDevice].proximityMonitoringEnabled == YES) {
        
        [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceProximityStateDidChangeNotification object:nil];
    }
}


#pragma mark - 处理近距离监听触发事件
- (void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)//传感器已启动前提条件下，如果用户接近 近距离传感器，此时属性值为YES
    {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        
    }else{
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

- (IBAction)giveGifButtonClick:(id)sender {
    
    _gif = [[GifView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) :^{
        
        LDChargeCenterViewController *cvc = [[LDChargeCenterViewController alloc] init];
        
        [self.navigationController pushViewController:cvc animated:YES];
        
    }];
    
    [_gif getPersonUid:self.userID andSign:@"赠送给某人"andUIViewController:self];
    
    [self.tabBarController.view addSubview:_gif];

}
- (IBAction)myGifListButtonClick:(id)sender {
    
    if ([self.userID intValue] == [[[NSUserDefaults standardUserDefaults]objectForKey:@"uid"] intValue]) {
        
        LDMyWalletPageViewController *wvc = [[LDMyWalletPageViewController alloc] init];
        
        wvc.type = @"1";
        
        [self.navigationController pushViewController:wvc animated:YES];
        
    }else{
    
        LDLookGifListViewController *lvc = [[LDLookGifListViewController alloc] init];
        
        lvc.userId = self.userID;
        
        [self.navigationController pushViewController:lvc animated:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    if (_gif) {
        
        [_gif removeView];
    }
    
    if (_stampView) {
        
        [_stampView removeView];
    }
    
    if (_audioPlayer != nil) {
        
        [self playDidFinish];
        
    }
}

- (IBAction)inageButtonClick:(id)sender {
    
      [XWScanImage scanBigImageWithImageView:self.headImageView];
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
