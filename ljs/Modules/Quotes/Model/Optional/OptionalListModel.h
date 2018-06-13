//
//  OptionalListModel.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@class Marketfxh;

@interface OptionalListModel : BaseModel

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *exchangeEname;
@property (nonatomic, copy) NSString *exchangeCname;
@property (nonatomic, copy) NSString *choiceId;


@property (nonatomic, copy) NSString *toCoin;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, copy) NSString *coin;

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, strong) Marketfxh *marketFxh;
@property (nonatomic, strong) NSNumber *lastPrice;

@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *toSymbol;
@property (nonatomic, copy) NSString *amount;

@property (nonatomic, copy) NSString *totalMarketCapUsd;
@property (nonatomic, copy) NSString *totalMarketCapCny;
@property (nonatomic, copy) NSString *maxMarketCapUsd;
@property (nonatomic, copy) NSString *maxMarketCapCny;
@property (nonatomic, copy) NSString *percentChange24h;
@property (nonatomic, strong) NSNumber *percentChange;
@property (nonatomic, copy) NSString *choiceCount;
@property (nonatomic, copy) NSString *coinCname;

@property (nonatomic, copy) NSString *coinSymbolPair;
///24小时RMB数
@property (nonatomic, strong) NSNumber *volume;
//涨幅
@property (nonatomic, copy) NSString *changeRate;
//涨跌颜色
@property (nonatomic, strong) UIColor *bgColor;
//交易所英文
//交易所中文
//币种名称
@property (nonatomic, copy) NSString *coinSymbol;
//rmb价格
@property (nonatomic, strong) NSNumber *lastCnyPrice;

@property (nonatomic, copy) NSString *coinEname;
//参考币种
@property (nonatomic, copy) NSString *toCoinSymbol;
//相对于某币种的价格
//排名
@property (nonatomic, assign) NSInteger rank;
//图标
@property (nonatomic, copy) NSString *symbolPic;


//类型
@property (nonatomic, copy) NSString *type;
//币种名称
//
@property (nonatomic, copy) NSString *tradeVolume;
//相对于某币种的价格
//涨幅
@property (nonatomic, strong) NSNumber *percentChange1m;

@property (nonatomic, strong) NSNumber *percentChange7d;
//排名颜色
@property (nonatomic, strong) UIColor *rankColor;
//是否选择(1是 0否)
@property (nonatomic, copy) NSString *isChoice;
//最高价
@property (nonatomic, strong) NSNumber *high;
//最低价
@property (nonatomic, strong) NSNumber *low;
//开盘价
@property (nonatomic, strong) NSNumber *open;
//收盘价
@property (nonatomic, strong) NSNumber *close;
//市值
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy)   NSString   *isWarn;

//流入
@property (nonatomic, copy) NSString *in_flow_volume_cny;
//流出
@property (nonatomic, copy) NSString *out_flow_volume_cny;
//净流入
@property (nonatomic, copy) NSString *flow_volume_cny;
@property (nonatomic, copy) NSString *flowVolume;
//流入/流出涨跌
@property (nonatomic, strong) NSNumber *flow_percent_change_24h;
//涨跌颜色
@property (nonatomic, strong) UIColor *flowBgColor;


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

