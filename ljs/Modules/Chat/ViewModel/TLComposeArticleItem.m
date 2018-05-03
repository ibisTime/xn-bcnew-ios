//
//  TLComposeArticleItem.m
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/25.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//

#import "TLComposeArticleItem.h"
@implementation TLComposeImgItem

+ (NSString *)primaryKey {
    
    //shortUrl唯一，设为主键
    return @"code";
    
}


+ (NSArray<NSString *> *)requiredProperties {

    //属性不能为空
    return @[@"code",@"shortUrl",@"imgData"];

}

@end

/**
 帖子模型
 */
@implementation TLComposeArticleItem

+ (NSArray<NSString *> *)requiredProperties {
    
    //属性不能为空
    return @[@"code"];
    
}

+ (NSString *)primaryKey {
    
    //shortUrl唯一，设为主键
    return @"code";
    
}

@end
