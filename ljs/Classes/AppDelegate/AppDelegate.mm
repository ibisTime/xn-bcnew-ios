//
//  AppDelegate.m
//  ljs
//
//  Created by 蔡卓越 on 2017/7/13.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+JPush.h"

//Manager
#import "AppConfig.h"
#import "TLUser.h"
#import "QQManager.h"
#import "TLWXManager.h"
//Extension
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "IQKeyboardManager.h"
//C
#import "NavigationController.h"
#import "TabbarViewController.h"
#import "TLUserLoginVC.h"
#import "TLUpdateVC.h"
//禁止IQKeyboardManager的VC类
#import "InfoDetailVC.h"
#import "InfoCommentDetailVC.h"
#import "ForumDetailVC.h"
#import "ForumCircleCommentVC.h"

//#import "AppDelegate+Launch.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - App Life Cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //配置QQ
    [self configQQ];
    //配置微信
    [self configWeChat];
    //服务器环境
    [self configServiceAddress];
    //键盘
    [self configIQKeyboard];
    //配置极光
//    [self jpushInitWithLaunchOption:launchOptions];
    //配置根控制器
    [self configRootViewController];
    
    return YES;
}

// iOS9 NS_AVAILABLE_IOS
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
//    BOOL isQQ = [QQApiInterface handleOpenURL:url delegate:[QQManager manager]];
    
    if ([url.host containsString:@"qq"]) {
        
        return  [QQApiInterface handleOpenURL:url delegate:[QQManager manager]];
//        [TencentOAuth HandleOpenURL:url];
        
    } else {

        return [WXApi handleOpenURL:url delegate:[TLWXManager manager]];
    }
    
    return YES;
}

// iOS9 NS_DEPRECATED_IOS
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
//    BOOL isQQ = [QQApiInterface handleOpenURL:url delegate:[QQManager manager]];

    if ([url.host containsString:@"qq"]) {

        return [QQApiInterface handleOpenURL:url delegate:[QQManager manager]];
//        [TencentOAuth HandleOpenURL:url];

    } else {

        return [WXApi handleOpenURL:url delegate:[TLWXManager manager]];

    }
    return YES;
}

#pragma mark - Config
- (void)configQQ {
    
    [[QQManager manager] registerApp];
}

- (void)configWeChat {
    
    [[TLWXManager manager] registerApp];
}

- (void)configServiceAddress {
    
    //配置环境
    [AppConfig config].runEnv = RunEnvTest;
}

- (void)configIQKeyboard {
    
    //
//    [IQKeyboardManager sharedManager].enable = YES;
    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[InfoDetailVC class]];
    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[InfoCommentDetailVC class]];
    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[ForumDetailVC class]];
    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[ForumCircleCommentVC class]];

}

- (void)configRootViewController {
    
    [UIApplication sharedApplication].statusBarHidden = NO;

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    if (1) {
        //先配置到，检查更新的VC,开启更新检查
        TLUpdateVC *updateVC = [[TLUpdateVC alloc] init];
        self.window.rootViewController = updateVC;
        
    } else {
    
        TabbarViewController *tabbarCtrl = [[TabbarViewController alloc] init];
        self.window.rootViewController = tabbarCtrl;
    }
    //重新登录
    if([TLUser user].checkLogin) {
        
        [[TLUser user] updateUserInfo];
        // 登录时间变更到，didBecomeActive中
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginNotification
                                                            object:nil];
        
    };
    
    //登出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];
    //Token失效
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenExpried) name:kUserTokenExpiredNotification object:nil];

}

#pragma mark- 退出登录
- (void)loginOut {
    
    //user 退出
    [[TLUser user] loginOut];
}

#pragma mark - Token失效
- (void)tokenExpried {
    
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    TLUserLoginVC *loginVC = [TLUserLoginVC new];
    
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
    
    [vc presentViewController:nav animated:YES completion:nil];
}

@end
