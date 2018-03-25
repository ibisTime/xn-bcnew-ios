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
@property (nonatomic, copy) NSString *symbol;
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
@property (nonatomic, copy) NSString *rank;
//
@property (nonatomic, copy) NSString *availableSupply;

@property (nonatomic, copy) NSString *lastUpdated;
//涨跌颜色
@property (nonatomic, strong) UIColor *bgColor;


@end
