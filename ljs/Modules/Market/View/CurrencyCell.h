//
//  CurrencyCell.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseTableViewCell.h"
//M
#import "CurrencyModel.h"
#import "CurrencyPriceModel.h"
@interface CurrencyCell : BaseTableViewCell
//
@property (nonatomic, strong) CurrencyPriceModel *currency;

@end
