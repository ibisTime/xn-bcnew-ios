//
//  ForumQuotesChildVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ForumQuotesChildVC.h"

//M
#import "PlatformModel.h"
#import "CurrencyModel.h"

@interface ForumQuotesChildVC ()
//行情
@property (nonatomic, strong) ForumQuotesTableView *tableView;
//
@property (nonatomic, strong) NSArray <PlatformModel *>*platforms;
@property (nonatomic, strong) NSArray <CurrencyModel *>*currencys;
@end

@implementation ForumQuotesChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self initTableView];
    
    if (self.type == ForumQuotesTypePlatform) {
        
        //获取平台行情列表
        [self requestPlatformQuotesList];
    } else {
        
        //获取币种行情列表
        [self requestCurrencyQuotesList];
    }
    
    //添加通知
    [self addNotification];
}

#pragma mark - Notification
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"RefreshForumDetail" object:nil];
    
}

- (void)refresh:(NSNotification *)notification {
    
    if (self.type == ForumQuotesTypePlatform) {
        
        //获取平台行情列表
        [self requestPlatformQuotesList];
    } else {
        
        //获取币种行情列表
        [self requestCurrencyQuotesList];
    }
}

#pragma mark - Setting
- (void)setVcCanScroll:(BOOL)vcCanScroll {
    
    _vcCanScroll = vcCanScroll;
    
    self.tableView.vcCanScroll = vcCanScroll;
    
    self.tableView.contentOffset = CGPointZero;
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[ForumQuotesTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.tag = 1800 + self.index;
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无行情"];

    self.tableView.type = self.type;

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];

}

#pragma mark - Data
- (void)requestPlatformQuotesList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628340";

    helper.parameters[@"keywords"] = self.toCoin;
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[CurrencyModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.currencys = objs;
        
        weakSelf.tableView.currencys = objs;
        
        [weakSelf.tableView reloadData_tl];
        
        if (weakSelf.refreshSuccess) {
            
            weakSelf.refreshSuccess();
        }
        
    } failure:^(NSError *error) {
        
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

- (void)requestCurrencyQuotesList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628340";
    
//    if (self.type == ForumQuotesTypeCurrency) {
//
//        helper.parameters[@"coinSymbol"] = self.toCoin;
//    }else {
//
//        helper.parameters[@"exchangeEname"] = self.toCoin;
//    }
    helper.parameters[@"keywords"] = self.toCoin;
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[CurrencyModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.currencys = objs;
        
        weakSelf.tableView.currencys = objs;
        
        [weakSelf.tableView reloadData_tl];
        
        if (weakSelf.refreshSuccess) {
            
            weakSelf.refreshSuccess();
        }
        
    } failure:^(NSError *error) {
        
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
 VC被释放时移除通知
 */
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
