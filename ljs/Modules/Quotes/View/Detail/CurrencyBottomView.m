//
//  CurrencyBottomView.m
//  ljs
//
//  Created by zhangfuyu on 2018/5/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyBottomView.h"
#import "AppColorMacro.h"
#import <Masonry.h>

#import "UIButton+EnLargeEdge.h"
#import "UIButton+Custom.h"

@implementation CurrencyBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    self.backgroundColor = kWhiteColor;
    
    //topLine
    UIView *topLine = [[UIView alloc] init];
    
    topLine.backgroundColor = kLineColor;
    
    [self addSubview:topLine];

    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    //设置预警
    UIButton *warningBtn = [UIButton buttonWithTitle:@"预警"
                                          titleColor:[UIColor whiteColor]
                                     backgroundColor:kClearColor
                                           titleFont:14.0];
    [warningBtn addTarget:self action:@selector(settingWarning:) forControlEvents:UIControlEventTouchUpInside];
    [warningBtn setImage:kImage(@"设置预警") forState:UIControlStateNormal];
    warningBtn.tag = 10086;
    
    [self addSubview:warningBtn];
    [warningBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@10);
        make.centerY.equalTo(@0);
        make.height.equalTo(@50);
        make.right.equalTo(self.mas_centerX);
    }];
    [warningBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    
    
    //gengduo
    UIButton *moreBtn = [UIButton buttonWithTitle:@"更多"
                                       titleColor:[UIColor whiteColor]
                                     backgroundColor:kClearColor
                                           titleFont:14.0];
    [moreBtn addTarget:self action:@selector(settingWarning:) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setImage:kImage(@"更多") forState:UIControlStateNormal];
    
    [self addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_centerX);
        make.centerY.equalTo(@0);
        make.height.equalTo(@50);
        make.right.equalTo(self.mas_right).with.offset(-10);
    }];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    moreBtn.tag = 10085;
}
- (void)settingWarning:(UIButton *)btn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectBtnisChangeWrning:with:)]) {
        [self.delegate selectBtnisChangeWrning:btn.tag == 10086 ? YES : NO with:btn];
    }
}

@end
