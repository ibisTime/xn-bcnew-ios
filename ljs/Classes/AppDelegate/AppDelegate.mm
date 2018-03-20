//
//  AppDelegate.m
//  ljs
//
//  Created by 蔡卓越 on 2017/7/13.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "AppDelegate.h"

#import "IQKeyboardManager.h"
//#import "WXApi.h"

//#import "AppDelegate+Launch.h"
//#import "AppDelegate+BaiduMap.h"

#import "AppConfig.h"

#import "NavigationController.h"
#import "TabbarViewController.h"
#import "InfoDetailVC.h"
#import "TLUserLoginVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - App Life Cycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //服务器环境
    [self configServiceAddress];
    //键盘
    [self configIQKeyboard];
    //配置地图
//    [self configMapKit];
    //配置极光
//    [self configJPushWithOptions:launchOptions];
    //配置根控制器
    [self configRootViewController];
    
    return YES;
}

// iOS9 NS_AVAILABLE_IOS
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
//    if ([url.host isEqualToString:@"safepay"]) {
//
//        [TLAlipayManager hadleCallBackWithUrl:url];
//        return YES;
//
//    } else {
//
//        return [WXApi handleOpenURL:url delegate:[TLWXManager manager]];
//
//    }
    
    return YES;
}

// iOS9 NS_DEPRECATED_IOS
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
//    if ([url.host isEqualToString:@"safepay"]) {
//
//        [TLAlipayManager hadleCallBackWithUrl:url];
//        return YES;
//
//    } else {
//
//        return [WXApi handleOpenURL:url delegate:[TLWXManager manager]];
//
//    }
    return YES;
}

#pragma mark - Config
- (void)configServiceAddress {
    
    //配置环境
    [AppConfig config].runEnv = RunEnvDev;
    
}

- (void)configIQKeyboard {
    
    //
//    [IQKeyboardManager sharedManager].enable = YES;
    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[InfoDetailVC class]];
//    [[IQKeyboardManager sharedManager].disabledToolbarClasses addObject:[SendCommentVC class]];
    
}

- (void)configRootViewController {
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    TabbarViewController *tabbarCtrl = [[TabbarViewController alloc] init];
    self.window.rootViewController = tabbarCtrl;
    
    //重新登录
    if([TLUser user].isLogin) {
        
        [[TLUser user] reLogin];
        //            [[ChatManager sharedManager] loginIM];
        
    };
    
    //登出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:kUserLoginOutNotification object:nil];
    //登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:kIMLoginNotification object:nil];
}

#pragma mark- 退出登录
- (void)loginOut {
    
    //user 退出
    [[TLUser user] loginOut];
    
}

#pragma mark - 用户登录
- (void)userLogin {
    
}

#pragma mark 微信支付结果
//- (void)onResp:(BaseResp *)resp {
//
//    if ([resp isKindOfClass:[PayResp class]]) {
//        //支付返回结果
//        NSNotification *notification = [NSNotification notificationWithName:ORDER_PAY_NOTIFICATION object:[NSNumber numberWithInt:resp.errCode]];
//        [[NSNotificationCenter defaultCenter] postNotification:notification];
//    }
//}

@end
