//
//  PlatformAndOtherCell.m
//  ljs
//
//  Created by zhangfuyu on 2018/5/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//
//Category

#import "NSString+CGSize.h"

#import "PlatformAndOtherCell.h"
#import "UILabel+Extension.h"
#import "NSString+CGSize.h"
#import "NSString+Extension.h"
#import "NSNumber+Extension.h"
@interface PlatformAndOtherCell()

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

@property (nonatomic, strong) UIButton *addBtn;
/*
//平台名称
@property (nonatomic, strong) UILabel *platformNameLbl;
//当前对应币种
@property (nonatomic, strong) UILabel *opppsitePriceLbl;
//当前人民币价格
@property (nonatomic, strong) UILabel *rmbPriceLbl;
//涨跌情况
@property (nonatomic, strong) UIButton *priceFluctBtn;

@property (nonatomic, strong) UIButton *addBtn;
*/
@end


@implementation PlatformAndOtherCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];

    }
    return self;
}
#pragma mark - Init
- (void)initSubviews {
    
    //平台名称
    self.platformNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor
                                                        font:12.0];
    //平台名称
    self.syomblName = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:kTextColor
                                                   font:17.0];
    
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
    
    //添加自选
    self.addBtn = [UIButton buttonWithTitle:@""
                                        titleColor:kClearColor
                                   backgroundColor:kClearColor
                                         titleFont:17.0 cornerRadius:5];
    [self.addBtn addTarget:self action:@selector(addzixuan) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addBtn];
    
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
//    [self.IsWarnImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@10);
//
//        make.left.equalTo(@15);
//        make.width.equalTo(@15);
//        make.height.equalTo(@15);
//
//    }];
    //平台
    
    
    
    
    [self.syomblName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.platformNameLbl.mas_left);
        make.top.equalTo(self.contentView.mas_top).with.offset(10);
        make.height.mas_equalTo(17);
    }];
    
    [self.platformNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mas_left).offset(10);
        make.height.mas_equalTo(14);
        make.top.equalTo(self.syomblName.mas_bottom).with.offset(10);
    }];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(40);
    }];

    //涨幅
    [self.priceFluctBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.addBtn.mas_left);
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
    
    if (![currency.isChoice boolValue]) {
        [self.addBtn setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];

    }
    else
    {
        [self.addBtn setImage:[UIImage imageNamed:@"选这个"] forState:UIControlStateNormal];

    }
    
    //平台名称
    self.platformNameLbl.text = [NSString stringWithFormat:@"24H量:%@",[self setAmount:currency.amount]];
    [self.platformNameLbl sizeToFit];
//    self.syomblName.text = [NSString stringWithFormat:@"%@/%@",[currency.symbol uppercaseString],[currency.toSymbol uppercaseString]];
    
    
    NSString *all = [NSString stringWithFormat:@"%@ /%@",[currency.symbol uppercaseString],[currency.toSymbol uppercaseString]];
    
    //    self.platformNameLbl.text = [NSString stringWithFormat:@"%@",[currency.symbol uppercaseString]];
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:all];
    
    //    NSRange range = [string rangeOfString:title];
    //字体
    [attributedStr addAttribute:NSFontAttributeName value:FONT(11) range:NSMakeRange(currency.symbol.length, all.length - currency.symbol.length)];
    //颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName value:kHexColor(@"#999999") range:NSMakeRange(currency.symbol.length, all.length - currency.symbol.length)];
    self.syomblName.attributedText = attributedStr;
    
    
    
    self.IsWarnImage.hidden = [currency.isWarn isEqualToString:@"0"];
//    if ([currency.isWarn isEqualToString:@"0"]) {
//        [self.platformNameLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(@15);
//            make.width.equalTo(@70);
//            make.centerY.equalTo(@0);
//        }];
//    }
    
    //对应币种价格
    self.opppsitePriceLbl.text = [NSString stringWithFormat:@"$%@", [currency.lastUsdPrice convertToRealMoneyWithNum:8]];
    
    
    
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

-(NSString *)setAmount:(NSString *)amout
{
    if ([amout floatValue] > 100000000) {
        return [NSString stringWithFormat:@"%.2f亿",[amout floatValue]/100000000];
    }
    if ([amout floatValue] > 10000) {
        return [NSString stringWithFormat:@"%.2f万",[amout floatValue]/10000];
    }
    return amout;
}

//#pragma mark - Init
//- (void)initSubviews {
//
//    //平台名称
//    self.platformNameLbl = [UILabel labelWithBackgroundColor:kClearColor
//                                                   textColor:[UIColor colorWithHexString:@"#3A3A3A"]
//                                                        font:17.0];
//
//    [self addSubview:self.platformNameLbl];
//    //涨跌情况
//    self.priceFluctBtn = [UIButton buttonWithTitle:@""
//                                        titleColor:kWhiteColor
//                                   backgroundColor:kClearColor
//                                         titleFont:17.0 cornerRadius:5];
//
//    [self addSubview:self.priceFluctBtn];
//    //当前对应币种价格
//    self.opppsitePriceLbl = [UILabel labelWithBackgroundColor:kClearColor
//                                                    textColor:[UIColor colorWithHexString:@"#34354E"]
//                                                         font:17.0];
//
//    [self addSubview:self.opppsitePriceLbl];
//
//    //当前人民币价格
//    self.rmbPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
//                                               textColor:kHexColor(@"#595A6E")
//                                                    font:15.0];
//
//    [self addSubview:self.rmbPriceLbl];
//
//    //添加自选
//    self.addBtn = [UIButton buttonWithTitle:@""
//                                        titleColor:kClearColor
//                                   backgroundColor:kClearColor
//                                         titleFont:17.0 cornerRadius:5];
//    [self.addBtn addTarget:self action:@selector(addzixuan) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:self.addBtn];
//
//    [self addSubview:self.priceFluctBtn];
//    //布局
//    [self setSubviewLayout];
//}
//- (void)setSubviewLayout {
//
//    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView.mas_right);
//        make.top.equalTo(self.contentView.mas_top);
//        make.bottom.equalTo(self.contentView.mas_bottom);
//        make.width.mas_equalTo(40);
//    }];
//    //平台
//    [self.platformNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(@15);
//        make.top.equalTo(self.contentView.mas_top).with.offset(10);
//        make.height.mas_equalTo(17);
//    }];
//    //涨幅
//    [self.priceFluctBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(self.addBtn.mas_left);
//        make.centerY.equalTo(@0);
//        make.height.equalTo(@37);
//    }];
//    //rmb价格
//    [self.rmbPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(@15);
//        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-10);
//        make.height.mas_equalTo(15);
//    }];
//    //对应币种
//    [self.opppsitePriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.right.equalTo(self.priceFluctBtn.mas_left).offset(-15);
//        make.centerY.equalTo(self.contentView.mas_centerY);
//        make.height.mas_equalTo(17);
//
//    }];
//
//}
//
//#pragma mark - Setting
//- (void)setCurrency:(CurrencyPriceModel *)currency {
//
//    _currency = currency;
//    if ([currency.isChoice boolValue]) {
//        [self.addBtn setImage:[UIImage imageNamed:@"df_选择"] forState:UIControlStateNormal];
//
//    }
//    else
//    {
//        [self.addBtn setImage:[UIImage imageNamed:@"optional_添加"] forState:UIControlStateNormal];
//
//    }
//    //平台名称
//    self.platformNameLbl.text = [NSString stringWithFormat:@"%@",currency.exchangeCname];
//
//    //对应币种价格
//    self.opppsitePriceLbl.text = [NSString stringWithFormat:@"%@", [currency.lastPrice convertToRealMoneyWithNum:8]];
//
//    //人民币价格
//    self.rmbPriceLbl.text =[currency.toSymbol uppercaseString]; //[NSString stringWithFormat:@"￥%.2lf", [currency.lastCnyPrice doubleValue]];
//    self.rmbPriceLbl.textColor = [UIColor colorWithHexString:@"#34354E"];
//
//    //涨跌情况
//    NSString *priceFluctStr = currency.changeRate;
//    CGFloat fluct = [priceFluctStr doubleValue];
//
//    if (fluct > 0) {
//
//        priceFluctStr = [NSString stringWithFormat:@"+%@%%", priceFluctStr];
//
//    } else  {
//
//        priceFluctStr = [NSString stringWithFormat:@"%@%%", priceFluctStr];
//    }
//
//    [self.priceFluctBtn setTitle:priceFluctStr forState:UIControlStateNormal];
//    [self.priceFluctBtn setBackgroundColor:currency.bgColor forState:UIControlStateNormal];
//
//    CGFloat btnW = [NSString getWidthWithString:priceFluctStr font:16.0] + 15;
//    [self.priceFluctBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//
//        make.width.equalTo(@(btnW > 75 ? btnW: 75));
//    }];
//
//}
- (void)addzixuan
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectAddBtn:)]) {
        [self.delegate selectAddBtn:self.index];
    }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
