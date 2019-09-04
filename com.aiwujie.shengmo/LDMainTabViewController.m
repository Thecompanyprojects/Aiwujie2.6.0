//
//  LDMainTabViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/18.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDMainTabViewController.h"
#import "LDMainNavViewController.h"

@interface LDMainTabViewController ()

@end

@implementation LDMainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = [NSArray array];
    
    array = @[@"LDDiscoverViewController",@"LDHomeViewController",@"LDInformationViewController",@"LDDynamicViewController",@"LDMineViewController"];
    
    NSArray *imgArray = @[@"发现灰",@"附近灰",@"消息灰",@"动态灰",@"我的灰"];
    
    NSArray *nameArray = @[@"公益",@"身边",@"消息",@"动态",@"我的"];
    
    NSArray *titleArray = @[@"公益",@"",@"消息",@"",@"我的"];
    
    NSArray *sImageArray = @[@"发现紫",@"附近紫",@"消息紫",@"动态紫",@"我的紫"];
    
    for (int i = 0; i < 5; i++) {
        
        Class class = NSClassFromString(array[i]);
        
        UIViewController *vc = [[class alloc] init];
        
        LDMainNavViewController *nvc = [[LDMainNavViewController alloc] initWithRootViewController:vc];
        
        
        UIImage *image = [UIImage imageNamed:imgArray[i]];
        
        nvc.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        nvc.tabBarItem.title = nameArray[i];
        
        nvc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
        
        vc.navigationItem.title = titleArray[i];
        
        UIImage *sImage = [UIImage imageNamed:sImageArray[i]];
        
        nvc.tabBarItem.selectedImage = [sImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //更改tabbar上字体的颜色
        
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName,[UIFont boldSystemFontOfSize:10],NSFontAttributeName, nil] forState:UIControlStateSelected];
        
        [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:10],NSFontAttributeName, nil] forState:UIControlStateNormal];
        
        [self addChildViewController:nvc];
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
