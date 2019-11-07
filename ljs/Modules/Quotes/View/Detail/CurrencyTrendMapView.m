//
//  CurrencyTrendMapView.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyTrendMapView.h"

//Manager
#import "AppConfig.h"
//Category
#import "UILabel+Extension.h"
//V
#import "DetailWebView.h"
#import "TLNetworking.h"

@interface CurrencyTrendMapView()

//一天涨跌幅
@property (nonatomic, strong) UILabel *oneDayPercentLbl;
//一周涨跌幅
@property (nonatomic, strong) UILabel *oneWeekPercentLbl;
//一月涨跌幅
@property (nonatomic, strong) UILabel *oneMonthPercentLbl;
//趋势图
@property (nonatomic, strong) DetailWebView *trendView;

@end

@implementation CurrencyTrendMapView

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
    
    self.backgroundColor = kWhiteColor;
    //一天涨跌幅
    self.oneDayPercentLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                     textColor:kTextColor4
                                                          font:11.0];
    [self addSubview:self.oneDayPercentLbl];
    [self.oneDayPercentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@15);
    }];
    //一周涨跌幅
    self.oneWeekPercentLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                     textColor:kTextColor4
                                                          font:11.0];
    self.oneWeekPercentLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.oneWeekPercentLbl];
    [self.oneWeekPercentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(@15);
    }];
    //一月涨跌幅
    self.oneMonthPercentLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                    textColor:kTextColor4
                                                         font:11.0];
    [self addSubview:self.oneMonthPercentLbl];
    [self.oneMonthPercentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.top.equalTo(@15);
    }];
    
//    //底部
//    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 190, kScreenWidth, 30)];
//    
//    [self addSubview:bottomView];
//    //topLine
//    UIView *topLine = [[UIView alloc] init];
//    
//    topLine.backgroundColor = kLineColor;
//    
//    [bottomView addSubview:topLine];
//    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.right.top.equalTo(@0);
//        make.height.equalTo(@0.5);
//        
//    }];
//    //箭头
//    UIButton *arrowBtn = [UIButton buttonWithImageName:@"更多-灰色"];
//    [arrowBtn addTarget:self action:@selector(clickArrow) forControlEvents:UIControlEventTouchUpInside];
//    [bottomView addSubview:arrowBtn];
//    [arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.right.equalTo(@0);
//        make.width.height.equalTo(@30);
//        make.centerY.equalTo(@0);
//    }];
}

- (DetailWebView *)trendView {
    
    if (!_trendView) {
        
        BaseWeakSelf;
        
        _trendView = [[DetailWebView alloc] initWithFrame:CGRectMake(0, 35, kScreenWidth, 155)];
        
        _trendView.webViewBlock = ^(CGFloat height) {
            
            [weakSelf setSubViewLayoutWithHeight:height];
        };
        [self addSubview:_trendView];
    }
    return _trendView;
}

/**
 调整视图高度
 */
- (void)setSubViewLayoutWithHeight:(CGFloat)height {
    
    
}

#pragma mark - Events
- (void)clickArrow {
    
    if (self.arrowEventBlock) {
        
        self.arrowEventBlock();
    }
}

#pragma mark - Setting
- (void)setPlatform:(PlatformModel *)platform {
    
    _platform = platform;
    //一天涨跌幅
    NSString *oneDayPercent = [platform getResultWithPercent:platform.percentChange24h];
    NSString *oneDay = [NSString stringWithFormat:@"1天: %@", oneDayPercent];
    UIColor *oneDayPercentColor = [platform getPercentColorWithPercent:platform.percentChange24h];
    [self.oneDayPercentLbl labelWithString:oneDay
                                     title:oneDayPercent
                                      font:Font(11.0)
                                     color:oneDayPercentColor];
    //一周涨跌幅
    NSString *oneWeekPercent = [platform getResultWithPercent:platform.percentChange7d];
    NSString *oneWeek = [NSString stringWithFormat:@"1周: %@", oneWeekPercent];
    UIColor *oneWeekPercentColor = [platform getPercentColorWithPercent:platform.percentChange7d];
    [self.oneWeekPercentLbl labelWithString:oneWeek
                                     title:oneWeekPercent
                                      font:Font(11.0)
                                     color:oneWeekPercentColor];
    //一月涨跌幅
    NSString *oneMonthPercent = [platform getResultWithPercent:platform.percentChange1m];
    NSString *oneMonth = [NSString stringWithFormat:@"1月: %@", oneMonthPercent];
    UIColor *oneMonthPercentColor = [platform getPercentColorWithPercent:platform.percentChange1m];
    [self.oneMonthPercentLbl labelWithString:oneMonth
                                     title:oneMonthPercent
                                      font:Font(11.0)
                                     color:oneMonthPercentColor];
    //趋势图
    //交易对
    NSString *symbol = [NSString stringWithFormat:@"%@/%@", platform.symbol, platform.toSymbol];
    
    
    TLNetworking *http1 = [TLNetworking new];
    
    http1.code = @"628917";
    http1.parameters[@"ckey"] = @"h5Url";
    
    [http1 postWithSuccess:^(id responseObject) {
        
        NSString *shareUrl = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"cvalue"]];
        NSString *symbol = [NSString stringWithFormat:@"%@/%@", platform.symbol, platform.toSymbol];
        //        NSString *html = [NSString stringWithFormat:@"%@/charts/index.html?symbol=%@&exchange=%@",shareUrl, symbol, platform.exchangeEname];
        
        NSString *html = [NSString stringWithFormat:@"%@/charts/marketLine.html?symbol=%@&exchange=%@&period=60min",shareUrl, symbol, platform.exchangeEname];
        NSLog(@"html = %@", html);
        
        [self.trendView loadRequestWithString:html];
        
//        NSString *html = [NSString stringWithFormat:@"%@/index.html?symbol=%@&exchange=%@&isfull=1",shareUrl, symbol, platform.exchangeEname];
//
//        //        [self.kLineView loadRequestWithString:html];
//
//
//
//
//        [self.kLineView loadRequestWithString:html];
        
    } failure:^(NSError *error) {
        NSLog(@"error");
    }];
    
}

@end
