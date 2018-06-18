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
    UIButton *optionBtn = [UIButton buttonWithTitle:@"自选"
                                          titleColor:[UIColor whiteColor]
                                     backgroundColor:kClearColor
                                           titleFont:14.0];
    [optionBtn addTarget:self action:@selector(settingWarning:) forControlEvents:UIControlEventTouchUpInside];
    [optionBtn setImage:kImage(@"自选白") forState:UIControlStateNormal];
    [optionBtn setBackgroundColor:kHexColor(@"#FFA300") forState:UIControlStateNormal];
    [optionBtn setBackgroundColor:kHexColor(@"#FFA300") forState:UIControlStateSelected];

    optionBtn.tag = 10084;
    
    [self addSubview:optionBtn];
    [optionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.centerY.equalTo(@0);
        make.height.equalTo(@50);
        make.right.equalTo(self.mas_right).with.offset(-(kScreenWidth - 10)/4 * 3);
    }];
    [optionBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    
    //设置预警
    UIButton *warningBtn = [UIButton buttonWithTitle:@"预警"
                                          titleColor:[UIColor whiteColor]
                                     backgroundColor:kClearColor
                                           titleFont:14.0];
    [warningBtn addTarget:self action:@selector(settingWarning:) forControlEvents:UIControlEventTouchUpInside];
    [warningBtn setImage:kImage(@"预警") forState:UIControlStateNormal];
    warningBtn.tag = 10086;
    
    [self addSubview:warningBtn];
    [warningBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(optionBtn.mas_right);
        make.centerY.equalTo(@0);
        make.height.equalTo(@50);
        make.right.equalTo(self.mas_right).with.offset(-(kScreenWidth - 30)/4 * 2);
    }];
    [warningBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    
    UIButton *AnalysisBtn = [UIButton buttonWithTitle:@"分析"
                                       titleColor:[UIColor whiteColor]
                                  backgroundColor:kClearColor
                                        titleFont:14.0];
    [AnalysisBtn addTarget:self action:@selector(settingWarning:) forControlEvents:UIControlEventTouchUpInside];
        [AnalysisBtn setImage:kImage(@"介绍") forState:UIControlStateNormal];
    
    [self addSubview:AnalysisBtn];
    [AnalysisBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(warningBtn.mas_right);
        make.centerY.equalTo(@0);
        make.height.equalTo(@50);
        make.right.equalTo(self.mas_right).with.offset(-(kScreenWidth - 30)/4);
        
    }];
    [AnalysisBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    AnalysisBtn.tag = 10087;
    
    
    //gengduo
    UIButton *moreBtn = [UIButton buttonWithTitle:@"更多"
                                       titleColor:[UIColor whiteColor]
                                     backgroundColor:kClearColor
                                           titleFont:14.0];
    [moreBtn addTarget:self action:@selector(settingWarning:) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setImage:kImage(@"更多") forState:UIControlStateNormal];
    
    [self addSubview:moreBtn];
    [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(AnalysisBtn.mas_right);
        make.centerY.equalTo(@0);
        make.height.equalTo(@50);
        make.right.equalTo(self.mas_right).with.offset(0);
    }];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    moreBtn.tag = 10085;
}
- (void)settingWarning:(UIButton *)btn
{
    if (btn.tag == 10087) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(opendAnalysisVC)]) {
            [self.delegate opendAnalysisVC];
        }
        return;
    }
    if (btn.tag == 10084) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(opendAnalysisVC)]) {
            [self.delegate addchouse];
        }
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectBtnisChangeWrning:with:)]) {
        [self.delegate selectBtnisChangeWrning:btn.tag == 10086 ? YES : NO with:btn];
    }
    
}

@end
