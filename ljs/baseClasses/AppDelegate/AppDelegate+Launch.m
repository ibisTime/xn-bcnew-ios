//
//  AppDelegate+Launch.m
//  b2c_user_ios
//
//  Created by 蔡卓越 on 16/11/3.
//  Copyright © 2016年 caizhuoyue. All rights reserved.
//

#import "AppDelegate+Launch.h"

@implementation AppDelegate (Launch)


- (void)launchEventWithCompletionHandle:(void (^) (LaunchOption launchOption))handle {

    // 设置程序启动
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
    }
    else {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
    // 程序为第一次启动
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
        
        // 记录版本号
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        [[NSUserDefaults standardUserDefaults] setValue:version forKey:@"VER"];
        
        handle(LaunchOptionGuide);
    }
    else {
        
        NSString *subVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *superVersion = [[NSUserDefaults standardUserDefaults] valueForKey:@"VER"];
        
        if ([subVersion isEqualToString:superVersion]) {
            
            handle(LaunchOptionLogin);

        } else {
            
            // 记录版本号
            NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
            [[NSUserDefaults standardUserDefaults] setValue:version forKey:@"VER"];
            
            handle(LaunchOptionGuide);
        }
    }
    
}


@end
