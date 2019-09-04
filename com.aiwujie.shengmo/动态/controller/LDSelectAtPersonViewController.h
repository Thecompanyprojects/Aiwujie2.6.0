//
//  LDSelectAtPersonViewController.h
//  圣魔无界
//
//  Created by 爱无界 on 2017/5/2.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyBlock)(NSString *allUid,int personNumber);

@interface LDSelectAtPersonViewController : UIViewController

@property (nonatomic,strong) MyBlock block;

@end
