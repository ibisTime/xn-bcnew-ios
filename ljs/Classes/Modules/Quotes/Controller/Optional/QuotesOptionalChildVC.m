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

@interface QuotesOptionalChildVC ()<RefreshDelegate>
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
    //刷新自选列表
    [self.tableView beginRefreshing];
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[AddOptionalTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无选项"];

    self.tableView.type = self.titleModel.type;
    self.tableView.refreshDelegate = self;
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
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628340";

    if ([self.titleModel.type isEqualToString:kOptionalTypeCurrency]) {
        
        helper.parameters[@"coinSymbol"] = self.titleModel.ename;
    }else {
        
        helper.parameters[@"exchangeEname"] = self.titleModel.ename;
    }
    
    helper.parameters[@"userId"] = [TLUser user].userId;
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[OptionalModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.optionals = objs;
        
            weakSelf.tableView.optionals = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.optionals = objs;
            
            weakSelf.tableView.optionals = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

/**
 添加自选
 */
- (void)addOptional:(NSInteger)index {
    
    OptionalModel *optional = self.optionals[index];

    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628330";
    http.showView = self.view;
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"exchangeEname"] = optional.exchangeEname;
    http.parameters[@"coin"] = optional.coinSymbol;
    http.parameters[@"toCoin"] = optional.toCoinSymbol;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"添加成功"];
        
        optional.isChoice = @"1";
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

/**
 删除自选
 */
- (void)deleteOptional:(NSInteger)index {
    
    OptionalModel *optional = self.optionals[index];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628332";
    http.showView = self.view;
    http.parameters[@"id"] = optional.ID;
    
    [http postWithSuccess:^(id responseObject) {
        
        [TLAlert alertWithSucces:@"删除成功"];
        
        optional.isChoice = @"0";
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OptionalModel *optional = self.optionals[indexPath.row];

    if ([optional.isChoice isEqualToString:@"0"]) {
        
        //添加币种
        [self addOptional:indexPath.row];
        return ;
    }
//    //删除币种
//    [self deleteOptional:indexPath.row];
//    return ;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
