//
//  QuotesOptionalChildVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "QuotesOptionalChildVC.h"
//Macro
//Framework
//Category
//Extension
//M
#import "OptionalModel.h"
//V
#import "AddOptionalTableView.h"

@interface QuotesOptionalChildVC ()
//自选
@property (nonatomic, strong) AddOptionalTableView *tableView;
//
@property (nonatomic, strong) NSMutableArray <OptionalModel *>*optionals;

@end

@implementation QuotesOptionalChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self initTableView];
    //获取自选列表
    [self requestOptionalList];
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[AddOptionalTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Data
/**
 获取自选列表
 */
- (void)requestOptionalList {
    
    NSMutableArray <OptionalModel *>*arr = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {
        
        OptionalModel *model = [OptionalModel new];
        
        model.symbol = @"BTC";
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
    
    self.optionals = arr;
    
    self.tableView.optionals = self.optionals;
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
