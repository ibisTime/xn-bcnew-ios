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

@interface SearchCurrcneyChildVC ()<RefreshDelegate>
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
    //刷新列表
    [self.tableView beginRefreshing];
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[SearchCurrencyTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.refreshDelegate = self;
    
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
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628326";
    
    if ([TLUser user].userId) {
        
        helper.parameters[@"userId"] = [TLUser user].userId;
    }
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[CurrencyModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.currencys = objs;
            
            weakSelf.tableView.currencys = objs;
            
            [weakSelf.tableView reloadData_tl];
            
            weakSelf.tableView.hidden = NO;
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.currencys = objs;
            
            weakSelf.tableView.currencys = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

/**
 添加自选
 */
- (void)addCurrency:(NSInteger)index {
    
    CurrencyModel *currency = self.currencys[index];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628330";
    http.showView = self.view;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"exchangeEname"] = currency.exchangeEname;
    http.parameters[@"coin"] = currency.coinSymbol;
    http.parameters[@"toCoin"] = currency.toCoinSymbol;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"添加成功"];
        
        currency.isChoice = @"1";
        
        if (self.currencyBlock) {
            
            self.currencyBlock();
        }
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (![TLUser user].isLogin) {
        
        [TLAlert alertWithInfo:@"添加自选功能需要登录后才能使用"];
        return ;
    };
    
    CurrencyModel *currency = self.currencys[indexPath.row];
    
    if ([currency.isChoice isEqualToString:@"0"]) {
        
        //添加币种
        [self addCurrency:indexPath.row];
        return ;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
