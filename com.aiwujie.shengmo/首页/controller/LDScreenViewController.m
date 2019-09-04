//
//  LDScreenViewController.m
//  com.aiwujie.shengmo
//
//  Created by a on 16/12/20.
//  Copyright © 2016年 a. All rights reserved.
//

#import "LDScreenViewController.h"

@interface LDScreenViewController ()<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>

//选择开关
@property (weak, nonatomic) IBOutlet UISwitch *screenSwitch;
@property(nonatomic,assign) BOOL isScreen;
@property (weak, nonatomic) IBOutlet UISwitch *onlineSwitch;
@property(nonatomic,assign) BOOL isOnline;
@property (weak, nonatomic) IBOutlet UISwitch *hightSwitch;
@property(nonatomic,assign) BOOL isHight;
@property(nonatomic,assign) BOOL isAuthen;
@property (weak, nonatomic) IBOutlet UISwitch *authenSwitch;

//用来存储选择的状态，如果确定筛选则存到本地，不确定筛选直接返回的话就不存
@property (nonatomic,copy) NSString *screenString;
@property (nonatomic,copy) NSString *onlineString;
@property (nonatomic,copy) NSString *ageString;
@property (nonatomic,copy) NSString *sexString;
@property (nonatomic,copy) NSString *sexualString;
@property (nonatomic,copy) NSString *roleString;
@property (nonatomic,copy) NSString *hightString;
@property (nonatomic,copy) NSString *educationString;
@property (nonatomic,copy) NSString *monthString;
@property (nonatomic,copy) NSString *authenString;

//性别选中状态数组
@property (nonatomic,strong) NSMutableArray *sexArray;
@property (nonatomic,strong) NSMutableArray *sexStateArray;

//性取向选中状态数组
@property (nonatomic,strong) NSMutableArray *sexualArray;
@property (nonatomic,strong) NSMutableArray *sexualStateArray;

//角色选中状态数组
@property (nonatomic,strong) NSMutableArray *roleArray;
@property (nonatomic,strong) NSMutableArray *roleStateArray;

//关闭开关的遮挡view
@property(nonatomic,strong) UIView *fontView;

@property(nonatomic,strong) UIButton *rightButton;

@property(nonatomic,assign) NSInteger j;

//年龄选择
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UIButton *ageButton;
@property(nonatomic,strong) UIPickerView *pickerView;
@property(nonatomic,strong) UIView *LVShadowView;
@property(nonatomic,strong) UIView *LVView;
@property(nonatomic,strong) NSMutableArray *ageArray;
@property(nonatomic,copy) NSString *minAge;
@property(nonatomic,copy) NSString *maxAge;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;

//学历
@property (weak, nonatomic) IBOutlet UILabel *educationLabel;
@property (weak, nonatomic) IBOutlet UIButton *educationButton;
@property(nonatomic,strong) NSArray *educationArray;
@property(nonatomic,copy) NSString *education;
@property(nonatomic,copy) NSString *educationRow;

//月收入
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIButton *monthButton;
@property(nonatomic,strong) NSArray *monthArray;
@property(nonatomic,copy) NSString *month;
@property(nonatomic,copy) NSString *monthRow;

@end

@implementation LDScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"条件筛选";
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"screen"];
    
    _ageArray = [NSMutableArray array];
    
    for (int i = 17; i <= 80; i++) {
        
        if (i == 17) {
            
            [_ageArray addObject:@"不限"];
            
        }else{
            
            [_ageArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
    
    _educationArray = @[@"不限",@"高中及以下",@"大专",@"本科",@"双学士",@"硕士",@"博士",@"博士后"];

    
    _monthArray = @[@"不限",@"2000以下",@"2000-5000",@"5000-10000",@"10000-20000",@"20000-50000",@"50000以上"];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sexButton"] length] == 0){
        
        _sexArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"13", nil];
        
        _sexStateArray = [NSMutableArray arrayWithObjects:@"no",@"no",@"no",@"yes", nil];
        
    }else{
    
        NSArray *sexArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"sexButton"] componentsSeparatedByString:@","];
        
        _sexArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
        
        _sexStateArray = [NSMutableArray arrayWithObjects:@"no",@"no",@"no",@"no", nil];
        
        for (int i = 0; i< sexArray.count; i++) {
            
            if ([sexArray[i] intValue] == 0) {
                
                [_sexArray replaceObjectAtIndex:3 withObject:@"13"];
                
                [_sexStateArray replaceObjectAtIndex:3 withObject:@"yes"];
                
            }else{
            
                [_sexArray replaceObjectAtIndex:[sexArray[i] intValue] - 1 withObject:[NSString stringWithFormat:@"%d",[sexArray[i] intValue] + 9]];
                
                [_sexStateArray replaceObjectAtIndex:[sexArray[i] intValue] - 1 withObject:@"yes"];
            }
            
            
        }
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"sexualButton"] length] == 0){
        
        _sexualArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"23", nil];
        
        _sexualStateArray = [NSMutableArray arrayWithObjects:@"no",@"no",@"no",@"yes", nil];
        
    }else{
        
        NSArray *sexualArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"sexualButton"] componentsSeparatedByString:@","];
        
        _sexualArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
        
        _sexualStateArray = [NSMutableArray arrayWithObjects:@"no",@"no",@"no",@"no", nil];
        
        for (int i = 0; i< sexualArray.count; i++) {
            
            if ([sexualArray[i] intValue] == 0) {
                
                [_sexualArray replaceObjectAtIndex:3 withObject:@"23"];
                
                [_sexualStateArray replaceObjectAtIndex:3 withObject:@"yes"];
                
            }else{
                
                [_sexualArray replaceObjectAtIndex:[sexualArray[i] intValue] - 1 withObject:[NSString stringWithFormat:@"%d",[sexualArray[i] intValue] + 19]];
                
                [_sexualStateArray replaceObjectAtIndex:[sexualArray[i] intValue] - 1 withObject:@"yes"];
            }
        }
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"roleButton"] length] == 0){
        
        _roleArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"34", nil];
        
        _roleStateArray = [NSMutableArray arrayWithObjects:@"no",@"no",@"no",@"no",@"yes", nil];
        
    }else{
        
        NSArray *roleArray = [[[NSUserDefaults standardUserDefaults] objectForKey:@"roleButton"] componentsSeparatedByString:@","];
        
        _roleArray = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
        
        _roleStateArray = [NSMutableArray arrayWithObjects:@"no",@"no",@"no",@"no",@"no", nil];
        
        for (int i = 0; i< roleArray.count; i++) {
            
            if ([roleArray[i] intValue] == 0) {
                
                [_roleArray replaceObjectAtIndex:4 withObject:@"34"];
                
                [_roleStateArray replaceObjectAtIndex:4 withObject:@"yes"];
                
            }else{
                
                [_roleArray replaceObjectAtIndex:[roleArray[i] intValue] - 1 withObject:[NSString stringWithFormat:@"%d",[roleArray[i] intValue] + 29]];
                
                [_roleStateArray replaceObjectAtIndex:[roleArray[i] intValue] - 1 withObject:@"yes"];
            }
        }
    }

    //当用户关闭筛选开关时显示
    self.fontView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, WIDTH, HEIGHT - 44)];
    
    self.fontView.backgroundColor = [UIColor whiteColor];
    
    self.fontView.alpha = 0.5;
    
    [self.view addSubview:self.fontView];
    
    //创建右上角完成按钮
    [self createRightButton];
    
    //进入界面赋值
    _screenString = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchSwitch"];
    _onlineString = [[NSUserDefaults standardUserDefaults] objectForKey:@"online"];
     _ageString = [[NSUserDefaults standardUserDefaults] objectForKey:@"screenAge"];
    _educationString = [[NSUserDefaults standardUserDefaults] objectForKey:@"screenEducation"];
    _educationRow = [[NSUserDefaults standardUserDefaults] objectForKey:@"educationRow"];
    _monthString = [[NSUserDefaults standardUserDefaults] objectForKey:@"screenMonth"];
    _monthRow = [[NSUserDefaults standardUserDefaults] objectForKey:@"monthRow"];
    _hightString = [[NSUserDefaults standardUserDefaults] objectForKey:@"hight"];
    _authenString = [[NSUserDefaults standardUserDefaults] objectForKey:@"authen"];
    
    _minAge = [[NSUserDefaults standardUserDefaults] objectForKey:@"minAge"];
    
    _maxAge = [[NSUserDefaults standardUserDefaults] objectForKey:@"maxAge"];
    
    //如果有数据显示年龄、学历、月收入
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"screenAge"] length] != 0) {
        
        self.ageLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"screenAge"];
    }
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"screenEducation"] length] != 0) {
        
        self.educationLabel.text = _educationArray[[[[NSUserDefaults standardUserDefaults] objectForKey:@"screenEducation"] intValue]];
        
        
    }
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"screenMonth"] length] != 0) {
        
        self.monthLabel.text = _monthArray[[[[NSUserDefaults standardUserDefaults] objectForKey:@"screenMonth"] intValue]];
        
        
    }

    
    //判定是否是会员
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 0) {
        
        self.vipImageView.image = [UIImage imageNamed:@"高级灰"];
        
        _hightSwitch.on = NO;
        
        _authenSwitch.on = NO;
        
        _onlineSwitch.on = NO;
        
        _educationButton.userInteractionEnabled = NO;
        
        _hightSwitch.userInteractionEnabled = NO;
        
        _monthButton.userInteractionEnabled = NO;
        
        _authenSwitch.userInteractionEnabled = NO;
        
        _ageButton.userInteractionEnabled = NO;
        
        _onlineSwitch.userInteractionEnabled = NO;
        
        self.educationLabel.text = nil;
        
        self.ageLabel.text = nil;
        
        self.monthLabel.text = nil;
        
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1){
        
        self.vipImageView.image = [UIImage imageNamed:@"高级紫"];
    }

    
    //筛选开关开启与否的判断
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"searchSwitch"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"searchSwitch"] integerValue] == 0) {
        
        _isScreen = NO;
        
        _screenSwitch.on = NO;
        
        self.fontView.hidden = NO;
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hight"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hight"] integerValue] == 0) {
            
            _isHight = NO;
            
            _hightSwitch.on = NO;
            
            _authenSwitch.on = NO;
            
            _onlineSwitch.on = NO;
            
            _onlineSwitch.userInteractionEnabled = NO;
            
            _authenSwitch.userInteractionEnabled = NO;
            
            _educationButton.userInteractionEnabled = NO;
            
            _monthButton.userInteractionEnabled = NO;
            
            _ageButton.userInteractionEnabled = NO;
            
        }else{
            
            _isHight = YES;
            
            _hightSwitch.on = YES;
            
            _onlineSwitch.userInteractionEnabled = YES;
            
            _authenSwitch.userInteractionEnabled = YES;
            
            _educationButton.userInteractionEnabled = YES;
            
            _monthButton.userInteractionEnabled = YES;
            
            _ageButton.userInteractionEnabled = YES;
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"authen"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"authen"] integerValue] == 0) {
                
                _isAuthen = NO;
                
                _authenSwitch.on = NO;
                
            }else{
                
                _isAuthen = YES;
                
                _authenSwitch.on = YES;
                
            }
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"online"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"online"] integerValue] == 0) {
                
                _isOnline = NO;
                
                _onlineSwitch.on = NO;
                
            }else{
                
                _isOnline = YES;
                
                _onlineSwitch.on = YES;
                
            }
        }

        
    }else{
        
        _isScreen = YES;
        
        _screenSwitch.on = YES;
        
        self.fontView.hidden = YES;
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 0) {
            
            _hightSwitch.userInteractionEnabled = NO;
            
        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"vip"] intValue] == 1){
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hight"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hight"] integerValue] == 0) {
                
                _isHight = NO;
                
                _hightSwitch.on = NO;
                
                _authenSwitch.on = NO;
                
                _onlineSwitch.on = NO;
                
                _authenSwitch.userInteractionEnabled = NO;
                
                _onlineSwitch.userInteractionEnabled = NO;
                
                _educationButton.userInteractionEnabled = NO;
                
                _ageButton.userInteractionEnabled = NO;
                
                _monthButton.userInteractionEnabled = NO;
                
            }else{
                
                _isHight = YES;
                
                _hightSwitch.on = YES;
                
                _authenSwitch.userInteractionEnabled = YES;
                
                _onlineSwitch.userInteractionEnabled = YES;
                
                _educationButton.userInteractionEnabled = YES;
                
                _ageButton.userInteractionEnabled = YES;
                
                _monthButton.userInteractionEnabled = YES;
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"authen"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"authen"] integerValue] == 0) {
                    
                    _isAuthen = NO;
                    
                    _authenSwitch.on = NO;
                    
                }else{
                    
                    _isAuthen = YES;
                    
                    _authenSwitch.on = YES;
                    
                }
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"online"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"online"] integerValue] == 0) {
                    
                    _isOnline = NO;
                    
                    _onlineSwitch.on = NO;
                    
                }else{
                    
                    _isOnline = YES;
                    
                    _onlineSwitch.on = YES;
                    
                }

                
            }
        }
    }
    
    //创建选择的按钮
    [self createButtonLayer:10];
    [self createButtonLayer:20];
    [self createButtonLayer:30];
    
}

-(void)createRightButton{

    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [_rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1] forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_rightButton addTarget:self action:@selector(rightButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void)rightButtonOnClick{
    
    NSString *age = [NSString string];
    
    NSString *education = [NSString string];
    
    NSString *month = [NSString string];
    
    NSString *online = [NSString string];
    
    NSString *real = [NSString string];
    
    if (_onlineString.length == 0) {
        
        online = @"";
        
    }else if (_onlineString.length != 0){
        
        online = _onlineString;
    }
    
    if (_ageString.length != 0) {
        
        age = [NSString stringWithFormat:@"%@,%@",_minAge,_maxAge];
        
    }else{
    
        age = @"";
    }
    
    NSMutableArray *sexArray = [NSMutableArray array];
    
    for (int i = 0; i < 4; i++) {
        
        if([_sexArray[i] length] != 0){
        
            [sexArray addObject:_sexArray[i]];
        }
    }
    
    if (sexArray.count == 1) {
        
        if ([sexArray[0] intValue]%10 == 3) {
            
            _sexString = @"0";
            
        }else{
        
            _sexString = [NSString stringWithFormat:@"%d",[sexArray[0] intValue]%10 + 1];
            
        }
    }else if(sexArray.count == 2){
    
        _sexString = [NSString stringWithFormat:@"%d,%d",[sexArray[0] intValue]%10 + 1,[sexArray[1] intValue]%10 + 1];
    
    }else if (sexArray.count == 3) {
    
        _sexString = [NSString stringWithFormat:@"%d,%d,%d",[sexArray[0] intValue]%10 + 1,[sexArray[1] intValue]%10 + 1,[sexArray[2] intValue]%10 + 1];
    }
    
    
    
    NSMutableArray *sexualArray = [NSMutableArray array];
    
    for (int i = 0; i < 4; i++) {
        
        if([_sexualArray[i] length] != 0){
            
            [sexualArray addObject:_sexualArray[i]];
        }
    }
    
    if (sexualArray.count == 1) {
        
        if ([sexualArray[0] intValue]%10 == 3) {
            
            _sexualString = @"0";
            
        }else{
            
            _sexualString = [NSString stringWithFormat:@"%d",[sexualArray[0] intValue]%10 + 1];
            
        }
    }else if(sexualArray.count == 2){
        
        _sexualString = [NSString stringWithFormat:@"%d,%d",[sexualArray[0] intValue]%10 + 1,[sexualArray[1] intValue]%10 + 1];
        
    }else if (sexualArray.count == 3) {
        
        _sexualString = [NSString stringWithFormat:@"%d,%d,%d",[sexualArray[0] intValue]%10 + 1,[sexualArray[1] intValue]%10 + 1,[sexualArray[2] intValue]%10 + 1];
    }
    
    
    NSMutableArray *roleArray = [NSMutableArray array];
    
    for (int i = 0; i < 5; i++) {
        
        if([_roleArray[i] length] != 0){
            
            [roleArray addObject:_roleArray[i]];
        }
    }
    
    if (roleArray.count == 1) {
        
        if ([roleArray[0] intValue]%10 == 4) {
            
            _roleString = @"0";
            
        }else{
            
            _roleString = [NSString stringWithFormat:@"%d",[roleArray[0] intValue]%10 + 1];
            
        }
    }else if(roleArray.count == 2){
        
        _roleString = [NSString stringWithFormat:@"%d,%d",[roleArray[0] intValue]%10 + 1,[roleArray[1] intValue]%10 + 1];
        
    }else if (roleArray.count == 3) {
        
        _roleString = [NSString stringWithFormat:@"%d,%d,%d",[roleArray[0] intValue]%10 + 1,[roleArray[1] intValue]%10 + 1,[roleArray[2] intValue]%10 + 1];
        
    }else if (roleArray.count == 4){
    
        _roleString = [NSString stringWithFormat:@"%d,%d,%d,%d",[roleArray[0] intValue]%10 + 1,[roleArray[1] intValue]%10 + 1,[roleArray[2] intValue]%10 + 1,[roleArray[3] intValue]%10 + 1];
    }
    
    if ([_hightString intValue] == 0) {
        
        education = @"";
        
        month = @"";
        
        real = @"";
        
    }else{
    
        if (_educationString.length == 0) {
            
            education = @"";
            
        }else if (_educationString.length != 0){
            
            education = _educationRow;
            
        }
        
        if (_monthString.length == 0) {
            
            month = @"";
            
        }else if (_monthString.length != 0){
            
            month = _monthRow;
            
        }
        
        if (_authenString.length == 0) {
            
            real = @"";
            
        }else if (_authenString.length != 0){
            
            real = _authenString;
        }

    }

    [[NSUserDefaults standardUserDefaults] setObject:_screenString forKey:@"searchSwitch"];
    
    [[NSUserDefaults standardUserDefaults] setObject:_onlineString forKey:@"online"];
    
    [[NSUserDefaults standardUserDefaults] setObject:_ageString forKey:@"screenAge"];
    
    [[NSUserDefaults standardUserDefaults] setObject:_sexString forKey:@"sexButton"];
    
    if (self.ageLabel.text.length != 0) {
        
        [[NSUserDefaults standardUserDefaults] setObject:_minAge forKey:@"minAge"];
        [[NSUserDefaults standardUserDefaults] setObject:_maxAge forKey:@"maxAge"];
    }
    
    
    [[NSUserDefaults standardUserDefaults] setObject:_sexualString forKey:@"sexualButton"];
    
    [[NSUserDefaults standardUserDefaults] setObject:_roleString forKey:@"roleButton"];
    
    [[NSUserDefaults standardUserDefaults] setObject:_hightString forKey:@"hight"];
    
    if (_educationRow.length != 0) {
        
        [[NSUserDefaults standardUserDefaults] setObject:_educationString forKey:@"screenEducation"];
        
        [[NSUserDefaults standardUserDefaults] setObject:_educationRow forKey:@"educationRow"];
    }
    
    if (_monthRow.length != 0) {
        
        [[NSUserDefaults standardUserDefaults] setObject:_monthString forKey:@"screenMonth"];
        
        [[NSUserDefaults standardUserDefaults] setObject:_monthRow forKey:@"monthRow"];
    }
    
    
    [[NSUserDefaults standardUserDefaults] setObject:_authenString forKey:@"authen"];
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"screen" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)screenSwitchClick:(UISwitch *)sender {
    
    if (_isScreen) {
        
        _isScreen = NO;
        
        _screenString = @"0";
        
        self.fontView.hidden = NO;
        
        [self createButtonLayer:10];
        
        [self createButtonLayer:20];
        
        [self createButtonLayer:30];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hight"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hight"] integerValue] == 0) {
            
            _isHight = NO;
            
            _hightSwitch.on = NO;
            
            _authenSwitch.on = NO;
            
            _onlineSwitch.on = NO;
            
            _onlineSwitch.userInteractionEnabled = NO;
            
            _authenSwitch.userInteractionEnabled = NO;
            
            _educationButton.userInteractionEnabled = NO;
            
            _ageButton.userInteractionEnabled = NO;
            
            _monthButton.userInteractionEnabled = NO;
            
        }else{
            
            _isHight = YES;
            
            _hightSwitch.on = YES;
            
            _onlineSwitch.userInteractionEnabled = YES;
            
            _authenSwitch.userInteractionEnabled = YES;
            
            _educationButton.userInteractionEnabled = YES;
            
            _monthButton.userInteractionEnabled = YES;
            
            _ageButton.userInteractionEnabled = YES;
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"authen"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"authen"] integerValue] == 0) {
                
                _isAuthen = NO;
                
                _authenSwitch.on = NO;
                
            }else{
                
                _isAuthen = YES;
                
                _authenSwitch.on = YES;
                
            }
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"online"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"online"] integerValue] == 0) {
                
                _isOnline = NO;
                
                _onlineSwitch.on = NO;
                
            }else{
                
                _isOnline = YES;
                
                _onlineSwitch.on = YES;
                
            }

            
        }

    }else{
        
        _isScreen = YES;
        
        _screenString = @"1";
        
        self.fontView.hidden = YES;
        
        [self createButtonLayer:10];
        
        [self createButtonLayer:20];
        
        [self createButtonLayer:30];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hight"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"hight"] integerValue] == 0) {
            
            _isHight = NO;
            
            _hightSwitch.on = NO;
            
            _authenSwitch.on = NO;
            
            _onlineSwitch.on = NO;
            
            _onlineSwitch.userInteractionEnabled = NO;
            
            _authenSwitch.userInteractionEnabled = NO;
            
            _educationButton.userInteractionEnabled = NO;
            
            _ageButton.userInteractionEnabled = NO;
            
            _monthButton.userInteractionEnabled = NO;
            
        }else{
            
            _isHight = YES;
            
            _hightSwitch.on = YES;
            
            _onlineSwitch.userInteractionEnabled = YES;
            
            _authenSwitch.userInteractionEnabled = YES;
            
            _educationButton.userInteractionEnabled = YES;
            
            _monthButton.userInteractionEnabled = YES;
            
            _ageButton.userInteractionEnabled = YES;
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"authen"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"authen"] integerValue] == 0) {
                
                _isAuthen = NO;
                
                _authenSwitch.on = NO;
                
            }else{
                
                _isAuthen = YES;
                
                _authenSwitch.on = YES;
                
            }
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"online"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"online"] integerValue] == 0) {
                
                _isOnline = NO;
                
                _onlineSwitch.on = NO;
                
            }else{
                
                _isOnline = YES;
                
                _onlineSwitch.on = YES;
                
            }

        }

    }
}
- (IBAction)hightSwitchClick:(UISwitch *)sender {
    
    if (_isHight) {
        
        _hightString = @"0";
        
        _authenSwitch.userInteractionEnabled = NO;
        
        _onlineSwitch.userInteractionEnabled = NO;
        
        _educationButton.userInteractionEnabled = NO;
        
        _monthButton.userInteractionEnabled = NO;
        
        _ageButton.userInteractionEnabled = NO;
        
        _authenSwitch.on = NO;
        
        _onlineSwitch.on = NO;
       
        _isHight = NO;
        
    }else{
        
        _hightString = @"1";
        
        _authenSwitch.userInteractionEnabled = YES;
        
        _onlineSwitch.userInteractionEnabled = YES;
        
        _educationButton.userInteractionEnabled = YES;
        
        _monthButton.userInteractionEnabled = YES;
        
        _ageButton.userInteractionEnabled = YES;
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"authen"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"authen"] integerValue] == 0) {
            
            _isAuthen = NO;
            
            _authenSwitch.on = NO;
            
        }else{
            
            _isAuthen = YES;
            
            _authenSwitch.on = YES;
            
        }
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"online"] length] == 0 || [[[NSUserDefaults standardUserDefaults] objectForKey:@"online"] integerValue] == 0) {
            
            _isOnline = NO;
            
            _onlineSwitch.on = NO;
            
        }else{
            
            _isOnline = YES;
            
            _onlineSwitch.on = YES;
            
        }

        
        _isHight = YES;
    }

}
- (IBAction)authenSwitchClick:(id)sender {
    
    if (_isAuthen) {
        
        _authenString = @"0";
        
        _isAuthen = NO;
        
    }else{
        
        _authenString = @"1";
        
        _isAuthen = YES;
    }
    

}

- (IBAction)onlineSwitchClick:(UISwitch *)sender {
    
    if (_isOnline) {
        
        _onlineString = @"0";
        
        _isOnline = NO;
        
    }else{
        
        _onlineString = @"1";
        
        _isOnline = YES;
    }
}

- (IBAction)monthButtonClick:(UIButton *)sender {
    
    _j = sender.tag;
    
    [self createSelectView:sender];
}
- (IBAction)educationButtonClick:(UIButton *)sender {
    
    _j = sender.tag;
    
    [self createSelectView:sender];
    
}
- (IBAction)ageButtonClick:(UIButton *)sender {
    
    _j = sender.tag;
    
    [self createSelectView:sender];
}

-(void)createSelectView:(UIButton *)button{
    
//    NSLog(@"%ld",button.tag);

    self.LVView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    //        self.LVView.alpha = 0;
    self.LVView.backgroundColor = [UIColor clearColor];
    [self.navigationController.view addSubview:self.LVView];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, HEIGHT - 216, WIDTH, 216)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.backgroundColor = [UIColor whiteColor];
    
    if (_j == 50) {
        
        [self.pickerView selectRow:0 inComponent:0 animated:YES];
        [self.pickerView selectRow:6 inComponent:2 animated:YES];
        
        _minAge = _ageArray[0];
        
        _maxAge = _ageArray[6];
        
    }else if (_j == 60){
    
        [self.pickerView selectRow:3 inComponent:0 animated:YES];
        
        _education = _educationArray[3];
        
        _educationRow = @"3";
        
    }else if (_j == 70){
    
        [self.pickerView selectRow:4 inComponent:0 animated:YES];
    
        _month = _monthArray[4];
        
        _monthRow = @"4";
    }
    
    
    [self.LVView addSubview:self.pickerView];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, HEIGHT - 216 - 40, WIDTH, 40)];
    toolBar.barStyle = UIBarButtonItemStylePlain;
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleButtonClick)];
    item1.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(sureButtonOnClick)];
    item2.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"请选择" style:UIBarButtonItemStylePlain target:self action:nil];
    item3.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *flexible1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *flexible2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [toolBar setItems:@[item1, flexible1, item3, flexible2 ,item2]];
    
    toolBar.barTintColor = CDCOLOR;
    
    [self.LVView addSubview:toolBar];
    
    self.LVShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 256)];
    self.LVShadowView.backgroundColor = [UIColor lightGrayColor];
    self.LVShadowView.alpha = 0.5;
    [self.LVView addSubview:self.LVShadowView];
    
    UITapGestureRecognizer *singletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancleButtonClick)];
    [singletap setNumberOfTapsRequired:1];
    singletap.delegate = self;
    [self.LVShadowView addGestureRecognizer:singletap];
}

#pragma mark - 该方法的返回值决定该控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    if (_j == 50) {
        
        return 4;
        
    }
    
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    
    return 50.0;
}

#pragma mark - 该方法的返回值决定该控件指定列包含多少个列表项
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    //    NSLog(@"%@",_heightArray);
    
    if (component == 0) {
        
        if (_j == 50) {
            
            return _ageArray.count;
            
        }else if (_j == 60){
        
            return _educationArray.count;
        }
        
        return _monthArray.count;
        
    }else if (component == 1){
        
        NSArray * array = @[@"岁"];
        
        return array.count;
        
    }else if (component == 2){
        
        return _ageArray.count;
        
    }
    
    NSArray * array = @[@"岁"];
    
    return array.count;
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    if (_j == 50) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WIDTH / 4 - 20 , 50)];
        
        titleLabel.textAlignment = NSTextAlignmentRight;
        
        UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH / 4, 50)];
        
        unitLabel.textAlignment = NSTextAlignmentCenter;
        
        unitLabel.text = @"岁";
        
        if (component == 0 || component == 2) {
            
            titleLabel.text = _ageArray[row];
            
            return titleLabel;
        }
        
        return unitLabel;

    }else{
    
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH , 50)];
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        if (_j == 60){
        
            titleLabel.text = _educationArray[row];
            
        }else if (_j == 70){
        
            titleLabel.text = _monthArray[row];
        }
        
        return titleLabel;
    
    }
    
    
    
}
#pragma mark - 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        
        if (_j == 50) {
            
            _minAge = _ageArray[row];
            
        }else if (_j == 60){
        
            _education = _educationArray[row];
            
            _educationRow = [NSString stringWithFormat:@"%ld",(long)row];
            
        }else if (_j == 70){
        
            _month = _monthArray[row];
            
            _monthRow = [NSString stringWithFormat:@"%ld",(long)row];
        }
        
    }else if (component == 2){
        
        _maxAge = _ageArray[row];
    }
    
}


- (void)cancleButtonClick {
    
    _educationRow = @"";
    
    _monthRow = @"";
    
    [self.LVView removeFromSuperview];
}

-(void)sureButtonOnClick{
    
    if (_j == 50) {
        
        if ([_minAge isEqualToString:@"不限"]) {
            
            _minAge = @"0";
            
        }
        
        if ([_maxAge isEqualToString:@"不限"]) {
            
            _maxAge = @"1000";
        }
        
        if ([_minAge intValue] > [_maxAge intValue]) {
            
            [AlertTool alertWithViewController:self andTitle:@"提示" andMessage:@"年龄段选择有误,请重新选择~"];
            
        }else{
            
            if ([_minAge intValue] == [_maxAge intValue]) {
                
                self.ageLabel.text = [NSString stringWithFormat:@"%@岁",_minAge];
                
            }else{
                
                if ([_minAge intValue] == 0 && [_maxAge intValue] == 1000) {
                    
                    self.ageLabel.text = [NSString stringWithFormat:@"不限岁"];
                    
                }else{
                    
                    if ([_minAge intValue] == 0) {
                        
                        self.ageLabel.text = [NSString stringWithFormat:@"不限岁-%@岁",_maxAge];
                        
                    }else if ([_maxAge intValue] == 1000){
                    
                        self.ageLabel.text = [NSString stringWithFormat:@"%@岁-不限岁",_minAge];
                    
                    }else{
                    
                        self.ageLabel.text = [NSString stringWithFormat:@"%@岁-%@岁",_minAge,_maxAge];
                    }
    
                }
            }
            
            _ageString = self.ageLabel.text;
            
            [self.LVView removeFromSuperview];
        }

    }else{
        
        if(_j == 60){
        
            self.educationLabel.text = _education;
            
            _educationString = _educationRow;
            
        }else if (_j == 70){
        
            self.monthLabel.text = _month;
            
            _monthString = _monthRow;
        }
    
        [self.LVView removeFromSuperview];
    }
    
}



-(void)createButtonLayer:(int)number{
    
    if (number == 10 || number == 20) {
        
        for (int i = 0; i < 4; i++) {
            
            UIButton *button = (UIButton *)[self.view viewWithTag:number + i];
            
            button.layer.cornerRadius = 15;
            
            button.clipsToBounds = YES;
            
            button.layer.borderColor = [UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1].CGColor;
            
            if (button.tag/10 == 1) {
                
                if ([_sexStateArray[i] isEqualToString:@"yes"]) {
                    
                    [button setBackgroundColor:CDCOLOR];
                    
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    
                    button.layer.borderWidth = 0;
                    
                    
                }else{
                    
                    [button setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
                    
                    [button setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
                    
                    button.layer.borderWidth = 1;
                    
                }
                
                
            }else if (button.tag/10 == 2){
                
                if ([_sexualStateArray[i] isEqualToString:@"yes"]) {
                    
                    [button setBackgroundColor:CDCOLOR];
                    
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    
                    button.layer.borderWidth = 0;
                    
                    
                }else{
                    
                    [button setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
                    
                    [button setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
                    
                    button.layer.borderWidth = 1;
                    
                }
                
            }
            
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }

    }else if (number == 30){
    
        for (int i = 0; i < 5; i++) {
            
            UIButton *button = (UIButton *)[self.view viewWithTag:number + i];
            
            button.layer.cornerRadius = 15;
            
            button.clipsToBounds = YES;
            
            button.layer.borderColor = [UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1].CGColor;
            
            
                if ([_roleStateArray[i] isEqualToString:@"yes"]) {
                    
                    [button setBackgroundColor:CDCOLOR];
                    
                    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    
                    button.layer.borderWidth = 0;
                    
                    
                }else{
                    
                    [button setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
                    
                    [button setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
                    
                    button.layer.borderWidth = 1;
                    
                }
            
            
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }

    
}

-(void)buttonClick:(UIButton *)button{
        
    [self changeBackgrouncolor:button];
        
}

-(void)changeBackgrouncolor:(UIButton *)button{
    
        if (button.tag/10 == 1) {
            
            if ([_sexStateArray[button.tag%10] isEqualToString:@"yes"]) {
                
                [button setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
                
                [button setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
                
                button.layer.borderWidth = 1;
                
                [_sexStateArray replaceObjectAtIndex:button.tag%10 withObject:@"no"];
                
                [_sexArray replaceObjectAtIndex:button.tag%10 withObject:@""];
                
            }else{
                
                [button setBackgroundColor:CDCOLOR];
                
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                button.layer.borderWidth = 0;
                
                [_sexStateArray replaceObjectAtIndex:button.tag%10 withObject:@"yes"];
                
                [_sexArray replaceObjectAtIndex:button.tag%10 withObject:[NSString stringWithFormat:@"%ld",(long)button.tag]];
                
            }
            
            if ([_sexStateArray[0] isEqualToString:@"yes"] || [_sexStateArray[1] isEqualToString:@"yes"] || [_sexStateArray[2] isEqualToString:@"yes"]) {
                
                [_sexStateArray replaceObjectAtIndex:3 withObject:@"no"];
                
                [_sexArray replaceObjectAtIndex:3 withObject:@""];
                
                for (int i = 0; i < 4; i ++) {
                    
                    UIButton *button = (UIButton *)[self.view viewWithTag:10 + i];
                    
                    if ([_sexStateArray[i] isEqualToString:@"yes"]) {
                        
                        [button setBackgroundColor:CDCOLOR];
                        
                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        
                        button.layer.borderWidth = 0;
                        
                    }else{
                        
                        [button setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
                        
                        [button setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
                        
                        button.layer.borderWidth = 1;
                        
                    }

                    
                }
                
            }else if ([_sexStateArray[0] isEqualToString:@"no"] && [_sexStateArray[1] isEqualToString:@"no"] && [_sexStateArray[2] isEqualToString:@"no"]){
            
                [_sexStateArray replaceObjectAtIndex:3 withObject:@"yes"];
                
                [_sexArray replaceObjectAtIndex:3 withObject:@"13"];
                
                for (int i = 0; i < 4; i ++) {
                    
                    UIButton *button = (UIButton *)[self.view viewWithTag:10 + i];
                    
                    if ([_sexStateArray[i] isEqualToString:@"yes"]) {
                        
                        [button setBackgroundColor:CDCOLOR];
                        
                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        
                        button.layer.borderWidth = 0;
                        
                    }else{
                        
                        [button setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
                        
                        [button setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
                        
                        button.layer.borderWidth = 1;
                        
                    }
                }
                
            }
            
        }else if (button.tag/10 == 2){
            
            if ([_sexualStateArray[button.tag%10] isEqualToString:@"yes"]) {
                
                [button setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
                
                [button setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
                
                button.layer.borderWidth = 1;
                
                [_sexualStateArray replaceObjectAtIndex:button.tag%10 withObject:@"no"];
                
                [_sexualArray replaceObjectAtIndex:button.tag%10 withObject:@""];
                
            }else{
                
                [button setBackgroundColor:CDCOLOR];
                
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                button.layer.borderWidth = 0;
                
                [_sexualStateArray replaceObjectAtIndex:button.tag%10 withObject:@"yes"];
                
                [_sexualArray replaceObjectAtIndex:button.tag%10 withObject:[NSString stringWithFormat:@"%ld",(long)button.tag]];
                
            }
            
            if ([_sexualStateArray[0] isEqualToString:@"yes"] || [_sexualStateArray[1] isEqualToString:@"yes"] || [_sexualStateArray[2] isEqualToString:@"yes"]) {
                
                [_sexualStateArray replaceObjectAtIndex:3 withObject:@"no"];
                
                [_sexualArray replaceObjectAtIndex:3 withObject:@""];
                
                for (int i = 0; i < 4; i ++) {
                    
                    UIButton *button = (UIButton *)[self.view viewWithTag:20 + i];
                    
                    if ([_sexualStateArray[i] isEqualToString:@"yes"]) {
                        
                        [button setBackgroundColor:CDCOLOR];
                        
                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        
                        button.layer.borderWidth = 0;
                        
                    }else{
                        
                        [button setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
                        
                        [button setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
                        
                        button.layer.borderWidth = 1;
                        
                    }
                    
                    
                }
                
            }else if ([_sexualStateArray[0] isEqualToString:@"no"] && [_sexualStateArray[1] isEqualToString:@"no"] && [_sexualStateArray[2] isEqualToString:@"no"]){
                
                [_sexualStateArray replaceObjectAtIndex:3 withObject:@"yes"];
                
                [_sexualArray replaceObjectAtIndex:3 withObject:@"23"];
                
                for (int i = 0; i < 4; i ++) {
                    
                    UIButton *button = (UIButton *)[self.view viewWithTag:20 + i];
                    
                    if ([_sexualStateArray[i] isEqualToString:@"yes"]) {
                        
                        [button setBackgroundColor:CDCOLOR];
                        
                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        
                        button.layer.borderWidth = 0;
                        
                    }else{
                        
                        [button setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
                        
                        [button setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
                        
                        button.layer.borderWidth = 1;
                        
                    }
                }
                
            }

            
        }else if (button.tag/10 == 3){
            
            if ([_roleStateArray[button.tag%10] isEqualToString:@"yes"]) {
                
                [button setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
                
                [button setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
                
                button.layer.borderWidth = 1;
                
                [_roleStateArray replaceObjectAtIndex:button.tag%10 withObject:@"no"];
                
                [_roleArray replaceObjectAtIndex:button.tag%10 withObject:@""];
                
            }else{
                
                [button setBackgroundColor:CDCOLOR];
                
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                button.layer.borderWidth = 0;
                
                [_roleStateArray replaceObjectAtIndex:button.tag%10 withObject:@"yes"];
                
                [_roleArray replaceObjectAtIndex:button.tag%10 withObject:[NSString stringWithFormat:@"%ld",(long)button.tag]];
                
            }
            
            if ([_roleStateArray[0] isEqualToString:@"yes"] || [_roleStateArray[1] isEqualToString:@"yes"] || [_roleStateArray[2] isEqualToString:@"yes"] || [_roleStateArray[3] isEqualToString:@"yes"]) {
                
                [_roleStateArray replaceObjectAtIndex:4 withObject:@"no"];
                
                [_roleArray replaceObjectAtIndex:4 withObject:@""];
                
                for (int i = 0; i < 5; i ++) {
                    
                    UIButton *button = (UIButton *)[self.view viewWithTag:30 + i];
                    
                    if ([_roleStateArray[i] isEqualToString:@"yes"]) {
                        
                        [button setBackgroundColor:CDCOLOR];
                        
                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        
                        button.layer.borderWidth = 0;
                        
                    }else{
                        
                        [button setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
                        
                        [button setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
                        
                        button.layer.borderWidth = 1;
                        
                    }
                    
                }
                
            }else if ([_roleStateArray[0] isEqualToString:@"no"] && [_roleStateArray[1] isEqualToString:@"no"] && [_roleStateArray[2] isEqualToString:@"no"] && [_roleStateArray[3] isEqualToString:@"no"]){
                
                [_roleStateArray replaceObjectAtIndex:4 withObject:@"yes"];
                
                [_roleArray replaceObjectAtIndex:4 withObject:@"34"];
                
                for (int i = 0; i < 5; i ++) {
                    
                    UIButton *button = (UIButton *)[self.view viewWithTag:30 + i];
                    
                    if ([_roleStateArray[i] isEqualToString:@"yes"]) {
                        
                        [button setBackgroundColor:CDCOLOR];
                        
                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        
                        button.layer.borderWidth = 0;
                        
                    }else{
                        
                        [button setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
                        
                        [button setTitleColor:[UIColor colorWithRed:183/255.0 green:183/255.0 blue:183/255.0 alpha:1] forState:UIControlStateNormal];
                        
                        button.layer.borderWidth = 1;
                        
                    }
                }
            }
        }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
