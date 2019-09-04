//
//  TopicCell.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/7/19.
//  Copyright © 2017年 a. All rights reserved.
//

#import "TopicCell.h"

@implementation TopicCell

-(void)setModel:(TopicModel *)model{

    _model = model;
    
    NSArray *colorArray = @[@"0xff0000",@"0xb73acb",@"0x0000ff",@"0x18a153",@"0xf39700",@"0xff00ff",@"0x00a0e9"];
    
    [self.topicImageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:[UIImage imageNamed:@"动态图片默认"]];
    
    self.topicLabel.text = [NSString stringWithFormat:@"#%@#",model.title];
    
    self.topicLabel.textColor = UIColorFromRGB(strtoul([colorArray[_indexPath.section%7] UTF8String], 0, 0));
    
    self.topicIntroduceLabel.text = [NSString stringWithFormat:@"%@",model.introduce];
    
    self.topicJoinLabel.text = [NSString stringWithFormat:@"%@参与",model.partaketimes];
    
    self.topicDynamicLabel.text = [NSString stringWithFormat:@"%@动态",model.dynamicnum];
}
- (IBAction)tapHeadImageView:(id)sender {
    
    [XWScanImage scanBigImageWithImageView:self.topicImageView];
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
