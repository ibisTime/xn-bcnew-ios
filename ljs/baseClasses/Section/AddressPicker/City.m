//
//  City.m
//  testUTF8
//
//  Created by 蔡卓越 on 16/7/13.
//  Copyright © 2016年 caizhuoyue. All rights reserved.
//

#import "City.h"

@implementation City

- (instancetype)initWithName:(NSString *)name
                       areas:(NSArray *)areas{
    if (self = [super init]) {
        _cityName = name;
        _areas = areas;
    }
    return self;
}

+ (instancetype)cityWithName:(NSString *)cityName
                       areas:(NSArray *)areas{
    City * city = [[City alloc]initWithName:cityName
                                      areas:areas];
    return city;
}

@end
