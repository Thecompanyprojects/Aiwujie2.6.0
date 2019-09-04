//
//  BillCell.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/12.
//  Copyright © 2017年 a. All rights reserved.
//

#import "BillCell.h"

@implementation BillCell

-(void)setModel:(BillModel *)model{
    
    _model = model;
    
    NSArray *giftArray = @[@"握手",@"黄瓜",@"玫瑰",@"送吻",@"红酒",@"对戒",@"蛋糕",@"跑车",@"游轮",@"棒棒糖",@"狗粮",@"秋裤",@"黄瓜",@"心心相印",@"香蕉",@"口红",@"亲一个",@"玫瑰花",@"眼罩",@"心灵束缚",@"黄金",@"拍之印",@"鞭之痕",@"老司机",@"一生一世",@"水晶高跟",@"恒之光",@"666",@"红酒",@"蛋糕",@"钻戒",@"皇冠",@"跑车",@"直升机",@"游轮",@"城堡",@"幸运草",@"糖果",@"玩具狗",@"内内",@"TT"];
    
    if ([self.type isEqualToString:@"收到的礼物"]) {
        
        self.timeLabel.text = model.addtime_format;
        
        self.weekLabel.text = model.week;
        
        if ([model.beans intValue] == 0 && [model.amount intValue] == 0) {
        
            self.beanLabel.text = [NSString stringWithFormat:@"系统礼物"];
            
        }else{
        
            self.beanLabel.text = [NSString stringWithFormat:@"+%@魔豆",model.beans];
        }
        
        if ([model.beans intValue] == 0 && [model.amount intValue] == 0) {
        
            if (giftArray.count >= [model.type intValue]) {
                
                self.moneyLabel.text = [NSString stringWithFormat:@"%@赠[%@]×%@",model.nickname,giftArray[[model.type intValue] - 1],model.num];
                
            }else{
                
                self.moneyLabel.text = [NSString stringWithFormat:@"%@赠[新版系统礼物]×%@",model.nickname,model.num];
            }

        }else{
        
            if (giftArray.count >= [model.type intValue]) {
                
                self.moneyLabel.text = [NSString stringWithFormat:@"%@赠[%@]×%@[%@元]",model.nickname,giftArray[[model.type intValue] - 1],model.num,model.amount];
                
            }else{
                
                self.moneyLabel.text = [NSString stringWithFormat:@"%@赠[新版礼物]×%@[%@元]",model.nickname,model.num,model.amount];
            }

        }
        
    }else if([self.type isEqualToString:@"礼物系统赠送"]){
        
        self.timeLabel.text = model.addtime_format;
        
        self.weekLabel.text = model.week;
            
        self.beanLabel.text = [NSString stringWithFormat:@"系统礼物"];
        
        if (giftArray.count >= [model.type intValue]) {
            
            self.moneyLabel.text = [NSString stringWithFormat:@"系统赠[%@]×%@",giftArray[[model.type intValue] - 1],model.num];
            
        }else{
            
            self.moneyLabel.text = [NSString stringWithFormat:@"系统赠[新版系统礼物]×%@",model.num];
        }

    }else if ([self.type isEqualToString:@"礼物赠送记录"]){
        
        self.timeLabel.text = model.addtime_format;
        
        self.weekLabel.text = model.week;
        
        NSString *vip = [NSString string];
        
        if ([model.type intValue] == 1) {
            
            vip = @"VIP1个月";
            
        }else if ([model.type intValue] == 2){
            
            vip = @"VIP3个月";
            
        }else if ([model.type intValue] == 3){
            
            vip = @"VIP6个月";
            
        }else if ([model.type intValue] == 4){
            
            vip = @"VIP12个月";
            
        }else{
            
            vip = @"VIP";
        }
        
        self.beanLabel.text = [NSString stringWithFormat:@"-%@魔豆",model.beans];
        
        self.moneyLabel.text = [NSString stringWithFormat:@"赠%@%@[%@元]",model.nickname,vip,model.amount];
    
    }else if ([self.type isEqualToString:@"礼物提现记录"]){
    
        self.timeLabel.text = model.success_time_format;
        
        self.weekLabel.text = model.week;
        
        self.beanLabel.text = [NSString stringWithFormat:@"-%@魔豆",model.beans];
        
        self.moneyLabel.text = [NSString stringWithFormat:@"提现[%@元]",model.money];
    
    }else if([self.type isEqualToString:@"充值记录"]){
    
        self.timeLabel.text = model.date;
        
        self.weekLabel.text = model.week;
            
        self.moneyLabel.text = [NSString stringWithFormat:@"%@",model.amount];
   
        self.beanLabel.text = [NSString stringWithFormat:@"%@魔豆",model.beans];

    }else if([self.type isEqualToString:@"充值赠送记录"]){
    
        self.timeLabel.text = model.addtime_format;
        
        self.weekLabel.text = model.week;
        
        if ([model.beans intValue] == 0 && [model.amount intValue] == 0) {
        
            self.beanLabel.text = [NSString stringWithFormat:@"系统礼物"];
            
        }else{
        
            self.beanLabel.text = [NSString stringWithFormat:@"-%@魔豆",model.beans];
        }

        if ([model.state intValue] == 1) {
            
            if ([model.beans intValue] == 0 && [model.amount intValue] == 0) {
            
                if (giftArray.count >= [model.type intValue]) {
                    
                    self.moneyLabel.text = [NSString stringWithFormat:@"赠%@[%@]×%@",model.nickname,giftArray[[model.type intValue] - 1],model.num];
                    
                }else{
                    
                    self.moneyLabel.text = [NSString stringWithFormat:@"赠%@[新版系统礼物]×%@",model.nickname,model.num];
                }

                
            }else{
            
                if (giftArray.count >= [model.type intValue]) {
                    
                    self.moneyLabel.text = [NSString stringWithFormat:@"赠%@[%@]×%@[%@元]",model.nickname,giftArray[[model.type intValue] - 1],model.num,model.amount];
                    
                }else{
                    
                    self.moneyLabel.text = [NSString stringWithFormat:@"赠%@[新版礼物]×%@[%@元]",model.nickname,model.num,model.amount];
                }

            }

        }else if ([model.state intValue] == 2){
            
            NSString *vip = [NSString string];
            
            if ([model.type intValue] == 1) {
                
                vip = @"VIP1个月";
                
            }else if ([model.type intValue] == 2){
            
                vip = @"VIP3个月";
                
            }else if ([model.type intValue] == 3){
            
                vip = @"VIP6个月";
                
            }else if ([model.type intValue] == 4){
            
                vip = @"VIP12个月";
                
            }else{
            
                vip = @"VIP";
            }
        
             self.moneyLabel.text = [NSString stringWithFormat:@"赠%@%@[%@元]",model.nickname,vip,model.amount];
            
        }
    }else if([self.type isEqualToString:@"充值兑换记录"] || [self.type isEqualToString:@"礼物兑换记录"]){
    
        self.timeLabel.text = model.addtime_format;
        
        self.weekLabel.text = model.week;
        
        self.beanLabel.text = [NSString stringWithFormat:@"-%@魔豆",model.beans];
        
        if ([model.state intValue] == 1) {
            
            NSString *vip = [NSString string];
            
            if ([model.type intValue] == 1) {
                
                vip = @"VIP1个月";
                
            }else if ([model.type intValue] == 2){
                
                vip = @"VIP3个月";
                
            }else if ([model.type intValue] == 3){
                
                vip = @"VIP6个月";
                
            }else if ([model.type intValue] == 4){
                
                vip = @"VIP12个月";
                
            }else{
                
                vip = @"VIP";
            }
            
            self.moneyLabel.text = [NSString stringWithFormat:@"兑换%@[%@元]",vip,model.amount];
            
        }else if ([model.state intValue] == 2){
            
            self.moneyLabel.text = [NSString stringWithFormat:@"兑换斯慕邮票%@张[%@元]",model.num,model.amount];
        }
    }else if([self.type isEqualToString:@"邮票购买记录"]){
    
        self.timeLabel.text = model.addtime_format;
        
        self.weekLabel.text = model.week;
        
        self.beanLabel.text = [NSString stringWithFormat:@"+%@张邮票",model.num];
        
        if ([model.amount intValue] == 0) {
            
            self.moneyLabel.text = [NSString stringWithFormat:@"用%@魔豆兑换",model.beans];
            
        }else{
            
            self.moneyLabel.text = [NSString stringWithFormat:@"充值%@元",model.amount];
        }
    }else if ([self.type isEqualToString:@"邮票系统赠送记录"]){
    
        self.timeLabel.text = model.addtime_format;
        
        self.weekLabel.text = model.week;
        
        self.beanLabel.text = [NSString stringWithFormat:@"+%d张邮票",[model.num intValue] * 3];
            
        self.moneyLabel.text = [NSString stringWithFormat:@"[%@]赠男/女/CDTS票各%@张",model.type,model.num];
        
    }else if([self.type isEqualToString:@"邮票使用记录"]){
    
        self.timeLabel.text = model.addtime_format;
        
        self.weekLabel.text = model.week;
        
        self.moneyLabel.text = [NSString stringWithFormat:@"给%@发消息",model.nickname];
        
        if ([model.type intValue] == 1) {
            
            self.beanLabel.text = [NSString stringWithFormat:@"-1张男票"];
            
        }else if ([model.type intValue] == 2){
        
            self.beanLabel.text = [NSString stringWithFormat:@"-1张女票"];
            
        }else if([model.type intValue] == 3){
        
            self.beanLabel.text = [NSString stringWithFormat:@"-1张CDTS票"];
            
        }else if ([model.type intValue] == 4){
        
            self.beanLabel.text = [NSString stringWithFormat:@"-1张通用邮票"];
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
