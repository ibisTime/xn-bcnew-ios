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
//    [optionBtn setImage:kImage(@"自选白") forState:UIControlStateNormal];
//    [optionBtn setImage:kImage(@"删除 红") forState:UIControlStateSelected];

    [optionBtn setBackgroundColor:kHexColor(@"#FFA300") forState:UIControlStateNormal];
    [optionBtn setBackgroundColor:kHexColor(@"#FFA300") forState:UIControlStateSelected];
    self.optionBtn = optionBtn;
    optionBtn.tag = 10084;
    
    [self addSubview:optionBtn];
    [optionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.centerY.equalTo(@0);
        make.height.equalTo(@50);
        make.width.mas_equalTo(kScreenWidth/3);
//        make.right.equalTo(self.mas_right).with.offset(-(kScreenWidth - 10)/4 * 3);
    }];
    [optionBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    
   
    //设置预警
//    UIButton *warningBtn = [UIButton buttonWithTitle:@"预警"
//                                          titleColor:[UIColor whiteColor]
//                                     backgroundColor:kClearColor
//                                           titleFont:14.0];
//    [warningBtn addTarget:self action:@selector(settingWarning:) forControlEvents:UIControlEventTouchUpInside];
//    [warningBtn setImage:kImage(@"预警") forState:UIControlStateNormal];
//    warningBtn.tag = 10086;
//
//    [self addSubview:warningBtn];
//    [warningBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(optionBtn.mas_right);
//        make.centerY.equalTo(@0);
//        make.height.equalTo(@50);
//        make.right.equalTo(self.mas_right).with.offset(-(kScreenWidth - 30)/4 * 2);
//    }];
//    [warningBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    
//    UIView *lineView = [[UIView alloc] init];
//    [warningBtn addSubview:lineView];
//    lineView.backgroundColor = kWhiteColor;
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(warningBtn.mas_right).offset(-5);
//        make.centerY.equalTo(@0);
//        make.height.equalTo(@20);
//        make.width.equalTo(@0.5);
//
//    }];
    UIButton *AnalysisBtn = [UIButton buttonWithTitle:@"介绍"
                                       titleColor:[UIColor whiteColor]
                                  backgroundColor:kClearColor
                                        titleFont:14.0];
    [AnalysisBtn addTarget:self action:@selector(settingWarning:) forControlEvents:UIControlEventTouchUpInside];
        [AnalysisBtn setImage:kImage(@"介绍") forState:UIControlStateNormal];
    
    [self addSubview:AnalysisBtn];
    [AnalysisBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(optionBtn.mas_right);
        make.centerY.equalTo(@0);
        make.height.equalTo(@50);
        make.width.mas_equalTo(kScreenWidth/3);
        
    }];
    [AnalysisBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    AnalysisBtn.tag = 10087;
    
    UIView *lineView2 = [[UIView alloc] init];
    [AnalysisBtn addSubview:lineView2];
    lineView2.backgroundColor = kWhiteColor;
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(AnalysisBtn.mas_right).offset(-5);
        make.centerY.equalTo(@0);
        make.height.equalTo(@20);
        make.width.equalTo(@1);
        
    }];
    //gengduo
    UIButton *moreBtn = [UIButton buttonWithTitle:@"更多"
                                       titleColor:[UIColor whiteColor]
                                     backgroundColor:kClearColor
                                           titleFont:14.0];
    [moreBtn addTarget:self action:@selector(settingWarning:) forControlEvents:UIControlEventTouchUpInside];
    [moreBtn setImage:kImage(@"更多3") forState:UIControlStateNormal];
    
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

-(void)setPlatform:(PlatformModel *)platform
{
    _platform = platform;
    if ([platform.isChoice isEqualToString:@"0"]) {
        [self.optionBtn setImage:kImage(@"自选白") forState:UIControlStateNormal];

    }else{
        [self.optionBtn setImage:kImage(@"删除 红") forState:UIControlStateNormal];

        
    }
    
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
            if (self.kine) {
                BaseWeakSelf;
//                self.kine.choose = ^(NSInteger type) {
//                    switch (type) {
//                        case 0:
//                            [weakSelf.optionBtn setImage:kImage(@"删除 红") forState:UIControlStateNormal];
//
////                        [weakSelf.optionBtn setImage:kImage(@"删除 红") forState:UIControlStateSelected];
//                        [weakSelf.optionBtn setImage:kImage(@"删除 红") forState:UIControlStateNormal];
//
//                            break;
//                        case 1:
//                        [weakSelf.optionBtn setImage:kImage(@"删除 红") forState:UIControlStateSelected];
//
//                            break;
//
//                        default:
//                            break;
//                    }
//                };
            }
            
        }
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectBtnisChangeWrning:with:)]) {
        [self.delegate selectBtnisChangeWrning:btn.tag == 10086 ? YES : NO with:btn];
    }
    
}

@end
