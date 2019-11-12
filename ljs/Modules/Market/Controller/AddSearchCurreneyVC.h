//
//  AddSearchCurreneyVC.h
//  ljs
//
//  Created by shaojianfei on 2018/5/29.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//
#import "CurrencyTitleModel.h"
#import "AddSearchCurreneyVC.h"
#import "BaseViewController.h"
typedef void(^AddCurrencyBlock)();


@interface AddSearchCurreneyVC : BaseViewController
@property (nonatomic, copy) AddCurrencyBlock currencyBlock;
@property (nonatomic, strong) NSArray <CurrencyTitleModel *>*currencyTitleList;
@property (nonatomic, strong) NSMutableArray <CurrencyTitleModel *>*resultTitleList;

@property (nonatomic, strong) NSMutableArray <CurrencyTitleModel *>*titles;
@property (nonatomic, strong) NSMutableArray <CurrencyTitleModel *>*tempTitles;

@property (nonatomic, strong) NSMutableArray <CurrencyTitleModel *>*bottomtitles;

@end
