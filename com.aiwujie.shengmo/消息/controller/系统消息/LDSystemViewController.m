//
//  LDSystemViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/24.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDSystemViewController.h"

@interface LDSystemViewController ()

@end

@implementation LDSystemViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
    if ([self.navigationItem.title isEqualToString:@"系统消息"]) {
        
       [self scrollToBottomAnimated:YES];
        
    }else{
    
        self.conversationMessageCollectionView.frame = CGRectMake(0, 64, WIDTH, HEIGHT - 64);
        
        [self scrollToBottomAnimated:YES];
        
        self.chatSessionInputBarControl.hidden = YES;
    }
  
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
