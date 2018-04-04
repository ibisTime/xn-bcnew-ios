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

#import "AppConfig.h"

@implementation AppDelegate (JPush)

- (void)jpushRegisterDeviceToken:(NSData *)deviceToken {

    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)jpushDidReceiveLocalNotification:(UILocalNotification *)notification {

//    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];

}


- (void)jpushInitWithLaunchOption:(NSDictionary *)launchOptions {

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
    
    Aps *aps = model.aps;
    
    UIViewController *topmostVC = [self topViewController];
    
    if (application.applicationState > 0) {
        
        [self checkMessageTypeWithModel:model vc:topmostVC];
        
    }else if (application.applicationState == 0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:aps.alert preferredStyle:UIAlertControllerStyleAlert];
        

        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self checkMessageTypeWithModel:model vc:topmostVC];
        }];
        
        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
        
        [alertController addAction:yesAction];
        
        [alertController addAction:noAction];
        
        [topmostVC presentViewController:alertController animated:YES completion:nil];
        
    }
}

- (void)checkMessageTypeWithModel:(JPushModel *)model vc:(UIViewController *)vc {
    
    Aps *aps = model.aps;
    
    NSInteger badge = aps.badge.integerValue;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    
    NSString *openType = model.openType;
    
    
    if ([openType isEqualToString:@"0"]) {
        //系统消息
        
//        SystemNoticeVC *systemNotice = [SystemNoticeVC new];
//
//        [vc.navigationController pushViewController:systemNotice animated:YES];
        
        
    }else if ([openType isEqualToString:@"1"]) {
        
        //进入帖子详情页
//        CSWArticleDetailVC *articleDetailVC = [CSWArticleDetailVC new];
//
//        articleDetailVC.articleCode = model.code;
//
//        [vc.navigationController pushViewController:articleDetailVC animated:YES];
        
    }
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
//    name = tianlei; //附加字段
//    url = "https://www.jiguang.cn/push/app/7cd9f997dcedd781b3409c52/push/notification";
//}

@end
