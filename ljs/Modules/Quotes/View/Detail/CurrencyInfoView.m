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
@property (nonatomic, strong) UILabel *rmbPriceLbl1;

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
//涨跌情况
@property (nonatomic, strong) UIButton *priceFluctBtn1;
//最高价
@property (nonatomic, strong) UILabel *highPriceLbl1;
//最低价
@property (nonatomic, strong) UILabel *lowPriceLbl1;
//开盘
@property (nonatomic, strong) UILabel *startPriceLbl1;
//额
@property (nonatomic, strong) UILabel *tradeVolumeLbl1;
//收
@property (nonatomic, strong) UILabel *endPriceLbl1;
//市值
@property (nonatomic, strong) UILabel *marketVolumeLbl1;
//关注量
@property (nonatomic, strong) UILabel *followNumLbl1;
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
                                                textColor:kAppCustomMainColor
                                                     font:11.0];
    [self addSubview:self.followNumLbl];
    self.followNumLbl1 = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kAppCustomMainColor
                                                     font:11.0];
    [self addSubview:self.followNumLbl1];
    //高
    self.highPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kTextColor
                                                     font:11.0];
    [self addSubview:self.highPriceLbl];
    self.highPriceLbl1 = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kAppCustomMainColor
                                                     font:11.0];
    [self addSubview:self.highPriceLbl1];
    //低
    self.lowPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kTextColor
                                                     font:11.0];
    [self addSubview:self.lowPriceLbl];
    self.lowPriceLbl1 = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kAppCustomMainColor
                                                    font:11.0];
    [self addSubview:self.lowPriceLbl1];
    //开
    self.startPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kTextColor
                                                     font:11.0];
    [self addSubview:self.startPriceLbl];
    self.startPriceLbl1 = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kAppCustomMainColor
                                                      font:11.0];
    [self addSubview:self.startPriceLbl1];
    //额
    self.tradeVolumeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kTextColor
                                                       font:11.0];
    
    [self addSubview:self.tradeVolumeLbl];
    self.tradeVolumeLbl1 = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kAppCustomMainColor
                                                       font:11.0];
    
    [self addSubview:self.tradeVolumeLbl1];
    //收
    self.endPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kTextColor
                                                       font:11.0];
    
    [self addSubview:self.endPriceLbl];
    self.endPriceLbl1 = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kAppCustomMainColor
                                                    font:11.0];
    
    [self addSubview:self.endPriceLbl1];
    //市值
    self.marketVolumeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:11.0];
    
    [self addSubview:self.marketVolumeLbl];
    self.marketVolumeLbl1 = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kAppCustomMainColor
                                                        font:11.0];
    
    [self addSubview:self.marketVolumeLbl1];
    
   
    //行情数据
    CGFloat btnW = kScreenWidth/2.0;
    
    UIButton *quotesDataBtn = [UIButton buttonWithImageName:@""];
    
#warning 禁止点击详情数据
//    [quotesDataBtn addTarget:self action:@selector(lookQuotesData) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:quotesDataBtn];
//    [quotesDataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(@(btnW));
//        make.top.equalTo(@0);
//        make.width.equalTo(@(btnW));
//        make.height.equalTo(@(self.height));
//    }];
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    CGFloat lblW = kScreenWidth/2.0;
    
    //rmb价格
    [self.rmbPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@12);
        make.left.equalTo(@15);
        
        
    }];
    
  
    
    //币种名称
    [self.currencyNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.rmbPriceLbl.mas_left);
        make.top.equalTo(self.rmbPriceLbl.mas_bottom).offset(5);
        
//        make.top.equalTo(@12);
//        make.left.equalTo(@15);
    }];
    //涨跌情况

    [self.priceFluctBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.currencyNameLbl.mas_right).offset(10);
        make.centerY.equalTo(self.currencyNameLbl.mas_centerY);
    }];
   
    //关注
    [self.followNumLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.currencyNameLbl.mas_left);
        make.top.equalTo(self.currencyNameLbl.mas_bottom).offset(5);
    }];
   
    [self.followNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.followNumLbl1.mas_right).offset(2);
        make.top.equalTo(self.currencyNameLbl.mas_bottom).offset(5);
    }];
    //高
    [self.highPriceLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@15);
        make.left.equalTo(@(lblW));
    }];
    
    [self.highPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@15);
        make.left.equalTo(self.highPriceLbl1.mas_right).offset(2);
    }];
    //低
    
    [self.lowPriceLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@15);
        make.left.equalTo(self.mas_right).offset(-kWidth(85));
    }];
   

    [self.lowPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@15);
        make.left.equalTo(self.lowPriceLbl1.mas_right).offset(2);
    }];
    //开
    [self.startPriceLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.highPriceLbl.mas_bottom).offset(13);
        make.left.equalTo(self.highPriceLbl1.mas_left);
    }];
 
    [self.startPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.highPriceLbl.mas_bottom).offset(13);
        make.left.equalTo(self.startPriceLbl1.mas_right).offset(2);
    }];
    //额
    [self.tradeVolumeLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lowPriceLbl.mas_bottom).offset(13);
        make.left.equalTo(self.lowPriceLbl1.mas_left);
    }];
   
    [self.tradeVolumeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lowPriceLbl.mas_bottom).offset(13);
        make.left.equalTo(self.tradeVolumeLbl1.mas_right).offset(2);
    }];
    //收
    [self.endPriceLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.startPriceLbl.mas_bottom).offset(13);
        make.left.equalTo(self.highPriceLbl1.mas_left);
    }];
  
    [self.endPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.startPriceLbl.mas_bottom).offset(13);
        make.left.equalTo(self.endPriceLbl1.mas_right).offset(2);
    }];
    //市值
  
    [self.marketVolumeLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.tradeVolumeLbl.mas_bottom).offset(13);
        make.left.equalTo(self.lowPriceLbl1.mas_left);
    }];
 
    [self.marketVolumeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.tradeVolumeLbl.mas_bottom).offset(13);
        make.left.equalTo(self.marketVolumeLbl1.mas_right).offset(2);
    }];
}

#pragma mark - Setting
- (void)setPlatform:(PlatformModel *)platform {
    
    _platform = platform;
    //币种名称
    self.currencyNameLbl.text = [NSString stringWithFormat:@"%.6f", [platform.priceChange doubleValue]];
    self.currencyNameLbl.textColor = platform.bgColor;
    //当前人民币价格
    self.rmbPriceLbl.textColor = platform.bgColor;
    self.rmbPriceLbl.text = [NSString stringWithFormat:@"￥%.2lf", [platform.lastCnyPrice doubleValue]];
    self.followNumLbl1.text = @"量:";
    self.followNumLbl1.textColor = kBullowColor;
    self.highPriceLbl1.text = @"高:";
    self.highPriceLbl1.textColor = kBullowColor;
    self.lowPriceLbl1.text = @"低:";
    self.lowPriceLbl1.textColor = kBullowColor;
    self.startPriceLbl1.text = @"开:";
    self.startPriceLbl1.textColor = kBullowColor;
    self.tradeVolumeLbl1.text = @"收:";
    self.tradeVolumeLbl1.textColor = kBullowColor;
    self.endPriceLbl1.text = @"买:";
    self.endPriceLbl1.textColor = kBullowColor;
    self.marketVolumeLbl1.text = @"卖:";
    self.marketVolumeLbl1.textColor = kBullowColor;
    //涨跌情况
    NSString *priceFluctStr = platform.changeRate;
    CGFloat fluct = [priceFluctStr doubleValue];
    
    if (fluct > 0) {
        priceFluctStr = [NSString stringWithFormat:@"+%@%%", priceFluctStr];
        
    } else  {
        
        priceFluctStr = [NSString stringWithFormat:@"%@%%", priceFluctStr];
    }
    self.backgroundColor = kAppCustomMainColor;

    [self.priceFluctBtn setTitle:priceFluctStr forState:UIControlStateNormal];
    [self.priceFluctBtn setTitleColor:platform.bgColor forState:UIControlStateNormal];
    //关注量
    self.followNumLbl.text = [NSString stringWithFormat:@"%@", [platform.volume convertToRealMoneyWithNum:8]];
    self.followNumLbl.textColor = [UIColor whiteColor];
    //最高价
    self.highPriceLbl.text = [NSString stringWithFormat:@"%@", [platform.high convertToRealMoneyWithNum:8]];
    self.highPriceLbl.textColor = [UIColor whiteColor];
    //最低价
    self.lowPriceLbl.text = [NSString stringWithFormat:@"%@", [platform.low convertToRealMoneyWithNum:8]];
    self.lowPriceLbl.textColor = [UIColor whiteColor];
    //开盘
    self.startPriceLbl.text = [NSString stringWithFormat:@"%.2f", [platform.open floatValue]];
    self.startPriceLbl.textColor = [UIColor whiteColor];
    //额
//    NSString *volumeStr = platform.tradeVolume;
    self.tradeVolumeLbl.text = /*[NSString stringWithFormat:@"额:%@", volumeStr];*/[NSString stringWithFormat:@"%.2f", [platform.close floatValue]];
    self.tradeVolumeLbl.textColor = [UIColor whiteColor];
    //收
    self.endPriceLbl.text = /*[NSString stringWithFormat:@"收:%@", [platform.close convertToRealMoneyWithNum:8]];*/[NSString stringWithFormat:@"%.2f", [platform.bidPrice floatValue]];
    self.endPriceLbl.textColor = [UIColor whiteColor];
    //市值
    self.marketVolumeLbl.text = /*[NSString stringWithFormat:@"市值:%@", [platform getNumWithVolume:platform.totalMarketCapCny]];*/[NSString stringWithFormat:@"%.2f", [platform.askPrice floatValue]];
    self.marketVolumeLbl.textColor = [UIColor whiteColor];
}
- (void)changeMoney:(NSString *)str
{
    self.rmbPriceLbl.text = str;
}
- (void)cahngeColorWithAnalysis
{
    self.backgroundColor = kWhiteColor;
    //币种名称
    
    self.currencyNameLbl.textColor = kTextColor;
    
    [self addSubview:self.currencyNameLbl];
    //当前人民币价格
    self.rmbPriceLbl.textColor = kThemeColor;
    
    //涨跌情况
    
    [self.priceFluctBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    
    //关注量
    self.followNumLbl.textColor = kTextColor2;
    

    //高
    self.highPriceLbl.textColor = kTextColor;
    
    
    //低
    self.lowPriceLbl.textColor = kTextColor;
    
    //开
    self.startPriceLbl.textColor = kTextColor;
    
    //额
    self.tradeVolumeLbl.textColor = kTextColor;
    
    //收
    self.endPriceLbl.textColor = kTextColor;
    
    //市值
    self.marketVolumeLbl.textColor = kTextColor;
    
    
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
