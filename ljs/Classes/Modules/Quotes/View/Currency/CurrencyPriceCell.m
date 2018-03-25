//
//  CurrencyPriceCell.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyPriceCell.h"
//Category
#import "UILabel+Extension.h"
#import "NSString+CGSize.h"
#import "NSNumber+Extension.h"

@interface CurrencyPriceCell()
//币种名称
@property (nonnull, strong) UILabel *currencyNameLbl;
//当前人民币价格
@property (nonatomic, strong) UILabel *rmbPriceLbl;
//涨跌情况
@property (nonatomic, strong) UIButton *priceFluctBtn;
//总流通量
@property (nonatomic, strong) UILabel *allVolumeLbl;
//24h流通量
@property (nonatomic, strong) UILabel *oneDayVolumeLbl;

@end

@implementation CurrencyPriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //币种名称
    self.currencyNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor
                                                        font:17.0];
    
    [self addSubview:self.currencyNameLbl];
    //总流通量
    self.allVolumeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor2
                                                        font:15.0];
    
    [self addSubview:self.allVolumeLbl];
    //24h流通量
    self.oneDayVolumeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kTextColor2
                                                       font:11.0];
    
    [self addSubview:self.oneDayVolumeLbl];
    //涨跌情况
    self.priceFluctBtn = [UIButton buttonWithTitle:@""
                                        titleColor:kWhiteColor
                                   backgroundColor:kClearColor
                                         titleFont:15.0 cornerRadius:5];
    
    [self addSubview:self.priceFluctBtn];
    //当前人民币价格
    self.rmbPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:17.0];
    
    [self addSubview:self.rmbPriceLbl];
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    //
    //币种名称
    [self.currencyNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.centerY.equalTo(@0);
        make.left.equalTo(@15);
        make.top.equalTo(@10);
    }];
    
    //总流通量
//    [self.allVolumeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.bottom.equalTo(self.currencyNameLbl.mas_top).offset(-5);
//        make.left.equalTo(self.currencyNameLbl.mas_left);
//    }];
    //一日流通量
    [self.oneDayVolumeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.currencyNameLbl.mas_bottom).offset(5);
        make.left.equalTo(self.currencyNameLbl.mas_left);
    }];
    //涨幅
    [self.priceFluctBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.centerY.equalTo(@0);
        make.height.equalTo(@37);
    }];
    //rmb价格
    [self.rmbPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.priceFluctBtn.mas_left).offset(-15);
        make.centerY.equalTo(@0);
    }];
   
}

#pragma mark - Setting
- (void)setCurrency:(CurrencyPriceModel *)currency {
    
    _currency = currency;
    
    //币种名称
    self.currencyNameLbl.text = currency.symbol;
    //总交易量
//    self.allVolumeLbl.text = [NSString stringWithFormat:@"流通量/额 %@/%@", currency.all_volume,currency.all_volume_cny];
    //一日交易量
//    self.oneDayVolumeLbl.text = [NSString stringWithFormat:@"24H量/额 %@/%@", currency.one_day_volume,currency.one_day_volume_cny];
    self.oneDayVolumeLbl.text = [NSString stringWithFormat:@"24H量 %@", currency.h24VolumeCny];
    //人民币价格
    
    NSString *priceCny = [@([currency.priceCny doubleValue]) convertToRealMoneyWithNum:4];
    
    self.rmbPriceLbl.text = [NSString stringWithFormat:@"￥%@", priceCny];
    self.rmbPriceLbl.textColor = currency.bgColor;
    
    //涨跌情况
    NSString *priceFluctStr = currency.percentChange24h;
    CGFloat fluct = [priceFluctStr doubleValue];
    
    if (fluct > 0) {
        
        priceFluctStr = [NSString stringWithFormat:@"+%@%%", priceFluctStr];
        
    } else  {
        
        priceFluctStr = [NSString stringWithFormat:@"%@%%", priceFluctStr];
    }
    
    [self.priceFluctBtn setTitle:priceFluctStr forState:UIControlStateNormal];
    [self.priceFluctBtn setBackgroundColor:currency.bgColor forState:UIControlStateNormal];
    
    CGFloat btnW = [NSString getWidthWithString:priceFluctStr font:16.0] + 15;
    [self.priceFluctBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(btnW > 75 ? btnW: 75));
    }];
    
}

@end
