//
//  NSNumber+Extension.m
//  Coin
//
//  Created by 蔡卓越 on 2017/11/8.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import "NSNumber+Extension.h"

@implementation NSNumber (Extension)

- (NSString *)convertToRealMoney {
    
    if (!self) {
        
        NSLog(@"金额不能为空");
        return nil;
    }
    
    long long m = [self longLongValue];
    double value = m/1.0;
    
    NSString *tempStr =  [NSString stringWithFormat:@"%.3f",value];
    NSString *subStr = [tempStr substringWithRange:NSMakeRange(0, tempStr.length - 1)];
    
    //  return [NSString stringWithFormat:@"%.2f",value];
    return subStr;
    
}

- (NSString *)convertToSimpleRealCoin {
    
    if (!self) {
        
        NSLog(@"金额不能为空");
        return nil;
        
    }
    
    //保留8位小数,第九位舍去
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:8 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    
    NSDecimalNumber *m = [NSDecimalNumber decimalNumberWithString:[self stringValue]];
    
    NSDecimalNumber *n = [NSDecimalNumber decimalNumberWithString:[@(1.0e+18) stringValue]];
    
    NSDecimalNumber *o = [m decimalNumberByDividingBy:n];
    
    NSDecimalNumber *p = [o decimalNumberByRoundingAccordingToBehavior:handler];
    
    return [NSString stringWithFormat:@"%@",p];
}

//能去掉小数点的尽量去掉小数点
- (NSString *)convertToSimpleRealMoney {
    
    if (!self) {
        
        NSLog(@"金额不能为空");
        return nil;
        
    }
    
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];

    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:[self stringValue]];
    
    NSDecimalNumber *result = [price decimalNumberByRoundingAccordingToBehavior:handler];

    return [result stringValue];

}

- (NSString *)convertToRealMoneyWithNum:(NSInteger)num {
    
    if (!self) {
        
        NSLog(@"金额不能为空");
        return nil;
    }
    
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:num raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    
    NSDecimalNumber *price = [NSDecimalNumber decimalNumberWithString:[self stringValue]];
    
    NSDecimalNumber *result = [price decimalNumberByRoundingAccordingToBehavior:handler];
    
    return [result stringValue];
    
}

//折扣
- (NSString *)convertToCountMoney {
    
    if (!self) {
        
        NSLog(@"金额不能为空");
        return nil;
    }
    
    long long m = [self doubleValue]*10000;
    
    double value = m*10.0/10000.0;
    
    if (m%10 > 0) { //有厘
        
        return [NSString stringWithFormat:@"%.2f",value];
        
    } else if (m%100 > 0) {//有分
        
        return [NSString stringWithFormat:@"%.2f",value];
        
    } else if(m%1000 > 0) { //有角
        
        return [NSString stringWithFormat:@"%.1f",value];
        
    } else {//元
        
        return [NSString stringWithFormat:@"%.0f",value];
    }
    
    
}

//减法
- (NSString *)subNumber:(NSNumber *)number {
    
    //保留8位小数,第九位舍去
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:8 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    
    NSDecimalNumber *m = [NSDecimalNumber decimalNumberWithString:[self stringValue]];
    
    NSDecimalNumber *n = [NSDecimalNumber decimalNumberWithString:[number stringValue]];
    
    NSDecimalNumber *o = [m decimalNumberBySubtracting:n];
    
    NSDecimalNumber *p = [o decimalNumberByRoundingAccordingToBehavior:handler];
    
    return [NSString stringWithFormat:@"%@",p];
}
+ (NSString *)mult1:(NSString *)mult1 mult2:(NSString *)mult2 scale:(NSUInteger)scale {
    
    NSDecimalNumber *mult1Num = [[NSDecimalNumber alloc] initWithString:mult1];
    NSDecimalNumber *mult2Num = [[NSDecimalNumber alloc] initWithString:mult2];
    NSDecimalNumber *result = [mult1Num decimalNumberByMultiplyingBy:mult2Num];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundDown
                                       scale:scale
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    
    return [[result decimalNumberByRoundingAccordingToBehavior:roundUp] stringValue];
    
}

+ (NSString *)div1:(NSString *)div1 div2:(NSString *)div2 scale:(NSUInteger)scale {
    
    NSDecimalNumber *div1Num = [[NSDecimalNumber alloc] initWithString:div1];
    NSDecimalNumber *div2Num = [[NSDecimalNumber alloc] initWithString:div2];
    NSDecimalNumber *result = [div1Num decimalNumberByDividingBy:div2Num];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundDown
                                       scale:scale
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    
    return [[result decimalNumberByRoundingAccordingToBehavior:roundUp] stringValue];
    
}

+ (NSString *)add1:(NSString *)add1 add2:(NSString *)add2 scale:(NSUInteger)scale {
    
    NSDecimalNumber *add1Num = [[NSDecimalNumber alloc] initWithString:add1];
    NSDecimalNumber *add2Num = [[NSDecimalNumber alloc] initWithString:add2];
    NSDecimalNumber *result = [add1Num decimalNumberByAdding:add2Num];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundDown
                                       scale:scale
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    
    return [[result decimalNumberByRoundingAccordingToBehavior:roundUp] stringValue];
}

+ (NSString *)sub1:(NSString *)sub1 sub2:(NSString *)sub2 scale:(NSUInteger)scale {
    
    NSDecimalNumber *sub1Num = [[NSDecimalNumber alloc] initWithString:sub1];
    NSDecimalNumber *sub2Num = [[NSDecimalNumber alloc] initWithString:sub2];
    NSDecimalNumber *result = [sub1Num decimalNumberBySubtracting:sub2Num];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       decimalNumberHandlerWithRoundingMode:NSRoundDown
                                       scale:scale
                                       raiseOnExactness:NO
                                       raiseOnOverflow:NO
                                       raiseOnUnderflow:NO
                                       raiseOnDivideByZero:YES];
    
    return [[result decimalNumberByRoundingAccordingToBehavior:roundUp] stringValue];
}

@end
