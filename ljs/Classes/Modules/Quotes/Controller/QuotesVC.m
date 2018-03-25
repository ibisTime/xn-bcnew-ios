//
//  QuotesVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "QuotesVC.h"
//Macro
//Framework
//Category
#import "UIBarButtonItem+convience.h"
//Extension
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

@end

@implementation QuotesVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ([TLUser user].isLogin) {
        
        //刷新自选列表
        [self.tableView beginRefreshing];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //判断是否有选择的币种
    [self initFooterView];
    //顶部切换
    [self initSegmentView];
    //
    [self addItem];
    //获取自选列表
    [self requestOptionalList];
    //获取平台title列表
    [self requestPlatformTitleList];
    //获取平台title列表
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
    
    self.tableView = [[OptionalTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) style:UITableViewStylePlain];
    
    [self.switchSV addSubview:self.tableView];
    
}

- (void)initSelectScrollViewWithIdx:(NSInteger)idx {
    
    SelectScrollView *selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(idx*kScreenWidth, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) itemTitles:self.titles];
    
    [self.switchSV addSubview:selectSV];
    
    self.selectSV = selectSV;
}

- (void)addSubViewController {
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        //平台
        if ([self.kind isEqualToString:kPlatform]) {
            
            QuotesPlatformVC *childVC = [[QuotesPlatformVC alloc] init];
            
//            childVC.type = i == 0 ? PlatformTypeAll: (i == 1 ? PlatformTypeMoney: PlatformTypePlatform);
            
            childVC.type = PlatformTypePlatform;
            childVC.titleModel = self.platformTitleList[i];
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - kTabBarHeight);
            
            [self addChildViewController:childVC];
            
            [self.selectSV.scrollView addSubview:childVC.view];
            
        } else {
            
            //币种
            QuotesCurrencyVC *childVC = [[QuotesCurrencyVC alloc] init];
            
//            childVC.type = i == 0 ? CurrencyTypePrice: (i == 1 ? CurrencyTypeNewCurrency: CurrencyTypeCurrency);
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
    
    [self.switchSV setContentOffset:CGPointMake((index - 1) * self.switchSV.width, 0)];
    [self.labelUnil dyDidScrollChangeTheTitleColorWithContentOfSet:(index-1)*kScreenWidth];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
