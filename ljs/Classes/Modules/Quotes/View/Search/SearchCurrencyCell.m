//
//  SearchCurrencyCell.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SearchCurrencyCell.h"
//Category
#import "UILabel+Extension.h"
#import "NSString+CGSize.h"
#import "NSString+Extension.h"

@interface SearchCurrencyCell()
//币种名称
@property (nonnull, strong) UILabel *currencyNameLbl;
//平台名称
@property (nonatomic, strong) UILabel *platformNameLbl;
//当前对应币种
@property (nonatomic, strong) UILabel *opppsitePriceLbl;
//涨跌情况
@property (nonatomic, strong) UIButton *priceFluctBtn;
//添加
@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation SearchCurrencyCell

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
    //平台名称
    self.platformNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor
                                                        font:17.0];
    
    [self addSubview:self.platformNameLbl];
    //涨跌情况
    self.priceFluctBtn = [UIButton buttonWithTitle:@""
                                        titleColor:kWhiteColor
                                   backgroundColor:kClearColor
                                         titleFont:15.0
                                      cornerRadius:5];
    
    [self addSubview:self.priceFluctBtn];
    //当前对应币种价格
    self.opppsitePriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                    textColor:kHexColor(@"#595A6E")
                                                         font:17.0];
    
    [self addSubview:self.opppsitePriceLbl];
    //添加按钮
    self.addBtn = [UIButton buttonWithImageName:@"小加"
                              selectedImageName:@"勾选"];
    
    self.addBtn.userInteractionEnabled = NO;
    
    [self addSubview:self.addBtn];
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    //币种名称
    [self.currencyNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@10);
        make.left.equalTo(@15);
    }];
    //平台
    [self.platformNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.currencyNameLbl.mas_left);
        make.top.equalTo(self.currencyNameLbl.mas_bottom).offset(5);
    }];
    //添加
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.centerY.equalTo(@0);
        make.width.height.equalTo(@22);
    }];
    //涨幅
    [self.priceFluctBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.addBtn.mas_left).offset(-15);
        make.centerY.equalTo(@0);
        make.height.equalTo(@37);
    }];
    //对应币种
    [self.opppsitePriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.priceFluctBtn.mas_left).offset(-15);
        make.centerY.equalTo(@0);
    }];
    
}

#pragma mark - Setting
- (void)setCurrency:(CurrencyModel *)currency {
    
    _currency = currency;
    
    //币种名称
    self.currencyNameLbl.text = [NSString stringWithFormat:@"%@/%@", currency.coinSymbol, currency.toCoinSymbol];
    //平台名称
    self.platformNameLbl.text = currency.exchangeEname;
    //对应币种价格
    self.opppsitePriceLbl.text = [NSString stringWithFormat:@"%@", currency.lastCnyPrice];
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
    //添加按钮
    self.addBtn.selected = [currency.isChoice boolValue];
}

@end
