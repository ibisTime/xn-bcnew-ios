//
//  TLTextField.m
//  WeRide
//
//  Created by  蔡卓越 on 2016/12/7.
//  Copyright © 2016年 trek. All rights reserved.
//

#import "TLTextField.h"
#import "AppColorMacro.h"
#import "TLUIHeader.h"
#import "UIColor+Extension.h"

@implementation TLTextField

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        //        self.textAlignment = NSTextAlignmentRight;
        self.font = [UIFont systemFontOfSize:15];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                    leftTitle:(NSString *)leftTitle
                   titleWidth:(CGFloat)titleWidth
                  placeholder:(NSString *)placeholder {
    
    if (self = [super init]) {
        
        UIView *leftBgView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:leftBgView];

        UILabel *leftLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        leftLbl.text = leftTitle;
        leftLbl.textAlignment = NSTextAlignmentLeft;
        leftLbl.font = Font(15.0);
        leftLbl.textColor = [UIColor colorWithHexString:@"#484848"];
//        leftLbl.textColor = [UIColor blackColor];
        [leftBgView addSubview:leftLbl];
        
        self.leftLbl = leftLbl;
        self.leftView = leftBgView;

        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.rightViewMode = UITextFieldViewModeAlways;
//        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.placeholder = placeholder;
        //    [tf addAction];
        self.font = [UIFont systemFontOfSize:15];
        
        [leftBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.width.mas_equalTo(titleWidth);
            make.bottom.equalTo(self.mas_bottom);
        }];
        [leftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftBgView.mas_left).with.offset(15);
            make.top.equalTo(leftBgView.mas_top);
            make.bottom.equalTo(leftBgView.mas_bottom);
            make.width.mas_equalTo(titleWidth - 20);
        }];

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                     leftIcon:(NSString *)leftIcon
                  placeholder:(NSString *)placeholder {
    
    if (self = [super initWithFrame:frame]) {
        
        UIView *leftBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, frame.size.height)];
        
        _leftIconIV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 16, 16)];
        _leftIconIV.contentMode = UIViewContentModeCenter;
        _leftIconIV.centerY = leftBgView.height/2.0;
        _leftIconIV.contentMode = UIViewContentModeScaleAspectFit;
        _leftIconIV.image = kImage(leftIcon);
        
        [leftBgView addSubview:_leftIconIV];
        
        self.leftView = leftBgView;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        self.font = [UIFont systemFontOfSize:14];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.backgroundColor = [UIColor whiteColor];
        self.placeholder = placeholder;
        //白色边界线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.7, 18)];
        
        lineView.backgroundColor = [UIColor whiteColor];
        lineView.centerY = frame.size.height/2.0;
        lineView.centerX = leftBgView.width;
        
        [leftBgView addSubview:lineView];
        //        self.tintColor = kAppCustomMainColor;
        lineView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    }
    return self;
}

#pragma mark --处理复制粘贴事件
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(self.isSecurity){
        
        return NO;
        
    } else{
        
        return [super canPerformAction:action withSender:sender];
    }
    //    if (action == @selector(paste:))//禁止粘贴
    //        return NO;
    //    if (action == @selector(select:))// 禁止选择
    //        return NO;
    //    if (action == @selector(selectAll:))// 禁止全选
    //        return NO;
}



@end
