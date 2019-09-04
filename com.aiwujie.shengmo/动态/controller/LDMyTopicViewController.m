//
//  LDMyTopicViewController.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/7/19.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDMyTopicViewController.h"
#import "LDCreateTopicViewController.h"
#import "LDMoreTopicPageViewController.h"

@interface LDMyTopicViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>


//翻页控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
@property (nonatomic, strong) LDMoreTopicPageViewController *topicPageViewController;

//创建话题按钮
@property (nonatomic,strong) UIButton *createTopicButton;


@end

@implementation LDMyTopicViewController

- (NSArray *)pageContentArray {
    if (!_pageContentArray) {
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        
        LDMoreTopicPageViewController *v1 = [[LDMoreTopicPageViewController alloc] init];
        LDMoreTopicPageViewController *v2 = [[LDMoreTopicPageViewController alloc] init];
        
        [arrayM addObject:v1];
        [arrayM addObject:v2];
        
        _pageContentArray = [[NSArray alloc] initWithArray:arrayM];
        
    }
    return _pageContentArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if ([self.userId intValue] == [[[NSUserDefaults standardUserDefaults] objectForKey:@"uid"] intValue]) {
        
        self.title = @"我的话题";
        
    }else{
        
        self.title = @"Ta的话题";
    }
    
    [self createTopTopic];
    
    //生成翻页控制器
    [self createPageViewController];
    
    //创建创建话题按钮
    [self createTopic];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideCreateTopicButton) name:@"创建话题按钮隐藏" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCreateTopicButton) name:@"创建话题按钮显示" object:nil];
}


-(void)hideCreateTopicButton{
    
    _createTopicButton.hidden = YES;
}

-(void)showCreateTopicButton{
    
    _createTopicButton.hidden = NO;
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)createTopic{
    
    CGFloat createTopicW = 106;
    CGFloat createTopicH = 44;
    CGFloat createTopicBottomY = 100;
    
    if (ISIPHONEX) {
        
        _createTopicButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH - createTopicW)/2, HEIGHT - createTopicBottomY - createTopicH - 34 - 24, createTopicW, createTopicH)];
        
    }else{
        
        if (ISIPHONEPLUS) {
            
            _createTopicButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH - (createTopicW / 375) * WIDTH)/2, HEIGHT - createTopicBottomY - (createTopicH / 667) * HEIGHT, (createTopicW / 375) * WIDTH, (createTopicH / 667) * HEIGHT)];
            
        }else{
            
            _createTopicButton = [[UIButton alloc] initWithFrame:CGRectMake((WIDTH - createTopicW)/2, HEIGHT - createTopicBottomY - createTopicH, createTopicW, createTopicH)];
        }
    }
    
    [_createTopicButton setBackgroundImage:[UIImage imageNamed:@"创建话题"] forState:UIControlStateNormal];
    
    [_createTopicButton addTarget:self action:@selector(createTopicButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_createTopicButton];
}

-(void)createTopicButtonClick{
    
    LDCreateTopicViewController *tvc = [[LDCreateTopicViewController alloc] init];
    
    [self.navigationController pushViewController:tvc animated:YES];
}


-(void)createTopTopic{
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    
    if (@available(iOS 11.0, *)) {
        
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        
    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    NSArray *array = @[@"发布的话题",@"参与的话题"];
    
    //    CGFloat btnX = 10;
    
    for (int i = 0; i < 2; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(5 + i * (WIDTH - 10)/2, 0, (WIDTH - 10)/2, 40);
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        
        //重要的是下面这部分哦！
        CGSize titleSize = [array[i] sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:btn.titleLabel.font.fontName size:btn.titleLabel.font.pointSize]}];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((btn.frame.size.width - titleSize.width)/2 , 36, titleSize.width , 2)];
        
        view.backgroundColor = CDCOLOR;
        
        view.tag = 200 + i;
        
        [btn setTitle:array[i] forState:UIControlStateNormal];
        
        btn.tag = 100 + i;
        
        [btn addTarget:self action:@selector(btnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //重要的是下面这部分哦！
        //        CGSize titleSize = [array[i] sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:btn.titleLabel.font.fontName size:btn.titleLabel.font.pointSize]}];
        //
        //        titleSize.height = 20;
        //        titleSize.width += 20;
        
        //        btn.frame = CGRectMake(btnX, 10, titleSize.width, titleSize.height);
        
        //        btnX = btnX + titleSize.width;
        
        //        btn.backgroundColor = [UIColor blackColor];
        
        //        if (i == 7) {
        
        scrollView.contentSize = CGSizeMake(WIDTH, 0);
        //        }
        
        [btn addSubview:view];
        [scrollView addSubview:btn];
    }
    
    [self.view addSubview:scrollView];
    
}

-(void)btnButtonClick:(UIButton *)sender{
    
    LDMoreTopicPageViewController *initialViewController = [self viewControllerAtIndex:sender.tag - 100];// 得到对应页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
    [self changeNavButtonColor:sender.tag - 100];
}


//生成翻页控制器
-(void)createPageViewController{
    
    // 设置UIPageViewController的配置项
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(1)};
    //    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    
    // 根据给定的属性实例化UIPageViewController
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal options:options];
    _pageViewController.view.backgroundColor = [UIColor whiteColor];
    // 设置UIPageViewController代理和数据源
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    if ([self.state isEqualToString:@"参与的话题"]) {
        
        LDMoreTopicPageViewController *initialViewController = [self viewControllerAtIndex:1];// 得到第二页
        
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
        [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
        
        [self changeNavButtonColor:1];
        
    }else if ([self.state isEqualToString:@"发布的话题"]){
    
        LDMoreTopicPageViewController *initialViewController = [self viewControllerAtIndex:0];// 得到第一页
        
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
        [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
        
        [self changeNavButtonColor:0];
        
    }
    
    
    
    //    _index = 0;
    
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height);
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDMoreTopicPageViewController *)viewController];
    
    if ((index == 0) || (index == NSNotFound)) {
        
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

#pragma mark 返回下一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDMoreTopicPageViewController *)viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    if (index == [self.pageContentArray count]) {
        
        return nil;
    }
    
    
    return [self viewControllerAtIndex:index];
    
}

//翻页视图控制器将要翻页时执行的方法
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    
    _topicPageViewController = (LDMoreTopicPageViewController *)pendingViewControllers[0];
    
}
//翻页动画执行完成后回调的方法
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if (finished) {
        
        if (completed) {
            
            NSInteger index = [self.pageContentArray indexOfObject:_topicPageViewController];
            
            //            _index = index;
            
            [self changeNavButtonColor:index];
            
        }else{
            
            NSInteger index = [self.pageContentArray indexOfObject:previousViewControllers[0]];
            
            //            _index = index;
            
            [self changeNavButtonColor:index];
        }
    }
}

#pragma mark - 根据index得到对应的UIViewController

- (LDMoreTopicPageViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        
        return nil;
    }
    
    LDMoreTopicPageViewController *contentVC = self.pageContentArray[index];
    
    contentVC.content = [NSString stringWithFormat:@"%ld",(long)index];
    
    contentVC.userId = self.userId;
    
    contentVC.type = @"MyTopic";

    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(LDMoreTopicPageViewController *)viewController {
    
    return [viewController.content integerValue];
    
}

//改变导航栏上按钮的颜色
-(void)changeNavButtonColor:(NSInteger)index{
    
    UIButton *button = (UIButton *)[self.view viewWithTag:index + 100];
    
    //    _index = index;
    
    for (int i = 100; i < 102; i++) {
        
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        
        UIView *view = (UIView *)[self.view viewWithTag:100 + i];
        
        if (btn.tag == button.tag) {
            
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            view.hidden = NO;
            
            
        }else{
            
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            view.hidden = YES;
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
