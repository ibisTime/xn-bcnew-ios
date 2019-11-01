//
//  OptionalCell.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "OptionalCell.h"
//Category
#import "UILabel+Extension.h"
#import "NSString+CGSize.h"
#import "NSString+Extension.h"
#import "NSNumber+Extension.h"
@interface OptionalCell()

//币种名称
@property (nonnull, strong) UILabel *currencyNameLbl;
//平台名称
@property (nonatomic, strong) UILabel *platformNameLbl;
//24H交易量
@property (nonatomic, strong) UILabel *tradeVolumeLbl;
//当前对应币种
@property (nonatomic, strong) UILabel *opppsitePriceLbl;
//当前人民币价格
@property (nonatomic, strong) UILabel *rmbPriceLbl;
//涨跌情况
@property (nonatomic, strong) UIButton *priceFluctBtn;
@property (nonatomic, strong) UIImageView *isWarnView;

@end

@implementation OptionalCell

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
                                                   textColor:kTextColor font:17.0];
     
    [self addSubview:self.currencyNameLbl];
                            
    self.isWarnView =[[UIImageView alloc] init];
    self.isWarnView.image = [UIImage imageNamed:@"闹钟"];
    [self addSubview:self.isWarnView];

    //平台名称
    self.platformNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor2
                                                        font:14.0];
    
    [self addSubview:self.platformNameLbl];
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
                                                    font:14.0];
    
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
    
    [self.isWarnView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@10);
        make.left.equalTo(@15);
        make.width.height.equalTo(@15);
    }];
    
    //币种名称
    [self.currencyNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@10);
        make.left.equalTo(self.isWarnView.mas_right).offset(10);
    }];
    //平台
    [self.platformNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.currencyNameLbl.mas_right).offset(10);
        make.centerY.equalTo(self.currencyNameLbl.mas_centerY);
    }];
    
   
    //一日交易量
    [self.tradeVolumeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.currencyNameLbl.mas_bottom).offset(10);
        make.left.equalTo(@15);
        
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
- (void)setOptional:(OptionalListModel *)optional {
    
    _optional = optional;
    
    //币种名称
    self.currencyNameLbl.text = [optional.symbol uppercaseString];;
    //平台名称
//    self.platformNameLbl.text = optional.exchangeEname;
//    = [optional.isWarn isEqualToString:@"0"];
//    if (self.currencyNameLbl.frame.origin.x <= self.isWarnView.frame.origin.x) {
//
        if ([optional.isWarn isEqualToString:@"0"]) {
            self.isWarnView.hidden = YES;
            [self.currencyNameLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@10);
                make.left.equalTo(@15);
            }];
        }else{
        [self.currencyNameLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            self.isWarnView.hidden = NO;

            make.top.equalTo(@10);
            make.left.mas_equalTo(self.isWarnView.mas_right).offset(10);
        }];
        }
//    }else
//    {
//    if ([optional.isWarn isEqualToString:@"0"]) {
//        [self.currencyNameLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(@10);
//                make.left.equalTo(@15);
//        }];
//    }
//    }
    //一日交易量
//    CGFloat volume = [optional.one_day_volume_cny doubleValue];
    
    NSString *volumeStr = [NSString stringWithFormat:@"%.2f万",optional.volume.floatValue/10000];
    self.tradeVolumeLbl.text = [NSString stringWithFormat:@"%@ 量%@", [optional.toSymbol uppercaseString],volumeStr];

    //对应币种价格
    self.opppsitePriceLbl.text = [NSString stringWithFormat:@"%@",[optional.lastPrice convertToRealMoneyWithNum:8]];
//    self.usdPriceLbl.textColor = optional.bgColor;
    //人民币价格
    self.rmbPriceLbl.text = [NSString stringWithFormat:@"￥%.2lf",[optional.lastCnyPrice doubleValue]];
     UIColor *fluctColor  = [optional getPercentColorWithPercent:optional.percentChange];;
    self.rmbPriceLbl.textColor = fluctColor;
    
    //涨跌情况
    NSString *priceFluctStr = optional.changeRate;
    CGFloat fluct = [priceFluctStr doubleValue];
    
    if (fluct > 0) {
        
        priceFluctStr = [NSString stringWithFormat:@"+%@%%", priceFluctStr];
        
    } else  {
        
        priceFluctStr = [NSString stringWithFormat:@"%@%%", priceFluctStr];
    }
    
    [self.priceFluctBtn setTitle:priceFluctStr forState:UIControlStateNormal];
    [self.priceFluctBtn setBackgroundColor:optional.bgColor forState:UIControlStateNormal];
    
    CGFloat btnW = [NSString getWidthWithString:priceFluctStr font:16.0] + 15;
    [self.priceFluctBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(btnW > 75 ? btnW: 75));
    }];
    
}

@end
