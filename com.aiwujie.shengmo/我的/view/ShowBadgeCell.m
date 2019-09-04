//
//  ShowBadgeCell.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/3/23.
//  Copyright © 2017年 a. All rights reserved.
//

#import "ShowBadgeCell.h"

@implementation ShowBadgeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.badgeLabel.layer.cornerRadius = 10;
    self.badgeLabel.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
