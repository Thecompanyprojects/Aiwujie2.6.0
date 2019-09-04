//
//  CollectModel.h
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/23.
//  Copyright © 2016年 a. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectModel : NSObject

@property (nonatomic,copy) NSString *age;
@property (nonatomic,copy) NSString *distance;
@property (nonatomic,copy) NSString *head_pic;
@property (nonatomic,copy) NSString *lat;
@property (nonatomic,copy) NSString *lng;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *onlinestate;
@property (nonatomic,copy) NSString *realname;
@property (nonatomic,copy) NSString *sex;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *vip;
@property (nonatomic,copy) NSString *is_hand;
@property (nonatomic,copy) NSString *is_admin;

//志愿者
@property (nonatomic,copy) NSString *is_volunteer;
//svip
@property (nonatomic,copy) NSString *svip;
//年svip
@property (nonatomic,copy) NSString *svipannual;
//年费会员
@property (nonatomic,copy) NSString *vipannual;

@end
