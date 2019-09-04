//
//  AtCell.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/5/4.
//  Copyright © 2017年 a. All rights reserved.
//

#import "AtCell.h"

@implementation AtCell

-(void)setModel:(AtModel *)model{
    
    _model = model;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.headView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.head_pic]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@在动态中提到了你",model.nickname];
    
    self.timeLabel.text = [self timeWithTimeIntervalString:model.addtime];
    
    if (model.content.length != 0) {
        
        self.ccomentLabel.text = model.content;
        
    }else{
        
        [self.ccomentView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",URL,model.pic]] placeholderImage:nil];
    }
}

- (NSString *)timeWithTimeIntervalString:(int)time
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:time];
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.headView.layer.cornerRadius = 20;
    self.headView.clipsToBounds = YES;
    
    self.ccomentView.layer.cornerRadius = 2;
    self.ccomentView.clipsToBounds = YES;
    
    self.ccomentLabel.layer.cornerRadius = 2;
    self.ccomentLabel.clipsToBounds = YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
