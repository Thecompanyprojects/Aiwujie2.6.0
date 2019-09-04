//
//  GifView.h
//  圣魔无界
//
//  Created by 爱无界 on 2017/6/20.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GifView : UIView

@property (nonatomic,strong) void (^MyBlock)();

//获取界面传过来的动态id.位置,及从哪个界面传过来的标记
-(void)getDynamicDid:(NSString *)did andIndexPath:(NSIndexPath *)indexPath andSign:(NSString *)sign andUIViewController:(UIViewController *)controller;

//获取界面传过来的赠送给人的UID及标记
-(void)getPersonUid:(NSString *)userId andSign:(NSString *)sign andUIViewController:(UIViewController *)controller;

//显示送礼物
-(instancetype)initWithFrame:(CGRect)frame :(void (^)())block;

//移除送礼物页面
-(void)removeView;

@end
