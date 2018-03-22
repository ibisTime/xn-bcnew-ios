//
//  TabbarViewController.m
//  BS
//
//  Created by 蔡卓越 on 16/3/31.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import "TabbarViewController.h"

//Category
#import "UIImage+Tint.h"
//C
#import "NavigationController.h"
#import "TLUserLoginVC.h"

@interface TabbarViewController () <UITabBarControllerDelegate>
//ItemArray
@property (nonatomic, strong) NSMutableArray *tabBarItems;
//
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation TabbarViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tabbar样式
    [self initTabBar];
    // 创建子控制器
    [self createSubControllers];
}

#pragma mark - Init

- (void)initTabBar {
    
    // 设置tabbar样式
    [UITabBar appearance].tintColor = kAppCustomMainColor;
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kAppCustomMainColor , NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
}

- (void)createSubControllers {
    
    NSArray *titles = @[@"首页", @"行情", @"币吧", @"我的"];
    
    NSArray *normalImages = @[@"home", @"quotes", @"forum", @"mine"];
    
    NSArray *selectImages = @[@"home_select", @"quotes_select", @"forum_select", @"mine_select"];
    
    NSArray *vcNames = @[@"HomeVC", @"QuotesVC", @"ForumVC", @"MineVC"];
    
    for (int i = 0; i < normalImages.count; i++) {
        
        [self addChildVCWithTitle:titles[i]
                           vcName:vcNames[i]
                        imgNormal:normalImages[i]
                      imgSelected:selectImages[i]];
    }
    
}

- (void)addChildVCWithTitle:(NSString *)title
                     vcName:(NSString *)vcName
                  imgNormal:(NSString *)imgNormal
                imgSelected:(NSString *)imgSelected {
    
    //对选中图片进行渲染
    UIImage *selectedImg = [[UIImage imageNamed:imgSelected] tintedImageWithColor:kAppCustomMainColor];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title
                                                             image:[UIImage imageNamed:imgNormal]
                                                     selectedImage:selectedImg];
    
    tabBarItem.selectedImage = [tabBarItem.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem.image= [tabBarItem.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //title颜色
    [tabBarItem setTitleTextAttributes:@{
                                         NSForegroundColorAttributeName : kAppCustomMainColor
                                         } forState:UIControlStateSelected];
    [tabBarItem setTitleTextAttributes:@{
                                         NSForegroundColorAttributeName : kTextColor
                                         } forState:UIControlStateNormal];
    
    UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
    
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:vc];
    
    vc.tabBarItem = tabBarItem;
    
    [self addChildViewController:nav];
}

#pragma mark 判断是否登录若没登录跳转到登录页面
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(nonnull UIViewController *)viewController {
    //赋值更改前的index
    self.currentIndex = tabBarController.selectedIndex;
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    BaseWeakSelf;
    
    NSInteger idx = tabBarController.selectedIndex;
    
    //判断点击的Controller是不是需要登录，如果是，那就登录
    
    
}

@end
