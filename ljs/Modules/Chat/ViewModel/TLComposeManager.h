//
//  TLComposeManager.h
//  CityBBS
//
//  Created by  caizhuoyue on 2017/3/25.
//  Copyright © 2017年  caizhuoyue. All rights reserved.
//  后台上传帖子，保存帖子数据到数据库

#import <Foundation/Foundation.h>
#import "TLComposeArticleItem.h"

@interface TLComposeManager : NSObject

+ (instancetype)manager;

+ (void)saveArticleToLocalAndBeginUpload:(TLComposeArticleItem *)article;

//应用退出调用该方法
- (void)appCancle;

@end
