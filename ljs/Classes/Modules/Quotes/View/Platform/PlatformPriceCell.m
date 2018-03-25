//
//  PlatformPriceCell.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PlatformPriceCell.h"
//Category
#import "UILabel+Extension.h"
#import "NSString+CGSize.h"
#import "NSString+Extension.h"

@interface PlatformPriceCell()
//平台名称
@property (nonatomic, strong) UILabel *platformNameLbl;
//24H交易量
@property (nonatomic, strong) UILabel *tradeVolumeLbl;
//交易量涨跌情况
@property (nonatomic, strong) UIButton *tradeVolumeFluctBtn;
//流入/流出
@property (nonatomic, strong) UILabel *tradeFlowLbl;

@end

@implementation PlatformPriceCell

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
    
    [self addSubview:self.platformNameLbl];
    //24H交易量
    self.tradeVolumeLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                  textColor:kTextColor
                                                       font:17.0];
    
    [self addSubview:self.tradeVolumeLbl];
    //涨跌情况
    self.tradeVolumeFluctBtn = [UIButton buttonWithTitle:@""
                                              titleColor:kWhiteColor
                                         backgroundColor:kClearColor
                                               titleFont:15.0 cornerRadius:5];
    
    [self addSubview:self.tradeVolumeFluctBtn];
    //流入/流出
    self.tradeFlowLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                textColor:kTextColor2
                                                     font:12.0];
    [self addSubview:self.tradeFlowLbl];
    //布局
    [self setSubviewLayout];
}

- (void)setSubviewLayout {
    
    //平台
    [self.platformNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@15);
        make.top.equalTo(@10);
    }];
    
    //交易量涨跌情况
    [self.tradeVolumeFluctBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@(-15));
        make.centerY.equalTo(@0);
        make.height.equalTo(@37);
    }];
    //一日交易量
    [self.tradeVolumeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(@0);
        make.right.equalTo(self.tradeVolumeFluctBtn.mas_left).offset(-15);
    }];
    
    //流入/流出
    [self.tradeFlowLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.platformNameLbl.mas_left);
        make.top.equalTo(self.platformNameLbl.mas_bottom).offset(7);
    }];
}

#pragma mark - Setting
- (void)setPlatform:(PlatformModel *)platform {
    
    _platform = platform;
    
    //平台名称
    self.platformNameLbl.text = [NSString stringWithFormat:@"%@(24h)", platform.exchangeEname];
    self.tradeFlowLbl.text = [NSString stringWithFormat:@"流入/流出%@/%@", platform.in_flow_volume_cny, platform.out_flow_volume_cny];
    //一日净流入
    NSString *volumeStr = platform.flow_volume_cny;
    self.tradeVolumeLbl.text = [NSString stringWithFormat:@"￥%@",volumeStr];
    
    //涨跌情况
    NSString *tradeVolumeFluctStr = platform.flow_percent_change_24h;
    CGFloat fluct = [tradeVolumeFluctStr doubleValue];
    
    if (fluct > 0) {
        
        tradeVolumeFluctStr = [NSString stringWithFormat:@"+%@%%", tradeVolumeFluctStr];
        
    } else  {
        
        tradeVolumeFluctStr = [NSString stringWithFormat:@"%@%%", tradeVolumeFluctStr];
    }
    
    [self.tradeVolumeFluctBtn setTitle:tradeVolumeFluctStr forState:UIControlStateNormal];
    [self.tradeVolumeFluctBtn setBackgroundColor:platform.flowBgColor forState:UIControlStateNormal];
    
    CGFloat btnW = [NSString getWidthWithString:tradeVolumeFluctStr font:16.0] + 15;
    [self.tradeVolumeFluctBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@(btnW > 75 ? btnW: 75));
    }];
    
}

@end
