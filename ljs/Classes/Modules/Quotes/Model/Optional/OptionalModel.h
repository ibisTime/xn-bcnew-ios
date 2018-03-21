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
@property (nonatomic, copy) NSString *code;
//币种名称
@property (nonatomic, copy) NSString *symbol;
//平台
@property (nonatomic, copy) NSString *platformName;
//rmb价格
@property (nonatomic, copy) NSString *price_cny;
///24小时RMB数
@property (nonatomic, copy) NSString *one_day_volume_cny;
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
//是否选择
@property (nonatomic, assign) BOOL isSelect;

@end
