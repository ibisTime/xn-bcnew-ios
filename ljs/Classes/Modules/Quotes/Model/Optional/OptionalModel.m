//
//  OptionalModel.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "OptionalModel.h"
#import "AppColorMacro.h"

@implementation OptionalModel

- (UIColor *)bgColor {
    
    CGFloat fluct = [self.percent_change_24h doubleValue];
    
    return fluct >= 0 ? kRiseColor: kThemeColor;
}

@end
