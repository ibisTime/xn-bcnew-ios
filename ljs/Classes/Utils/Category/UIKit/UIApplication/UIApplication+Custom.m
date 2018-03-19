//
//  UIApplication+Custom.m
//  b2c_user_ios
//
//  Created by 蔡卓越 on 16/11/9.
//  Copyright © 2016年 caizhuoyue. All rights reserved.
//

#import "UIApplication+Custom.h"

#import "AppMacro.h"

@implementation UIApplication (Custom)



+ (BOOL)canOpenUrl:(NSString*)urlStr {

    if (!PASS_NULL_TO_NIL(urlStr)) {
        return NO;
    }
    
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlStr]];
}




@end
