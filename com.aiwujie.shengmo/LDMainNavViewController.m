//
//  LDMainNavViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/18.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDMainNavViewController.h"
#import "LDLoginViewController.h"
#import "LDMapViewController.h"
#import "LDProvacyViewController.h"
#import "LDPrivacyPhotoViewController.h"
#import "LDEditViewController.h"
#import "LDGetListViewController.h"
#import "WUGesturesUnlockViewController.h"
#import "LDEditMatchmakerViewController.h"

@interface LDMainNavViewController ()

@end

@implementation LDMainNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    __weak typeof (self) weakSelf = self;
    //解决因为自定义导航栏按钮,滑动返回失效的问题
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count) {
        
        viewController.hidesBottomBarWhenPushed = YES;
    
        if (![viewController isKindOfClass:[LDLoginViewController class]] && ![viewController isKindOfClass:[LDMapViewController class]] && ![viewController isKindOfClass:[LDProvacyViewController class]] && ![viewController isKindOfClass:[LDPrivacyPhotoViewController class]] && ![viewController isKindOfClass:[LDEditViewController class]] && ![viewController isKindOfClass:[WUGesturesUnlockViewController class]] && ![viewController isKindOfClass:[LDGetListViewController class]] && ![viewController isKindOfClass:[LDEditMatchmakerViewController class]]) {
            
            UIButton * areaButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 36, 10, 14)];

            if (@available(iOS 11.0, *)) {

                [areaButton setImage:[UIImage imageNamed:@"back-11"] forState:UIControlStateNormal];
                
            }else{

                [areaButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            }

            [areaButton addTarget:self action:@selector(backButtonOnClick) forControlEvents:UIControlEventTouchUpInside];

            UIBarButtonItem* leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:areaButton];
            
            if (@available(iOS 11.0, *)) {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                leftBarButtonItem.customView.frame = CGRectMake(0, 0, 100, 44);
            }
            
            
            viewController.navigationItem.leftBarButtonItem = leftBarButtonItem;
        }
    }
    
    [super pushViewController:viewController animated:animated];
}
- (void)backButtonOnClick {
    
    [self popViewControllerAnimated:YES];
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
