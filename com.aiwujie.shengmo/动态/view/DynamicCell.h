//
//  DynamicCell.h
//  com.aiwujie.shengmo
//
//  Created by a on 17/1/21.
//  Copyright © 2017年 a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicModel.h"

@protocol DynamicDelegate <NSObject>

@optional

-(void)tap:(UITapGestureRecognizer *)tap;

-(void)transmitClickModel:(DynamicModel *)model;

@end

@interface DynamicCell : UITableViewCell<YBAttributeTapActionDelegate>

@property (nonatomic,strong) DynamicModel *model;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,assign) NSInteger integer;

@property (nonatomic,strong) id <DynamicDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *headButton;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *onlineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *handleView;
@property (weak, nonatomic) IBOutlet UIImageView *vipView;
@property (weak, nonatomic) IBOutlet UIImageView *idView;
@property (weak, nonatomic) IBOutlet UIView *aSexView;
@property (weak, nonatomic) IBOutlet UIImageView *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexualLabel;
@property (weak, nonatomic) IBOutlet UILabel *scanLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceY;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *picH;
@property (weak, nonatomic) IBOutlet UIView *picView;
@property (weak, nonatomic) IBOutlet UILabel *zanLabel;
@property (weak, nonatomic) IBOutlet UIView *zanView;
@property (weak, nonatomic) IBOutlet UIButton *zanButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *rewardButton;
@property (weak, nonatomic) IBOutlet UIImageView *zanImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *idViewW;
@property (weak, nonatomic) IBOutlet UILabel *rewardLabel;
@property (weak, nonatomic) IBOutlet UIImageView *recommendView;

//添加财富和魅力值的显示
@property (weak, nonatomic) IBOutlet UIView *wealthView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wealthW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wealthSpace;
@property (weak, nonatomic) IBOutlet UILabel *wealthLabel;
@property (weak, nonatomic) IBOutlet UIView *charmView;
@property (weak, nonatomic) IBOutlet UILabel *charmLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *charmW;



@end
