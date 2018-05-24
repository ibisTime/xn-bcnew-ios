//
//  PlatformAndOtherCell.h
//  ljs
//
//  Created by zhangfuyu on 2018/5/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "CurrencyModel.h"
#import "CurrencyPriceModel.h"

@interface PlatformAndOtherCell : BaseTableViewCell
@property (nonatomic, strong) CurrencyPriceModel *currency;

@end
