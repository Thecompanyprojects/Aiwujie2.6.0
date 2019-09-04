//
//  BillModel.h
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/12.
//  Copyright © 2017年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BillModel : NSObject

@property (nonatomic,copy) NSString *week;
@property (nonatomic,copy) NSString *amount;
@property (nonatomic,copy) NSString *beans;
@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *fuid;

//
@property (nonatomic,copy) NSString *addtime;
@property (nonatomic,copy) NSString *addtime_format;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *num;
@property (nonatomic,copy) NSString *type;

//提现的时间,金额
@property (nonatomic,copy) NSString *money;
@property (nonatomic,copy) NSString *success_time;
@property (nonatomic,copy) NSString *success_time_format;

//充值赠送或兑换的类型
@property (nonatomic,copy) NSString *state;


@end
