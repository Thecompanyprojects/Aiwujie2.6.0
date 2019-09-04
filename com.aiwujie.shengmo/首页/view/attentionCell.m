//
//  attentionCell.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/1.
//  Copyright © 2017年 a. All rights reserved.
//

#import "attentionCell.h"

@implementation attentionCell

-(void)setModel:(TableModel *)model{
    
    _model = model;
    
    if (model.userInfo == nil) {
        
        [self createOtherUI];
        
    }else{
    
       [self createUI];
    }
}

-(void)createOtherUI{

    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:_model.head_pic] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    if ([_model.onlinestate intValue] == 0) {
        
        self.onlineLabel.hidden = YES;
        
    }else{
        
        self.onlineLabel.hidden = NO;
    }
    
    self.nameLabel.text = _model.nickname;
    
    self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self.nameLabel sizeToFit];
    
    self.nameW.constant = self.nameLabel.frame.size.width;
   
    if ([_model.is_volunteer intValue] == 1) {
        
        self.vipView.hidden = NO;
        
        self.vipView.image = [UIImage imageNamed:@"志愿者标识"];
        
    }else if ([_model.is_admin intValue] == 1) {
        
        self.vipView.hidden = NO;
        
        self.vipView.image = [UIImage imageNamed:@"官方认证"];
        
    }else{
        
        if ([_model.svipannual intValue] == 1) {
            
            self.vipView.hidden = NO;
            
            self.vipView.image = [UIImage imageNamed:@"年svip标识"];

        }else if ([_model.svip intValue] == 1){
        
            self.vipView.hidden = NO;
            
            self.vipView.image = [UIImage imageNamed:@"svip标识"];
            
        }else if ([_model.vipannual intValue] == 1) {
            
            self.vipView.hidden = NO;
            
            self.vipView.image = [UIImage imageNamed:@"年费会员"];
            
        }else{
        
            if ([_model.vip intValue] == 1) {
                
                self.vipView.hidden = NO;
                
                self.vipView.image = [UIImage imageNamed:@"高级紫"];
                
            }else{
                
                self.vipView.hidden = YES;
            }

        }
        
    }

    
    if ([_model.realname intValue] == 0) {
        
        self.idImageView.hidden = YES;
        
        self.idViewW.constant = 0;
        
    }else{
        
        self.idImageView.hidden = NO;
        
        self.idViewW.constant = 16;
    }
    
    //    NSLog(@"jjjjjjjjjjjjj%ld",_integer);
    
    if ([_model.role isEqualToString:@"S"]) {
        
        self.sexualLabel.text = @"斯";
        
        self.sexualLabel.backgroundColor = BOYCOLOR;
        
    }else if ([_model.role isEqualToString:@"M"]){
        
        self.sexualLabel.text = @"慕";
        
        self.sexualLabel.backgroundColor = GIRLECOLOR;
        
    }else if ([_model.role isEqualToString:@"SM"]){
        
        self.sexualLabel.text = @"双";
        
        self.sexualLabel.backgroundColor = CDCOLOR;
        
    }else{
    
        self.sexualLabel.text = @"~";
        
        self.sexualLabel.backgroundColor = [UIColor colorWithRed:84/255.0 green:185/255.0 blue:36/255.0 alpha:1];
    }
    
    if ([_model.sex intValue] == 1) {
        
        self.sexLabel.image = [UIImage imageNamed:@"男"];
        
        self.aSexView.backgroundColor = BOYCOLOR;
        
    }else if ([_model.sex intValue] == 2){
        
        self.sexLabel.image = [UIImage imageNamed:@"女"];
        
        self.aSexView.backgroundColor = GIRLECOLOR;
        
    }else{
        
        self.sexLabel.image = [UIImage imageNamed:@"双性"];
        
        self.aSexView.backgroundColor = CDCOLOR;
    }
    
    NSArray *colorArray = @[@"握手紫",@"黄瓜紫",@"玫瑰紫",@"送吻紫",@"红酒紫",@"对戒紫",@"蛋糕紫",@"跑车紫",@"游轮紫" ,@"棒棒糖",@"狗粮",@"秋裤",@"黄瓜",@"心心相印",@"香蕉",@"口红",@"亲一个",@"玫瑰花",@"眼罩",@"心灵束缚",@"黄金",@"拍之印",@"鞭之痕",@"老司机",@"一生一世",@"水晶高跟",@"恒之光",@"666",@"红酒",@"蛋糕",@"钻戒",@"皇冠",@"跑车",@"直升机",@"游轮",@"城堡",@"幸运草",@"糖果",@"玩具狗",@"内内",@"TT"];
    
    NSArray *giftArray = @[@"握手",@"黄瓜",@"玫瑰",@"送吻",@"红酒",@"对戒",@"蛋糕",@"跑车",@"游轮",@"棒棒糖",@"狗粮",@"秋裤",@"黄瓜",@"心心相印",@"香蕉",@"口红",@"亲一个",@"玫瑰花",@"眼罩",@"心灵束缚",@"黄金",@"拍之印",@"鞭之痕",@"老司机",@"一生一世",@"水晶高跟",@"恒之光",@"666",@"红酒",@"蛋糕",@"钻戒",@"皇冠",@"跑车",@"直升机",@"游轮",@"城堡",@"幸运草",@"糖果",@"玩具狗",@"内内",@"TT"];
    
    if ([_model.amount intValue] == 0) {
        
        if (_model.city.length == 0) {
            
              self.introduceLabel.text = [NSString stringWithFormat:@"%@",_model.sendtime];
            
        }else{
        
              self.introduceLabel.text = [NSString stringWithFormat:@"%@ %@",_model.city,_model.sendtime];
        }
        
        [self getWealthAndCharmState:_wealthLabel andView:_wealthView andText:_model.wealth_val andNSLayoutConstraint:_wealthW andType:@"财富"];
        
        [self getWealthAndCharmState:_charmLabel andView:_charmView andText:_model.charm_val andNSLayoutConstraint:_charmW andType:@"魅力"];

    }else{
        
        if ([_model.psid intValue] != 0) {
            
            if (_model.city.length == 0) {
                
                if (giftArray.count >= [_model.psid intValue]) {
                    
                    self.introduceLabel.text = [NSString stringWithFormat:@"%@ 打赏礼物%@",_model.sendtime,giftArray[[_model.psid intValue] - 1]];
                    
                }else{
                
                    self.introduceLabel.text = [NSString stringWithFormat:@"%@ 打赏%@魔豆礼物",_model.sendtime,_model.amount];
                }

            }else{
                
                if (giftArray.count >= [_model.psid intValue]) {
                
                     self.introduceLabel.text = [NSString stringWithFormat:@"%@ %@ 打赏礼物%@",_model.city,_model.sendtime,giftArray[[_model.psid intValue] - 1]];
                    
                }else{
                
                    self.introduceLabel.text = [NSString stringWithFormat:@"%@ %@ 打赏%@魔豆礼物",_model.city,_model.sendtime,_model.amount];
                }
 
            }

        }else{
            
            if (_model.city.length != 0) {
                
                self.introduceLabel.text = _model.city;
                
            }else{
            
                self.introduceLabel.text = @"隐身";
            }
        }
    }
    
    self.ageLabel.text = [NSString stringWithFormat:@"%@",_model.age];
    
    if ([self.otherType intValue] == 0) {
        
        if ([_model.state intValue] == 0) {
            
            [self.attentButton setBackgroundImage:[UIImage imageNamed:@"关注"] forState:UIControlStateNormal];
            
            if (_model.psid != nil && [_model.psid intValue] != 0) {
                
                self.modouView.hidden = NO;
                
                self.numLabel.hidden = NO;
                
                self.modouView.image = [UIImage imageNamed:colorArray[[_model.psid intValue] - 1]];
                
                self.numLabel.text = [NSString stringWithFormat:@"×%@",_model.num];
                
                [self.numLabel sizeToFit];
                
            }else{
            
                self.modouView.hidden = YES;
                
                self.numLabel.hidden = YES;

                
            }
            
            self.attentW.constant = 56;
            
        }else if ([_model.state intValue] == 1){
            
            [self.attentButton setBackgroundImage:[UIImage imageNamed:@"取消关注"] forState:UIControlStateNormal];
            
            if (_model.psid != nil && [_model.psid intValue] != 0) {
                
                if (giftArray.count >= [_model.psid intValue]) {
                
                    self.modouView.hidden = NO;
                    
                    self.numLabel.hidden = NO;
                    
                    self.modouView.image = [UIImage imageNamed:colorArray[[_model.psid intValue] - 1]];
                    
                    self.numLabel.text = [NSString stringWithFormat:@"×%@",_model.num];
                    
                    [self.numLabel sizeToFit];
                    
                }else{
                
                    self.modouView.hidden = YES;
                    
                    self.numLabel.hidden = YES;

                }

            }else{
                
                self.modouView.hidden = YES;
                
                self.numLabel.hidden = YES;

                
            }
            
            self.attentW.constant = 56;
            
        }else if ([_model.state intValue] == 2){
            
            [self.attentButton setBackgroundImage:[UIImage imageNamed:@"被关注"] forState:UIControlStateNormal];
            
            if (_model.psid != nil && [_model.psid intValue] != 0) {
                
                if (giftArray.count >= [_model.psid intValue]) {
                    
                    self.modouView.hidden = NO;
                    
                    self.numLabel.hidden = NO;
                    
                    self.modouView.image = [UIImage imageNamed:colorArray[[_model.psid intValue] - 1]];
                    
                    self.numLabel.text = [NSString stringWithFormat:@"×%@",_model.num];
                    
                    [self.numLabel sizeToFit];
                    
                }else{
                    
                    self.modouView.hidden = YES;
                    
                    self.numLabel.hidden = YES;

                }
                
            }else{
                
                self.modouView.hidden = YES;
                
                self.numLabel.hidden = YES;

                
            }
            
            self.attentW.constant = 56;
            
        }else if ([_model.state intValue] == 3){
            
            [self.attentButton setBackgroundImage:[UIImage imageNamed:@"互相关注"] forState:UIControlStateNormal];
            
            if (_model.psid != nil && [_model.psid intValue] != 0) {
                
                if (giftArray.count >= [_model.psid intValue]) {
                    
                    self.modouView.hidden = NO;
                    
                    self.numLabel.hidden = NO;
                    
                    self.modouView.image = [UIImage imageNamed:colorArray[[_model.psid intValue] - 1]];
                    
                    self.numLabel.text = [NSString stringWithFormat:@"×%@",_model.num];
                    
                    [self.numLabel sizeToFit];
                    
                }else{
                    
                    self.modouView.hidden = YES;
                    
                    self.numLabel.hidden = YES;

                }
                
            }else{
                
                self.modouView.hidden = YES;
                
                self.numLabel.hidden = YES;

                
            }
            
            self.attentW.constant = 56;
            
        }else if ([_model.state intValue] == 4){
            
            [self.attentButton setBackgroundImage:nil forState:UIControlStateNormal];
            
            if (_model.psid != nil && [_model.psid intValue] != 0) {
                
                if (giftArray.count >= [_model.psid intValue]) {
                    
                    self.modouView.hidden = NO;
                    
                    self.numLabel.hidden = NO;
                    
                    self.modouView.image = [UIImage imageNamed:colorArray[[_model.psid intValue] - 1]];
                    
                    self.numLabel.text = [NSString stringWithFormat:@"×%@",_model.num];
                    
                    [self.numLabel sizeToFit];
                    
                }else{
                    
                    self.modouView.hidden = YES;
                    
                    self.numLabel.hidden = YES;

                }
                
            }else{
                
                self.modouView.hidden = YES;
                
                self.numLabel.hidden = YES;

                
            }
            
            self.attentW.constant = 0;
        }
    }
}

-(void)createUI{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:_model.userInfo[@"head_pic"]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    if ([_model.userInfo[@"onlinestate"] intValue] == 0) {
        
        self.onlineLabel.hidden = YES;
        
    }else{
        
        self.onlineLabel.hidden = NO;
    }
    
    self.nameLabel.text = _model.userInfo[@"nickname"];
    
    self.nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self.nameLabel sizeToFit];
    
    self.nameW.constant = self.nameLabel.frame.size.width;
    
    if ([_model.userInfo[@"is_admin"] intValue] == 1) {
        
        self.vipView.hidden = NO;
        
        self.vipView.image = [UIImage imageNamed:@"官方认证"];
        
    }else{
        
        if ([_model.userInfo[@"svipannual"] intValue] == 1) {
            
            self.vipView.hidden = NO;
            
            self.vipView.image = [UIImage imageNamed:@"年svip标识"];
            
        }else if ([_model.userInfo[@"svip"] intValue] == 1){
            
            self.vipView.hidden = NO;
            
            self.vipView.image = [UIImage imageNamed:@"svip标识"];
            
        }else if ([_model.userInfo[@"vipannual"] intValue] == 1) {
            
            self.vipView.hidden = NO;
            
            self.vipView.image = [UIImage imageNamed:@"年费会员"];
            
        }else{
        
            if ([_model.userInfo[@"vip"] intValue] == 1) {
                
                self.vipView.hidden = NO;
                
                self.vipView.image = [UIImage imageNamed:@"高级紫"];
                
            }else{
                
                self.vipView.hidden = YES;
            }
        }
    }

    
    if ([_model.userInfo[@"realname"] intValue] == 0) {
        
        self.idImageView.hidden = YES;
        
        self.idViewW.constant = 0;
        
    }else{
        
        self.idImageView.hidden = NO;
        
        self.idViewW.constant = 16;
    }
    
    //    NSLog(@"jjjjjjjjjjjjj%ld",_integer);
    
    if ([_model.userInfo[@"role"] isEqualToString:@"S"]) {
        
        self.sexualLabel.text = @"斯";
        
        self.sexualLabel.backgroundColor = BOYCOLOR;
        
    }else if ([_model.userInfo[@"role"] isEqualToString:@"M"]){
        
        self.sexualLabel.text = @"慕";
        
        self.sexualLabel.backgroundColor = GIRLECOLOR;
        
    }else if ([_model.userInfo[@"role"] isEqualToString:@"SM"]){
        
        self.sexualLabel.text = @"双";
        
        self.sexualLabel.backgroundColor = CDCOLOR;
    }else{
    
        self.sexualLabel.text = @"~";
        
        self.sexualLabel.backgroundColor = [UIColor colorWithRed:84/255.0 green:185/255.0 blue:36/255.0 alpha:1];
    }
    
    if ([_model.userInfo[@"sex"] intValue] == 1) {
        
        self.sexLabel.image = [UIImage imageNamed:@"男"];
        
        self.aSexView.backgroundColor = BOYCOLOR;
        
    }else if ([_model.userInfo[@"sex"] intValue] == 2){
        
        self.sexLabel.image = [UIImage imageNamed:@"女"];
        
        self.aSexView.backgroundColor = GIRLECOLOR;
        
    }else{
        
        self.sexLabel.image = [UIImage imageNamed:@"双性"];
        
        self.aSexView.backgroundColor = CDCOLOR;
    }
    
    self.ageLabel.text = [NSString stringWithFormat:@"%@",_model.userInfo[@"age"]];
    
    if (![_model.userInfo[@"city"] isEqual:[NSNull null]] && ![_model.userInfo[@"province"] isEqual:[NSNull null]]) {
    
        if ([_model.userInfo[@"city"] length] != 0) {
            
            if ([_model.userInfo[@"city"] isEqualToString:_model.userInfo[@"province"]]) {
                
                self.introduceLabel.text = _model.userInfo[@"city"];
                
            }else{
                
                if ([_model.userInfo[@"province"] length] != 0) {
                    
                    self.introduceLabel.text = [NSString stringWithFormat:@"%@ %@",_model.userInfo[@"province"],_model.userInfo[@"city"]];
                    
                }else{
                    
                    self.introduceLabel.text = [NSString stringWithFormat:@"%@",_model.userInfo[@"city"]];
                }
            }
            
        }else{
            
            self.introduceLabel.text = @"隐身";
        }

    }else{
    
        self.introduceLabel.text = @"隐身";
    }
    
    
    if ([self.otherType intValue] == 0 ||[self.otherType intValue] == 1) {
        
        if ([_model.state intValue] == 0) {
            
            [self.attentButton setBackgroundImage:[UIImage imageNamed:@"关注"] forState:UIControlStateNormal];
            
        }else if ([_model.state intValue] == 1){
        
            [self.attentButton setBackgroundImage:[UIImage imageNamed:@"取消关注"] forState:UIControlStateNormal];
            
        }else if ([_model.state intValue] == 2){
        
            [self.attentButton setBackgroundImage:[UIImage imageNamed:@"被关注"] forState:UIControlStateNormal];
            
        }else if ([_model.state intValue] == 3){
        
            [self.attentButton setBackgroundImage:[UIImage imageNamed:@"互相关注"] forState:UIControlStateNormal];
            
        }else if ([_model.state intValue] == 4){
        
            [self.attentButton setBackgroundImage:nil forState:UIControlStateNormal];
        }
    }
    
    if ([self.type intValue] == 0 && self.type.length != 0) {
        
        if ([_model.state intValue] == 0) {
            
            [self.attentButton setBackgroundImage:[UIImage imageNamed:@"取消关注"] forState:UIControlStateNormal];
            
        }else if ([_model.state intValue] == 1){
        
            [self.attentButton setBackgroundImage:[UIImage imageNamed:@"互相关注"] forState:UIControlStateNormal];
        }
        
    }else if ([self.type intValue] == 1){
    
        if ([_model.state intValue] == 0) {
            
           [self.attentButton setBackgroundImage:[UIImage imageNamed:@"被关注"] forState:UIControlStateNormal];
            
        }else if ([_model.state intValue] == 1){
            
             [self.attentButton setBackgroundImage:[UIImage imageNamed:@"互相关注"] forState:UIControlStateNormal];
            
        }
    
    }
    
    [self getWealthAndCharmState:_wealthLabel andView:_wealthView andText:_model.userInfo[@"wealth_val"] andNSLayoutConstraint:_wealthW andType:@"财富"];
    
    [self getWealthAndCharmState:_charmLabel andView:_charmView andText:_model.userInfo[@"charm_val"]andNSLayoutConstraint:_charmW andType:@"魅力"];
}

-(void)getWealthAndCharmState:(UILabel *)label andView:(UIView *)backView andText:(NSString *)text andNSLayoutConstraint:(NSLayoutConstraint *)constraint andType:(NSString *)type{
    
    if ([type isEqualToString:@"财富"]) {
        
        if ([text intValue] == 0) {
            
            self.wealthSpace.constant = 0;
            
            backView.hidden = YES;
            
            constraint.constant = 0;
            
        }else{
            
            self.wealthSpace.constant = 5;
            
            backView.hidden = NO;
            
            label.text = [NSString stringWithFormat:@"%@",text];
            
            label.textColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1];
            backView.layer.borderColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1].CGColor;
            
            constraint.constant = 27 + [self fitLabelWidth:label.text].width;
        }
        
    }else{
        
        if ([text intValue] == 0) {
            
            backView.hidden = YES;
            
        }else{
            
            backView.hidden = NO;
            
            label.text = [NSString stringWithFormat:@"%@",text];
            
            label.textColor = [UIColor colorWithRed:245/255.0 green:102/255.0 blue:132/255.0 alpha:1];
            backView.layer.borderColor = [UIColor colorWithRed:245/255.0 green:102/255.0 blue:132/255.0 alpha:1].CGColor;
            
            constraint.constant = 27 + [self fitLabelWidth:label.text].width;
        }
    }
    
    backView.layer.borderWidth = 1;
    backView.layer.cornerRadius = 2;
    backView.clipsToBounds = YES;
}

-(CGSize)fitLabelWidth:(NSString *)string{
    
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.0]}];
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    CGSize labelSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    return labelSize;
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.headImageView.layer.cornerRadius = 29;
    self.headImageView.clipsToBounds = YES;
    
    self.aSexView.layer.cornerRadius = 2;
    self.aSexView.clipsToBounds = YES;
    
    self.sexualLabel.layer.cornerRadius = 2;
    self.sexualLabel.clipsToBounds = YES;
    
    self.onlineLabel.layer.cornerRadius = 4;
    self.onlineLabel.clipsToBounds = YES;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
