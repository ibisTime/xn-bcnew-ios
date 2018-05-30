//
//  MyCollectionListVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

//V
#import "MyCollectionTableView.h"
//C
#import "MyCollectionListVC.h"
#import "InfoDetailVC.h"
#import "SelectScrollView.h"
#import "CollectionActivityVC.h"

@interface MyCollectionListVC ()<RefreshDelegate>
//
@property (nonatomic, strong) MyCollectionTableView *tableView;
//收藏列表
@property (nonatomic, strong) NSArray <MyCollectionModel *>*collections;

@property (nonatomic , strong)SelectScrollView *selectSV;

@end

@implementation MyCollectionListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"收藏";
    
    self.selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) itemTitles:@[@"资讯",@"活动"]];
    
    [self.view addSubview:self.selectSV];
    
    [self addsubview];
    
    [self requestCollectionList];

    [self.tableView beginRefreshing];

    
}
- (void)addsubview
{
    for (NSInteger index = 0; index < 2; index ++) {
        if (index == 1) {
            CollectionActivityVC *activity = [[CollectionActivityVC alloc]init];
            [self addChildViewController:activity];
            activity.view.frame = CGRectMake(kScreenWidth*index, 1, kScreenWidth, kSuperViewHeight  - kTabBarHeight);
            [self.selectSV.scrollView addSubview:activity.view];
        }
        else
        {
            [self initTableView];
        }
    }
}



#pragma mark - Init
- (void)initTableView {
    
    self.tableView = [[MyCollectionTableView alloc] initWithFrame:CGRectMake(0, 1, kScreenWidth, kSuperViewHeight - 40 - kTabBarHeight) style:UITableViewStylePlain];
    
//    self.tableView.frame = CGRectMake(0, 1, kScreenWidth, kSuperViewHeight - 40 - kTabBarHeight);
    
    self.tableView.refreshDelegate = self;
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无收藏"];

    [self.selectSV.scrollView addSubview:self.tableView];
    
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

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseWeakSelf;
    
    MyCollectionModel *collectionModel = self.collections[indexPath.row];
    
    InfoDetailVC *detailVC = [InfoDetailVC new];
    
    detailVC.code = collectionModel.code;
    detailVC.title = collectionModel.typeName;
    detailVC.collectionBlock = ^{
        //
        [weakSelf.tableView beginRefreshing];
    };
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
