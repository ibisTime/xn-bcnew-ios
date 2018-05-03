//
//  SearchCurrencyTableView.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TLTableView.h"
//M
#import "CurrencyModel.h"

@interface SearchCurrencyTableView : TLTableView
//
@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*currencys;

@end
