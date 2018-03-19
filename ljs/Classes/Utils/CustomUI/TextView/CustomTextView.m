//
//  CustomTextView.m
//  YS_iOS
//
//  Created by 蔡卓越 on 2017/1/6.
//  Copyright © 2017年 caizhuoyue. All rights reserved.
//

#import "CustomTextView.h"

#import "TLUIHeader.h"
#import "AppColorMacro.h"

@interface CustomTextView ()<UITextViewDelegate>

@end

@implementation CustomTextView

+ (CustomTextView *)textViewWithTextColor:(UIColor *)textColor font:(CGFloat)font {

    CustomTextView *tv = [[CustomTextView alloc] init];
    
    // 设置默认字体
    tv.font = Font(14.0);
    tv.textColor = textColor;
    
    return tv;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        // 使用通知监听文字改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)textDidChange:(NSNotification *)notification
{
    // 会重新调用drawRect:方法
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 * 每次调用drawRect:方法，都会将以前画的东西清除掉
 */
- (void)drawRect:(CGRect)rect
{
    // 如果有文字，就直接返回，不需要画占位文字
    if (self.hasText) {
    
        return;
    }
    
    // 属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor;
    
    // 画文字
    rect.origin.x = 5;
    rect.origin.y = 5;
    rect.size.width -= 2 * rect.origin.x;
    [self.placeholder drawInRect:rect withAttributes:attrs];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setNeedsDisplay];
}

#pragma mark - setter
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText
{
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}

@end
