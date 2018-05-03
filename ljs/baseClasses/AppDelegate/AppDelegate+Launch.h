//
//  AppDelegate+Launch.h
//  b2c_user_ios
//
//  Created by 蔡卓越 on 16/11/3.
//  Copyright © 2016年 caizhuoyue. All rights reserved.
//

#import "AppDelegate.h"


typedef NS_ENUM(NSUInteger, LaunchOption) {
    LaunchOptionGuide,
    LaunchOptionLogin,
};


@interface AppDelegate (Launch)


- (void)launchEventWithCompletionHandle:(void (^) (LaunchOption launchOption))handle;




@end
