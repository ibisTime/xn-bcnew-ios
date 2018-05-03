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

@property (nonatomic, copy) NSString *toCoin;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *orderNo;

@property (nonatomic, copy) NSString *coin;

@property (nonatomic, copy) NSString *updateDatetime;

@property (nonatomic, strong) Marketfxh *marketFxh;

@end

@interface Marketfxh : NSObject

@property (nonatomic, copy) NSString *coinCname;

@property (nonatomic, copy) NSString *coinSymbolPair;
///24小时RMB数
@property (nonatomic, copy) NSString *volume;
//涨幅
@property (nonatomic, copy) NSString *changeRate;
//涨跌颜色
@property (nonatomic, strong) UIColor *bgColor;
//交易所英文
@property (nonatomic, copy) NSString *exchangeCname;
//交易所中文
@property (nonatomic, copy) NSString *exchangeEname;
//币种名称
@property (nonatomic, copy) NSString *coinSymbol;
//rmb价格
@property (nonatomic, copy) NSString *lastCnyPrice;

@property (nonatomic, copy) NSString *coinEname;
//参考币种
@property (nonatomic, copy) NSString *toCoinSymbol;
//相对于某币种的价格
@property (nonatomic, copy) NSString *lastPrice;

@end
