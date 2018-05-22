//
//  QuotesChangeView.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "QuotesChangeView.h"

@implementation QuotesChangeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.5];
    self.hidden = YES;
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    
    whiteView.backgroundColor = kWhiteColor;
    
    [self addSubview:whiteView];
    //更换交易所
    UILabel *changePlatformLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                         textColor:kTextColor
                                                              font:15.0];
    changePlatformLbl.frame = CGRectMake(15, 25, 100, 16);
    
    [self addSubview:changePlatformLbl];
    
    
    __block CGFloat btnYy;
    
    [self.titles enumerateObjectsUsingBlock:^(PlatformTitleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat w = (kScreenWidth - 5*15)/4.0;
        CGFloat h = 30;
        CGFloat x = 15 + (w+15)*(idx%4);
        CGFloat y = 60 + (h+15)*idx/4;
        
        UIButton *platformBtn = [UIButton buttonWithTitle:obj.cname
                                               titleColor:kTextColor
                                          backgroundColor:kHexColor(@"#f5f7fa")
                                                titleFont:14.0
                                             cornerRadius:2.5];
        platformBtn.frame = CGRectMake(x, y, w, h);
        platformBtn.tag = 2100 + idx;
        [platformBtn addTarget:self action:@selector(selectPlatform:) forControlEvents:UIControlEventTouchUpInside];

        [whiteView addSubview:platformBtn];
        btnYy = platformBtn.yy;
    }];
    
    //更换币种
    UILabel *changeCurrencyLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                         textColor:kTextColor
                                                              font:15.0];
    changeCurrencyLbl.frame = CGRectMake(15, btnYy+42, 100, 16);

    [self addSubview:changeCurrencyLbl];
    
    NSArray *currencys = @[@"USDT", @"BTC", @"ETH"];
    
    __block CGFloat lblYy = changePlatformLbl.yy + 20;
    
    [currencys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat w = (kScreenWidth - 5*15)/4.0;
        CGFloat h = 30;
        CGFloat x = 15 + (w+15)*(idx%4);
        CGFloat y = lblYy + (h+15)*idx/4;
        
        UIButton *currencyBtn = [UIButton buttonWithTitle:obj
                                               titleColor:kTextColor
                                          backgroundColor:kHexColor(@"#f5f7fa")
                                                titleFont:14.0
                                             cornerRadius:2.5];
        currencyBtn.frame = CGRectMake(x, y, w, h);
        currencyBtn.tag = 2200 + idx;
        [currencyBtn addTarget:self action:@selector(selectCurrency:) forControlEvents:UIControlEventTouchUpInside];
        
        [whiteView addSubview:currencyBtn];
    }];
    
    whiteView.height = changePlatformLbl.yy + 110;
}

#pragma mark - Events
- (void)selectPlatform:(UIButton *)sender {
    
    
}

- (void)selectCurrency:(UIButton *)sender {
    
    
}

- (void)show {
    
    self.hidden = NO;
}

- (void)hide {
    
    self.hidden = YES;
}

@end
