//
//  QuotesVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "QuotesVC.h"
//Category
#import "UIBarButtonItem+convience.h"
//M
#import "QuotesManager.h"
#import "OptionalListModel.h"
#import "PlatformTitleModel.h"
#import "CurrencyTitleModel.h"
//V
#import "BaseView.h"
#import "SelectScrollView.h"
#import "TopLabelUtil.h"
#import "OptionalTableView.h"
//C
#import "QuotesPlatformVC.h"
#import "QuotesCurrencyVC.h"
#import "QuotesOptionalVC.h"
#import "SearchCurrencyVC.h"
#import "NavigationController.h"
#import "HomeQuotesView.h"
#import "QutesChildViewController.h"
#import "CurrencyKLineVC.h"
#import "NewSearchViewController.h"
#import "TLUserLoginVC.h"
#import "NavigationController.h"
@interface QuotesVC ()<SegmentDelegate>
//顶部切换
@property (nonatomic, strong) TopLabelUtil *labelUnil;
//大滚动
@property (nonatomic, strong) UIScrollView *switchSV;
//小滚动
@property (nonatomic, strong) SelectScrollView *selectSV;
//当前大标签索引
@property (nonatomic, assign) NSInteger currentSegmentIndex;
//类型
@property (nonatomic, copy) NSString *kind;
//
@property (nonatomic, strong) NSMutableArray *titles;
//类型
@property (nonatomic, strong) NSMutableArray *kinds;
//自选
@property (nonatomic, strong) NSMutableArray <OptionalListModel *>*optionals;

@property (nonatomic, strong) PlatformTableView *tableView;
//添加
@property (nonatomic, strong) BaseView *footerView;

//平台
@property (nonatomic, strong) NSArray <PlatformTitleModel *>*platformTitleList;
@property (nonatomic, strong) PlatformTitleModel  *platformTitleModel;

//币种
@property (nonatomic, strong) NSArray <CurrencyTitleModel *>*currencyTitleList;
//定时器
@property (nonatomic, strong) NSTimer *timer;
//
@property (nonatomic, strong) TLPageDataHelper *helper;
//当前平台索引
@property (nonatomic, assign) NSInteger platformLabelIndex;
//当前币种索引
@property (nonatomic, assign) NSInteger currencyLabelIndex;
@property (nonatomic, strong) PlatformTitleModel *titleModel;

@property (nonatomic, strong) NSArray *titleBars;
@property (nonatomic, strong) HomeQuotesView *quotesView;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, strong) BaseView *headerView;
@property (nonatomic, strong) UILabel *platformNameLbl;
@property (nonatomic, assign) PlatformType type;
@property (nonatomic, assign) NSInteger percentChangeIndex;//涨幅 跌幅

@property (nonatomic, strong) UILabel *currencyNameLbl;


@property (nonatomic, strong) NSArray <PlatformModel *>*platforms;

@end

@implementation QuotesVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.currentSegmentIndex == 1) {

        [self startCurrencyTimerWithSegmentIndex:self.currentSegmentIndex
                                      labelIndex:self.platformLabelIndex];
    } else if (self.currentSegmentIndex == 2) {

        [self startCurrencyTimerWithSegmentIndex:self.currentSegmentIndex
                                      labelIndex:self.currencyLabelIndex];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    //页面消失，所有的定时器停止
    if (self.currentSegmentIndex == 1) {
        
        [self stopTimer];
        return ;
    }
    
//    [self startCurrencyTimerWithSegmentIndex:1
//                                  labelIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //判断是否有选择的币种
    [self initFooterView];
    //顶部切换
    [self initSegmentView];
    //添加+搜索
    [self addItem];
//    [self initHeaderView];
//    [self initTableView];
   
    //获取平台title列表
    [self requestPlatformTitleList];
    //获取币种title列表
    [self requestCurrencyTitleList];
    //自选
//    [self requestOptionalList];

//    [self requestPlatform];
    [self.tableView beginRefreshing];
    //添加通知
    [self addNotification];
}

#pragma mark - addNotification
- (void)addNotification {
    //登录后刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:kUserLoginNotification object:nil];
    //退出登录刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:kUserLoginOutNotification object:nil];
    NSLog(@"%@",NSStringFromCGRect(self.tableView.frame));
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleBarClick:) name:@"titleBarindex" object:nil];
    NSLog(@"%@",NSStringFromCGRect(self.tableView.frame));
    
    
}
- (void)initHeaderView {
    
    self.headerView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
    
    self.headerView.backgroundColor = kWhiteColor;
    [self.switchSV addSubview:self.headerView];

    //币种名称
    self.currencyNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor
                                                        font:17.0];
//    self.currencyNameLbl.text = self.titles[1];
    [self.headerView addSubview:self.currencyNameLbl];
    [self.currencyNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        
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
    
}

- (void)userLogin {
    
    //刷新自选列表
//    self.tableView.hiddenHeader = NO;
    [self.tableView beginRefreshing];
}

- (void)userLogout {
    //关闭定时器
    [self stopTimer];
    //清空数据
    [self.tableView reloadData_tl];
//    self.tableView.hiddenHeader = YES;
    self.tableView.tableFooterView = self.footerView;
}

#pragma mark - Init

- (void)initFooterView {
    
    self.footerView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight)];
    
    self.footerView.backgroundColor = kWhiteColor;
    //添加按钮
    UIButton *addBtn = [UIButton buttonWithImageName:@"大加"];
    
    [addBtn addTarget:self action:@selector(addCurrency) forControlEvents:UIControlEventTouchUpInside];
    
    [self.footerView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(@0);
        make.width.height.equalTo(@72);
    }];
}

- (void)initSegmentView {
    
    self.currentSegmentIndex = 1;
    self.platformLabelIndex = 0;
    self.currencyLabelIndex = 0;
    
    NSArray *titleArr = @[
                          @"平台",
                          @"币种",
                          @"自选"];
    
    CGFloat h = 34-4;
    
    self.labelUnil = [[TopLabelUtil alloc]initWithFrame:CGRectMake(kScreenWidth/2 - kWidth(249), (44-h), kWidth(250), h)];
    
    self.labelUnil.delegate = self;
    self.labelUnil.backgroundColor = [UIColor clearColor];
    self.labelUnil.titleNormalColor = kWhiteColor;
    self.labelUnil.titleSelectColor = kAppCustomMainColor;
    self.labelUnil.titleFont = Font(16.0);
    self.labelUnil.lineType = LineTypeButtonLength;
    self.labelUnil.titleArray = titleArr;
    self.labelUnil.layer.cornerRadius = h/2.0;
    self.labelUnil.layer.borderWidth = 1;
    self.labelUnil.layer.borderColor = kWhiteColor.CGColor;
    
    self.navigationItem.titleView = self.labelUnil;
    
    //1.切换背景
    self.switchSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight)];
    [self.view addSubview:self.switchSV];
    [self.switchSV setContentSize:CGSizeMake(titleArr.count*self.switchSV.width, self.switchSV.height)];
    self.switchSV.scrollEnabled = NO;
    //2.添加自选
    self.titleBars = @[@"涨幅榜", @"跌幅榜",@"预警中"];
    self.percentChangeIndex = -1;
    self.quotesView = [[HomeQuotesView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 46) itemTitles:self.titleBars];
    [self.view addSubview:self.quotesView];
    BaseWeakSelf;
    self.quotesView.selectBlock = ^(NSInteger index) {
       
      // index 0 涨幅榜 1 跌幅榜 3预警中
        NSLog(@"点击了%ld",index);
        //点击标签
       
        if (![TLUser user].isLogin) {
            return ;
        }
        switch (index) {
            case 0:
                index = 1;
                break;
            case  1 :
                index = 0;
            default:
                break;
        }
        NSDictionary *dic = @{@"titleBarindex": @(index)};
       
        [[NSNotificationCenter defaultCenter] postNotificationName:@"titleBarindex"
                                                            object:nil
                                                          userInfo:dic];
        
        
    };
   
    int i = 0;
//    [self.selectSV setCurrentIndex:1];
    [self.switchSV setContentOffset:CGPointMake((0) * self.switchSV.width, 0)];
//    [self.labelUnil dyDidScrollChangeTheTitleColorWithContentOfSet:(i+1)*kScreenWidth];
    if (i ==1 || i == 2 || i == 0) {
        [self.quotesView setFrame:CGRectMake(0, 44, kScreenWidth, 46)];
    }else{
        [self.quotesView setFrame:CGRectMake(0, 0, kScreenWidth, 46)];
    }
//    NSInteger labelIndex = index == 2 ? self.platformLabelIndex: self.currencyLabelIndex;
//    [self startCurrencyTimerWithSegmentIndex:index labelIndex:labelIndex];
//
//    [self initOptionalTableView];
}
#pragma mark - Init

- (void)initTableView {
        
    self.tableView = [[PlatformTableView alloc] initWithFrame:CGRectMake(0, 88, kScreenWidth, kSuperViewHeight) style:UITableViewStylePlain];
    BaseWeakSelf;
    self.tableView.selectBlock = ^(NSString *idear) {
        [weakSelf pushCurrencyKLineVCWith:idear];
    };
    self.tableView.type = PlatformTypePlatform;
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无平台"];

   [self.selectSV addSubview:self.tableView];
//       self.tableView.tableHeaderView = self.headerView;
    [self requestPlatform];


    
  
}

- (void)initSelectScrollViewWithIdx:(NSInteger)idx {
    
    BaseWeakSelf;
    
    SelectScrollView *selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(idx*kScreenWidth, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) itemTitles:self.titles];
    
    selectSV.selectBlock = ^(NSInteger index) {
        if (idx == 1) {
            
            weakSelf.currencyLabelIndex = index;
        } else if (idx == 2) {
            
            weakSelf.platformLabelIndex = index;
        }
        //点击标签
        [weakSelf startCurrencyTimerWithSegmentIndex:weakSelf.currentSegmentIndex
                                          labelIndex:index];
    };
    
    [self.switchSV addSubview:selectSV];
    
    self.selectSV = selectSV;
}

- (void)addSubViewController {
    
  
    
    BaseWeakSelf;

    for (NSInteger i = 0; i < self.titles.count; i++) {
        if ([self.kind isEqualToString:kCurrency]) {
            //币种
            QuotesCurrencyVC *childVC = [[QuotesCurrencyVC alloc] init];
            childVC.selectBlock = ^(NSString *symobel) {
                [weakSelf pushCurrencyKLineVCWith:symobel];
            };
            childVC.currencyTitleList = self.currencyTitleList;
            //            childVC.type = i == 0 ? CurrencyTypePrice: (i == 1 ? CurrencyTypeNewCurrency: CurrencyTypeCurrency);
            childVC.currentIndex = i;
            childVC.type = i == 0 ? CurrencyTypePrice:  CurrencyTypeCurrency;
            if (i != 0) {
                
                childVC.titleModel = self.currencyTitleList[i - 1];
            }
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - kTabBarHeight);
            
            [self addChildViewController:childVC];
            
            [self.selectSV.scrollView addSubview:childVC.view];
           
        }
        else{
            
            
            //自选
            QuotesPlatformVC *childVC = [[QuotesPlatformVC alloc] init];
            
            
            childVC.selectBlock = ^(NSString *idsar) {
                [weakSelf pushCurrencyKLineVCWith:idsar];
            };
            //            childVC.type = i == 0 ? PlatformTypeAll: (i == 1 ? PlatformTypeMoney: PlatformTypePlatform);
            childVC.optionals = self.optionals;
            childVC.currentIndex = i;
            childVC.type = PlatformTypePlatform;
            //            childVC.titleModel = self.platformTitleList[i];
            //            childVC.optionals = self.platformTitleList;
            //            self.kind =
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - kTabBarHeight);
            
            [self addChildViewController:childVC];
            
            [self.selectSV.scrollView addSubview:childVC.view];
        }
    }
    
}

- (void)startTimer {
        
        //开启定时器,实时刷新
        self.timer = [NSTimer timerWithTimeInterval:10
                                             target:self
                                           selector:@selector(refreshPlatformList)
                                           userInfo:nil
                                            repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        NSLog(@"平台定时器开启, index = %ld", self.currentSegmentIndex);
        
    }
    
- (void)refreshPlatformList {
        NSLog(@"平台定时器刷新中, index = %ld", self.currentSegmentIndex);
        
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
        NSLog(@"平台定时器停止, index = %ld", self.currentSegmentIndex);
    }
//平台列表
- (void)requestPlatform {
        BaseWeakSelf;
    
        TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
        
        helper.code = @"628350";
    
        if (self.platformTitleModel) {
            helper.parameters[@"exchangeEname"] = self.platformTitleModel.ename;
            
        }
        helper.parameters[@"start"] = @"0";
        helper.parameters[@"limit"] = @"200";
        
        
    
        helper.tableView = self.tableView;
        [helper modelClass:[PlatformModel class]];
        
        self.helper = helper;
        
        [self.tableView addRefreshAction:^{
            if ([TLUser user].userId) {
                helper.parameters[@"userId"] = [TLUser user].userId;
                if (weakSelf.titleModel) {
                    helper.parameters[@"exchangeEname"] = weakSelf.platformTitleModel.ename;
                    
                }
                if (weakSelf.percentChangeIndex >= 0) {
                    helper.parameters[@"direction"] = [NSString stringWithFormat:@"%ld",weakSelf.percentChangeIndex];
                    }
                }
            
            [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
                if (objs.count == 0) {
                    
                    weakSelf.tableView.tableFooterView = weakSelf.footerView;

                    return ;
                }
//                weakSelf.tableView.tableFooterView = nil;

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
//        [self initHeaderView];
        [self.tableView beginRefreshing];
    }
    

#pragma mark - Events
- (void)addItem {
    //添加选择
    [UIBarButtonItem addLeftItemWithImageName:@"添加" frame:CGRectMake(0, 0, 40, 40) vc:self action:@selector(addCurrency)];
    //搜索
    [UIBarButtonItem addRightItemWithImageName:@"搜索" frame:CGRectMake(0, 0, 40, 40) vc:self action:@selector(search)];
    NSLog(@"%@",NSStringFromCGRect(self.tableView.superview.frame));
    
}

/**
 添加币种
 */

/**
 点击标签
 */
- (void)didSelectIndex:(NSInteger)index {
    
    
}

/**
 开启当前显示页面的定时器
 */
- (void)startCurrencyTimerWithSegmentIndex:(NSInteger)segmentIndex
                                labelIndex:(NSInteger)labelIndex {
    
    NSDictionary *dic = @{
                          @"segmentIndex": @(segmentIndex),
                          @"labelIndex": @(labelIndex),
                          };
    if (segmentIndex == 1) {
        //当前控制器 不需要通知
        [self segmenChildLableClick:segmentIndex :labelIndex];
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidSwitchLabel"
                                                        object:nil
                                                      userInfo:dic];
}

- (void)segmenChildLableClick: (NSInteger)segment : (NSInteger)labIndex
{
    
    NSLog(@"%@",self.titles);
    if (labIndex > self.platformTitleList.count) {
        labIndex = 0;
        
    }
    if (self.platformTitleList >= 0) {
        self.platformTitleModel = self.platformTitleList[labIndex];
        [self requestPlatform];
    }
      
}

#pragma mark - Data

- (void)titleBarClick:(NSNotification *)notification {
    
    NSInteger index = [notification.userInfo[@"titleBarindex"] integerValue];
    self.percentChangeIndex = index;
    [self requestPlatform];
}

/**
 添加币种
 */


- (void)addCurrency {
    
    BaseWeakSelf;
    [self checkLogin:^{
        
        QuotesOptionalVC *optionalVC = [QuotesOptionalVC new];
        
        optionalVC.addSuccess = ^{
            
            [weakSelf.tableView beginRefreshing];
        };
        
        [weakSelf.navigationController pushViewController:optionalVC animated:YES];
    }];
}
/**
 搜索
 */
- (void)search {
    
    BaseWeakSelf;
    
    NewSearchViewController *searchVC = [NewSearchViewController new];
    
//    searchVC.currencyBlock = ^{
//
//        [weakSelf.tableView beginRefreshing];
//    };
    
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:searchVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}
/**
 获取平台title列表
 */
- (void)requestPlatformTitleList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628317";
    helper.isList = YES;
    
    [helper modelClass:[PlatformTitleModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.platformTitleList = objs;
        
        //遍历标题
        weakSelf.titles = [NSMutableArray array];
        
        [weakSelf.platformTitleList enumerateObjectsUsingBlock:^(PlatformTitleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.cname) {
                
                [weakSelf.titles addObject:obj.cname];
                
            }
        }];
        [self initHeaderView];
        [self initSelectScrollViewWithIdx:0];
        [self initTableView];
        //添加滚动
       
       
        
    } failure:^(NSError *error) {
        
    }];
}

/**
 获取币种title列表
 */
- (void)requestCurrencyTitleList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628307";
    helper.isList = YES;
    
    [helper modelClass:[CurrencyTitleModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.currencyTitleList = objs;
        //遍历标题
        weakSelf.titles = [NSMutableArray arrayWithObject:@"全部"];
        
        [weakSelf.currencyTitleList enumerateObjectsUsingBlock:^(CurrencyTitleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.symbol) {

                [weakSelf.titles addObject:obj.symbol];
            }
        }];
        
        weakSelf.kind = kCurrency;
        
        //添加滚动
        [weakSelf initSelectScrollViewWithIdx:1];
        //

        [weakSelf addSubViewController];
        [self requestOptionalList];
    } failure:^(NSError *error) {
        
    }];
}
/**
 判断用户是否登录
 */
- (void)checkLogin:(void(^)(void))loginSuccess {
    
    if(![TLUser user].isLogin) {
        
        TLUserLoginVC *loginVC = [TLUserLoginVC new];
        
        loginVC.loginSuccess = loginSuccess;
        
        NavigationController *nav = [[NavigationController alloc] initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:nil];
        return ;
    }
    
    if (loginSuccess) {
        
        loginSuccess();
    }
}

#pragma mark - SegmentDelegate
- (void)segment:(TopLabelUtil *)segment didSelectIndex:(NSInteger)index {
//    [self.tableView beginRefreshing];

    self.currentSegmentIndex = index;
//    if (index == 1) {
//        index = 0;
//    }
//
//    [self.selectSV.scrollView setContentOffset:CGPointMake((index-1) * kScreenWidth, 0)];
    [self.switchSV setContentOffset:CGPointMake((index-1) * self.switchSV.width, 0)];
    [self.labelUnil dyDidScrollChangeTheTitleColorWithContentOfSet:(index-1)*kScreenWidth];
    if (index ==1 || index == 2 || index == 0) {
        [self.quotesView setFrame:CGRectMake(0, 44, kScreenWidth, 46)];
    }else{
        [self.quotesView setFrame:CGRectMake(0, 0, kScreenWidth, 46)];

        
    }
    
    //1:自选, 不是自选就停止定时器
    if (index == 1) {
        //开启自选定时器
//        [self startTimer];
        
//        return ;
    }
    
    NSInteger labelIndex = index == 2 ? self.platformLabelIndex: self.currencyLabelIndex;
    [self startCurrencyTimerWithSegmentIndex:index labelIndex:labelIndex];
    //自选定时器停止
    [self stopTimer];
    
    NSLog(@"点击了%ld",labelIndex);
}
/*
获取自选列表
*/
- (void)requestOptionalList {
    
    BaseWeakSelf;
    //    return;
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    weakSelf.kind = kOptional;
    self.titles = [NSMutableArray arrayWithObjects:@"自选", nil];

    helper.code = @"628351";
    helper.parameters[@"start"] = @"0";
    helper.parameters[@"limit"] = @"100";
    [weakSelf initSelectScrollViewWithIdx:2];
    [weakSelf addSubViewController];
    [self requestPlatformTitleList];
    helper.parameters[@"userId"] = [TLUser user].userId;
    if (![TLUser user].userId) {
        return;
    }
    if (weakSelf.percentChangeIndex >= 0) {
        helper.parameters[@"direction"] = [NSString stringWithFormat:@"%ld",weakSelf.percentChangeIndex];
        
    }
    helper.tableView = self.tableView;
    
//    helper.isList = YES;


    [helper modelClass:[OptionalListModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        if (objs.count == 0) {
            
            return ;
        }
        
        weakSelf.optionals = objs;
        //遍历标题
        weakSelf.titles = [NSMutableArray array];
        weakSelf.kind = kOptional;
        [weakSelf.currencyTitleList enumerateObjectsUsingBlock:^(CurrencyTitleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.symbol) {
                
                [weakSelf.titles addObject:obj.symbol];
            }
        }];
        
        //添加滚动
       
        
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

- (void)pushCurrencyKLineVCWith:(NSString *)idear
{
    CurrencyKLineVC *kineVC = [[CurrencyKLineVC alloc]init];
    kineVC.symbolID = idear;
    [self.navigationController pushViewController:kineVC animated:YES];
}

@end
