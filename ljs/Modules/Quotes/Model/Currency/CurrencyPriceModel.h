//
//  CurrencyPriceModel.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface CurrencyPriceModel : BaseModel

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *priceBtc;
//币种名称
@property (nonatomic, copy) NSString *name;
//币种符号
@property (nonatomic, copy) NSString *toSymbol;
//24h涨跌幅
@property (nonatomic, copy) NSString *percentChange24h;
//美元市值
@property (nonatomic, copy) NSString *marketCapUsd;
//人民币市值
@property (nonatomic, copy) NSString *marketCapCny;
//流通量
@property (nonatomic, copy) NSString *totalSuply;
//市值总量
@property (nonatomic, copy) NSString *maxSupply;
//最新美元价格
@property (nonatomic, copy) NSString *priceUsd;
//最新人民币价格
@property (nonatomic, copy) NSString *priceCny;
//24h美元交易量
@property (nonatomic, copy) NSString *h24VolumeUsd;
//24h人民币交易量
@property (nonatomic, copy) NSString *h24VolumeCny;
//市值排名
@property (nonatomic, strong) NSNumber *rank;
//
@property (nonatomic, copy) NSString *availableSupply;
//是否添加自选 0 no 1 yes
@property (nonatomic, copy)NSString *isChoice;

@property (nonatomic, copy) NSString *lastUpdated;
@property (nonatomic, copy) NSString *totalMarketCapCny;
@property (nonatomic, copy) NSString *maxMarketCapCny;
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *exchangeEname;
@property (nonatomic, copy) NSString *totalMarketCapUsd;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *maxMarketCapUsd;
@property (nonatomic, copy) NSString *lastCnyPrice;
@property (nonatomic, copy) NSString *lastUsdPrice;
@property (nonatomic, copy) NSNumber *percentChange;
@property (nonatomic, copy) NSString *choiceCount;
@property (nonatomic, copy) NSString *isWarn;
@property (nonatomic, copy) NSString *lastPrice;
@property (nonatomic, copy) NSString *exchangeCname;
@property (nonatomic, copy) NSString *changeRate;
//涨跌颜色
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) NSNumber *volume;

@property (nonatomic, strong) NSNumber *flow_percent_change_24h;

/**
 获取涨跌颜色
 */
- (UIColor *)getPercentColorWithPercent:(NSNumber *)percent;
/**
 获取涨跌幅
 */
- (NSString *)getResultWithPercent:(NSNumber *)percent;
/**
 获取币种数量
 */
- (NSString *)getNumWithVolume:(NSNumber *)volumeNum;

@end
