//
//  CurrencyInfoHeaderView.h
//  bige
//
//  Created by 蔡卓越 on 2018/4/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"
//M
#import "PlatformModel.h"
/**
 项目信息简介
 */
@interface CurrencyInfoHeaderView : BaseView
//
@property (nonatomic, copy) void(^refreshHeaderBlock)();
//
@property (nonatomic, strong) PlatformModel *platform;

@end
