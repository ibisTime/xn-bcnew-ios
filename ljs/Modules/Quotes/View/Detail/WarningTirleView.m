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

@property (nonatomic , strong)UIImageView *topImageView;
@property (nonatomic , strong)UIView *bottomView;

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
    
    self.backgroundColor = RGB(17, 37, 74);
    //币种名称
    
    
//    self.layer.cornerRadius = 8;
//    self.clipsToBounds = YES;
    self.topImageView = [[UIImageView alloc] initWithImage:kImage(@"Oval 3")];
//    self.topImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.topImageView];
    self.currencyNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:[UIColor whiteColor]
                                                        font:17.0];
    self.currencyNameLbl.textAlignment = NSTextAlignmentCenter;
    [self.topImageView addSubview:self.currencyNameLbl];
    
    //当前人民币价格
//    self.rmbPriceLbl = [UILabel labelWithBackgroundColor:kHexColor(@"#FFA300")
//                                               textColor:[UIColor whiteColor]
//                                                    font:17.0];
//    self.rmbPriceLbl.textAlignment = NSTextAlignmentCenter;
//    self.rmbPriceLbl.layer.cornerRadius = 10;
//    self.rmbPriceLbl.clipsToBounds = YES;
//    [self addSubview:self.rmbPriceLbl];
    
//    //当前人民币价格
//    self.USDLabel = [UILabel labelWithBackgroundColor:kHexColor(@"#FFA300")
//                                               textColor:[UIColor whiteColor]
//                                                    font:17.0];
//    self.USDLabel.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:self.USDLabel];
//
//    //当前人民币价格
  
    self.bottomView = [[UIView alloc]init];
    [self addSubview:self.bottomView];
    self.bottomView.backgroundColor = kBackgroundColor;
    self.toSymbol = [UILabel labelWithBackgroundColor:kHexColor(@"#FFA300")
                                            textColor:[UIColor whiteColor]
                                                 font:17.0];
    self.toSymbol.textAlignment = NSTextAlignmentLeft;
    self.toSymbol.layer.cornerRadius = 23.5;
    self.toSymbol.clipsToBounds = YES;
    [self addSubview:self.toSymbol];
    
    self.lineView = [[UIView alloc]init];
    [self addSubview:self.lineView];
    self.lineView.backgroundColor = kClearColor;
    //布局
    [self setSubviewLayout];

}
- (void)setSubviewLayout
{
    
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(60);
    }];
    
    [self.currencyNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topImageView.mas_centerX);
        make.centerY.equalTo(self.topImageView.mas_centerY);
        make.height.mas_equalTo(17);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.right.equalTo(self.mas_right).with.offset(-15);
        make.centerY.equalTo(self.mas_centerY).offset(0);
        make.height.mas_equalTo(1);

    }];
    
 
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(0);
        make.bottom.equalTo(self.self.mas_bottom).with.offset(0);
        make.right.equalTo(self.mas_right).offset(0);
        //        make.width.mas_equalTo(([UIScreen mainScreen].bounds.size.width - 30)/3);
        make.height.mas_equalTo(28);
        
    }];
    [self.toSymbol mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(15);
        make.bottom.equalTo(self.self.mas_bottom).with.offset(-5);
        make.right.equalTo(self.mas_right).offset(-15);
        //        make.width.mas_equalTo(([UIScreen mainScreen].bounds.size.width - 30)/3);
        make.height.mas_equalTo(47);
        
    }];
//    [self.USDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.toSymbol.mas_right);
//        make.top.equalTo(self.lineView.mas_bottom).with.offset(10);
//        make.width.mas_equalTo(([UIScreen mainScreen].bounds.size.width - 30)/3);
//        make.height.mas_equalTo(35);
//    }];
//
//    [self.rmbPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.USDLabel.mas_right);
//        make.top.equalTo(self.lineView.mas_bottom).with.offset(10);
//        make.width.mas_equalTo(([UIScreen mainScreen].bounds.size.width - 30)/3);
//        make.height.mas_equalTo(35);
//
//    }];
    
    UIView *line3 = [[UIView alloc]init];
    line3.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self addSubview:line3];
    
//    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.toSymbol.mas_top).offset(10);
//        make.left.equalTo(self.toSymbol.mas_right);
//        make.height.mas_equalTo(27);
//        make.width.mas_equalTo(1);
//    }];
    
    UIView *line4 = [[UIView alloc]init];
    line4.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self addSubview:line4];
    
//    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.toSymbol.mas_top).offset(10);
//        make.left.equalTo(@(([UIScreen mainScreen].bounds.size.width - 30)/3));
//        make.height.mas_equalTo(27);
//        make.width.mas_equalTo(1);
//    }];
}
- (void)setPlatform:(PlatformModel *)platform
{
    _platform = platform;
    NSString *toSymbol = [_platform.symbol uppercaseString];
    
    
    self.currencyNameLbl.text = _platform.exchangeCname;
    self.toSymbol.text = [NSString stringWithFormat:@"     %@  |         ¥ %.2lf  |         $ %.2lf",toSymbol,[platform.lastCnyPrice doubleValue],[platform.lastUsdPrice doubleValue]];
    
//    self.rmbPriceLbl.text = [NSString stringWithFormat:@"￥%.2lf", [platform.lastCnyPrice doubleValue]];
//    self.USDLabel.text = [NSString stringWithFormat:@"$%.2lf", [platform.lastUsdPrice doubleValue]];
}

@end
