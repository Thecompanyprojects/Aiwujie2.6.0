//
//  LDSignView.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/7/6.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDSignView.h"
#import "AppDelegate.h"
#import "FlowFlower.h"
#import "UIImage+Extension.h"

@interface LDSignView ()

@property (nonatomic,strong) UIView *backView;

@property (nonatomic,strong) UILabel *signDaysLabel;

//签到按钮
@property (nonatomic,strong) UIImageView *gifImageView;

//签到次数
@property (nonatomic,copy) NSString *signtimes;

//签到按钮
@property (nonatomic,strong) UIButton *signButton;

@end

@implementation LDSignView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self createUI:frame];
    }
    
    return self;
}

-(void)createUI:(CGRect)frame{
    
    
}

-(void)createHaveGetGifImage:(NSString *)type{

    _gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(tapClick)];
    [_gifImageView addGestureRecognizer:tap];
    
    _gifImageView.userInteractionEnabled = YES;
    
    _gifImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"签到得礼物%@",type]];
    
    [self addSubview:_gifImageView];

}

-(void)tapClick{

    [_gifImageView removeFromSuperview];
}

//获取签到天数和签到状态
-(void)getSignDays:(NSString *)signtimes andsignState:(NSString *)state{

    _signtimes = signtimes;
    
    _signDaysLabel.text = [NSString stringWithFormat:@"已签到%@天",_signtimes];
    
    if ([state isEqualToString:@"未签到"]) {
        
        [_signButton setTitle:@"签到领取" forState:UIControlStateNormal];
        
         [_signButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else{
    
        [_signButton setTitle:@"关闭" forState:UIControlStateNormal];
        
         [_signButton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    }
    
    for (int i = 0; i < 7; i++) {
        
        UIImageView *view = (UIImageView *)[_backView viewWithTag:20 + i];
        
        if ([_signtimes intValue] == 0) {
            
            view.hidden = YES;
            
        }else{
        
            if ([_signtimes intValue] >= i + 1) {
                
                view.hidden = NO;
                
            }else{
            
                view.hidden = YES;
            }
        }
    }
}

-(void)cancleButtonClick{

    [self removeFromSuperview];
}

@end
