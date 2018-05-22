//
//  PlatformModel.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

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
//24小时交易量
@property (nonatomic, strong) NSNumber *volume;
//24小时交易额
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
