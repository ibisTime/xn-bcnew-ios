//
//  TLAuthHelper.m
//  ljs
//
//  Created by  蔡卓越 on 2017/1/9.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import "TLAuthHelper.h"
#import <CoreLocation/CoreLocation.h>

#import <UIKit/UIKit.h>

@implementation TLAuthHelper

+ (BOOL)isEnableLocation {

    CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];
    if (authStatus == kCLAuthorizationStatusDenied) {
        return NO;
    } else {
        return YES;
    }

}

+ (void)openSetting {

    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}
@end
