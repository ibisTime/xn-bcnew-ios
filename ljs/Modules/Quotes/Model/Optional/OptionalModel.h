//
//  OptionalModel.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface OptionalModel : BaseModel
//编号
@property (nonatomic, copy) NSString *ID;
//币种名称
@property (nonatomic, copy) NSString *coinSymbol;
//参考币种
@property (nonatomic, copy) NSString *toCoinSymbol;
//交易所英文
@property (nonatomic, copy) NSString *exchangeEname;
//交易所中文
@property (nonatomic, copy) NSString *exchangeCname;
//rmb价格
@property (nonatomic, copy) NSString *lastCnyPrice;
///24小时RMB数
@property (nonatomic, copy) NSString *volume;
//相对于某币种的价格
@property (nonatomic, strong) NSNumber *lastPrice;
//24小时某币种数
@property (nonatomic, copy) NSString *one_day_volume_usd;
//涨幅
@property (nonatomic, copy) NSString *changeRate;
//涨跌颜色
@property (nonatomic, strong) UIColor *bgColor;
//是否选择(1是 0否)
@property (nonatomic, copy) NSString *isChoice;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *toSymbol;
@property (nonatomic, strong) UIColor *flowBgColor;
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *symbolPair;
@property (nonatomic, copy) NSString *open;
@property (nonatomic, copy) NSString *close;
@property (nonatomic, copy) NSString *low;
@property (nonatomic, copy) NSString *high;
@property (nonatomic, copy) NSString *bidPrice;
@property (nonatomic, copy) NSString *bidAmount;
@property (nonatomic, copy) NSString *askPrice;
@property (nonatomic, copy) NSString *askAmount;
@property (nonatomic, copy) NSString *lastUsdPrice;
@property (nonatomic, copy) NSString *marketCapUsd;
@property (nonatomic, copy) NSString *percentChange;
@property (nonatomic, copy) NSString *percentChange24h;
@property (nonatomic, copy) NSString *percentChange1m;
@property (nonatomic, copy) NSString *symbolPic;
@property (nonatomic, copy) NSString *percentChange7d;

@end
