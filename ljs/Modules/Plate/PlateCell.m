//
//  PlateCell.m
//  ljs
//
//  Created by shaojianfei on 2018/6/18.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PlateCell.h"
//Category
#import "UILabel+Extension.h"
#import "NSString+CGSize.h"
#import "NSString+Extension.h"
#import "NSNumber+Extension.h"

@interface  PlateCell()

//平台名称
@property (nonatomic, strong) UILabel *platformNameLbl;
@property (nonatomic, strong) UILabel *syomblName;

//当前对应币种
@property (nonatomic, strong) UILabel *opppsitePriceLbl;
//当前人民币价格
@property (nonatomic, strong) UILabel *rmbLbl;
//当前对应币种
@property (nonatomic, strong) UILabel *opppsiteLbl;
//当前人民币价格
@property (nonatomic, strong) UILabel *rmbPriceLbl;

//涨跌情况
@property (nonatomic, strong) UIButton *priceFluctBtn;
@property (nonatomic, strong) UIImageView *IsWarnImage;
@end
@implementation PlateCell

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
    self.opppsiteLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                    textColor:kHexColor(@"#595A6E")
                                                         font:14.0];
    
    [self addSubview:self.opppsiteLbl];
    
    //当前人民币价格
   
    
    self.rmbPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:kTextColor
                                                    font:15.0];
    self.rmbLbl = [UILabel labelWithBackgroundColor:kClearColor
                                          textColor:kHexColor(@"#595A6E")
                                               font:14.0];
    [self addSubview:self.rmbLbl];
    [self addSubview:self.rmbPriceLbl];

    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
   
    //平台
    [self.platformNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(@10);
        //        make.width.equalTo(@70);
        make.centerY.equalTo(@0);
    }];
    
//    [self.syomblName mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.mas_equalTo(self.platformNameLbl.mas_right).offset(10);
//        make.centerY.equalTo(@0);
//    }];
    
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
        make.top.equalTo(@10);
    }];
    [self.rmbLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.rmbPriceLbl.mas_left).offset(-5);
        make.top.equalTo(@10);
    }];
    //对应币种
    [self.opppsitePriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.priceFluctBtn.mas_left).offset(-15);
        make.top.equalTo(self.rmbPriceLbl.mas_bottom).offset(10);
    }];
    [self.opppsiteLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.opppsitePriceLbl.mas_left).offset(-5);
        make.top.equalTo(self.rmbPriceLbl.mas_bottom).offset(10);
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
-(void)setModel:(PlateMineModel *)model
{
    
    _model = model;
    self.backgroundColor = kBackgroundColor;
    self.platformNameLbl.text = model.name;
    CGFloat f =  [model.avgChange floatValue]*100;
    if (f > 0) {
        [self.priceFluctBtn setTitle:[NSString stringWithFormat:@"+%.2f%%",[model.avgChange doubleValue]*100] forState:UIControlStateNormal];
//        self.contentLab.text = [NSString stringWithFormat:@"+%.2f%%",[model.bestChange doubleValue]*100];
        [self.priceFluctBtn setBackgroundColor:kRiseColor forState:UIControlStateNormal];
        [self.priceFluctBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];;
    }else
    {
         [self.priceFluctBtn setTitle:[NSString stringWithFormat:@"%.2f%%",[model.avgChange doubleValue]*100] forState:UIControlStateNormal];
        [self.priceFluctBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [self.priceFluctBtn setBackgroundColor:kbottomColor forState:UIControlStateNormal];

    }
    self.rmbLbl.text = model.bestSymbol;
    self.rmbPriceLbl.text = [NSString stringWithFormat:@"%.2f%%",[model.bestChange floatValue]*100];
    if ([model.bestChange floatValue]*100 >0) {
        self.rmbPriceLbl.textColor = kRiseColor;
    }else
    {
        self.rmbPriceLbl.textColor = kbottomColor;

    }
    self.opppsiteLbl.text = model.worstSymbol;
    if ([model.worstChange floatValue]*100 >0) {
        self.opppsitePriceLbl.textColor = kRiseColor;
    }else
    {
        self.opppsitePriceLbl.textColor = kbottomColor;
        
    }
    self.opppsitePriceLbl.text = [NSString stringWithFormat:@"%.2f%%",[model.worstSymbol floatValue]*100];
    
    
    }

@end
