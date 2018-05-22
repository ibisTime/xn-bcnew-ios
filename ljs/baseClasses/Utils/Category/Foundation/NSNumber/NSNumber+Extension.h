//
//  NSNumber+Extension.h
//  Coin
//
//  Created by 蔡卓越 on 2017/11/8.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Extension)

//转换金额
- (NSString *)convertToRealMoney;

//能去掉小数点的尽量去掉小数点
- (NSString *)convertToSimpleRealMoney;
//位数
- (NSString *)convertToRealMoneyWithNum:(NSInteger)num;

- (NSString *)convertToSimpleRealCoin;

- (NSString *)convertToCountMoney;
//减法
- (NSString *)subNumber:(NSNumber *)number;
/**
 两个数相乘，可以指定小数位数
 */
+ (NSString *)mult1:(NSString *)mult1 mult2:(NSString *)mult2 scale:(NSUInteger)scale;
/**
 两个数相除，可以指定小数位数
 */
+ (NSString *)div1:(NSString *)div1 div2:(NSString *)div2 scale:(NSUInteger)scale;
/**
 两个数相加，可以指定小数位数
 */
+ (NSString *)add1:(NSString *)add1 add2:(NSString *)add2 scale:(NSUInteger)scale;
/**
 两个数相减，可以指定小数位数
 */
+ (NSString *)sub1:(NSString *)sub1 sub2:(NSString *)sub2 scale:(NSUInteger)scale;
@end
