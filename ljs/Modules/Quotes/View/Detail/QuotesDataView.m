//
//  QuotesDataView.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "QuotesDataView.h"
//Category
#import "NSNumber+Extension.h"
#import "UILabel+Extension.h"

#define kBgViewHeight  210

@interface QuotesDataView()

//背景
@property (nonatomic, strong) UIView *bgView;
//总市值
@property (nonatomic, strong) UILabel *marketVolumeLbl;
//总流通量
@property (nonatomic, strong) UILabel *tradeVolumeLbl;
//开盘价
@property (nonatomic, strong) UILabel *startPriceLbl;
//收
@property (nonatomic, strong) UILabel *endPriceLbl;
//最高价
@property (nonatomic, strong) UILabel *highPriceLbl;
//最低价
@property (nonatomic, strong) UILabel *lowPriceLbl;
//涨跌情况
@property (nonatomic, strong) UILabel *priceFluctLbl;
//当前人民币价格
@property (nonatomic, strong) UILabel *rmbPriceLbl;

@end

@implementation QuotesDataView

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
    
    self.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.7];

    //背景
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(15, kScreenHeight, kScreenWidth - 30, kBgViewHeight)];
    
    self.bgView.center = CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0);
    self.bgView.backgroundColor = kWhiteColor;
    self.bgView.layer.cornerRadius = 10;
    self.bgView.clipsToBounds = YES;
    
    [self addSubview:self.bgView];
    //行情数据
    UILabel *textLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:15.0];
    
    textLbl.text = @"行情数据";
    
    [self.bgView addSubview:textLbl];
    [textLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(@0);
        make.top.equalTo(@25);
    }];
    //市值
    self.marketVolumeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor2
                                                        font:12.0];
    
    [self.bgView addSubview:self.marketVolumeLbl];
    //额
    self.tradeVolumeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kTextColor2
                                                       font:12.0];
    
    [self.bgView addSubview:self.tradeVolumeLbl];
    //开
    self.startPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kTextColor2
                                                      font:12.0];
    [self.bgView addSubview:self.startPriceLbl];
    //收
    self.endPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor2
                                                    font:12.0];
    
    [self.bgView addSubview:self.endPriceLbl];
    //高
    self.highPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kTextColor2
                                                     font:12.0];
    [self.bgView addSubview:self.highPriceLbl];
    //低
    self.lowPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor2
                                                    font:12.0];
    [self.bgView addSubview:self.lowPriceLbl];
    //涨跌情况
    self.priceFluctLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                 textColor:kTextColor2
                                                      font:12.0];
    [self.bgView addSubview:self.priceFluctLbl];
    //当前人民币价格
    self.rmbPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor2
                                                    font:12.0];
    
    [self.bgView addSubview:self.rmbPriceLbl];
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    //市值
    [self.marketVolumeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@60);
        make.left.equalTo(@15);
    }];
    //额
    [self.tradeVolumeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@60);
        make.left.equalTo(self.bgView.mas_centerX).offset(15);
    }];
    //开
    [self.startPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.marketVolumeLbl.mas_bottom).offset(13);
        make.left.equalTo(self.marketVolumeLbl.mas_left);
    }];
    //收
    [self.endPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.tradeVolumeLbl.mas_bottom).offset(13);
        make.left.equalTo(self.tradeVolumeLbl.mas_left);
    }];
    //高
    [self.highPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.startPriceLbl.mas_bottom).offset(13);
        make.left.equalTo(self.marketVolumeLbl.mas_left);
    }];
    //低
    [self.lowPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.endPriceLbl.mas_bottom).offset(13);
        make.left.equalTo(self.tradeVolumeLbl.mas_left);
    }];
    //涨跌幅
    [self.priceFluctLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.highPriceLbl.mas_bottom).offset(13);
        make.left.equalTo(self.marketVolumeLbl.mas_left);
    }];
    //rmb价格
    [self.rmbPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lowPriceLbl.mas_bottom).offset(13);
        make.left.equalTo(self.tradeVolumeLbl.mas_left);
    }];

}

#pragma mark - Data
- (void)setPlatform:(PlatformModel *)platform {
    
    _platform = platform;
    //总市值
    NSString *marketVolume = [NSString stringWithFormat:@"总市值  %@", [platform getNumWithVolume:platform.totalMarketCapCny]];
    
    [self.marketVolumeLbl labelWithString:marketVolume
                                    title:[platform getNumWithVolume:platform.totalMarketCapCny]
                                     font:Font(13.0)
                                    color:kTextColor];
    //额
    NSString *volumeStr = [platform getNumWithVolume:@([platform.coin.totalSupply doubleValue])];
    
    [self.tradeVolumeLbl labelWithString:[NSString stringWithFormat:@"总流通  %@", volumeStr]
                                   title:volumeStr
                                    font:Font(13.0)
                                   color:kTextColor];
    //开盘
    NSString *open = [NSString stringWithFormat:@"开盘价  %@", [platform.open convertToRealMoneyWithNum:8]];
    [self.startPriceLbl labelWithString:open
                                   title:[platform.open convertToRealMoneyWithNum:8]
                                    font:Font(13.0)
                                   color:kTextColor];
    //收
    NSString *close = [NSString stringWithFormat:@"昨收价  %@", [platform.close convertToRealMoneyWithNum:8]];
    [self.endPriceLbl labelWithString:close
                                  title:[platform.close convertToRealMoneyWithNum:8]
                                   font:Font(13.0)
                                  color:kTextColor];
    //最高价
    NSString *high = [NSString stringWithFormat:@"最高价  %@", [platform.high convertToRealMoneyWithNum:8]];
    [self.highPriceLbl labelWithString:high
                                  title:[platform.high convertToRealMoneyWithNum:8]
                                   font:Font(13.0)
                                  color:kTextColor];
    //最低价
    NSString *low = [NSString stringWithFormat:@"最低价  %@", [platform.low convertToRealMoneyWithNum:8]];
    [self.lowPriceLbl labelWithString:low
                                  title:[platform.low convertToRealMoneyWithNum:8]
                                   font:Font(13.0)
                                  color:kTextColor];
    //涨跌情况
    NSString *priceFluctStr = platform.changeRate;
    CGFloat fluct = [priceFluctStr doubleValue];
    
    if (fluct > 0) {
        
        priceFluctStr = [NSString stringWithFormat:@"+%@%%", priceFluctStr];
        
    } else  {
        
        priceFluctStr = [NSString stringWithFormat:@"%@%%", priceFluctStr];
    }
    
    [self.priceFluctLbl labelWithString:[NSString stringWithFormat:@"涨跌幅  %@", priceFluctStr]
                                  title:priceFluctStr
                                   font:Font(13.0)
                                  color:platform.bgColor];
    //当前人民币价格
    NSString *lastCnyPrice = [NSString stringWithFormat:@"现价格  ￥%.2lf", [platform.lastCnyPrice doubleValue]];
    [self.rmbPriceLbl labelWithString:lastCnyPrice
                                  title:[NSString stringWithFormat:@"￥%.2lf", [platform.lastCnyPrice doubleValue]]
                                   font:Font(13.0)
                                  color:kTextColor];
    
}

#pragma mark - Events

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hide {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self hide];
}


@end
