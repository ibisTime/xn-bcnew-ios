//
//  SearchCurrencyVC.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^AddCurrencyBlock)();

@interface SearchCurrencyVC : BaseViewController

@property (nonatomic, copy) AddCurrencyBlock currencyBlock;

@end
