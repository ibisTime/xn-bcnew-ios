//
//  CurrencyInfoChildVC.m
//  bige
//
//  Created by 蔡卓越 on 2018/4/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CurrencyInfoChildVC.h"

//V
#import "CurrencyInfoHeaderView.h"
#import "CurrencyInfoTableView.h"

@interface CurrencyInfoChildVC ()
//简介
@property (nonatomic, strong) CurrencyInfoHeaderView *introduceView;
//
@property (nonatomic, strong) CurrencyInfoTableView *tableView;

@end

@implementation CurrencyInfoChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //简介
    [self initIntroduceView];
    //
    [self initTableView];
}

#pragma mark - Setting
- (void)setVcCanScroll:(BOOL)vcCanScroll {
    
    _vcCanScroll = vcCanScroll;
    
    self.tableView.vcCanScroll = vcCanScroll;
    
    self.tableView.contentOffset = CGPointZero;
}

#pragma mark - Init
- (void)initIntroduceView {
    
    BaseWeakSelf;
    
    self.introduceView = [[CurrencyInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    
    self.introduceView.platform = self.platform;

    self.introduceView.refreshHeaderBlock = ^{
        
        weakSelf.tableView.tableHeaderView = weakSelf.introduceView;
    };
    
    self.introduceView.backgroundColor = kWhiteColor;

}

- (void)initTableView {
    
    self.tableView = [[CurrencyInfoTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.platform = self.platform;
    self.tableView.tag = 1802;

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    
    self.tableView.tableHeaderView = self.introduceView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
