//
//  NavigationController.m
//  BS
//
//  Created by 蔡卓越 on 16/3/31.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import "NavigationController.h"
#import "TabbarViewController.h"

@interface NavigationController ()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        [self.navigationItem setHidesBackButton:YES];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"返回-白色"] forState:UIControlStateNormal];
        btn.contentMode = UIViewContentModeScaleToFill;
        btn.frame = CGRectMake(-10, 0, 40, 44);
        [btn addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *customView = [[UIView alloc] initWithFrame:btn.bounds];
        [customView addSubview:btn];
        
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:customView];
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)clickButton {
    
    [self.view endEditing:YES];
    [self popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    TabbarViewController *tabbarCrl = (TabbarViewController*)self.tabBarController;
    //[tabbarCrl removeOriginTabbarButton];
}
#pragma mark - 横屏
- (BOOL)shouldAutorotate{
    
    return self.topViewController.shouldAutorotate;
}


@end
