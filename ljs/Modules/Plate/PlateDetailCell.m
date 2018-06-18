//
//  PlateDetailCell.m
//  ljs
//
//  Created by shaojianfei on 2018/6/18.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PlateDetailCell.h"
//Category
#import "UILabel+Extension.h"
#import "NSString+CGSize.h"
#import "NSString+Extension.h"
#import "NSNumber+Extension.h"

@interface  PlateDetailCell()

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

@end
@implementation PlateDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self initSubviews];
        self.backgroundColor = kBackgroundColor;
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
    //24H交易量
    self.tradeVolumeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kTextColor2
                                                       font:15.0];
    
    [self addSubview:self.tradeVolumeLbl];
    //涨跌情况
    self.priceFluctBtn = [UIButton buttonWithTitle:@""
                                        titleColor:kWhiteColor
                                   backgroundColor:kClearColor
                                         titleFont:15.0 cornerRadius:5];
    
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
    
  
    //币种名称
    [self.currencyNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@10);
//        make.left.equalTo(self.presentImage.mas_right).offset(10);
                make.left.equalTo(@10);
        
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
        make.width.equalTo(@70);

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
    
    UIView *line = [UIView new];
    [self addSubview:line];
    line.backgroundColor = kLineColor;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@-10);
        make.left.equalTo(@10);
        make.height.equalTo(@1);
        make.bottom.equalTo(self.mas_bottom);

    }];
    
}

- (void)setModel:(plateDetailModel *)model
{
    self.currencyNameLbl.text = model.symbol;
    self.tradeVolumeLbl.text = [NSString stringWithFormat:@"量%.2f万",[model.count floatValue]/10000];
    self.rmbPriceLbl.text = [NSString stringWithFormat:@"¥%.4f",[model.lastCnyPrice floatValue]];
    self.opppsitePriceLbl.text = [NSString stringWithFormat:@"$%.8f",[model.lastPrice floatValue]];;
    if ([model.percentChange24h floatValue]*100 > 0) {
        [self.priceFluctBtn setTitle:[NSString stringWithFormat:@"%.2f%%",[model.percentChange24h floatValue]*100] forState:UIControlStateNormal];

        [self.priceFluctBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self.priceFluctBtn setBackgroundColor:kRiseColor forState:UIControlStateNormal];
    }else
        
    {
        [self.priceFluctBtn setTitle:[NSString stringWithFormat:@"%.2f%%",[model.percentChange24h floatValue]*100] forState:UIControlStateNormal];
        [self.priceFluctBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];

        [self.priceFluctBtn setBackgroundColor:kbottomColor forState:UIControlStateNormal];

        
        
    }
}

@end
