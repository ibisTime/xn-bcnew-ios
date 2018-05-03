//
//  ZipImg.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/7/1.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface ZipImg : NSObject

/**
 @param oldImg 需要压缩的图片
 @param beginHandler 开始
 @param endHandler 完成的回调
 */
- (void)zipImg:(UIImage *)oldImg begin:(void(^)())beginHandler end:(void(^)(UIImage *))endHandler;

@end
