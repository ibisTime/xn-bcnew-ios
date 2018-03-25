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
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
