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
@property (nonatomic, strong) OptionalTableView *tableView;
//添加
@property (nonatomic, strong) BaseView *footerView;
//自选列表
@property (nonatomic, strong) NSMutableArray <OptionalListModel *>*optionals;
//平台
@property (nonatomic, strong) NSArray <PlatformTitleModel *>*platformTitleList;
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

@end

@implementation QuotesVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ([TLUser user].isLogin) {
        
        //刷新自选列表
        [self.tableView beginRefreshing];
    }
    
    if (self.currentSegmentIndex == 2) {
        
        [self startCurrencyTimerWithSegmentIndex:self.currentSegmentIndex
                                      labelIndex:self.platformLabelIndex];
    } else if (self.currentSegmentIndex == 3) {
        
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
    
    [self startCurrencyTimerWithSegmentIndex:1
                                  labelIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //判断是否有选择的币种
    [self initFooterView];
    //顶部切换
    [self initSegmentView];
    //添加+搜索
    [self addItem];
    //获取自选列表
    [self requestOptionalList];
    //获取平台title列表
    [self requestPlatformTitleList];
    //获取币种title列表
    [self requestCurrencyTitleList];
}

#pragma mark - Init
- (void)addItem {
    //添加选择
    [UIBarButtonItem addLeftItemWithImageName:@"添加" frame:CGRectMake(0, 0, 40, 40) vc:self action:@selector(addCurrency)];
    //搜索
    [UIBarButtonItem addRightItemWithImageName:@"搜索" frame:CGRectMake(0, 0, 40, 40) vc:self action:@selector(search)];
}

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
                          @"自选",
                          @"平台",
                          @"币种"];
    
    CGFloat h = 34;
    
    self.labelUnil = [[TopLabelUtil alloc]initWithFrame:CGRectMake(kScreenWidth/2 - kWidth(249), (44-h), kWidth(248), h)];
    
    self.labelUnil.delegate = self;
    self.labelUnil.backgroundColor = [UIColor clearColor];
    self.labelUnil.titleNormalColor = kWhiteColor;
    self.labelUnil.titleSelectColor = kAppCustomMainColor;
    self.labelUnil.titleFont = Font(18.0);
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
    [self initOptionalTableView];
}

- (void)initOptionalTableView {
    
    BaseWeakSelf;
    
    self.tableView = [[OptionalTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) style:UITableViewStylePlain];
    
    self.tableView.refreshBlock = ^{
        
        [weakSelf.tableView beginRefreshing];
    };
    
    [self.switchSV addSubview:self.tableView];
    
}

- (void)initSelectScrollViewWithIdx:(NSInteger)idx {
    
    BaseWeakSelf;
    
    SelectScrollView *selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(idx*kScreenWidth, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) itemTitles:self.titles];
    
    selectSV.selectBlock = ^(NSInteger index) {
        
        if (idx == 1) {
            
            weakSelf.platformLabelIndex = index;
        } else if (idx == 2) {
            
            weakSelf.currencyLabelIndex = index;
        }
        //点击标签
        [weakSelf startCurrencyTimerWithSegmentIndex:weakSelf.currentSegmentIndex
                                          labelIndex:index];
    };
    
    [self.switchSV addSubview:selectSV];
    
    self.selectSV = selectSV;
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        //平台
        if ([self.kind isEqualToString:kPlatform]) {
            
            QuotesPlatformVC *childVC = [[QuotesPlatformVC alloc] init];
            
//            childVC.type = i == 0 ? PlatformTypeAll: (i == 1 ? PlatformTypeMoney: PlatformTypePlatform);
            
            childVC.currentIndex = i;
            childVC.type = PlatformTypePlatform;
            childVC.titleModel = self.platformTitleList[i];
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - kTabBarHeight);
            
            [self addChildViewController:childVC];
            
            [self.selectSV.scrollView addSubview:childVC.view];
        } else {
            
            //币种
            QuotesCurrencyVC *childVC = [[QuotesCurrencyVC alloc] init];
            
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
    }
}

- (void)startTimer {
    
    //开启定时器,实时刷新
    self.timer = [NSTimer timerWithTimeInterval:10
                                         target:self
                                       selector:@selector(refreshOptionalList)
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

- (void)refreshOptionalList {
    
    NSLog(@"自选定时器刷新中");

    BaseWeakSelf;
    
    [self.helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.optionals = objs;

        weakSelf.tableView.optionals = objs;
        
        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Events
/**
 添加币种
 */
- (void)addCurrency {
    
    BaseWeakSelf;
    [self checkLogin:^{
        
        QuotesOptionalVC *optionalVC = [QuotesOptionalVC new];
        
        [weakSelf.navigationController pushViewController:optionalVC animated:YES];
    }];
}
/**
 搜索
 */
- (void)search {
    
    BaseWeakSelf;
    
    SearchCurrencyVC *searchVC = [SearchCurrencyVC new];
    
    searchVC.currencyBlock = ^{
        
        [weakSelf.tableView beginRefreshing];
    };
    
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:searchVC];
    
    [self presentViewController:nav animated:YES completion:nil];
}

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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidSwitchLabel"
                                                        object:nil
                                                      userInfo:dic];
}

#pragma mark - Data
/**
 获取自选列表
 */
- (void)requestOptionalList {
    
    if (![TLUser user].isLogin) {
        
        self.tableView.tableFooterView = self.footerView;
        return ;
    }
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628336";
    
    if ([TLUser user].isLogin) {
        
        helper.parameters[@"userId"] = [TLUser user].userId;
    }
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[OptionalListModel class]];
    self.helper = helper;
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            if (objs.count == 0) {
                
                weakSelf.tableView.tableFooterView = weakSelf.footerView;
                return ;
            }
            
            weakSelf.tableView.tableFooterView = nil;
            
            weakSelf.optionals = objs;
            
            weakSelf.tableView.optionals = objs;
            
            [weakSelf.tableView reloadData_tl];
            
            if (weakSelf.currentSegmentIndex == 1) {
                //定时器开启
                [weakSelf startTimer];
            }
            
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
        
        weakSelf.kind = kPlatform;

        //添加滚动
        [weakSelf initSelectScrollViewWithIdx:1];
        //
        [weakSelf addSubViewController];
        
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
        weakSelf.titles = [NSMutableArray arrayWithObject:@"币价"];
        
        [weakSelf.currencyTitleList enumerateObjectsUsingBlock:^(CurrencyTitleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.symbol) {

                [weakSelf.titles addObject:obj.symbol];
            }
        }];
        
        weakSelf.kind = kCurrency;
        
        //添加滚动
        [weakSelf initSelectScrollViewWithIdx:2];
        //
        [weakSelf addSubViewController];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - SegmentDelegate
- (void)segment:(TopLabelUtil *)segment didSelectIndex:(NSInteger)index {
    
    self.currentSegmentIndex = index;
    
    [self.switchSV setContentOffset:CGPointMake((index - 1) * self.switchSV.width, 0)];
    [self.labelUnil dyDidScrollChangeTheTitleColorWithContentOfSet:(index-1)*kScreenWidth];
    
    //1:自选, 不是自选就停止定时器
    if (index == 1) {
        //开启自选定时器
        [self startTimer];
        
        return ;
    }
    
    NSInteger labelIndex = index == 2 ? self.platformLabelIndex: self.currencyLabelIndex;
    [self startCurrencyTimerWithSegmentIndex:index labelIndex:labelIndex];
    //自选定时器停止
    [self stopTimer];
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
