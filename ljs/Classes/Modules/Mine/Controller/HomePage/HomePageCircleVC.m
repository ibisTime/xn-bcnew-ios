//
//  HomePageCircleVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "HomePageCircleVC.h"
//Macro
//Framework
//Category
#import "NSString+Extension.h"
//Extension
#import <UIImageView+WebCache.h>
//M
#import "CircleCommentModel.h"
//V
#import "HomePageHeaderView.h"
#import "HomePageCircleTableView.h"
//C

@interface HomePageCircleVC ()

//头部
@property (nonatomic, strong) HomePageHeaderView *headerView;
//
@property (nonatomic, strong) HomePageCircleTableView *tableView;
//数据
@property (nonatomic, strong) NSArray <CircleCommentModel *>*pageModels;

@end

@implementation HomePageCircleVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    // 设置导航栏背景色
    [self.navigationController.navigationBar setBackgroundImage:[kHexColor(@"#2E2E2E") convertToImage] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    //
    [self initTableView];
    //获取信息列表
    [self requestPageList];
    //
    [self.tableView beginRefreshing];
    //获取用户信息
    [self requestUserInfo];
}

#pragma mark - Init
- (void)initTableView {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = kImage(@"我的-背景");
    
    imageView.tag = 1500;
    imageView.backgroundColor = kAppCustomMainColor;
    
    [self.view addSubview:imageView];
    
    self.tableView = [[HomePageCircleTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight) style:UITableViewStyleGrouped];
    
    [self.view addSubview:self.tableView];
    
    //tableview的header
    self.headerView = [[HomePageHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
    
    self.headerView.backgroundColor = kHexColor(@"#2E2E2E");
    
    self.tableView.tableHeaderView = self.headerView;
    
}

#pragma mark - Data
/**
 评论我的和我评论的资讯分页查询
 */
- (void)requestPageList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628211";
    helper.parameters[@"userId"] = self.userId;
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[CircleCommentModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.pageModels = objs;
            
            weakSelf.tableView.pageModels = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.pageModels = objs;
            
            weakSelf.tableView.pageModels = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

/**
 获取用户信息
 */
- (void)requestUserInfo {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805121";
    http.parameters[@"userId"] = self.userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *photo = responseObject[@"data"][@"photo"];
        NSString *nickname = responseObject[@"data"][@"nickname"];
        //
        [self.headerView.userPhoto sd_setImageWithURL:[NSURL URLWithString:[photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
        
        [self.headerView.nameBtn setTitle:nickname forState:UIControlStateNormal];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
