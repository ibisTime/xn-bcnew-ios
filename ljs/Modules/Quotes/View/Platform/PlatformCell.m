//
//  PlatformCell.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PlatformCell.h"
//Category
#import "UILabel+Extension.h"
#import "NSString+CGSize.h"
#import "NSString+Extension.h"
#import "NSNumber+Extension.h"
@interface PlatformCell()
//币种名称
@property (nonnull, strong) UILabel *currencyNameLbl;
//24H交易量
@property (nonatomic, strong) UILabel *tradeVolumeLbl;
//当前对应币种
@property (nonatomic, strong) UILabel *opppsitePriceLbl;
//当前人民币价格
@property (nonatomic, strong) UILabel *rmbPriceLbl;
//涨跌情况
@property (nonatomic, strong) UIButton *priceFluctBtn;
@property (nonatomic, strong) UIImageView *presentImage;

@end

@implementation PlatformCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //币种名称
    self.presentImage = [[UIImageView alloc] init];
    self.presentImage.image =[UIImage imageNamed:@"闹钟"];
    [self addSubview:self.presentImage];
    
    self.currencyNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kTextColor
                                                       font:17.0];
    [self addSubview:self.currencyNameLbl];
    //24H交易量
    self.tradeVolumeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kTextColor2
                                                       font:15.0];
    
    [self addSubview:self.tradeVolumeLbl];
    //涨跌情况
    self.priceFluctBtn = [UIButton buttonWithTitle:@""
                                        titleColor:kWhiteColor
                                   backgroundColor:kClearColor
                                         titleFont:17.0 cornerRadius:5];
    
    [self addSubview:self.priceFluctBtn];
    
    //当前对应币种价格
    self.opppsitePriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                    textColor:kHexColor(@"#595A6E")
                                                         font:12.0];
    
    [self addSubview:self.opppsitePriceLbl];
    
    //当前人民币价格
    self.rmbPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:15.0];
    
    [self addSubview:self.rmbPriceLbl];
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    [self.presentImage mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(@10);
        make.left.equalTo(@10);
        make.width.equalTo(@15);
        make.height.equalTo(@15);

    }];
    //币种名称
    [self.currencyNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@10);
        make.left.equalTo(self.presentImage.mas_right).offset(10);
//        make.left.equalTo(@30);

    }];
    //一日交易量
    [self.tradeVolumeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.currencyNameLbl.mas_bottom).offset(10);
        make.left.equalTo(@10);
        
    }];
    //涨幅
    [self.priceFluctBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-10));
        make.centerY.equalTo(@0);
        make.height.equalTo(@37);
    }];
    //rmb价格
    [self.rmbPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.priceFluctBtn.mas_left).offset(-15);
        make.top.equalTo(self.currencyNameLbl.mas_top);
    }];
    //对应币种
    [self.opppsitePriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.priceFluctBtn.mas_left).offset(-15);
        make.top.equalTo(self.tradeVolumeLbl.mas_top);
    }];
    
}

#pragma mark - Setting
- (void)setPlatform:(PlatformModel *)platform {
    _platform = platform;
    
    
//    platform.bgColor = kThemeColor;
    //币种名称
    self.currencyNameLbl.text = [platform.symbol uppercaseString];
    self.presentImage.hidden = [platform.isWarn isEqualToString:@"0"];
    if (self.currencyNameLbl.frame.origin.x <= self.presentImage.frame.origin.x) {
        
        if ([platform.isWarn isEqualToString:@"0"]) {
            [self.currencyNameLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@10);
                make.left.equalTo(@10);
            }];
        }else{
            [self.currencyNameLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@10);
                make.left.equalTo(self.presentImage.mas_right).offset(10);
            }];
        }
    }else
    {
        if ([platform.isWarn isEqualToString:@"0"]) {
            [self.currencyNameLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@10);
                make.left.equalTo(@10);
            }];
        }
    }

    //一日交易量
    NSString *volumeStr = [NSString stringWithFormat:@"%d",platform.volume.intValue];
    self.tradeVolumeLbl.text = [NSString stringWithFormat:@"%@ 量%@", [platform.toSymbol uppercaseString] ,volumeStr];
    
    //对应币种价格
    self.opppsitePriceLbl.text = [NSString stringWithFormat:@"%@", [platform.lastPrice convertToRealMoneyWithNum:8]];
    
    //人民币价格
    self.rmbPriceLbl.text = [NSString stringWithFormat:@"￥%.2lf", [platform.lastCnyPrice doubleValue]];
    UIColor *fluctColor  = [platform getPercentColorWithPercent:platform.percentChange];;
    
    self.rmbPriceLbl.textColor = fluctColor;

    //涨跌情况
    NSString *priceFluctStr = platform.changeRate ;
    CGFloat fluct = [priceFluctStr doubleValue];
    
    if (fluct > 0) {
        
        priceFluctStr = [NSString stringWithFormat:@"+%@%%", priceFluctStr];
        
    } else  {
        
        priceFluctStr = [NSString stringWithFormat:@"%@%%", priceFluctStr];
    }
    
    [self.priceFluctBtn setTitle:priceFluctStr forState:UIControlStateNormal];
    [self.priceFluctBtn setBackgroundColor:platform.bgColor forState:UIControlStateNormal];
    
    CGFloat btnW = [NSString getWidthWithString:priceFluctStr font:16.0] + 15;
    [self.priceFluctBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(btnW > 75 ? btnW: 75));
    }];
    
}

- (void)setCurrency:(CurrencyModel *)currency {
    
    _currency = currency;
    
    //币种名称
    self.currencyNameLbl.text = currency.coinSymbol;
    //一日交易量
    NSString *volumeStr = currency.volume;
    self.tradeVolumeLbl.text = [NSString stringWithFormat:@"%@ 量%@", currency.toCoinSymbol,volumeStr];
    
    //对应币种价格
    self.opppsitePriceLbl.text = [NSString stringWithFormat:@"%@", currency.lastPrice];
    
    //人民币价格
    self.rmbPriceLbl.text = [NSString stringWithFormat:@"￥%@", currency.lastCnyPrice];
    self.rmbPriceLbl.textColor = currency.bgColor;
    
    //涨跌情况
    NSString *priceFluctStr = currency.changeRate;
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
