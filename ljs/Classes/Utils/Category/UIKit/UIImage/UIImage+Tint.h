//
//  UIImage+Tint.h
//  ljs
//
//  Created by 蔡卓越 on 2018/2/5.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tint)

//对图片内部进行渲染
- (UIImage *)tintedImageWithColor:(UIColor *)tintColor;
//
- (UIImage *)tintedGradientImageWithColor:(UIColor *)tintColor;

@end
