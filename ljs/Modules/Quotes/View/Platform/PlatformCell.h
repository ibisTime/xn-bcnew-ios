//
//  PlatformCell.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
//M
#import "PlatformModel.h"
#import "CurrencyModel.h"
/**
 具体平台
 */
@interface PlatformCell : BaseTableViewCell
//
@property (nonatomic, strong) PlatformModel *platform;
//
@property (nonatomic, strong) CurrencyModel *currency;

@end
