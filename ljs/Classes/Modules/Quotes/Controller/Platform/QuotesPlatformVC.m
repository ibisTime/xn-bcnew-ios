//
//  QuotesPlatformVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "QuotesPlatformVC.h"

//Macro
//Framework
//Category
//Extension
//M
#import "PlatformModel.h"
#import "OptionalModel.h"
//V
#import "BaseView.h"

@interface QuotesPlatformVC ()
//
@property (nonatomic, strong) NSArray <PlatformModel *>*platforms;
//平台
@property (nonatomic, strong) PlatformTableView *tableView;
//
@property (nonatomic, strong) BaseView *headerView;
//平台名称
@property (nonatomic, strong) UILabel *platformNameLbl;
//帖子数
@property (nonatomic, strong) UILabel *postNumLbl;

@end

@implementation QuotesPlatformVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //头部
    [self initHeaderView];
    //
    [self initTableView];
    //获取平台列表
    [self requestPlatformList];
    //刷新平台列表
    [self.tableView beginRefreshing];
}

#pragma mark - Init
- (void)initHeaderView {
    
    self.headerView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 85)];
    
    self.headerView.backgroundColor = kWhiteColor;
    
    //平台名称
    self.platformNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor
                                                        font:17.0];
    self.platformNameLbl.text = self.titleModel.cname;
    [self.headerView addSubview:self.platformNameLbl];
    [self.platformNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@10);
        make.top.equalTo(@10);
    }];
    //阴影
    UIView *shadowView = [[UIView alloc] init];
    
    shadowView.backgroundColor = kWhiteColor;
    shadowView.layer.shadowColor = kAppCustomMainColor.CGColor;
    shadowView.layer.shadowOpacity = 0.8;
    shadowView.layer.shadowRadius = 2;
    shadowView.layer.shadowOffset = CGSizeMake(0, 0);
    shadowView.layer.cornerRadius = 4;
    
    [self.headerView addSubview:shadowView];
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(@0);
        make.right.equalTo(@(-kWidth(25)));
        make.width.equalTo(@87);
        make.height.equalTo(@40);
    }];
    //进吧
    UIButton *forumBtn = [UIButton buttonWithTitle:@"进吧"
                                        titleColor:kWhiteColor
                                   backgroundColor:kAppCustomMainColor
                                         titleFont:15.0
                                      cornerRadius:4];
    
    [self.headerView addSubview:forumBtn];
    [forumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(@0);
        make.right.equalTo(@(-kWidth(25)));
        make.width.equalTo(@87);
        make.height.equalTo(@40);
    }];
    //帖子数
    self.postNumLbl = [UILabel labelWithBackgroundColor:kClearColor
                                              textColor:kTextColor
                                                   font:14.0];
    self.postNumLbl.numberOfLines = 0;
    self.postNumLbl.text = @"现在有12.3万个贴在讨论,你也一起来吧!";
    
    [self.headerView addSubview:self.postNumLbl];
    [self.postNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.platformNameLbl.mas_left);
        make.top.equalTo(self.platformNameLbl.mas_bottom).offset(10);
        make.right.equalTo(forumBtn.mas_left).offset(-15);
    }];
    
}

- (void)initTableView {
    
    self.tableView = [[PlatformTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.type = self.type;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    //判断是否是具体平台
    if (self.type == PlatformTypePlatform) {
        
        self.tableView.tableHeaderView = self.headerView;
    }
}

#pragma mark - Data
/**
 获取平台列表
 */
- (void)requestPlatformList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628340";
    
    helper.parameters[@"exchangeEname"] = self.titleModel.ename;

    helper.parameters[@"userId"] = [TLUser user].userId;
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[OptionalModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.platforms = objs;
            
            weakSelf.tableView.platforms = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.platforms = objs;
            
            weakSelf.tableView.platforms = objs;
            
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
