//
//  DynamicCell.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/21.
//  Copyright © 2017年 a. All rights reserved.
//

#import "DynamicCell.h"
#import "LDOwnInformationViewController.h"

@implementation DynamicCell

-(void)setModel:(DynamicModel *)model{

    _model = model;
    
    for (UIView *view in self.picView.subviews) {
    
        if ([view isKindOfClass:[UIImageView class]]) {
            
            [view removeFromSuperview];
        }
    }
    
    for (UIView *view in self.contentView.subviews) {
        
        if ([view isKindOfClass:[UIButton class]] && view.frame.origin.y > self.headButton.frame.origin.y && view.frame.origin.y < self.picView.frame.origin.y) {
            
            [view removeFromSuperview];
        }
    }
    
    [self.headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.head_pic]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    self.nameLabel.text = model.nickname;
    
    [self.nameLabel sizeToFit];
    
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
    
    if (model.stickstate.length != 0) {
        
        if ([model.uid intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
            
            if ([model.stickstate intValue] == 1) {
                
                self.recommendView.image = [UIImage imageNamed:@"置顶动态图标"];
                
                self.recommendView.hidden = NO;
                
            }else if([model.is_hidden intValue] == 1){
            
                self.recommendView.image = [UIImage imageNamed:@"隐藏动态"];
                
                self.recommendView.hidden = NO;
                
            }else if([model.recommend intValue] != 0){
            
                self.recommendView.image = [UIImage imageNamed:@"推荐动态"];
                
                self.recommendView.hidden = NO;
                
            }else{
            
                self.recommendView.hidden = YES;
            }
            
        }else{
            
            if([model.is_hidden intValue] == 1){
                
                self.recommendView.image = [UIImage imageNamed:@"隐藏动态"];
                
                self.recommendView.hidden = NO;
                
            }else{
                
                if([model.recommend intValue] != 0){
                    
                    self.recommendView.image = [UIImage imageNamed:@"推荐动态"];
                    
                    self.recommendView.hidden = NO;
                    
                }else{
                    
                    self.recommendView.hidden = YES;
                }
            }
        }

        if ([model.recommend intValue] == 0) {
         
            self.scanLabel.text = @"";
            
            self.distanceY.constant = 20;
            
        }else{
        
            self.scanLabel.text = [NSString stringWithFormat:@"浏览 %@",model.readtimes];
            
            self.distanceY.constant = 38;
        }
        
        
    }else{
        
        if([model.is_hidden intValue] == 1){
            
            self.recommendView.image = [UIImage imageNamed:@"隐藏动态"];
            
            self.recommendView.hidden = NO;
            
            if ([model.recommend intValue] == 0) {
                
                self.scanLabel.text = @"";
                
                self.distanceY.constant = 20;
                
            }else{
                
                self.scanLabel.text = [NSString stringWithFormat:@"浏览 %@",model.readtimes];
                
                self.distanceY.constant = 38;
            }
            
        }else{
            
            if ([model.recommend intValue] == 0) {
                
                self.recommendView.hidden = YES;
                
                self.scanLabel.text = @"";
                
                self.distanceY.constant = 20;
                
            }else{
                
                self.scanLabel.text = [NSString stringWithFormat:@"浏览 %@",model.readtimes];
                
                self.distanceY.constant = 38;
                
                self.recommendView.hidden = NO;
                
                if (model.recommendall.length != 0) {
                    
                    if ([model.recommendall intValue] > 0) {
                        
                        self.recommendView.image = [UIImage imageNamed:@"置顶动态图标"];
                        
                    }else{
                        
                        self.recommendView.image = [UIImage imageNamed:@"推荐动态"];
                    }
                    
                }else{
                    
                    self.recommendView.image = [UIImage imageNamed:@"推荐动态"];
                }
            }
        }
    }
    
    if ([model.is_hand intValue] == 1) {
        
        self.handleView.hidden = NO;
        
    }else{
    
        self.handleView.hidden = YES;
    }
    
    if ([model.onlinestate intValue] == 1) {
        
        self.onlineLabel.hidden = NO;
        
    }else{
    
        self.onlineLabel.hidden = YES;
    }
    
    if ([model.realname intValue] == 1) {
        
        self.idView.hidden = NO;
        
        self.idViewW.constant = 17;
        
    }else{
    
        self.idView.hidden = YES;
        
        self.idViewW.constant = 0;
    }
    
    
    if (self.integer == 2001){
        
        if (model.commenttime.length != 0) {
            
            self.distanceLabel.text = [NSString stringWithFormat:@"%@回复",model.addtime];
            
        }else{
        
            self.distanceLabel.text = [NSString stringWithFormat:@"%@",model.addtime];
        }
        
    }else{
        
        if (model.commenttime.length != 0) {
            
            self.distanceLabel.text = [NSString stringWithFormat:@"%@km %@回复",model.distance,model.addtime];
            
        }else{
            
           self.distanceLabel.text = [NSString stringWithFormat:@"%@km %@",model.distance,model.addtime];
        }
        
    }
    
    NSString *content = [NSString string];
    
    if (model.topictitle.length == 0) {
        
        content = model.content;
        
        [self setAttributedString:content andIsHaveTopic:NO];
        
    }else{
        
        content = [NSString stringWithFormat:@"#%@# %@",model.topictitle,model.content];
        
        [self setAttributedString:content andIsHaveTopic:YES];
        
    }
    
    
    self.commentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    CGSize size = [self.commentLabel sizeThatFits:CGSizeMake(WIDTH - 16, MAXFLOAT)];
    
    if (self.commentLabel.text.length == 0) {
        
        self.commentH.constant = 0;
        
    }else{
        
        self.commentH.constant = size.height;
    }
    
    self.zanLabel.text = [NSString stringWithFormat:@"%@",model.laudnum];
    
    if (model.pic.count != 0) {
        
        if (_model.pic.count == 1) {
            
            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 240, 240)];
            
            [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.pic[0]]] placeholderImage:[UIImage imageNamed:@"动态图片默认"]];
            
            imageV.userInteractionEnabled = YES;
            
            imageV.tag = self.indexPath.section * 100;
            
            imageV.contentMode = UIViewContentModeScaleAspectFill;
            
            imageV.clipsToBounds = YES;
            
            self.picH.constant = 240;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            
            [imageV addGestureRecognizer:tap];
            
            [_picView addSubview:imageV];
                      
        }else if (_model.pic.count > 1){
            
            for (int i = 0; i < _model.pic.count; i++) {
                
                UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(i%3 * (WIDTH - 24)/3 + i%3 * 4, i/3 * (WIDTH - 24)/3 + i/3 * 4, (WIDTH - 24)/3, (WIDTH - 24)/3)];
                
                [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_model.pic[i]]] placeholderImage:[UIImage imageNamed:@"动态图片默认"]];
                
                imageV.contentMode = UIViewContentModeScaleAspectFill;
                
                imageV.clipsToBounds = YES;
                
                imageV.userInteractionEnabled = YES;
                
                imageV.tag = self.indexPath.section * 100 + i;
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
                
                
                [imageV addGestureRecognizer:tap];

                
                [_picView addSubview:imageV];

            }
            
            if (_model.pic.count <= 3 && _model.pic.count > 1) {
                
                self.picH.constant = (WIDTH - 24)/3;
                
            }else if(_model.pic.count > 3 && _model.pic.count <= 6){
                
                self.picH.constant = 2 * (WIDTH - 24)/3 + 4;
                
            }else{
                
                self.picH.constant = 3 * (WIDTH - 24)/3 + 8;
            }
            
        }
        
    }else{
    
        self.picH.constant = 0;
    }

    if ([model.laudstate intValue] == 0) {
        
        self.zanImageView.image = [UIImage imageNamed:@"赞灰"];
        
    }else{
        
        self.zanImageView.image = [UIImage imageNamed:@"赞紫"];
    }
    
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
    
    self.ageLabel.text = [NSString stringWithFormat:@"%@",_model.age];
    
    self.contentLabel.text = [NSString stringWithFormat:@"%@",_model.comnum];

    self.rewardLabel.text = [NSString stringWithFormat:@"%@",_model.rewardnum];
    
    [self getWealthAndCharmState:_wealthLabel andView:_wealthView andNSLayoutConstraint:_wealthW andType:@"财富"];
    
    [self getWealthAndCharmState:_charmLabel andView:_charmView andNSLayoutConstraint:_charmW andType:@"魅力"];
    
}

/**
 * 富文本文字设置
 */
-(void)setAttributedString:(NSString *)content andIsHaveTopic:(BOOL)haveTopic{

    // 调整行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, [content length])];
    
    if (haveTopic) {
        
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:183/255.0 green:53/255.0 blue:208/255.0 alpha:1] range:NSMakeRange(0, [[NSString stringWithFormat:@"#%@#",_model.topictitle] length])];
        
        CGSize size = [[NSString stringWithFormat:@"#%@#",_model.topictitle] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.commentLabel.frame.origin.x, self.commentLabel.frame.origin.y, size.width, size.height)];
        
        [button addTarget:self action:@selector(topicButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button];
    }
    
    self.commentLabel.attributedText = attributedString;
    
}

/**
 * 获取并创建财富榜和魅力榜
 */
-(void)getWealthAndCharmState:(UILabel *)label andView:(UIView *)backView andNSLayoutConstraint:(NSLayoutConstraint *)constraint andType:(NSString *)type{
    
    if ([type isEqualToString:@"财富"]) {
        
        if ([_model.wealth_val intValue] == 0) {
            
            self.wealthSpace.constant = 0;
            
            backView.hidden = YES;
            
            constraint.constant = 0;
            
        }else{
            
            self.wealthSpace.constant = 5;
            
            backView.hidden = NO;
            
            label.text = [NSString stringWithFormat:@"%@",_model.wealth_val];
            label.textColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1];
            backView.layer.borderColor = [UIColor colorWithRed:244/255.0 green:191/255.0 blue:62/255.0 alpha:1].CGColor;
            
            constraint.constant = 27 + [self fitLabelWidth:label.text].width;
        }
        
    }else{
        
        if ([_model.charm_val intValue] == 0) {
            
            backView.hidden = YES;
            
        }else{
            
            backView.hidden = NO;
            
            label.text = [NSString stringWithFormat:@"%@",_model.charm_val];
            label.textColor = [UIColor colorWithRed:245/255.0 green:102/255.0 blue:132/255.0 alpha:1];
            backView.layer.borderColor = [UIColor colorWithRed:245/255.0 green:102/255.0 blue:132/255.0 alpha:1].CGColor;
            
            constraint.constant = 27 + [self fitLabelWidth:label.text].width;
        }
    }
    
    backView.layer.borderWidth = 1;
    backView.layer.cornerRadius = 2;
    backView.clipsToBounds = YES;
}

/**
 * 文字自适应宽度
 */
-(CGSize)fitLabelWidth:(NSString *)string{
    
    CGSize size = [string sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10.0]}];
    // ceilf()向上取整函数, 只要大于1就取整数2. floor()向下取整函数, 只要小于2就取整数1.
    CGSize labelSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
    
    return labelSize;
    
}

#pragma 点击图片调用代理方法
-(void)tap:(UITapGestureRecognizer *)tap{
    
    if ([self.delegate respondsToSelector:@selector(tap:)]) {
        
         [_delegate tap:tap];
    }

}

#pragma 点击话题调用代理方法
-(void)topicButtonClick{
    
    if (_model.topictitle.length != 0) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(transmitClickModel:)]) {
            
            [self.delegate transmitClickModel:_model];
        }
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.bounds = [UIScreen mainScreen].bounds;
    
    self.headView.layer.cornerRadius = 20;
    self.headView.clipsToBounds = YES;
    
    self.onlineLabel.layer.cornerRadius = 4;
    self.onlineLabel.clipsToBounds = YES;
    
    self.aSexView.layer.cornerRadius = 2;
    self.aSexView.clipsToBounds = YES;
    
    self.sexualLabel.layer.cornerRadius = 2;
    self.sexualLabel.clipsToBounds = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
