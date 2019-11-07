//
//  CurrencyPriceModel.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyPriceModel.h"
#import "AppColorMacro.h"
#import "NSNumber+Extension.h"
#import "NSString+Extension.h"
@implementation CurrencyPriceModel
+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"ID"]) {
        return @"id";
    }
    
    if ([propertyName isEqualToString:@"cpCount"]) {
        return @"copyCount";
    }
    if ([propertyName isEqualToString:@"SymbolIMG"]) {
        return @"symbolIcon";
    }
    
    return propertyName;
}

- (UIColor *)bgColor {
    
    return [self getPercentColorWithPercent:self.percentChange];
}

/**
 排名背景色
 */
- (UIColor *)rankColor {
    
    if (self.rank == 1) {
        
        return kHexColor(@"#348ff6");
        
    } else if (self.rank == 2) {
        
        return kHexColor(@"#73b3fc");
        
    } else if (self.rank == 3) {
        
        return kHexColor(@"#a4cdfc");
    }
    
    return kWhiteColor;
}

- (UIColor *)flowBgColor {
    
    return [self getPercentColorWithPercent:self.flow_percent_change_24h];
}

- (NSString *)tradeVolume {
    
    return [self getNumWithVolume:self.volume];
}


/**
 转换百分比
 */
- (NSString *)changeRate {
    
    return [NSNumber mult1:[self.percentChange stringValue] mult2:@"100" scale:2];
}

/**
 获取涨跌颜色
 */
- (UIColor *)getPercentColorWithPercent:(NSNumber *)percent {
    
    CGFloat fluct = [percent doubleValue];
    
    if (fluct > 0) {
        
        return kRiseColor;
        
    } else if (fluct == 0) {
        
        return kHexColor(@"#979797");
    }
    
    return kThemeColor;
}

/**
 获取涨跌幅
 */
- (NSString *)getResultWithPercent:(NSNumber *)percent {
    
    NSString *priceFluctStr;
    
    CGFloat fluct = [percent doubleValue]*100;
    
    if (fluct > 0) {
        
        priceFluctStr = [NSString stringWithFormat:@"+%.2lf%%", fluct];
        
    } else  {
        
        priceFluctStr = [NSString stringWithFormat:@"%.2lf%%", fluct];
    }
    
    return priceFluctStr;
}

/**
 获取币种数量
 */
- (NSString *)getNumWithVolume:(NSNumber *)volumeNum {
    
    CGFloat volume = [volumeNum doubleValue];
    
    if (volumeNum == 0) {
        
        return @"-";
    }
    
    NSString *result;
    
    if (volume > 1000000000000) {
        
        result = [NSString stringWithFormat:@"%.0lft", volume/1000000000000];
        return result;
    }
    
    if (volume > 1000000000) {
        
        result = [NSString stringWithFormat:@"%.0lfb", volume/1000000000];
        return result;
    }
    
    if (volume > 1000000) {
        
        result = [NSString stringWithFormat:@"%.0lfm", volume/1000000];
        return result;
    }
    
    result = [NSString stringWithFormat:@"%.0lf", volume];
    
    return result;
}

@end
