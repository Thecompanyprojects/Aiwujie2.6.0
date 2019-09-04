//
//  LDGiveGifListViewController.m
//  圣魔无界
//
//  Created by 爱无界 on 2017/6/19.
//  Copyright © 2017年 a. All rights reserved.
//

#import "LDGiveGifListViewController.h"
#import "LDGiveGifListPageViewController.h"


@interface LDGiveGifListViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

//翻页控制器
@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
@property (nonatomic, strong) LDGiveGifListPageViewController *GiveGifListPageViewController;

@property (nonatomic, weak) UIView *navLine;

@end

@implementation LDGiveGifListViewController

#pragma mark - Lazy Load

- (NSArray *)pageContentArray {
    if (!_pageContentArray) {
        NSMutableArray *arrayM = [[NSMutableArray alloc] init];
        
        LDGiveGifListPageViewController *v1 = [[LDGiveGifListPageViewController alloc] init];
        LDGiveGifListPageViewController *v2 = [[LDGiveGifListPageViewController alloc] init];
        
        [arrayM addObject:v1];
        [arrayM addObject:v2];
        
        _pageContentArray = [[NSArray alloc] initWithArray:arrayM];
        
    }
    return _pageContentArray;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    // bg.png为自己ps出来的想要的背景颜色。
    [navigationBar setBackgroundImage:nil
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:nil];
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    // bg.png为自己ps出来的想要的背景颜色。
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"导航背景"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"大喇叭";
    
    //生成翻页控制器
    [self createPageViewController];
}

//生成翻页控制器
-(void)createPageViewController{
    
    // 设置UIPageViewController的配置项
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(1)};
    //    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    
    // 根据给定的属性实例化UIPageViewController
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation: UIPageViewControllerNavigationOrientationHorizontal options:options];
    _pageViewController.view.backgroundColor = [UIColor colorWithHexString:@"#222222" alpha:1];
    // 设置UIPageViewController代理和数据源
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    LDGiveGifListPageViewController *initialViewController = [self viewControllerAtIndex:0];// 得到第一页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    
//    _index = 0;
    
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height);
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate

#pragma mark 返回上一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDGiveGifListPageViewController *)viewController];
    
    if ((index == 0) || (index == NSNotFound)) {
        
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

#pragma mark 返回下一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self indexOfViewController:(LDGiveGifListPageViewController *)viewController];
    
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
    
    _GiveGifListPageViewController = (LDGiveGifListPageViewController *)pendingViewControllers[0];
    
}
//翻页动画执行完成后回调的方法
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    
    if (finished) {
        
        if (completed) {
            
            NSInteger index = [self.pageContentArray indexOfObject:_GiveGifListPageViewController];
            
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

- (LDGiveGifListPageViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count])) {
        
        return nil;
    }
    
    LDGiveGifListPageViewController *contentVC = self.pageContentArray[index];
    
    contentVC.content = [NSString stringWithFormat:@"%ld",(long)index];
    
    return contentVC;
}

#pragma mark - 数组元素值，得到下标值

- (NSUInteger)indexOfViewController:(LDGiveGifListPageViewController *)viewController {
    
    return [viewController.content integerValue];
    
}

//改变导航栏上按钮的颜色
-(void)changeNavButtonColor:(NSInteger)index{
    
    UIButton *button = (UIButton *)[self.view viewWithTag:index + 100];
    
//    _index = index;
    
    for (int i = 100; i < 102; i++) {
        
        UIButton *btn = (UIButton *)[self.view viewWithTag:i];
        
        UIView *view = (UIView *)[self.view viewWithTag:i + 100];
        
        if (button.tag == btn.tag) {
            
            view.hidden = NO;
            
        }else{
            
            view.hidden = YES;
        }
    }
}
- (IBAction)buttonClick:(UIButton *)sender {
    
    LDGiveGifListPageViewController *initialViewController = [self viewControllerAtIndex:sender.tag - 100];// 得到对应页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    if (sender.tag == 100) {
        
        [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
        
    }else{
    
        [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    }
    
    [self changeNavButtonColor:sender.tag - 100];
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
