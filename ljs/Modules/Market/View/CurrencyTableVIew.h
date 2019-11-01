//
//  CurrencyTableVIew.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "CurrencyModel.h"
#import "CurrencyPriceModel.h"

typedef NS_ENUM(NSInteger, CurrencyType) {
    
    CurrencyTypePrice = 0,          //币价
    CurrencyTypeNewCurrency,        //新币
    CurrencyTypeCurrency,           //具体币种
};
typedef void(^selectCurrent)(NSString *);


@interface CurrencyTableVIew : TLTableView
//
@property (nonatomic, strong) NSArray <CurrencyModel *>*currencys;
//
@property (nonatomic, strong) NSArray <CurrencyPriceModel *>*currencyPrices;

//类型
@property (nonatomic, assign) CurrencyType type;
@property (nonatomic,copy)selectCurrent selectBlock;

@end
