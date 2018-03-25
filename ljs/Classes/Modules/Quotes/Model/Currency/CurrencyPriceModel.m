//
//  CurrencyPriceModel.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyPriceModel.h"
#import "AppColorMacro.h"

@implementation CurrencyPriceModel

- (UIColor *)bgColor {
    
    CGFloat fluct = [self.percentChange24h doubleValue];
    
    if (fluct > 0) {
        
        return kRiseColor;
        
    } else if (fluct == 0) {
        
        return kHexColor(@"#979797");
    }
    
    return kThemeColor;
}

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"ID"]) {
        return @"id";
    }
    
    return propertyName;
}

@end
