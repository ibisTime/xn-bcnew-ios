//
//  CurrencyModel.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseModel.h"

@interface CurrencyModel : BaseModel
//编号
@property (nonatomic, copy) NSString *code;
//币种名称
@property (nonatomic, copy) NSString *symbol;
//平台
@property (nonatomic, copy) NSString *platformName;
//rmb价格
@property (nonatomic, copy) NSString *price_cny;
//24小时币种交易额
@property (nonatomic, copy) NSString *one_day_volume_cny;
//24小时币种流通量
@property (nonatomic, copy) NSString *one_day_volume;
//总的币种交易额
@property (nonatomic, copy) NSString *all_volume_cny;
//总的币种流通量
@property (nonatomic, copy) NSString *all_volume;
//相对于某币种的价格
@property (nonatomic, copy) NSString *price_usd;
//24小时某币种数
@property (nonatomic, copy) NSString *one_day_volume_usd;
//单位
@property (nonatomic, copy) NSString *unit;
//涨幅
@property (nonatomic, copy) NSString *percent_change_24h;
//涨跌颜色
@property (nonatomic, strong) UIColor *bgColor;
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
