//
//  CommentCell.h
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/23.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "commentModel.h"

@interface CommentCell : UITableViewCell

@property (nonatomic,strong) commentModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentH;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIImageView *handleView;
@property (weak, nonatomic) IBOutlet UIImageView *vipView;

@end
