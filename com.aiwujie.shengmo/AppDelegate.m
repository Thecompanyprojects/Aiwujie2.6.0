//
//  AppDelegate.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/15.
//  Copyright © 2016年 a. All rights reserved.
//

#import "AppDelegate.h"
#import "LDLoginViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LDMainTabViewController.h"
#import "UITabBar+badge.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UMMobClick/MobClick.h"

@interface AppDelegate ()<CLLocationManagerDelegate,RCIMConnectionStatusDelegate,UIAlertViewDelegate,RCIMReceiveMessageDelegate,WXApiDelegate,WeiboSDKDelegate,QQApiInterfaceDelegate>

@property (nonatomic,strong) CLLocationManager *locationManager;

@property (nonatomic,strong) LDMainTabViewController *mvc;

@property (nonatomic,strong) UIAlertView *alert;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //@{}代表Dictionary  设置title颜色
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    
    [UINavigationBar appearance].translucent = NO;
    
    [[UINavigationBar appearance]
     setBarTintColor:[UIColor whiteColor]];
    
    //用keychain存储用户的唯一标示uuid,用于封设备
    UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.aiwujie.shengmoApp"];
    
    if ([keychain[@"device_token"] length] == 0) {
        
        NSString *IDFV = [UIDevice currentDevice].identifierForVendor.UUIDString;
        
        [keychain setString:[NSString stringWithFormat:@"%@",IDFV] forKey:@"device_token"];
        
    }

    //友盟统计
    UMConfigInstance.appKey = @"591a7b45677baa4928000098";
    UMConfigInstance.channelId = @"App Store";
//    UMConfigInstance.eSType = E_UM_GAME; //仅适用于游戏场景，应用统计不用设置
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick startWithConfigure:UMConfigInstance];
    
    //初始化CLLocationManager并开始定位
    if([CLLocationManager locationServicesEnabled]){
        
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [_locationManager startUpdatingLocation];
        
    }else{
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"latitude"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"longitude"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"addr"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"city"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"province"];
        
    }

    //微信登陆
    [WXApi registerApp:@"wx0392b14b6a6f023c"];
    
    //微博登录
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    
    //注册融云及开启融云一些功能
    [[RCIM sharedRCIM] initWithAppKey:@"6tnym1brns117"];
    [RCIM sharedRCIM].enablePersistentUserInfoCache  = YES;
    [RCIM sharedRCIM].enableMessageRecall = YES;
    [RCIM sharedRCIM].receiveMessageDelegate = self;
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    //允许群组@人
    [RCIM sharedRCIM].enableMessageMentioned = YES;
    [RCIM sharedRCIM].globalConversationAvatarStyle = RC_USER_AVATAR_CYCLE;
    [RCIM sharedRCIM].globalMessageAvatarStyle = RC_USER_AVATAR_CYCLE;
    //开启输入状态监听
    [RCIM sharedRCIM].enableTypingStatus=YES;
    //开启发送已读回执
    [RCIM sharedRCIM].enabledReadReceiptConversationTypeList = @[@(ConversationType_PRIVATE),@(ConversationType_GROUP)];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    [RCIM sharedRCIM].globalNavigationBarTintColor = [UIColor blackColor];
    
    [RCIMClient sharedRCIMClient].logLevel = RC_Log_Level_Info;
    
    //前台提示音开关
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"voiceSwitch"] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:@"voiceSwitch"] isEqualToString:@"no"]) {
        
        [RCIM sharedRCIM].disableMessageAlertSound = NO;
        
    }else{
        
        [RCIM sharedRCIM].disableMessageAlertSound = YES;
    }
    
    //本地通知提示音开关
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"notificationSwitch"] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:@"notificationSwitch"] isEqualToString:@"no"]) {
        
        [RCIM sharedRCIM].disableMessageNotificaiton = NO;
        
    }else{
        
        [RCIM sharedRCIM].disableMessageNotificaiton = YES;
        
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] == 0) {
        
        //为在底部控制器上添加红点或消息数
        LDMainTabViewController *mvc = [[LDMainTabViewController alloc] init];
        
        _mvc = mvc;
        
        LDLoginViewController *lvc = [[LDLoginViewController alloc] init];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:lvc];
        
        self.window.rootViewController = nav;
        
    }else{
        
        LDMainTabViewController *mvc = [[LDMainTabViewController alloc] init];
        
        _mvc = mvc;
        
        self.window.rootViewController = mvc;
        
        [self createOtherUnreadData];
        
        /**
         
         融云聊天集成
         
         */
        //        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"token"]);
        [[RCIM sharedRCIM] connectWithToken:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"] success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
            
            [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UITabBarItem * item=[mvc.tabBar.items objectAtIndex:2];
                
                NSInteger badge = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
                
                if (badge <= 0) {
                    
                    item.badgeValue = 0;
                    
                }else{
                    
                    item.badgeValue = [NSString stringWithFormat:@"%ld",(long)badge];
                }
            });

            
        } error:^(RCConnectErrorCode status) {
            
            NSLog(@"登陆的错误码为:%ld", (long)status);
            
        } tokenIncorrect:^{
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            NSLog(@"token错误");
        }];
        
    }

    //融云即时通讯
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessageNotification:)  name:RCKitDispatchMessageNotification object:nil];
    
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    
    /**
     * 推送处理1
     */
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        //注册推送, 用于iOS8以及iOS8之后的系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
        
        [application registerUserNotificationSettings:settings];
    }
    
    [NSThread sleepForTimeInterval:2.0];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

//访问,群广场,新人的消息数及展示
-(void)createOtherUnreadData{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Other/getRedDutNum"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"]};
    //    NSLog(@"%@",role);
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger integer = [[responseObject objectForKey:@"retcode"] intValue];
        
//        NSLog(@"%@",responseObject);
        
        if (integer == 2000){
            
            if ([responseObject[@"data"][@"dynamic"] integerValue] > 0) {
                
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"dynamic"] forKey:@"dynamicBadge"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dynamicBadge" object:nil];
                
            }else{
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"dynamicBadge"];
                
            }
            
            if ([responseObject[@"data"][@"groupNum"] integerValue] > 0) {
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"groupNum"]] forKey:@"groupBadge"];
                
                //有新建群
                [[NSNotificationCenter defaultCenter] postNotificationName:@"groupBadge" object:nil];
            }else{
            
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"groupBadge"];
                
                //没有新建群
                [[NSNotificationCenter defaultCenter] postNotificationName:@"groupBadge1" object:nil];
            }
            
            if ([responseObject[@"data"][@"newRegerNum"] integerValue] > 0) {
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"newRegerNum"]] forKey:@"newestBadge"];
                
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"newestBadge" object:nil userInfo:nil];
                
            }else{
            
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"newestBadge"];
            }
            
            if ([responseObject[@"data"][@"followDyNum"] integerValue] > 0) {
                
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"followDyNum"] forKey:@"followBadge"];
                
            }else{
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"followBadge"];
                
            }
            
            if ([responseObject[@"data"][@"dyRecommendNum"] integerValue] > 0) {
                
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"dyRecommendNum"] forKey:@"recommendBadge"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"dynamicBadge" object:nil];
                
            }else{
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"recommendBadge"];
                
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

}

//监听后台推送的融云消息
-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    
    if ([message.objectName isEqualToString:@"RC:CmdMsg"]) {
        
        if ([message.senderUserId intValue] == 5) {//监听查看过我的人
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"lookBadge"] intValue] + 1] forKey:@"lookBadge"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                [_mvc.tabBar showBadgeOnItemIndex:4];
                
            });
            
             [[NSNotificationCenter defaultCenter] postNotificationName:@"lookBadge" object:nil];

            
        }else if([message.senderUserId intValue] == 3){//监听是否有新的点赞评论打赏的消息
        
            [[NSNotificationCenter defaultCenter] postNotificationName:@"消息接收" object:nil];
            
        }else if ([message.senderUserId intValue] == 6){//监听某人是否被封号
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                LDLoginViewController *push = [[LDLoginViewController alloc] initWithNibName:@"LDLoginViewController" bundle:nil];
                
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:push];
                
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"uid"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"hideLocation"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"lookBadge"];
                
                [[RCIM sharedRCIM] disconnect:NO];
                
                [_mvc.tabBar hideBadgeOnItemIndex:0];
                [_mvc.tabBar hideBadgeOnItemIndex:1];
                [_mvc.tabBar hideBadgeOnItemIndex:2];
                [_mvc.tabBar hideBadgeOnItemIndex:3];
                [_mvc.tabBar hideBadgeOnItemIndex:4];

                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                
                self.window.rootViewController = nav;
                
                if ([message.content isMemberOfClass:[RCCommandMessage class]]) {
                    
                    RCCommandMessage *commandMsg = (RCCommandMessage*)message.content;
                
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:commandMsg.data delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    
                    [alert show];
                
                }
            });
            
        }else if([message.senderUserId intValue] == 7){
            
            if ([message.content isMemberOfClass:[RCCommandMessage class]]) {//动态@某人的推送
                
                RCCommandMessage *commandMsg = (RCCommandMessage*)message.content;
                
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"atPerson"] == nil || [[[NSUserDefaults standardUserDefaults] objectForKey:@"atPerson"] count] == 0) {
                    
                    NSMutableArray *array = [NSMutableArray array];
                    
                    NSData * data = [commandMsg.data dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    
                    [array addObject:jsonDict];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"atPerson"];
                    
                }else{
                
                    NSMutableArray *array = [NSMutableArray array];
                    
                    [array addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"atPerson"]];
                    
                    NSData * data = [commandMsg.data dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    
                    [array addObject:jsonDict];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"atPerson"];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"消息接收" object:nil];
            }
        }else if([message.senderUserId intValue] == 8){
        
            if ([message.content isMemberOfClass:[RCCommandMessage class]]) {//判断用户是否被禁言
                
                RCCommandMessage *commandMsg = (RCCommandMessage*)message.content;
                
                if ([commandMsg.name isEqualToString:@"forbiduserchat"]) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"ableOrDisable"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:commandMsg.data delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                        
                        [alert show];
                        
                    });
                    
                }else if ([commandMsg.name isEqualToString:@"resumeuser"]){
                
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"ableOrDisable"];
                }
                
            }
        }
    }
}

/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //融云推送处理3
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""]
      stringByReplacingOccurrencesOfString:@">" withString:@""]
     stringByReplacingOccurrencesOfString:@" " withString:@""];
    
//    NSLog(@"%@",token);
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    
}

//融云连接状态
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        
        _alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的帐号在别的设备上登录，您被迫下线！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        
        [_alert show];
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView == _alert) {
        
        LDLoginViewController *push = [[LDLoginViewController alloc] initWithNibName:@"LDLoginViewController" bundle:nil];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:push];
        
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"uid"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"hideLocation"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"lookBadge"];
        
        [_mvc.tabBar hideBadgeOnItemIndex:0];
        [_mvc.tabBar hideBadgeOnItemIndex:1];
        [_mvc.tabBar hideBadgeOnItemIndex:2];
        [_mvc.tabBar hideBadgeOnItemIndex:3];
        [_mvc.tabBar hideBadgeOnItemIndex:4];
        
        [[RCIM sharedRCIM] disconnect:NO];
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        
        self.window.rootViewController = nav;

    }

}

#pragma mark 地图的代理方法

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:manager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark * placemark in placemarks) {
            
            if (!placemark.locality) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）

                [[NSUserDefaults standardUserDefaults] setObject:placemark.administrativeArea forKey:@"city"];
                
                [[NSUserDefaults standardUserDefaults] setObject:placemark.administrativeArea forKey:@"province"];
                
            }else{
                
                [[NSUserDefaults standardUserDefaults] setObject:placemark.administrativeArea forKey:@"province"];
            
                [[NSUserDefaults standardUserDefaults] setObject:placemark.locality forKey:@"city"];
                
            }

            [[NSUserDefaults standardUserDefaults] setObject:placemark.name forKey:@"addr"];
            
            if (manager.location.coordinate.latitude != 0 && manager.location.coordinate.longitude != 0) {
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",manager.location.coordinate.latitude] forKey:@"latitude"];
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",manager.location.coordinate.longitude] forKey:@"longitude"];
                
                //如果不需要实时定位，使用完即使关闭定位服务
                [_locationManager stopUpdatingLocation];

            }else{
            
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"latitude"];
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"longitude"];
                
                 [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"addr"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"city"];
                
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"province"];
            }
        }
    }];
    
}

//上传实时位置
-(void)createDataLat:(CGFloat)lat andLng:(CGFloat)lng{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Other/setLogintimeAndLocation"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hideLocation"] intValue] == 0) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"province"] length] == 0) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"province"];
            
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"city"] length] == 0) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"city"];
            
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"addr"] length] == 0) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"addr"];
            
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] length] == 0) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"latitude"];
            
            lat = 0;
            
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"] length] == 0) {
            
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"longitude"];
            
            lng = 0;
            
        }

        
        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":[NSString stringWithFormat:@"%lf",lat],@"lng":[NSString stringWithFormat:@"%lf",lng],@"city":[[NSUserDefaults standardUserDefaults] objectForKey:@"city"],@"addr":[[NSUserDefaults standardUserDefaults] objectForKey:@"addr"],@"province":[[NSUserDefaults standardUserDefaults] objectForKey:@"province"]};
        
    }else{
        
        parameters = @{@"uid":[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"],@"lat":@"",@"lng":@"",@"city":@"",@"addr":@"",@"province":@""};
    }
    
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//                NSLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
    
}


- (void)didReceiveMessageNotification:(NSNotification *)notification {
    
//    NSLog(@"%@",notification.object);
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"shockSwitch"] isEqualToString:@"yes"]) {
        
        //震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
    }

    if ([notification.userInfo[@"left"] intValue] == 0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"badgeNumber" object:nil];
        
        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_APPSERVICE),@(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP),@(ConversationType_SYSTEM)]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
            
        });
    }
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
        
        return [WeiboSDK handleOpenURL:url delegate:self];
  
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {

    if ([TencentOAuth HandleOpenURL:url] == FALSE) {
        
        if ([QQApiInterface handleOpenURL:url delegate:self] == FALSE) {
            
             return [WXApi handleOpenURL:url delegate:self];
        }
        
        return [QQApiInterface handleOpenURL:url delegate:self];
        
    }
    
    return [TencentOAuth HandleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    if ([TencentOAuth HandleOpenURL:url] == FALSE) {
        
        if ([QQApiInterface handleOpenURL:url delegate:self] == FALSE) {
            
            if ([WXApi handleOpenURL:url delegate:self] == FALSE) {
                
                return [WeiboSDK handleOpenURL:url delegate:self ];
            }
            
            return [WXApi handleOpenURL:url delegate:self];
        }
        
        return [QQApiInterface handleOpenURL:url delegate:self];
    }
    
    return  [TencentOAuth HandleOpenURL:url];
}

//微博接受请求
-(void)didReceiveWeiboRequest:(WBBaseRequest *)request{

    
}

//微博登陆第三方回调
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    
    if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        //微博登录
        if ([response.requestUserInfo[@"Other_Info_1"] isEqualToString:@"bindWB"]) {
            
            if ([[(WBAuthorizeResponse *)response userID] length] != 0){
            
                [[NSUserDefaults standardUserDefaults] setObject:[(WBAuthorizeResponse *)response userID] forKey:@"bindOpenid"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"绑定微博第三方" object:nil];
                
            }
            
        }else{
        
            self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
            self.wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
            self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
            //        [alert show];
            
            if (self.wbCurrentUserID.length != 0 && self.wbtoken.length != 0) {
                
                [[NSUserDefaults standardUserDefaults] setObject:self.wbCurrentUserID forKey:@"openid"];
                
                [MBProgressHUD showHUDAddedTo:self.window.rootViewController.view animated:YES];
                
                AFHTTPSessionManager *manager = [LDAFManager sharedManager];
                
                [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
                manager.requestSerializer.timeoutInterval = 10.f;
                
                [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
                
                NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"api/users/charge_openid"];
                
                NSString *device = [NSString string];
                
                UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.aiwujie.shengmoApp"];
                
                if ([keychain[@"device_token"] length] == 0) {
                    
                    device = @"";
                    
                }else{
                    
                    device = keychain[@"device_token"];
                }
                
                NSDictionary *parameters = @{@"openid":self.wbCurrentUserID,@"channel":@"3",@"device_token":device};
                
                [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
                    
                    [MBProgressHUD hideHUDForView:self.window.rootViewController.view animated:YES];
                    //                            NSLog(@"%@",responseObject);
                    
                    if (integer == 4000) {
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"channel"]] forKey:@"loginChannel"];
                        
                        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
                        
                        NSDictionary *parameters = @{@"access_token":self.wbtoken,@"uid":self.wbCurrentUserID};
                        
                        [manager GET:@"https://api.weibo.com/2/users/show.json" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            
                            //                        NSLog(@"%@",responseObject);
                            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"screen_name"] forKey:@"wbname"];
                            
                            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"profile_image_url"] forKey:@"wbheadUrl"];
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"wbregister" object:nil];
                            
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            
                            NSLog(@"%@",error);
                            
                        }];
                        
                        
                    }else if(integer == 2000){
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"uid"]] forKey:@"uid"];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"r_token"] forKey:@"token"];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"sex"] forKey:@"newestSex"];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"sexual"] forKey:@"newestSexual"];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"chatstatus"]] forKey:@"ableOrDisable"];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"wbLogin" object:nil];
                        
                        
                    }else{
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:responseObject[@"msg"] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                        
                        [alert show];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    NSLog(@"%@",error);
                    
                }];
                
            }

            
        }
        
    }else if([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        //微博分享

        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
        if (accessToken)
        {
            self.wbtoken = accessToken;
        }
        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
        
        if (userID) {
            
            self.wbCurrentUserID = userID;
        }
        
        if (sendMessageToWeiboResponse.statusCode == 0) {
            
            [self getAppShareStampData];
        }
    }    
}


-(void)onReq:(QQBaseReq *)req{

}

-(void)isOnlineResponse:(NSDictionary *)response{

}

//qq回调和微信回调
- (void)onResp:(id)resp{

    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        
        SendMessageToQQResp *msg = (SendMessageToQQResp *)resp;
        
        if ([msg.result integerValue] == 0 && msg.type == ESENDMESSAGETOQQRESPTYPE) {
            
            [self getAppShareStampData];
        }
        
    }else if ([resp isKindOfClass:[SendAuthResp class]]){ //    WXApi loginSuccessByCode
        
        SendAuthResp *authResp = (SendAuthResp *)resp;
        
        if (authResp.errCode == 0) {
            
            [self createGetToken:authResp];
            
        }
        
    }else if([resp isKindOfClass:[SendMessageToWXResp class]]){
        
        SendMessageToWXResp *sendResp = (SendMessageToWXResp *)resp;
        
        if (sendResp.errCode == 0) {
            
            [self getAppShareStampData];
            
        }
    }
}

-(void)getAppShareStampData{

    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"Api/Users/getShareStamp"];
    
    NSDictionary *parameters = [NSDictionary dictionary];
    
    NSString *uid = [NSString string];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] length] == 0) {
        
        uid = @"";
        
    }else{
    
        uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"uid"];
        
    }
        
    parameters = @{@"uid":uid};
      
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      
    }];

}

-(void)createGetToken:(SendAuthResp *)resp{
    
//    NSLog(@"%@",resp.state);
    
    if ([resp.state isEqualToString:@"123WX"]) {
        
        
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        
        NSString *string = resp.code;
        
        NSDictionary *parameters = @{@"appid":@"wx0392b14b6a6f023c",@"secret":@"e9d7a5a8e1f15528a99ab7e51a7193e2",@"code":string,@"grant_type":@"authorization_code"};
        
        [manager GET:@"https://api.weixin.qq.com/sns/oauth2/access_token" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            //                NSLog(@"%@",responseObject);
            
            //        [self createWeiXinData:responseObject[@"openid"]];
            
            NSString *openid = responseObject[@"openid"];
            
            NSString *access_token = responseObject[@"access_token"];
            
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"openid"] forKey:@"openid"];
            
            [MBProgressHUD showHUDAddedTo:self.window.rootViewController.view animated:YES];
            
            
            AFHTTPSessionManager *manager = [LDAFManager sharedManager];
            
            [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
            
            manager.requestSerializer.timeoutInterval = 10.f;
            
            [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
            
            NSString *url = [NSString stringWithFormat:@"%@%@",URL,@"api/users/charge_openid"];
            
            NSString *device = [NSString string];
            
            UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:@"com.aiwujie.shengmoApp"];
            
            if ([keychain[@"device_token"] length] == 0) {
                
                device = @"";
                
            }else{
                
                device = keychain[@"device_token"];
            }
            
            NSDictionary *parameters = @{@"openid":responseObject[@"openid"],@"channel":@"1",@"device_token":device};
            
            [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSInteger integer = [[responseObject objectForKey:@"retcode"] integerValue];
                
                [MBProgressHUD hideHUDForView:self.window.rootViewController.view animated:YES];
                
                //            NSLog(@"%@",responseObject);
                
                if (integer == 4000) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"channel"]] forKey:@"loginChannel"];
                    
                    [self createUserinfoData:access_token andOpenid:openid];
                    
                }else if(integer == 2000){
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"uid"]] forKey:@"uid"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"r_token"] forKey:@"token"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"sex"] forKey:@"newestSex"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"data"][@"sexual"] forKey:@"newestSexual"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",responseObject[@"data"][@"chatstatus"]] forKey:@"ableOrDisable"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"wxLogin" object:nil];
                    
                }else{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:responseObject[@"msg"] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    
                    [alert show];
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                NSLog(@"%@",error);
                
            }];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"%@",error);
            
        }];

    }else if ([resp.state isEqualToString:@"WXBind"]){
    
        AFHTTPSessionManager *manager = [LDAFManager sharedManager];
        
        NSString *string = resp.code;
        
        NSDictionary *parameters = @{@"appid":@"wx0392b14b6a6f023c",@"secret":@"e9d7a5a8e1f15528a99ab7e51a7193e2",@"code":string,@"grant_type":@"authorization_code"};
        
        [manager GET:@"https://api.weixin.qq.com/sns/oauth2/access_token" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"openid"] forKey:@"bindOpenid"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"绑定微信第三方" object:nil];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            NSLog(@"%@",error);
            
        }];

    }
    
}

-(void)createUserinfoData:(NSString *)token andOpenid:(NSString *)openid{
    
    AFHTTPSessionManager *manager = [LDAFManager sharedManager];
    
    NSDictionary *parameters = @{@"access_token":token,@"openid":openid};
    
    [manager GET:@"https://api.weixin.qq.com/sns/userinfo" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //                NSLog(@"%@",responseObject);
        [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"responseObject"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"register" object:nil];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] != 0) {
        
        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_APPSERVICE),@(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP),@(ConversationType_SYSTEM)]];
        [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
        
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
           //退出再进入app上传当前位置
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue] != 0) {
        
        [self createOtherUnreadData];
        
        [self createDataLat:[[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] floatValue] andLng:[[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"] floatValue]];
        
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

}

@end
