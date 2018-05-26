//
//  WarningTirleView.m
//  ljs
//
//  Created by zhangfuyu on 2018/5/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "WarningTirleView.h"
#import "AppColorMacro.h"
@interface WarningTirleView ()

//币种名称
@property (nonatomic, strong) UILabel *currencyNameLbl;

@property (nonatomic, strong) UILabel *toSymbol;

//当前人民币价格
@property (nonatomic, strong) UILabel *rmbPriceLbl;


@property (nonatomic, strong) UILabel *USDLabel;

@property (nonatomic , strong)UIView *lineView;

@end

@implementation WarningTirleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}
- (void)initSubviews {
    
    self.backgroundColor = kAppCustomMainColor;
    //币种名称
    self.currencyNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:[UIColor whiteColor]
                                                        font:17.0];
    self.currencyNameLbl.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.currencyNameLbl];
    
    //当前人民币价格
    self.rmbPriceLbl = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:[UIColor whiteColor]
                                                    font:17.0];
    self.rmbPriceLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.rmbPriceLbl];
    
    //当前人民币价格
    self.USDLabel = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:[UIColor whiteColor]
                                                    font:17.0];
    self.USDLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.USDLabel];
    
    //当前人民币价格
    self.toSymbol = [UILabel labelWithBackgroundColor:kClearColor
                                               textColor:[UIColor whiteColor]
                                                    font:17.0];
    self.toSymbol.textAlignment = NSTextAlignmentCenter;

    [self addSubview:self.toSymbol];
    
    self.lineView = [[UIView alloc]init];
    [self addSubview:self.lineView];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    //布局
    [self setSubviewLayout];

}
- (void)setSubviewLayout
{
    [self.currencyNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(17);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(1);

    }];
    
    [self.toSymbol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.top.equalTo(self.lineView.mas_bottom).with.offset(10);
        make.width.mas_equalTo(([UIScreen mainScreen].bounds.size.width - 30)/3);
        make.height.mas_equalTo(17);

    }];
    [self.USDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.toSymbol.mas_right);
        make.top.equalTo(self.lineView.mas_bottom).with.offset(10);
        make.width.mas_equalTo(([UIScreen mainScreen].bounds.size.width - 30)/3);
        make.height.mas_equalTo(17);
    }];
    
    [self.rmbPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.USDLabel.mas_right);
        make.top.equalTo(self.lineView.mas_bottom).with.offset(10);
        make.width.mas_equalTo(([UIScreen mainScreen].bounds.size.width - 30)/3);
        make.height.mas_equalTo(17);
        
    }];
    
    UIView *line3 = [[UIView alloc]init];
    line3.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self addSubview:line3];
    
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toSymbol.mas_top);
        make.left.equalTo(self.toSymbol.mas_right);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(1);
    }];
    
    UIView *line4 = [[UIView alloc]init];
    line4.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self addSubview:line4];
    
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.USDLabel.mas_top);
        make.left.equalTo(self.USDLabel.mas_right);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(1);
    }];
}
- (void)setPlatform:(PlatformModel *)platform
{
    _platform = platform;
    NSString *toSymbol = [_platform.symbol uppercaseString];
    
    
    self.currencyNameLbl.text = _platform.exchangeCname;
    self.toSymbol.text = toSymbol;
    
    self.rmbPriceLbl.text = [NSString stringWithFormat:@"￥%.2lf", [platform.lastCnyPrice doubleValue]];
    self.USDLabel.text = [NSString stringWithFormat:@"$%.2lf", [platform.lastUsdPrice doubleValue]];
}

@end
