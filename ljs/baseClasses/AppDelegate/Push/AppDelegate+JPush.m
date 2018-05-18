//
//  AppDelegate+JPush.m
//  ZHCustomer
//
//  Created by  tianlei on 2017/2/6.
//  Copyright © 2017年  tianlei. All rights reserved.
//

#import "AppDelegate+JPush.h"

// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

//Category
#import "AppConfig.h"
#import "TLAlert.h"
#import "NSString+Extension.h"
//C
#import "NewsFlashDetailVC.h"
#import "TabbarViewController.h"

@implementation AppDelegate (JPush)

- (void)jpushRegisterDeviceToken:(NSData *)deviceToken {

    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)jpushDidReceiveLocalNotification:(UILocalNotification *)notification {

//    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];

}

////后台进入前台
//- (void)applicationWillEnterForeground:(UIApplication *)application {
//
//    //后台进入前台,未读消息数清零
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /**
     以下代码没写，导致这个问题（Not get deviceToken yet. Maybe: your certificate not configured APNs?...）
     */
    [self jpushRegisterDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"app的APNS权限问题或者app运行在模拟器");
}

- (void)jpushInitWithLaunchOption:(NSDictionary *)launchOptions {
    //打开APP,未读消息数清零
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
        
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }

    
    BOOL isProducation = [AppConfig config].runEnv == RunEnvRelease;
    
    [JPUSHService setupWithOption:launchOptions
                           appKey:[AppConfig config].pushKey
                          channel:@"iOS"
                 apsForProduction:isProducation
            advertisingIdentifier:nil];
    
    if (isProducation) {
        [JPUSHService setLogOFF];
    }
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }   
    }];

}

//  iOS 8 .9 后台进入前台
- (void)jpushDidReceiveRemoteApplication:(UIApplication *)application notification:(NSDictionary *)userInfo {
    
    [JPUSHService handleRemoteNotification:userInfo];
    
    NSLog(@"iOS7及以上系统，收到通知:%@", [self logDic:userInfo]);
    
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    
    NSLog(@"%@", systemVersion);
    
    JPushModel *model = [JPushModel mj_objectWithKeyValues:userInfo];
    
    self.model = model;
    
    UIViewController *topmostVC = [self topViewController];
    
    [self checkMessageTypeWithModel:model vc:topmostVC];
}

- (void)checkMessageTypeWithModel:(JPushModel *)model vc:(UIViewController *)vc {
    
    Aps *aps = model.aps;
    
//    NSInteger badge = aps.badge.integerValue;
//
//    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    //角标清零
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    //判断HomeVC是否加载
    if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[TabbarViewController class]]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidReceivePushNotification"
                                                            object:nil];
        //判断内容是否有150字
        NSString *content;
        if (aps.alert.length > 150) {
            
            NSString *subString = [aps.alert subStringWithNum:150];
            content = [NSString stringWithFormat:@"%@......", subString];
        } else {
            
            content = aps.alert;
        }
        [TLAlert alertWithTitle:@"推送信息"
                            msg:content
                     confirmMsg:@"查看"
                      cancleMsg:@"取消"
                         cancle:^(UIAlertAction *action) {
                             
                         }
                        confirm:^(UIAlertAction *action) {
                            
                            NewsFlashDetailVC *detailVC = [NewsFlashDetailVC new];
                            
                            detailVC.code = model.flashCode;
                            
                            [vc.navigationController pushViewController:detailVC animated:YES];
                        }];
        return ;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLoadHomeVC)
                                                 name:@"DidLoadHomeVC"
                                               object:nil];
}

- (void)didLoadHomeVC {
    
    UIViewController *topmostVC = [self topViewController];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidReceivePushNotification"
                                                        object:nil];
    //最多展示150字
    NSString *subString = [self.model.aps.alert subStringWithNum:150];
    
    [TLAlert alertWithTitle:@"推送信息"
                        msg:[NSString stringWithFormat:@"%@......", subString]
                 confirmMsg:@"查看"
                  cancleMsg:@"取消"
                     cancle:^(UIAlertAction *action) {
                         
                     }
                    confirm:^(UIAlertAction *action) {
                        
                        NewsFlashDetailVC *detailVC = [NewsFlashDetailVC new];
                        
                        detailVC.code = self.model.flashCode;
                        
                        [topmostVC.navigationController pushViewController:detailVC animated:YES];
                    }];
}

//获取当前控制器
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标
    NSString *body = content.body;    // 推送消息体
    UNNotificationSound *sound = content.sound;  // 推送消息的声音
    NSString *subtitle = content.subtitle;  // 推送消息的副标题
    NSString *title = content.title;  // 推送消息的标题
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [JPUSHService handleRemoteNotification:userInfo];
        TLLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        
        
    } else {
        
        // 判断为本地通知
        TLLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

//点击消息会触发该方法
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    
    NSNumber *badge = content.badge;  // 推送消息的角标

    [UIApplication sharedApplication].applicationIconBadgeNumber = [badge integerValue];
    
    JPushModel *model = [JPushModel mj_objectWithKeyValues:userInfo];
    
    self.model = model;

    UIViewController *topmostVC = [self topViewController];
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [JPUSHService handleRemoteNotification:userInfo];
        
        [self checkMessageTypeWithModel:model vc:topmostVC];
        
    } else {
        // 判断为本地通知
//        TLLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif


- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

//{
//    "_j_msgid" = 2371100428;
//    aps =     {
//        alert =         {
//            body = "这是内容";
//            subtitle = "副标题";
//            title = "标题";
//        };
//        badge = 1;
//        "content-available" = 1;
//        sound = default;
//    };
//    flashCode = 编号; //附加字段
//}

@end
