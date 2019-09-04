//
//  TopicCell.h
//  圣魔无界
//
//  Created by 爱无界 on 2017/7/19.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicModel.h"

@interface TopicCell : UITableViewCell

@property (nonatomic,strong) TopicModel *model;
@property (nonatomic,strong) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UIImageView *topicImageView;
@property (weak, nonatomic) IBOutlet UILabel *topicLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicIntroduceLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicJoinLabel;
@property (weak, nonatomic) IBOutlet UILabel *topicDynamicLabel;

@end
