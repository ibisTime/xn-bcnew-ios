//
//  CurrencyInfoView.h
//  bige
//
//  Created by 蔡卓越 on 2018/4/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseView.h"
//M
#import "PlatformModel.h"

/**
 币种详情头部数据
 */
@interface CurrencyInfoView : BaseView
//
@property (nonatomic, strong) PlatformModel *platform;
- (void)changeMoney:(NSString *)str;
@end
