//
//  CurrencyKLineMapView.h
//  bige
//
//  Created by 蔡卓越 on 2018/4/27.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"

//M
#import "PlatformModel.h"
/**
 K线图
 */
@interface CurrencyKLineMapView : BaseView
//币种信息
@property (nonatomic, strong) PlatformModel *platform;
//屏幕横屏
@property (nonatomic, copy) void(^horizontalScreenBlock)(void);

@end
