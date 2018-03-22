//
//  SearchCurrcneyChildVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SearchCurrcneyChildVC.h"

//Macro
//Framework
//Category
//Extension
//M
#import "CurrencyModel.h"
//V
#import "SearchCurrencyTableView.h"

@interface SearchCurrcneyChildVC ()
//搜索
@property (nonatomic, strong) SearchCurrencyTableView *tableView;
//
@property (nonatomic, strong) NSMutableArray <CurrencyModel *>*currencys;
@end

@implementation SearchCurrcneyChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self initTableView];
    //获取币种列表
    [self requestCurrencyList];
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[SearchCurrencyTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Data
/**
 获取币种列表
 */
- (void)requestCurrencyList {
    
    NSMutableArray <CurrencyModel *>*arr = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {
        
        CurrencyModel *model = [CurrencyModel new];
        
        model.symbol = @"BTC";
        model.unit = @"USDT";
        model.platformName = @"币安";
        model.price_cny = @"90000";
        model.price_usd = @"15555";
        model.one_day_volume_cny = @"10000000";
        model.one_day_volume_usd = @"1600000";
        model.unit = @"USDT";
        model.percent_change_24h = @"50";
        model.isSelect = NO;
        
        [arr addObject:model];
    }
    
    self.currencys = arr;
    
    self.tableView.currencys = self.currencys;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
