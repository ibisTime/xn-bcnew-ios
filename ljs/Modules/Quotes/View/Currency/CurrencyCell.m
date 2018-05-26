//
//  CurrencyCell.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyCell.h"
//Category
#import "UILabel+Extension.h"
#import "NSString+CGSize.h"
#import "NSString+Extension.h"
#import "NSNumber+Extension.h"
@interface CurrencyCell()

//平台名称
@property (nonatomic, strong) UILabel *platformNameLbl;
@property (nonatomic, strong) UILabel *syomblName;

//当前对应币种
@property (nonatomic, strong) UILabel *opppsitePriceLbl;
//当前人民币价格
@property (nonatomic, strong) UILabel *rmbPriceLbl;
//涨跌情况
@property (nonatomic, strong) UIButton *priceFluctBtn;
@property (nonatomic, strong) UIImageView *IsWarnImage;

@end

@implementation CurrencyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
    }
    
    return self;
}

#pragma mark - Init
- (void)initSubviews {
    
    //平台名称
    self.platformNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor
                                                        font:17.0];
    //平台名称
    self.syomblName = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor
                                                        font:14.0];
    
    [self addSubview:self.platformNameLbl];
    [self addSubview:self.syomblName];
    self.IsWarnImage = [[UIImageView alloc] init];
    self.IsWarnImage.image = [UIImage imageNamed:@"闹钟"];
    [self addSubview:self.IsWarnImage];

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
                                                    font:14.0];
    
    [self addSubview:self.rmbPriceLbl];
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    [self.IsWarnImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);

        make.left.equalTo(@15);
        make.width.equalTo(@15);
        make.height.equalTo(@15);

    }];
    //平台
    [self.platformNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.IsWarnImage.mas_right).offset(10);
        make.width.equalTo(@70);
        make.centerY.equalTo(@0);
    }];
    
    [self.syomblName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.platformNameLbl.mas_right).offset(10);
        make.centerY.equalTo(@0);
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
        make.top.equalTo(@10);
    }];
    //对应币种
    [self.opppsitePriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.priceFluctBtn.mas_left).offset(-15);
        make.top.equalTo(self.rmbPriceLbl.mas_bottom).offset(10);
    }];
    
}

#pragma mark - Setting
- (void)setCurrency:(CurrencyPriceModel *)currency {
    
    _currency = currency;
    
    //平台名称
    self.platformNameLbl.text = [NSString stringWithFormat:@"%@",currency.exchangeCname];
    [self.platformNameLbl sizeToFit];
     self.syomblName.text = [NSString stringWithFormat:@"%@/%@",[currency.symbol uppercaseString],[currency.toSymbol uppercaseString]];
    self.IsWarnImage.hidden = [currency.isWarn isEqualToString:@"0"];
    if ([currency.isWarn isEqualToString:@"0"]) {
        [self.platformNameLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.width.equalTo(@70);
            make.centerY.equalTo(@0);
        }];
    }
    
    //对应币种价格
    self.opppsitePriceLbl.text = [NSString stringWithFormat:@"%@", [currency.lastPrice convertToRealMoneyWithNum:8]];
    
    //人民币价格
    self.rmbPriceLbl.text = [NSString stringWithFormat:@"￥%.2lf", [currency.lastCnyPrice doubleValue]];
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
