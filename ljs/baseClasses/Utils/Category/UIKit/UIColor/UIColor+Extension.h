//
//  UIColor+Extension.h
//  MOOM
//
//  Created by 田磊 on 16/4/25.
//  Copyright © 2016年 田磊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

//color转为Image
- (UIImage *)convertToImage;

+ (UIColor *)colorWithHexString:(NSString *)color;

+ (UIColor *)colorWithUIColor:(UIColor *)color alpha:(CGFloat)alpha;
/**
 颜色渐变

 @param view 需要渐变的View
 @param fromHexColorStr 起始颜色
 @param toHexColorStr 结束颜色
 */
+ (CAGradientLayer *)setGradualChangingColor:(UIView *)view fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr;
@end
