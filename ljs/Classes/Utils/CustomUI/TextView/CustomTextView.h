//
//  CustomTextView.h
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/1/6.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextView : UITextView

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, strong) UIColor *placeholderColor;

+ (CustomTextView *)textViewWithTextColor:(UIColor *)textColor font:(CGFloat)font;

@end
