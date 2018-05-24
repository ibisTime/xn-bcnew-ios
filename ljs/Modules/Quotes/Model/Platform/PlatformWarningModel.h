//
//  PlatformWarningModel.h
//  ljs
//
//  Created by zhangfuyu on 2018/5/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface PlatformWarningModel : BaseModel
//主键
@property (nonatomic, copy) NSString *userId;
//预警类型 PUSH("0", "推送");
@property (nonatomic, copy) NSString *type;
//交易所
@property (nonatomic, copy) NSString *exchangeEname;
//基础币种
@property (nonatomic, copy) NSString *symbol;
//计价币种
@property (nonatomic, copy) NSString *toSymbol;
//当时价格
@property (nonatomic, strong) NSNumber *currentPrice;
//涨跌幅
@property (nonatomic, strong) NSNumber *changeRate;
//预警价格
@property (nonatomic, strong) NSString *warnPrice;
//预警内容
@property (nonatomic, copy) NSString *warnContent;
//状态 TO_WARN("0", "待触发"), WARNED("1", "已触发");
@property (nonatomic, copy) NSString *status;
//币种
@property (nonatomic, copy) NSString *warnCurrency;
//预警方向 0 上涨 1 下跌
@property (nonatomic, copy) NSString *warnDirection;
//id
@property (nonatomic, copy) NSString *id;



@end
