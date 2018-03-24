//
//  MyCollectionListVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

//Macro
//Framework
//Category
//Extension
//M
//V
#import "MyCollectionTableView.h"
//C

#import "MyCollectionListVC.h"

@interface MyCollectionListVC ()
//
@property (nonatomic, strong) MyCollectionTableView *tableView;
//收藏列表
@property (nonatomic, strong) NSArray <MyCollectionModel *>*collections;

@end

@implementation MyCollectionListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收藏";
    //
    [self initTableView];
    //获取收藏列表
    [self requestCollectionList];
    //
    [self.tableView beginRefreshing];
}

#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[MyCollectionTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Data

/**
 获取收藏列表
 */
- (void)requestCollectionList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628207";
    helper.parameters[@"userId"] = [TLUser user].userId;
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[MyCollectionModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.collections = objs;
            
            weakSelf.tableView.collections = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.collections = objs;
            
            weakSelf.tableView.collections = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
