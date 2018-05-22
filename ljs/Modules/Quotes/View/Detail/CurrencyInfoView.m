//
//  CurrencyInfoView.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyInfoView.h"
//Category
#import "NSNumber+Extension.h"
//V
#import "QuotesDataView.h"

@interface CurrencyInfoView()
//币种名称
@property (nonatomic, strong) UILabel *currencyNameLbl;
//当前人民币价格
@property (nonatomic, strong) UILabel *rmbPriceLbl;
//涨跌情况
@property (nonatomic, strong) UIButton *priceFluctBtn;
//最高价
@property (nonatomic, strong) UILabel *highPriceLbl;
//最低价
@property (nonatomic, strong) UILabel *lowPriceLbl;
//开盘
@property (nonatomic, strong) UILabel *startPriceLbl;
//额
@property (nonatomic, strong) UILabel *tradeVolumeLbl;
//收
@property (nonatomic, strong) UILabel *endPriceLbl;
//市值
@property (nonatomic, strong) UILabel *marketVolumeLbl;
//关注量
@property (nonatomic, strong) UILabel *followNumLbl;
//行情数据
@property (nonatomic, strong) QuotesDataView *dataView;

@end

@implementation CurrencyInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

#pragma mark - Init
- (QuotesDataView *)dataView {
    
    if (!_dataView) {
        
        _dataView = [[QuotesDataView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _dataView;
}

- (void)initSubviews {
    
    self.backgroundColor = kWhiteColor;
    //币种名称
    self.currencyNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor
                                                        font:14.0];
    
    [self addSubview:self.currencyNameLbl];
    //当前人民币价格
    self.rmbPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kThemeColor
                                                    font:20.0];
    
    [self addSubview:self.rmbPriceLbl];
    //涨跌情况
    self.priceFluctBtn = [UIButton buttonWithTitle:@""
                                        titleColor:kWhiteColor
                                   backgroundColor:kClearColor
                                         titleFont:11.0 cornerRadius:5];
    
    [self addSubview:self.priceFluctBtn];
    //关注量
    self.followNumLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kTextColor2
                                                     font:11.0];
    [self addSubview:self.followNumLbl];
    //高
    self.highPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kTextColor
                                                     font:11.0];
    [self addSubview:self.highPriceLbl];
    //低
    self.lowPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kTextColor
                                                     font:11.0];
    [self addSubview:self.lowPriceLbl];
    //开
    self.startPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kTextColor
                                                     font:11.0];
    [self addSubview:self.startPriceLbl];
    //额
    self.tradeVolumeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kTextColor
                                                       font:11.0];
    
    [self addSubview:self.tradeVolumeLbl];
    //收
    self.endPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kTextColor
                                                       font:11.0];
    
    [self addSubview:self.endPriceLbl];
    //市值
    self.marketVolumeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:11.0];
    
    [self addSubview:self.marketVolumeLbl];
    //行情数据
    CGFloat btnW = kScreenWidth/2.0;
    
    UIButton *quotesDataBtn = [UIButton buttonWithImageName:@""];
    
    [quotesDataBtn addTarget:self action:@selector(lookQuotesData) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:quotesDataBtn];
    [quotesDataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@(btnW));
        make.top.equalTo(@0);
        make.width.equalTo(@(btnW));
        make.height.equalTo(@(self.height));
    }];
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    CGFloat lblW = kScreenWidth/2.0;
    //币种名称
    [self.currencyNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@12);
        make.left.equalTo(@15);
    }];
    //rmb价格
    [self.rmbPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.currencyNameLbl.mas_left).offset(-5);
        make.top.equalTo(self.currencyNameLbl.mas_bottom).offset(5);
    }];
    //涨跌情况
    [self.priceFluctBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.rmbPriceLbl.mas_right).offset(10);
        make.centerY.equalTo(self.rmbPriceLbl.mas_centerY);
    }];
    //关注
    [self.followNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.currencyNameLbl.mas_left);
        make.top.equalTo(self.rmbPriceLbl.mas_bottom).offset(5);
    }];
    //高
    [self.highPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@15);
        make.left.equalTo(@(lblW));
    }];
    //低
    [self.lowPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@15);
        make.left.equalTo(self.mas_right).offset(-kWidth(85));
    }];
    //开
    [self.startPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.highPriceLbl.mas_bottom).offset(13);
        make.left.equalTo(self.highPriceLbl.mas_left);
    }];
    //额
    [self.tradeVolumeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lowPriceLbl.mas_bottom).offset(13);
        make.left.equalTo(self.lowPriceLbl.mas_left);
    }];
    //收
    [self.endPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.startPriceLbl.mas_bottom).offset(13);
        make.left.equalTo(self.highPriceLbl.mas_left);
    }];
    //市值
    [self.marketVolumeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.tradeVolumeLbl.mas_bottom).offset(13);
        make.left.equalTo(self.lowPriceLbl.mas_left);
    }];
}

#pragma mark - Setting
- (void)setPlatform:(PlatformModel *)platform {
    
    _platform = platform;
    //币种名称
    self.currencyNameLbl.text = [platform.symbol uppercaseString];
    self.currencyNameLbl.textColor = [UIColor whiteColor];
    //当前人民币价格
    self.rmbPriceLbl.textColor = [UIColor whiteColor];
    self.rmbPriceLbl.text = [NSString stringWithFormat:@"￥%.2lf", [platform.lastCnyPrice doubleValue]];
    //涨跌情况
    NSString *priceFluctStr = platform.changeRate;
    CGFloat fluct = [priceFluctStr doubleValue];
    
    if (fluct > 0) {
        priceFluctStr = [NSString stringWithFormat:@"+%@%%", priceFluctStr];
        
    } else  {
        
        priceFluctStr = [NSString stringWithFormat:@"%@%%", priceFluctStr];
    }
    self.backgroundColor = _platform.bgColor;

    [self.priceFluctBtn setTitle:priceFluctStr forState:UIControlStateNormal];
    [self.priceFluctBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //关注量
    self.followNumLbl.text = [NSString stringWithFormat:@"量:%@", [platform.amount convertToRealMoneyWithNum:8]];
    self.followNumLbl.textColor = [UIColor whiteColor];
    //最高价
    self.highPriceLbl.text = [NSString stringWithFormat:@"高:%@", [platform.high convertToRealMoneyWithNum:8]];
    self.highPriceLbl.textColor = [UIColor whiteColor];
    //最低价
    self.lowPriceLbl.text = [NSString stringWithFormat:@"低:%@", [platform.low convertToRealMoneyWithNum:8]];
    self.lowPriceLbl.textColor = [UIColor whiteColor];
    //开盘
    self.startPriceLbl.text = [NSString stringWithFormat:@"开:%@", [platform.open convertToRealMoneyWithNum:8]];
    self.startPriceLbl.textColor = [UIColor whiteColor];
    //额
//    NSString *volumeStr = platform.tradeVolume;
    self.tradeVolumeLbl.text = /*[NSString stringWithFormat:@"额:%@", volumeStr];*/[NSString stringWithFormat:@"收:%@", [platform.close convertToRealMoneyWithNum:8]];
    self.tradeVolumeLbl.textColor = [UIColor whiteColor];
    //收
    self.endPriceLbl.text = /*[NSString stringWithFormat:@"收:%@", [platform.close convertToRealMoneyWithNum:8]];*/[NSString stringWithFormat:@"买:%@", platform.bidPrice];
    self.endPriceLbl.textColor = [UIColor whiteColor];
    //市值
    self.marketVolumeLbl.text = /*[NSString stringWithFormat:@"市值:%@", [platform getNumWithVolume:platform.totalMarketCapCny]];*/[NSString stringWithFormat:@"卖:%@", platform.askPrice];
    self.marketVolumeLbl.textColor = [UIColor whiteColor];
}

#pragma mark - Events

/**
 查看行情数据
 */
- (void)lookQuotesData {
    
    self.dataView.platform = self.platform;
    [self.dataView show];
}

@end
