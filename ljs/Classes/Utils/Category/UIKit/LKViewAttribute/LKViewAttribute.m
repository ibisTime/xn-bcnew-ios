//
//  LKViewAttribute.m
//  LKKit
//
//  Created by 蔡卓越 on 16/4/28.
//  Copyright © 2016年 蔡卓越. All rights reserved.
//

#import "LKViewAttribute.h"

#import <objc/runtime.h>


@implementation UIView (LKKit)


- (LKAttributeMaker *)lk_attribute {
   
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        
//        Method method1 = class_getInstanceMethod([self class], @selector(lk_performSelector:withObject:));
//        
//        Method method2 = class_getInstanceMethod([self class], @selector(performSelector:withObject:));
//        method_exchangeImplementations(method1, method2);
//        
//    });
    
    LKAttributeMaker *maker = [[LKAttributeMaker alloc] init];
    maker.view = self;
    
    return maker;
}

- (void)lk_performSelector:(SEL)aSelector withObject:(id)object {
    
    if ([self respondsToSelector:aSelector]) {
        [self performSelector:aSelector withObject:object];
    }    
}

@end


@interface LKAttributeMaker ()


@end

@implementation LKAttributeMaker

- (LKAttributeMaker* (^) (UIView *superView))superView {
    
    return  ^(UIView *superView) {
        
        
        
        [superView addSubview:self.view];
        return self;
    };
}


- (LKAttributeMaker *(^)(UIColor *color))backgroundColor {
    
    return  ^(UIColor *color) {
        
        self.view.backgroundColor = color;
        return self;
    };
}

- (LKAttributeMaker* (^) (NSInteger tag))tag {
    
    return  ^(NSInteger tag) {
        
        self.view.tag = tag;
        return self;
    };
}


- (LKAttributeMaker* (^) (CGFloat corner))corner {
    
    return  ^(CGFloat corner) {
        
        self.view.layer.cornerRadius = corner;
        self.view.layer.masksToBounds = YES;
        return self;
    };
}

- (LKAttributeMaker* (^) (UIColor *color, CGFloat borderWidth))border {
    
    return  ^(UIColor *color, CGFloat borderWidth) {
        
        self.view.layer.borderWidth = borderWidth;
        self.view.layer.borderColor = color.CGColor;
        return self;
    };
}

- (LKAttributeMaker* (^) (CGFloat alpha))alpha {
    
    return  ^(CGFloat alpha) {
        
        self.view.alpha = alpha;
        return self;
    };
}



/**
 *  these attributes just for UILabel
 */

- (LKAttributeMaker* (^) (NSString *text))text {

    return  ^(NSString *text) {
        
        [self.view lk_performSelector:@selector(setText:) withObject:text];
        
        return self;
    };
}

- (LKAttributeMaker* (^) (CGFloat font))font {
    
    return  ^(CGFloat font) {
        
//    [self.view lk_performSelector:@selector(setFont:) withObject:
//     [UIFont systemFontOfSize:font]];
       
        if ([self.view isKindOfClass:[UILabel class]]) {
            
            UILabel *label = (UILabel*)self.view;
            label.font = [UIFont systemFontOfSize:font];
        }
        else if ([self.view isKindOfClass:[UIButton class]]) {
        
            UIButton *button = (UIButton*)self.view;
            button.titleLabel.font = [UIFont systemFontOfSize:font];
        }
        
        return self;
    };
}

- (LKAttributeMaker* (^) (UIColor *color))textColor {
    
    return  ^(UIColor *color) {
        
        [self.view lk_performSelector:@selector(setTextColor:) withObject:color];
    
        return self;
    };
}


- (LKAttributeMaker* (^) (NSTextAlignment textAligent))textAlignment {
    return  ^(NSTextAlignment textAlignment) {
        
        if ([self.view isKindOfClass:[UILabel class]]) {
            
            UILabel *label = (UILabel*)self.view;
            label.textAlignment = textAlignment;
        }
        else if ([self.view isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton*)self.view;
            button.titleLabel.textAlignment = textAlignment;
        }

        return self;
    };
}

- (LKAttributeMaker* (^) (CGFloat lineSpace))lineSpace {
    
    return  ^(CGFloat lineSpace) {
        
//        if ([self.view isKindOfClass:[UILabel class]]) {
//            UILabel *label = (UILabel*)(self.view);
//            label.textAlignment = textAlignment;
//        }

      // [self.view lk_performSelector:@selector(setTextAlignment:) withObject:@((NSInteger)lineSpace)];
        
        return self;
    };
}

- (LKAttributeMaker* (^) (NSInteger numberLines))numberLines {

    return  ^(NSInteger numberLines) {
        
        if ([self.view isKindOfClass:[UILabel class]]) {
            
            UILabel *label = (UILabel*)self.view;
            label.numberOfLines = numberLines;
        }
        else if ([self.view isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton*)self.view;
            button.titleLabel.numberOfLines = numberLines;
        }

        return self;
    };
}


/**
 *  attributes just for UIImageView
 */

- (LKAttributeMaker* (^) (UIImage *image))image {

    return  ^(UIImage *image) {
        
        if ([self.view isKindOfClass:[UIImageView class]]) {
            UIImageView *imgView = (UIImageView*)(self.view);
            imgView.image = image;
        }
        
        return self;
    };
}

/**
 *  attribute for UIButton
 */

- (LKAttributeMaker* (^) (id target, SEL selector))event {

    return  ^(id target, SEL selector) {
        
        if ([self.view isKindOfClass:[UIControl class]]) {
            UIControl *control = (UIControl*)(self.view);
            [control addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        }
        
        return self;
    };
}


- (LKAttributeMaker* (^) (UIImage *image))selectImage {

    return  ^(UIImage *image) {
        
        if ([self.view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)(self.view);
            [button setImage:image forState:UIControlStateSelected];
        }
        
        return self;
    };
}

- (LKAttributeMaker* (^) (NSString *title))selectTitle {

    return  ^(NSString *title) {
        
        if ([self.view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)(self.view);
            [button setTitle:title forState:UIControlStateSelected];
        }
        
        return self;
    };
}

- (LKAttributeMaker* (^) (UIColor *color))selectTitleColor {

    return  ^(UIColor *color) {
        
        if ([self.view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)(self.view);
            [button setTitleColor:color forState:UIControlStateSelected];
        }
        
        return self;
    };
}

- (LKAttributeMaker* (^) (UIImage *image))selectBackgroundImage {
    
    return  ^(UIImage *image) {
        
        if ([self.view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)(self.view);
            [button setBackgroundImage:image forState:UIControlStateSelected];
        }
        
        return self;
    };
}


- (LKAttributeMaker* (^) (UIImage *image))normalImage {
    return  ^(UIImage *image) {
        
        if ([self.view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)(self.view);
            [button setImage:image forState:UIControlStateNormal];
        }
        
        return self;
    };
}

- (LKAttributeMaker* (^) (NSString *title))normalTitle {
    
    return  ^(NSString *title) {
        
        if ([self.view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)(self.view);
            [button setTitle:title forState:UIControlStateNormal];
        }
        
        return self;
    };
}

- (LKAttributeMaker* (^) (UIColor *color))normalTitleColor {
    return  ^(UIColor *color) {
        
        if ([self.view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)(self.view);
            [button setTitleColor:color forState:UIControlStateNormal];
        }
        
        return self;
    };
}

- (LKAttributeMaker* (^) (UIImage *image))normalBackgroundImage {
    
    return  ^(UIImage *image) {
        
        if ([self.view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)(self.view);
            [button setBackgroundImage:image forState:UIControlStateNormal];
        }
        
        return self;
    };
}

#pragma mark - Private










@end
