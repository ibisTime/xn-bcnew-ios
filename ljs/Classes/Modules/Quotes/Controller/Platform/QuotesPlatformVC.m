//
//  QuotesPlatformVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "QuotesPlatformVC.h"

//M
#import "PlatformModel.h"
#import "OptionalModel.h"
//V
#import "BaseView.h"
//C
#import "ForumDetailVC.h"

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
//定时器
@property (nonatomic, strong) NSTimer *timer;
//
@property (nonatomic, strong) TLPageDataHelper *helper;

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
    //获取贴吧信息
    [self requestForumInfo];
    //添加通知
    [self addNotification];
}

#pragma mark - 通知
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSwitchLabel:) name:@"DidSwitchLabel" object:nil];
}

- (void)didSwitchLabel:(NSNotification *)notification {
    
    NSInteger segmentIndex = [notification.userInfo[@"segmentIndex"] integerValue];
    
    NSInteger labelIndex = [notification.userInfo[@"labelIndex"] integerValue];

    if (labelIndex == self.currentIndex && segmentIndex == 2) {
        //刷新列表
        [self.tableView beginRefreshing];
        //刷新贴吧信息
        [self requestForumInfo];
        //定时器刷起来
        [self startTimer];
        return ;
    }
    //定时器停止
    [self stopTimer];
}

#pragma mark - 定时器
- (void)startTimer {
    
    //开启定时器,实时刷新
    self.timer = [NSTimer timerWithTimeInterval:10
                                         target:self
                                       selector:@selector(refreshPlatformList)
                                       userInfo:nil
                                        repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    NSLog(@"平台定时器开启, index = %ld", self.currentIndex);

}

- (void)refreshPlatformList {
    NSLog(@"平台定时器刷新中, index = %ld", self.currentIndex);

    BaseWeakSelf;
    //刷新平台列表
    [self.helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.platforms = objs;
        
        weakSelf.tableView.platforms = objs;
        
        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
    }];
}

//定时器停止
- (void)stopTimer {
    
    [self.timer invalidate];
    self.timer = nil;
    NSLog(@"平台定时器停止, index = %ld", self.currentIndex);
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
    
    [forumBtn addTarget:self action:@selector(clickForum) forControlEvents:UIControlEventTouchUpInside];
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
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无平台"];

    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    
}

#pragma mark - Events
- (void)clickForum {
    
    ForumDetailVC *detailVC = [ForumDetailVC new];
    
    detailVC.toCoin = self.titleModel.ename;
    detailVC.type = ForumEntrancetypeQuotes;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)clickPlatformWithIndex:(NSInteger)index {

    //刷新平台列表
    [self.tableView beginRefreshing];
    //判断是否当前子控制器,是则开启定时器。否则关闭
    if (index == self.currentIndex) {
        
        //定时器开启
        [self startTimer];
        return ;
    }
    //定时器停止
    [self stopTimer];
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
    
    self.helper = helper;
    
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

- (void)requestForumInfo {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628850";
    http.parameters[@"toCoin"] = self.titleModel.ename;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.postNumLbl.text = [NSString stringWithFormat:@"现在有%@个贴在讨论,你也一起来吧!", responseObject[@"data"][@"totalCount"]];
        //判断贴吧是否存在并且是具体平台
        NSString *isExist = responseObject[@"data"][@"isExistPlate"];
        
        if ([isExist isEqualToString:@"1"] && (self.type == PlatformTypePlatform)) {
            
            self.tableView.tableHeaderView = self.headerView;
            return ;
        }
        self.tableView.tableHeaderView = nil;
        
    } failure:^(NSError *error) {
        
    }];
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
