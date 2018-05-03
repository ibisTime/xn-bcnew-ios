//
//  ForumDetailModel.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ForumDetailModel.h"

@implementation ForumDetailModel

+ (NSDictionary *)objectClassInArray {
    
    return @{@"hotPostList" : [ForumCommentModel class]};
}

@end

@implementation ForumDetailCoin

+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    
    if ([propertyName isEqualToString:@"ID"]) {
        return @"id";
    }
    
    return propertyName;
}

@end

