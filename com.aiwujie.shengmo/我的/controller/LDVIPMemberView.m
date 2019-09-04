//
//  LDVIPMemberView.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/11/21.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDVIPMemberView.h"

@implementation LDVIPMemberView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self == [super initWithCoder:aDecoder]) {
        
        
        
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

-(instancetype)initWithVIPtype:(NSString *)type{
    
    if (self == [super init]) {
        
        [self setUpUI:type];
    }
    
    return self;
}

-(void)setUpUI:(NSString *)type{
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    sectionView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5" alpha:1];
    [self addSubview:sectionView];
    
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, (CGRectGetHeight(sectionView.frame) - 30)/2, WIDTH - 28, 30)];
    sectionLabel.font = [UIFont systemFontOfSize:15];
    [sectionView addSubview:sectionLabel];
    
    UIView *privilegeView = [[UIView alloc] init];
    [self addSubview:privilegeView];
    
    NSArray *array = [NSArray array];
    
    if ([type intValue] == 0) {
        
        sectionLabel.text = @"VIP会员特权";
        
        array = @[@"[专属]-尊贵紫V表示身份",@"[专属]-可看到Ta的最后登录时间",@"[专属]-查看谁看过我,知道谁对我感兴趣",@"[专属]-可查看动态广场,浏览所有用户发布的最新动态",@"[专属]-可查看他人相册、自我介绍、动态",@"[专属]-可使用地图找人特权,穿越地球去找你",@"[专属]-可使用高级搜索功能",@"[专属]-可出现在附近-推荐中(年会员最靠前)",@"[专属]-可立即创建500人群(年会员1000人)",@"[专属]-群成员列表排名靠前",@"[专属]-每月可修改3次昵称",@"[专属]-可使用相册的加密功能,照片由6张升级为15张",@"[专属]-可在个人主页置顶一篇动态",@"[专属]-可预推荐自己或他人动态",@"[专属]-发布的动态将会被优先推荐"];
        
    }else{
        
        sectionLabel.text = @"SVIP会员特权";
        
        array = @[@"[专属]-收发消息无需邮票,无限畅聊!",@"[专属]-其他人给SVIP发消息也无需邮票",@"[专属]-包含普通VIP会员所有特权",@"[专属]-聊天对话页显示红色昵称",@"[专属]-可创建1500人群组(年会员2000人)",@"[专属]-可编辑已发布动态",@"[专属]-各列表排名最前",@"[专属]-优先成为官方群组管理员",@"[专属]-豪华金V标识"];
    }
    
    CGFloat lineSpace = 6;
    
    CGFloat wordFont;
    
    if (WIDTH == 320) {
        
        wordFont = 12;
        
    }else{
        
        wordFont = 13;
    }
    
    for (int i = 0; i < array.count; i++) {
        
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + 15 * i + lineSpace * i, 20, 15)];
        numLabel.text = [NSString stringWithFormat:@"%d.",i + 1];
        numLabel.font = [UIFont systemFontOfSize:wordFont];
        numLabel.textAlignment = NSTextAlignmentCenter;
        [privilegeView addSubview:numLabel];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(numLabel.frame), 10 + 15 * i + lineSpace * i, WIDTH - 10, 15)];
        label.text = array[i];
        label.font = [UIFont systemFontOfSize:wordFont];
        [privilegeView addSubview:label];
        
        //更改[专属]的颜色
        [self changeWordColorTitle:label.text andLoc:0 andLen:4 andLabel:label];
        
        if (i == array.count - 1) {
                
            privilegeView.frame = CGRectMake(0, CGRectGetMaxY(sectionView.frame), WIDTH, CGRectGetMaxY(label.frame));
        }
    }
    
    if ([type intValue] == 0) {
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(privilegeView.frame) + 30, WIDTH - 20, 15)];
        
    }else{
        
        UILabel *warnLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, lineSpace + CGRectGetMaxY(privilegeView.frame), WIDTH - 24, 0)];
        warnLabel.text = @"升级无忧:已是VIP会员的用户,开通SVIP会员后VIP会暂停计时,待SVIP到期后VIP恢复计时,从而不给您造成任何损失,让您无后顾之忧!";
        warnLabel.font = [UIFont systemFontOfSize:wordFont];
        //更改升级无忧颜色
        [self changeWordColorTitle:warnLabel.text andLoc:0 andLen:5 andLabel:warnLabel];
        warnLabel.numberOfLines = 0;
        [warnLabel sizeToFit];
        warnLabel.frame = CGRectMake(12, lineSpace + CGRectGetMaxY(privilegeView.frame) + 10, WIDTH - 24, warnLabel.frame.size.height);
        [self addSubview:warnLabel];
        
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(warnLabel.frame) + 30, WIDTH - 20, 15)];
    }

    if ([type intValue] == 0){
        
        _moneyLabel.text = @"金额 30 元";
        
        //更改钱数的颜色
        [self changeWordColorTitle:_moneyLabel.text andLoc:3 andLen:2 andLabel:_moneyLabel];
        
    }else{
        
        _moneyLabel.text = @"金额 128 元";
        
        //更改钱数的颜色
        [self changeWordColorTitle:_moneyLabel.text andLoc:3 andLen:3 andLabel:_moneyLabel];
    }
    
    _moneyLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_moneyLabel];
    
    UILabel *protcolLabel = [[UILabel alloc] init];
    protcolLabel.font = [UIFont systemFontOfSize:13];
    protcolLabel.text = @"成为会员即表示已阅读并同意 圣魔会员协议";
    protcolLabel.userInteractionEnabled = YES;
    [protcolLabel sizeToFit];
    protcolLabel.frame = CGRectMake(15, CGRectGetMaxY(_moneyLabel.frame) + 10, CGRectGetWidth(protcolLabel.frame), 15);
    protcolLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:protcolLabel];
    
    [self changeWordColorTitle:protcolLabel.text andLoc:protcolLabel.text.length - 6 andLen:6 andLabel:protcolLabel];
    
    UIButton *protcolButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(protcolLabel.frame) - 150, 0, 150, 15)];
    [protcolButton addTarget:self action:@selector(protcolButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [protcolLabel addSubview:protcolButton];
    
    self.frame = CGRectMake(0, 0, WIDTH, CGRectGetMaxY(protcolLabel.frame) + 10);
}

-(void)protcolButtonClick{
    
    if ([self.delegate respondsToSelector:@selector(vipMemberProtcolDidSelect)]) {
        
        [self.delegate vipMemberProtcolDidSelect];
    }
}

//更改某个字体的颜色
-(void)changeWordColorTitle:(NSString *)str andLoc:(NSUInteger)loc andLen:(NSUInteger)len andLabel:(UILabel *)attributedLabel{
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:CDCOLOR range:NSMakeRange(loc,len)];
    attributedLabel.attributedText = attributedStr;
}

@end
