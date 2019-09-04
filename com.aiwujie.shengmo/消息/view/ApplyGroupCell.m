//
//  ApplyGroupCell.m
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/18.
//  Copyright © 2017年 a. All rights reserved.
//

#import "ApplyGroupCell.h"

@implementation ApplyGroupCell

+(instancetype)cellWithApplyCell:(UITableView *)tableView{

    ApplyGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ApplyGroup"];
    
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"ApplyGroupCell" owner:self options:nil].lastObject;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)setModel:(ApplyGroupModel *)model{

    _model = model;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.head_pic]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    if ([model.state intValue] == 1) {
        
        self.agreeButton.hidden = NO;
        
        self.refuseButton.hidden = NO;
        
        self.completeButton.hidden = YES;
        
        self.contentLabel.hidden = YES;
        
        self.nameLabel.hidden = NO;
        
        self.msgLabel.hidden = NO;
        
        self.nameLabel.text = model.content;
        
        if (model.msg.length == 0) {
            
            self.msgLabel.text = [NSString stringWithFormat:@"验证消息:未填写"];
            
        }else{
            
            self.msgLabel.text = [NSString stringWithFormat:@"验证消息:%@",model.msg];
        }
        
    }else if ([model.state intValue] == 2) {
        
        self.agreeButton.hidden = YES;
        
        self.refuseButton.hidden = YES;
        
        self.completeButton.hidden = NO;
        
        self.contentLabel.hidden = YES;
        
        self.nameLabel.hidden = NO;
        
        self.msgLabel.hidden = NO;
        
        self.nameLabel.text = model.content;
        
        if (model.msg.length == 0) {
            
            self.msgLabel.text = [NSString stringWithFormat:@"验证消息:未填写"];
            
        }else{
            
            self.msgLabel.text = [NSString stringWithFormat:@"验证消息:%@",model.msg];
        }
        
    }else if([model.state intValue] == 0){
    
        self.agreeButton.hidden = YES;
        
        self.refuseButton.hidden = YES;
        
        self.completeButton.hidden = YES;
        
        self.nameLabel.hidden = YES;
        
        self.msgLabel.hidden = YES;
        
        self.contentLabel.hidden = NO;
        
        self.contentLabel.text = model.content;
    }
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.headView.layer.cornerRadius = 25;
    self.headView.clipsToBounds = YES;
    
    self.refuseButton.layer.cornerRadius = 2;
    self.refuseButton.clipsToBounds = YES;
    
    self.agreeButton.layer.cornerRadius = 2;
    self.agreeButton.clipsToBounds = YES;
    
    self.completeButton.layer.cornerRadius = 2;
    self.completeButton.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
