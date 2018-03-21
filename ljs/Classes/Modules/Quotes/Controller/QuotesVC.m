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
#import "OptionalModel.h"
//V
#import "BaseView.h"
#import "SelectScrollView.h"
#import "TopLabelUtil.h"
#import "OptionalTableView.h"
//C
#import "QuotesPlatformVC.h"
#import "QuotesCurrencyVC.h"
#import "QuotesOptionalVC.h"

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
@property (nonatomic, strong) NSArray *titles;
//类型
@property (nonatomic, strong) NSMutableArray *kinds;
//自选
@property (nonatomic, strong) OptionalTableView *tableView;
//添加
@property (nonatomic, strong) BaseView *footerView;
//
@property (nonatomic, strong) NSMutableArray <OptionalModel *>*optionals;

@end

@implementation QuotesVC

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
    //2.行情列表
    NSArray *kindArr = @[kOptional,
                         kPlatform,
                         kCurrency];
    for (int i = 0; i < titleArr.count; i++) {
        
        self.kind = kindArr[i];
        
        if ([self.kind isEqualToString:kPlatform]) {
            
            self.titles = @[@"全部", @"资金", @"OKEx", @"BigONE", @"币安", @"ZB", @"Gate", @"Bitfinex"];
            
        } else if ([self.kind isEqualToString:kCurrency]) {
            
            self.titles = @[@"币价", @"新币", @"BTC", @"BCH", @"ETH", @"LTC", @"ETC", @"XRP", @"TRX", @"RLC", @"VIEB"];
        }
        
        if ([self.kind isEqualToString:kPlatform] || [self.kind isEqualToString:kCurrency]) {
            
            //添加滚动
            [self initSelectScrollViewWithIdx:i];
            //
            [self addSubViewController];

        } else {
            //添加自选
            [self initOptionalTableView];
        }
    }
    
}

- (void)initOptionalTableView {
    
    self.tableView = [[OptionalTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) style:UITableViewStylePlain];
    
    [self.switchSV addSubview:self.tableView];
    
    self.tableView.tableFooterView = self.footerView;
}

- (void)initSelectScrollViewWithIdx:(NSInteger)idx {
    
    SelectScrollView *selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(idx*kScreenWidth, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) itemTitles:self.titles];
    
    [self.switchSV addSubview:selectSV];
    
    self.selectSV = selectSV;
}

- (void)addSubViewController {
    
    self.kinds = [NSMutableArray array];

    [self.titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([self.kind isEqualToString:kPlatform]) {
        
            
        } else {
            
            
        }
    }];
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        //平台
        if ([self.kind isEqualToString:kPlatform]) {
            
            QuotesPlatformVC *childVC = [[QuotesPlatformVC alloc] init];
            
            childVC.type = i == 0 ? PlatformTypeAll: (i == 1 ? PlatformTypeMoney: PlatformTypePlatform);
            
            childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight - 40 - kTabBarHeight);
            
            [self addChildViewController:childVC];
            
            [self.selectSV.scrollView addSubview:childVC.view];
            
        } else {
            
            //币种
            QuotesCurrencyVC *childVC = [[QuotesCurrencyVC alloc] init];
            
            childVC.type = i == 0 ? CurrencyTypePrice: (i == 1 ? CurrencyTypeNewCurrency: CurrencyTypeCurrency);
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
    
    QuotesOptionalVC *optionalVC = [QuotesOptionalVC new];
    
    [self.navigationController pushViewController:optionalVC animated:YES];
}
/**
 搜索
 */
- (void)search {
    
    
}

#pragma mark - Data
/**
 获取自选列表
 */
- (void)requestOptionalList {
    
    NSMutableArray <OptionalModel *>*arr = [NSMutableArray array];
    
    for (int i = 0; i < 10; i++) {
        
        OptionalModel *model = [OptionalModel new];
        
        model.symbol = @"BTC";
        model.platformName = @"币安";
        model.price_cny = @"90000";
        model.price_usd = @"15555";
        model.one_day_volume_cny = @"10000000";
        model.one_day_volume_usd = @"1600000";
        model.unit = @"USDT";
        model.percent_change_24h = @"50";
        
        [arr addObject:model];
    }
    
    self.optionals = arr;
    
    self.tableView.optionals = self.optionals;
    
    [self.tableView reloadData];
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
