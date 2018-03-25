//
//  PlatformModel.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PlatformModel.h"
#import "AppColorMacro.h"

@implementation PlatformModel

- (UIColor *)bgColor {
    
    CGFloat fluct = [self.changeRate doubleValue];
    
    if (fluct > 0) {
        
        return kRiseColor;
        
    } else if (fluct == 0) {
        
        return kHexColor(@"#979797");
    }
    
    return kThemeColor;
}

- (UIColor *)flowBgColor {
    
    CGFloat fluct = [self.flow_percent_change_24h doubleValue];
    
    if (fluct > 0) {
        
        return kRiseColor;
        
    } else if (fluct == 0) {
        
        return kHexColor(@"#979797");
    }
    
    return kThemeColor;
}

@end
