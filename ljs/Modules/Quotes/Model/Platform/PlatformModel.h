//
//  PlatformModel.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@class CoinInfo;

@interface PlatformModel : BaseModel
//排名
@property (nonatomic, assign) NSInteger rank;
//图标
@property (nonatomic, copy) NSString *symbolPic;
//编号
@property (nonatomic, copy) NSString *ID;
//类型
@property (nonatomic, copy) NSString *type;
//币种名称
@property (nonatomic, copy) NSString *symbol;
//参考币种
@property (nonatomic, copy) NSString *toSymbol;
//交易所英文
@property (nonatomic, copy) NSString *exchangeEname;
//交易所中文
@property (nonatomic, copy) NSString *exchangeCname;
//rmb价格
@property (nonatomic, strong) NSNumber *lastCnyPrice;
//最新usd价格
@property (nonatomic, strong) NSNumber *lastUsdPrice;
//24小时交易额
@property (nonatomic, strong) NSNumber *volume;
//24小时交易量
@property (nonatomic, strong) NSNumber *amount;
//
@property (nonatomic, copy) NSString *tradeVolume;
//相对于某币种的价格
@property (nonatomic, strong) NSNumber *lastPrice;
//涨幅
@property (nonatomic, strong) NSNumber *percentChange1m;
@property (nonatomic, strong) NSNumber *percentChange24h;
@property (nonatomic, strong) NSNumber *percentChange7d;
@property (nonatomic, strong) NSNumber *percentChange;

@property (nonatomic, copy) NSString *changeRate;
//涨跌颜色
@property (nonatomic, strong) UIColor *bgColor;
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
@property (nonatomic, strong) NSNumber *maxMarketCapCny;
//总市值
@property (nonatomic, strong) NSNumber *totalMarketCapCny;
//关注人数
@property (nonatomic, assign) NSInteger choiceCount;
//交易成交数量
@property (nonatomic, assign) NSInteger count;

//币种信息
@property (nonatomic, strong) CoinInfo *coin;
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

//买一价
@property (nonatomic , strong)NSNumber *bidPrice;

//卖一价
@property (nonatomic , strong)NSNumber *askPrice;
@property (nonatomic , copy)NSString *isWarn;


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

@interface CoinInfo : NSObject

/*
 项目信息
 */
//币种介绍
@property (nonatomic, copy) NSString *introduce;
//币种英文名称
@property (nonatomic, copy) NSString *ename;
//币种中文名称
@property (nonatomic, copy) NSString *cname;
//类型
@property (nonatomic, copy) NSString *type;
//发行时间
@property (nonatomic, copy) NSString *publishDatetime;
//流通量
@property (nonatomic, copy) NSString *totalSupply;
//总发行量
@property (nonatomic, copy) NSString *maxSupply;
//流通市值
@property (nonatomic, copy) NSString *totalSupplyMarket;
//总市值
@property (nonatomic, copy) NSString *maxSupplyMarket;
//上架交易所
@property (nonatomic, copy) NSString *putExchange;
//前十交易所
@property (nonatomic, copy) NSString *topExchange;
//钱包类型
@property (nonatomic, copy) NSString *walletType;
/*
 链接
 */
//官网地址
@property (nonatomic, copy) NSString *webUrl;
/*
 公募信息
 */
//ICO时间
@property (nonatomic, copy) NSString *icoDatetime;
//ICO成本
@property (nonatomic, copy) NSString *icoCost;
//募集资金
@property (nonatomic, copy) NSString *raiseAmount;
//代币分配
@property (nonatomic, copy) NSString *tokenDist;
/*
 项目简介
 */
//最新提交次数
@property (nonatomic, copy) NSString *lastCommitCount;
//总提交次数
@property (nonatomic, copy) NSString *totalCommitCount;
//总贡献值
@property (nonatomic, copy) NSString *totalDist;
//粉丝数
@property (nonatomic, copy) NSString *fansCount;
//关注数
@property (nonatomic, copy) NSString *keepCount;
//复制数
@property (nonatomic, copy) NSString *cpCount;

@end

