//
//  PlatformWarningModel.m
//  ljs
//
//  Created by zhangfuyu on 2018/5/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PlatformWarningModel.h"

@implementation PlatformWarningModel

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"ID"]) {
        return @"id";
    }
    
    return propertyName;
}
@end
