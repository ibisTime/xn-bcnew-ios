//
//  TLPlaceholderView.h
//  ljs
//
//  Created by  蔡卓越 on 2016/12/21.
//  Copyright © 2016年  caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLPlaceholderView : UIView

@property (nonatomic , strong) UILabel *textLbl;

+ (instancetype)placeholderViewWithText:(NSString *)text;

+ (instancetype)placeholderViewWithText:(NSString *)text topMargin:(CGFloat)margin ;

+ (instancetype)placeholderViewWithImage:(NSString *)image text:(NSString *)text;

@end
