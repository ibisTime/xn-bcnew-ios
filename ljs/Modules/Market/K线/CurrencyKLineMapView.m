//
//  CurrencyKLineMapView.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyKLineMapView.h"

//Manager
#import "AppConfig.h"
//Category
#import "UILabel+Extension.h"
//V
#import "DetailWebView.h"
#import "TLNetworking.h"
#import "APICodeMacro.h"

@interface CurrencyKLineMapView()

//K线图
@property (nonatomic, strong) DetailWebView *kLineView;

@end

@implementation CurrencyKLineMapView

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
    //横屏
    UIButton *hScreenBtn = [UIButton buttonWithImageName:@""];
    
    [hScreenBtn addTarget:self action:@selector(clickHorizontal) forControlEvents:UIControlEventTouchUpInside];
    [self.kLineView addSubview:hScreenBtn];
    [hScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@0);
        make.right.equalTo(@(-10));
        make.width.equalTo(@32);
        make.height.equalTo(@35);
    }];
}

- (DetailWebView *)kLineView {
    
    if (!_kLineView) {
        
        BaseWeakSelf;
        
        _kLineView = [[DetailWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.height)];
        
        _kLineView.webViewBlock = ^(CGFloat height) {
            
            [weakSelf setSubViewLayoutWithHeight:height];
        };
        
        [self addSubview:_kLineView];
    }
    return _kLineView;
}

/**
 调整视图高度
 */
- (void)setSubViewLayoutWithHeight:(CGFloat)height {
    
    
}

#pragma mark - Setting

/**
 点击横屏
 */
- (void)clickHorizontal {
    
    if (self.horizontalScreenBlock) {
        
        self.horizontalScreenBlock();
    }
}

#pragma mark - Setting
- (void)setPlatform:(PlatformModel *)platform {
    
    _platform = platform;
    
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = USER_CKEY_CVALUE;
    http.parameters[@"ckey"] = @"h5Url";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *shareUrl = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"cvalue"]];
        NSString *symbol = [NSString stringWithFormat:@"%@/%@", platform.symbol, platform.toSymbol];
        NSString *html = [NSString stringWithFormat:@"%@/charts/index.html?symbol=%@&exchange=%@",shareUrl, symbol, platform.exchangeEname];
        
        [self.kLineView loadRequestWithString:html];
        
    } failure:^(NSError *error) {
        NSLog(@"error");
    }];
    
    //k线图
    //交易对
    
}
- (void)reloadWeb
{
    [self.kLineView.webView reload];
}

@end
