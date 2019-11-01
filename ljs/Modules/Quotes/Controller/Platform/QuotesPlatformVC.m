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
#import "OptionalTableView.h"
//C
#import "ForumDetailVC.h"
#import "QuotesOptionalVC.h"
#import "NavigationController.h"
#import "SearchCurrencyVC.h"
#import "UIBarButtonItem+convience.h"

@interface QuotesPlatformVC ()
//
@property (nonatomic, strong) NSArray <PlatformModel *>*platforms;
//平台
//@property (nonatomic, strong) PlatformTableView *tableView;
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
//自选
@property (nonatomic, strong) OptionalTableView *tableView;
//添加
@property (nonatomic, strong) BaseView *footerView;

@property (nonatomic, assign) NSInteger percentChangeIndex;
@property (nonatomic, assign) BOOL IsFirst;
@property (nonatomic, assign) NSInteger percentTempIndex;

@end

@implementation QuotesPlatformVC
- (void)removeSubViewClass
{
    [self willMoveToParentViewController:nil];
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //头部
//    [self initHeaderView];
    //
    [self initFooterView];
    [self initTableView];
    self.tableView.optionals = self.optionals;
    self.percentTempIndex = -1;
    self.automaticallyAdjustsScrollViewInsets = NO;

    //获取自选列表
    [self addNotification];

    if ([TLUser user].isLogin == YES) {
        [self requestOptionalList];

    }
//    [self.tableView beginRefreshing];
    //获取贴吧信息
//    [self requestForumInfo];
    //添加通知
}

- (void)initFooterView {
    
    self.footerView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight)];
    
    self.footerView.backgroundColor = kWhiteColor;
    //添加按钮
    UIButton *addBtn = [UIButton buttonWithImageName:@"添加自选"];
    
    [addBtn addTarget:self action:@selector(addCurrency) forControlEvents:UIControlEventTouchUpInside];
    
    [self.footerView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(@0);
        make.width.height.equalTo(@72);
    }];
    
    UILabel *addLab = [UILabel labelWithBackgroundColor:kClearColor textColor:kHexColor(@"#FFA300") font:15];
    [self.footerView addSubview:addLab];
    addLab.text = @"暂无自选,点击添加";
    [addLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(addBtn);
        make.top.equalTo(addBtn.mas_bottom).offset(10);
    }];

}
/**
 添加币种
 */


- (void)addCurrency {
    
    BaseWeakSelf;
    [self checkLogin:^{
        [weakSelf requestOptionalList];
//        [weakSelf startTimer];

        QuotesOptionalVC *optionalVC = [QuotesOptionalVC new];
        
        optionalVC.addSuccess = ^{
            
            [weakSelf.tableView beginRefreshing];
        };
        
        [weakSelf.navigationController pushViewController:optionalVC animated:YES];
    }];
}
#pragma mark - 通知
- (void)addNotification {
    //登录后刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userIn) name:kUserLoginNotification object:nil];
    //退出登录刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userOut) name:kUserLoginOutNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSwitchLabel:) name:@"DidSwitchLabel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleBarClick:) name:@"titleBarindex" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleSameMyBarClick:) name:@"titleSameBarindex" object:nil];
}
- (void)userIn {
    
    //刷新自选列表
    self.tableView.hiddenHeader = NO;
    [self requestOptionalList];
}

- (void)userOut {
    //关闭定时器
    [self stopTimer];
    //清空数据
    [self.tableView.optionals removeAllObjects];
    [self.tableView reloadData_tl];
    [self requestOptionalList];
    self.tableView.hiddenHeader = YES;
    self.tableView.tableFooterView = self.footerView;
}


- (void)titleSameMyBarClick:(NSNotification *)notification {
    if (!self.view.userInteractionEnabled) {
        return;
    }
    if (self.currentSegmentIndex == 1 || self.currentSegmentIndex == 2) {
        return;
    }
    if (self.IsFirst == YES) {
        //第二次点击同一个跌幅榜
        self.percentChangeIndex = -1;
//        self.tableView.optionals = nil;
//        [self.tableView.optionals removeAllObjects];
//        [self.tableView reloadData];
        self.view.userInteractionEnabled = NO;
        [self requestOptionalList];
        self.IsFirst = NO;

    }else{
    NSInteger index = [notification.userInfo[@"titleSameBarindex"] integerValue];

    self.percentChangeIndex = index;
//    self.tableView.optionals = nil;
//        [self.tableView.optionals removeAllObjects];
//        [self.tableView reloadData];
        self.view.userInteractionEnabled = NO;

        [self requestOptionalList];
        self.IsFirst = YES;

    }

}

- (void)titleBarClick:(NSNotification *)notification {
    if (!self.view.userInteractionEnabled) {
        return;
    }
    if (self.currentSegmentIndex == 1 || self.currentSegmentIndex == 2) {
        return;
    }
    self.IsFirst = YES;
    
//    NSInteger index = [notification.userInfo[@"titleBarindex"] integerValue];
//    self.percentChangeIndex = index;
//    [self.tableView beginRefreshing];
    NSInteger index = [notification.userInfo[@"titleBarindex"] integerValue];
    
    NSLog(@"点击了自选的第%ld个",index);
    if (self.percentTempIndex != index) {
        
        self.percentTempIndex = index;
        self.percentChangeIndex = index;
//        self.tableView.optionals = nil;
//        [self.tableView.optionals removeAllObjects];
//        [self.tableView reloadData];
        self.view.userInteractionEnabled = NO;
        [self requestOptionalList];
    }
    else {
        if(self.IsFirst == YES) {
        
        self.percentTempIndex = index;
        self.percentChangeIndex = index;
//        self.tableView.optionals = nil;
//            [self.tableView.optionals removeAllObjects];
//            [self.tableView reloadData];
        self.view.userInteractionEnabled = NO;

        [self requestOptionalList];
            
    }
    }
}


- (void)didSwitchLabel:(NSNotification *)notification {

    NSInteger segmentIndex = [notification.userInfo[@"segmentIndex"] integerValue];
    self.currentSegmentIndex = segmentIndex;
    NSInteger labelIndex = [notification.userInfo[@"labelIndex"] integerValue];
    if (segmentIndex == 2 || segmentIndex == 1) {
        return;
    }
   
//    self.percentChangeIndex = -1;

    [self requestOptionalList];

    if (segmentIndex == self.currentSegmentIndex && segmentIndex == 3) {
        if (![TLUser user].userId) {
            return;
        }
        //刷新列表
        [self requestOptionalList];
        //刷新贴吧信息
//        [self requestForumInfo];
        //定时器刷起来
//        [self startTimer];
        return ;
    }
    //定时器停止
    [self stopTimer];
}

#pragma mark - 定时器

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
//    //进吧
//    UIButton *forumBtn = [UIButton buttonWithTitle:@"进吧"
//                                        titleColor:kWhiteColor
//                                   backgroundColor:kAppCustomMainColor
//                                         titleFont:15.0
//                                      cornerRadius:4];
//
//    [forumBtn addTarget:self action:@selector(clickForum) forControlEvents:UIControlEventTouchUpInside];
//    [self.headerView addSubview:forumBtn];
//    [forumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.centerY.equalTo(@0);
//        make.right.equalTo(@(-kWidth(25)));
//        make.width.equalTo(@87);
//        make.height.equalTo(@40);
//    }];
//    //帖子数
//    self.postNumLbl = [UILabel labelWithBackgroundColor:kClearColor
//                                              textColor:kTextColor
//                                                   font:14.0];
//    self.postNumLbl.numberOfLines = 0;
//
//    [self.headerView addSubview:self.postNumLbl];
//    [self.postNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.equalTo(self.platformNameLbl.mas_left);
//        make.top.equalTo(self.platformNameLbl.mas_bottom).offset(10);
//        make.right.equalTo(forumBtn.mas_left).offset(-15);
//    }];
//
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    UIButton *btn = [currentVC.view viewWithTag:20180618];
    [btn  removeFromSuperview];
    [self.tableView beginRefreshing];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.tableView.optionals = self.optionals;
    [self.tableView reloadData_tl];
    
    
}

- (void)initTableView {
    self.percentChangeIndex = -1;

    self.tableView = [[OptionalTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));

    }];
    BaseWeakSelf;
    self.tableView.selectBlock = ^(NSString *tosymbol) {
        weakSelf.selectBlock(tosymbol);
    };
//    self.tableView.type = self.type;
    self.tableView.refreshBlock = ^{
        weakSelf.tableView.tableFooterView = weakSelf.footerView;
//        weakSelf.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无自选"];

    };
//    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无自选"];

    self.tableView.defaultNoDataText = @"暂无自选";
    self.tableView.defaultNoDataImage = kImage(@"暂无动态");
    [self.view addSubview:self.tableView];
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.top.mas_equalTo(self.headerView.mas_bottom).offset(90);
//        make.right.equalTo(0);
//        make.left.equalTo(0);
//
//    }];
    
}

#pragma mark - Events
- (void)clickForum {
    
    ForumDetailVC *detailVC = [ForumDetailVC new];
    
    detailVC.toCoin = self.titleModel.ename;
    detailVC.type = ForumEntrancetypeQuotes;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)clickPlatformWithIndex:(NSInteger)index {

    self.titleModel = self.platformTitleList[index];
    //刷新平台列表
    [self checkLogin:^{
        [self requestOptionalList];

    }];

    //判断是否当前子控制器,是则开启定时器。否则关闭
    if (index == self.currentIndex) {
        
        //定时器开启
//        [self startTimer];
        return ;
    }
    //定时器停止
    [self stopTimer];
}

#pragma mark - Data



/**
 获取平台列表
 */

/**
 VC被释放时移除通知
 */
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startTimer {
    
    //开启定时器,实时刷新
    self.timer = [NSTimer timerWithTimeInterval:10
                                         target:self
                                       selector:@selector(refreshList)
                                       userInfo:nil
                                        repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    NSLog(@"自选定时器开启");
    
}

//定时器停止
- (void)stopTimer {
    
    [self.timer invalidate];
    self.timer = nil;
    NSLog(@"自选定时器停止");
    
}

- (void)refreshList {
    
    NSLog(@"自选定时器刷新中");
    
    BaseWeakSelf;
    
    if ([TLUser user].isLogin) {
        if (self.view.userInteractionEnabled) {
            [self.tableView beginRefreshing];

        }
    }

//    [self.helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
//
//        weakSelf.optionals = objs;
//
//        weakSelf.tableView.optionals = objs;
//
//        [weakSelf.tableView reloadData_tl];
//
//    } failure:^(NSError *error) {
//
//    }];
}

/**
 获取自选列表
 */
- (void)requestOptionalList {
    

    self.view.userInteractionEnabled = NO;
    if ([TLUser user].isLogin == NO) {
        self.tableView.tableFooterView = self.footerView;
        self.view.userInteractionEnabled = YES;
        return;
    }
    BaseWeakSelf;
    //    return;
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
   
    helper.code = @"628351";
    helper.parameters[@"start"] = @"0";
    helper.parameters[@"limit"] = @"10";
    if ([TLUser user].isLogin == YES) {
        helper.parameters[@"userId"] = [TLUser user].userId;

    }
    
    helper.tableView = self.tableView;
    helper.showView = self.view;
    
    if (weakSelf.percentChangeIndex >= 0) {
        helper.parameters[@"direction"] = [NSString stringWithFormat:@"%ld",weakSelf.percentChangeIndex];
    
    }
    helper.parameters[@"userId"] = [TLUser user].userId;
    [helper modelClass:[OptionalListModel class]];
    self.helper = helper;
    
    [self.tableView addRefreshAction:^{
        
        if (weakSelf.percentChangeIndex >= 0) {
        helper.parameters[@"direction"] = [NSString stringWithFormat:@"%ld",weakSelf.percentChangeIndex];
        }
        if ([TLUser user].isLogin == YES) {
            helper.parameters[@"userId"] = [TLUser user].userId;
            
        }
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            if (objs.count == 0) {
                weakSelf.view.userInteractionEnabled = YES;
                weakSelf.optionals = objs;
                
                weakSelf.tableView.optionals = objs;
                
                [weakSelf.tableView reloadData_tl];
                weakSelf.tableView.tableFooterView = weakSelf.footerView;
                return ;
            }
           
            weakSelf.tableView.tableFooterView = nil;
            
            weakSelf.optionals = objs;
            
            weakSelf.tableView.optionals = objs;
            
            [weakSelf.tableView reloadData_tl];
            if (weakSelf.helper.refreshed == YES) {
                weakSelf.view.userInteractionEnabled = YES;
                
                return;
            }
//            if (weakSelf.optionals.count > 0) {
//                [weakSelf startTimer];
//            }
            weakSelf.view.userInteractionEnabled = YES;
           
            
        } failure:^(NSError *error) {
            weakSelf.view.userInteractionEnabled = YES;
            [weakSelf stopTimer];
        }];
    }];
    //判断是否登录，没有登录就不能下拉刷新
//    self.tableView.hiddenHeader = ![TLUser user].isLogin;
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.optionals = objs;
            
            weakSelf.tableView.optionals = objs;
            
            [weakSelf.tableView reloadData_tl];
            weakSelf.view.userInteractionEnabled = YES;
            
        } failure:^(NSError *error) {
            weakSelf.view.userInteractionEnabled = YES;
            [weakSelf stopTimer];

        }];
    }];
    
    [self.tableView beginRefreshing];
    //添加数据
    if ([TLUser user].isLogin) {
        
        //刷新自选列表
//        [self.tableView beginRefreshing];
    } else {
        
        self.tableView.tableFooterView = self.footerView;
        weakSelf.view.userInteractionEnabled = YES;

        [weakSelf stopTimer];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
