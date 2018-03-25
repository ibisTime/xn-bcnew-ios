//
//  PlatformModel.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface PlatformModel : BaseModel

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
@property (nonatomic, copy) NSString *lastPrice;
//涨幅
@property (nonatomic, copy) NSString *changeRate;
//涨跌颜色
@property (nonatomic, strong) UIColor *bgColor;
//是否选择(1是 0否)
@property (nonatomic, copy) NSString *isChoice;
//类型
@property (nonatomic, copy) NSString *type;


//流入
@property (nonatomic, copy) NSString *in_flow_volume_cny;
//流出
@property (nonatomic, copy) NSString *out_flow_volume_cny;
//净流入
@property (nonatomic, copy) NSString *flow_volume_cny;
//流入/流出涨跌
@property (nonatomic, copy) NSString *flow_percent_change_24h;
//涨跌颜色
@property (nonatomic, strong) UIColor *flowBgColor;

@end
