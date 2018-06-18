//
//  BaseViewController.m
//  BS
//
//  Created by 蔡卓越 on 16/3/31.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import "BaseViewController.h"

#import "NavigationController.h"
#import "TabbarViewController.h"
#import "TLUserLoginVC.h"
#import "UIColor+Extension.h"

#define kAnimationType 1


@interface BaseViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel *placeholderTitleLbl;

@property (nonatomic, strong) UIButton *opBtn;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = kBackgroundColor;
    
    [self setViewEdgeInset];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.backBarButtonItem = backItem;
//    //navigation底部分割线
//    self.navigationController.navigationBar.shadowImage = [kLineColor convertToImage];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:self.titleStr];

    // 设置导航栏背景色
    [self.navigationController.navigationBar setBackgroundImage:[kAppCustomMainColor convertToImage] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:self.titleStr];
}
- (UIScrollView *)bgSV {
    
    if (!_bgSV) {
        
        _bgSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
        
        _bgSV.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        _bgSV.contentSize = CGSizeMake(kScreenWidth, kSuperViewHeight + 1);
        
        [self.view addSubview:_bgSV];
    }
    
    return _bgSV;
    
}
- (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        
        currentVC = rootVC;
    }
    
    return currentVC;
}

#pragma mark - 用户登录
/**
 判断用户是否登录
 */
- (void)checkLogin:(void(^)(void))loginSuccess {
    
    if(![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [TLUserLoginVC new];
        
        loginVC.loginSuccess = loginSuccess;
        
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        return ;
    }
    
    if (loginSuccess) {
        
        loginSuccess();
    }
}

/**
 判断用户是否登录
 */
- (void)checkLogin:(void(^)(void))loginSuccess event:(void(^)(void))event {
    
    if(![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [TLUserLoginVC new];
        
        loginVC.loginSuccess = loginSuccess;
        
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        return ;
    }
    
    if (event) {
        
        event();
    }
}

#pragma mark - Setting
- (void)setTitle:(NSString *)title {
    
    self.navigationItem.titleView = [UILabel labelWithTitle:title frame:CGRectMake(0, 0, 200, 44)];
    
    self.titleStr = title;
}

#pragma mark - Private
// 如果tableview在视图最底层 默认会偏移电池栏的高度
- (void)setViewEdgeInset {
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (BOOL)isRootViewController {
    return (self == self.navigationController.viewControllers.firstObject);
}

#pragma mark - Public
- (void)returnButtonClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addPlaceholderView {
    
    if (self.placeholderView) {
        
        [self.view addSubview:self.placeholderView];
    }
}

- (void)removePlaceholderView {
    
    if (self.placeholderView) {
        
        [self.placeholderView removeFromSuperview];
    }
}

- (void)setPlaceholderViewTitle:(NSString *)title  operationTitle:(NSString *)opTitle {
    
    if (self.placeholderView) {
        
        _placeholderTitleLbl.text = title;
        [_opBtn setTitle:opTitle forState:UIControlStateNormal];
        
    } else {
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = self.view.backgroundColor;
        UILabel *lbl = [UILabel labelWithFrame:CGRectMake(0, 100, view.width, 50) textAligment:NSTextAlignmentCenter backgroundColor:[UIColor clearColor] font:FONT(16) textColor:kTextColor];
        [view addSubview:lbl];
        lbl.text = title;
        _placeholderTitleLbl = lbl;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, lbl.yy + 10, 200, 40)];
        [self.view addSubview:btn];
        btn.titleLabel.font = FONT(14);
        [btn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
        btn.centerX = view.width/2.0;
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor textColor].CGColor;
        [btn addTarget:self action:@selector(placeholderOperation) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:opTitle forState:UIControlStateNormal];
        [view addSubview:btn];
        _opBtn = btn;
        _placeholderView = view;
    }
}

- (UIView *)placholderViewWithTitle:(NSString *)title opTitle:(NSString *)opTitle {
    
    if (!_placeholderView) {
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = self.view.backgroundColor;
        UILabel *lbl = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor font:18.0];
        
        lbl.frame = CGRectMake(0, 100, view.width, 50);
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.backgroundColor = [UIColor clearColor];
        
        [view addSubview:lbl];
        lbl.text = title;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, lbl.yy + 10, 200, 40)];
        [self.view addSubview:btn];
        btn.titleLabel.font = FONT(15);
        [btn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
        btn.centerX = view.width/2.0;
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor textColor].CGColor;
        [btn addTarget:self action:@selector(placeholderOperation) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:opTitle forState:UIControlStateNormal];
        [view addSubview:btn];
        
        _placeholderView = view;
    }
    return _placeholderView;
    
}

#pragma mark- 站位操作
- (void)placeholderOperation {
    
    if ([self isMemberOfClass:NSClassFromString(@"BaseViewController")]) {
        
        NSLog(@"子类请重写该方法");
    }
}

- (UIView *)placeholderView {
    
    if (_placeholderView) {
        
        return _placeholderView;
    } else {
        
        NSLog(@"请先调用%@ 进行初始化",NSStringFromSelector(@selector(placholderViewWithTitle:opTitle:)));
        
        return nil;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    // 判断是都是根控制器， 是的话就不pop
    if ([self isRootViewController]) {
        return NO;
    } else {
        return YES;
    }
}

// 允许手势同时识别
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

// 优化pop时, 禁用其他手势,如：scrollView滑动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}
#pragma mark - 横屏
- (BOOL)shouldAutorotate {
    
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"%@类内存大爆炸",[self class]);
}

@end
