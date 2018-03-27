//
//  SearchCurrcneyChildVC.h
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SearchCurrencyBlock)();

@interface SearchCurrcneyChildVC : BaseViewController

@property (nonatomic, copy) SearchCurrencyBlock currencyBlock;

@end
