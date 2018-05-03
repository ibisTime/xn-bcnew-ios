//
//  TLTextField.h
//  WeRide
//
//  Created by  蔡卓越 on 2016/12/7.
//  Copyright © 2016年 trek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLTextField : UITextField
//左边文字
@property (nonatomic, strong) UILabel *leftLbl;
//左边图标
@property (nonatomic,strong) UIImageView *leftIconIV;
//禁止复制粘贴等功能
@property (nonatomic,assign) BOOL isSecurity;

- (instancetype)initWithFrame:(CGRect)frame
                    leftTitle:(NSString *)leftTitle
                   titleWidth:(CGFloat)titleWidth
                  placeholder:(NSString *)placeholder;

- (instancetype)initWithFrame:(CGRect)frame
                     leftIcon:(NSString *)leftIcon
                  placeholder:(NSString *)placeholder;

@end
