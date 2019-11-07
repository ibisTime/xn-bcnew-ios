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
#import <MBProgressHUD.h>
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
#import "MaskShowView.h"
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
#import "QuotesPlatForm.h"
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
@property (nonatomic, strong) NSMutableArray <CurrencyTitleModel *>*currencyTitleList;
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
@property (nonatomic, assign) NSInteger percentTempIndex;//涨幅 跌幅
@property (nonatomic, assign) BOOL percentLabStatus;//涨幅 跌幅

@property (nonatomic, strong) UILabel *currencyNameLbl;
@property (nonatomic, assign) BOOL IsFirst;

@property (nonatomic, strong) MBProgressHUD *MbHud;


@property (nonatomic, strong) NSArray <PlatformModel *>*platforms;
@property (nonatomic, strong) QuotesCurrencyVC *CurrencyVC;
@property (nonatomic, strong) QuotesPlatformVC *PlatformVC;
@property (nonatomic, strong) QuotesPlatForm *Platform;
@property (nonatomic, strong) NSMutableArray <QuotesCurrencyVC *>*CurrencyVCs;
@property (nonatomic, strong) NSMutableArray <QuotesPlatformVC *>*PlatformVCs;
@property (nonatomic, strong) NSMutableArray <QuotesPlatForm *>*forms;

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

    if (1) {
        [self.MbHud show:YES];

        [self requestPlatformTitleList];
        //获取币种title列表
        [self requestCurrencyTitleList];
    }
    //自选
//    [self requestOptionalList];

//    [self requestPlatform];
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
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleSameHomeBarClick:) name:@"titleSameBarindex" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(choseOptionList:) name:@"choseOptionList" object:nil];
    
    
}

- (void)chose
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    self.currencyTitleList  =[NSMutableArray array];
    NSData *data = [user objectForKey:@"choseOptionList"];
    self.currencyTitleList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //    self.currencyTitleList = notification.userInfo[@"choseOptionList"];
    CurrencyTitleModel *title = [CurrencyTitleModel new];
    title.symbol = @"";
    [self.currencyTitleList addObject:title];
    
    NSLog(@"currencyTitleList%@",self.currencyTitleList);
    
    self.titles = [NSMutableArray arrayWithObject:@"全部"];
    if (self.currencyTitleList.count > 1) {
        [self.currencyTitleList enumerateObjectsUsingBlock:^(CurrencyTitleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.symbol) {
                
                [self.titles addObject:obj.symbol];
            }
        }];
    }
}

- (void)choseOptionList : (NSNotification *)notification
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    self.currencyTitleList  =[NSMutableArray array];
    NSData *data = [user objectForKey:@"choseOptionList"];
    self.currencyTitleList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    self.currencyTitleList = notification.userInfo[@"choseOptionList"];
    CurrencyTitleModel *title = [CurrencyTitleModel new];
    title.symbol = @"";
    [self.currencyTitleList addObject:title];

    NSLog(@"currencyTitleList%@",self.currencyTitleList);
    
    for (QuotesCurrencyVC*vc in self.CurrencyVCs) {
        
        [vc removeSubViewClass];
    }
    for (QuotesPlatformVC*vc in self.PlatformVCs) {
        
        [vc removeSubViewClass];
    }for (QuotesPlatForm*vc in self.forms) {
        
        [vc removeSubViewClass];
    }
    
//    [self.switchSV removeFromSuperview];
//
//    [self.titles removeAllObjects];
    self.titles = [NSMutableArray arrayWithObject:@"全部"];
    if (self.currencyTitleList.count > 0) {
        [self.currencyTitleList enumerateObjectsUsingBlock:^(CurrencyTitleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.symbol) {
                
                [self.titles addObject:obj.symbol];
            }
        }];
    }
//    self.switchSV = nil;
//    self.selectSV = nil;
//    [self.switchSV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    [self.selectSV.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    
    [self initFooterView];
    
    //顶部切换
    [self initSegmentView];
    [self.MbHud show:YES];
    [self addItem];
    [self requestPlatformTitleList];
    self.kind = kCurrency;

    [self initSelectScrollViewIdx:1];
    //
    
    [self addSubViewController];
    [self requestOptionalList];
    [self addNotification];
    
    //添加滚动
//    [self segment:self.labelUnil didSelectIndex:2];

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
    MBProgressHUD *hud =[[MBProgressHUD alloc] init];
    [self.view addSubview:hud];
    self.MbHud = hud;
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
    self.CurrencyVCs = [NSMutableArray array];
    self.PlatformVCs = [NSMutableArray array];
    self.forms = [NSMutableArray array];

    
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
    self.labelUnil.backgroundColor = kWhiteColor;
    self.labelUnil.titleNormalColor = kTextColor;
    self.labelUnil.titleSelectColor = kAppCustomMainColor;
    self.labelUnil.titleFont = Font(16.0);
    self.labelUnil.lineType = LineTypeButtonLength;
    self.labelUnil.titleArray = titleArr;
    self.labelUnil.layer.cornerRadius = h/2.0;
    self.labelUnil.layer.borderWidth = 1;
    self.labelUnil.backgroundColor = kWhiteColor;
    self.labelUnil.titleNormalColor = kTextColor;
    self.labelUnil.titleSelectColor = kAppCustomMainColor;
    self.labelUnil.layer.borderColor = kLineColor.CGColor;
    
    self.navigationItem.titleView = self.labelUnil;
    self.percentTempIndex = -1;
    
    //1.切换背景
    self.switchSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight)];
    [self.view addSubview:self.switchSV];
    [self.switchSV setContentSize:CGSizeMake(titleArr.count*self.switchSV.width, self.switchSV.height)];
    self.switchSV.scrollEnabled = NO;
    //2.添加自选
    self.titleBars = @[@"市值榜", @"涨跌榜",@"成交榜"];
    self.percentChangeIndex = -1;
    self.quotesView = [[HomeQuotesView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 46) itemTitles:self.titleBars];
    [self.view addSubview:self.quotesView];
    BaseWeakSelf;
    self.quotesView.selectBlock = ^(NSInteger index) {
       
     
        NSLog(@"点击了%ld",index);
       
        weakSelf.percentTempIndex = -1;
        //点击标签
        if (index == 2) {
            [weakSelf checkLogin:nil];
            if (![TLUser user].isLogin) {
                return ;
            }
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
        if (weakSelf.percentTempIndex == index) {
            return ;
        }
        NSDictionary *dic = @{@"titleBarindex": @(index),@"segment": @(weakSelf.currentSegmentIndex)};
       
//        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"titleBarindex" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"titleBarindex"
                                                            object:nil
                                                          userInfo:dic];
    };
    self.quotesView.selectSameBlock = ^(NSInteger ind) {
        if (ind == 2) {
            if (![TLUser user].isLogin) {
                [weakSelf checkLogin:nil];

                return ;
            }
        }
        switch (ind) {
            case 0:
                ind = 1;
                break;
            case  1 :
                ind = 0;
            default:
                break;
        }
        weakSelf.percentLabStatus = NO;
        weakSelf.percentTempIndex = ind;
        NSLog(@"点击了相同的lable%ld",ind);
        weakSelf.percentChangeIndex =-1;
        NSDictionary *dic = @{@"titleSameBarindex": @(ind),@"segment": @(weakSelf.currentSegmentIndex)};

//        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"titleSameBarindex" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"titleSameBarindex"
                                                            object:nil
                                                          userInfo:dic];
        if (weakSelf.currentSegmentIndex == 2 || weakSelf.currentSegmentIndex == 3) {
            return ;
        }
//        [weakSelf requestPlatform];
    };
//    int i = 0;
//    [self.switchSV setContentOffset:CGPointMake((0) * self.switchSV.width, 0)];
//    if (i ==1 || i == 2 || i == 0) {
//        [self.quotesView setFrame:CGRectMake(0, 44, kScreenWidth, 46)];
//    }else{
//        [self.quotesView setFrame:CGRectMake(0, 0, kScreenWidth, 46)];
//    }
//    NSInteger labelIndex = index == 2 ? self.platformLabelIndex: self.currencyLabelIndex;
//    [self startCurrencyTimerWithSegmentIndex:index labelIndex:labelIndex];
//
//    [self initOptionalTableView];
}
#pragma mark - Init

- (void)initTableView {
        
    self.tableView = [[PlatformTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    BaseWeakSelf;
    [self.selectSV addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(88, 0, 0, 0));
    }];

    self.tableView.selectBlock = ^(NSString *idear) {
        [weakSelf pushCurrencyKLineVCWith:idear];
    };
    self.tableView.pagingEnabled = false;
    self.tableView.type = PlatformTypePlatform;
//    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无平台"];
    self.tableView.defaultNoDataText = @"暂无币种";
    self.tableView.defaultNoDataImage = kImage(@"暂无动态");
   [self.selectSV addSubview:self.tableView];
//       self.tableView.tableHeaderView = self.headerView;
//    [self requestPlatform];


    
  
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

- (void)initSelectScrollViewIdx:(NSInteger)idx {
    
    BaseWeakSelf;
   
    SelectScrollView *selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(idx*kScreenWidth, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) itemTitles:self.titles];
//    selectSV.IsUserList = YES;
    selectSV.selectBlock = ^(NSInteger index) {
        if (index == 1) {
            
            weakSelf.currencyLabelIndex = index;
        } else if (index == 2) {
            
            weakSelf.platformLabelIndex = index;
        }
        //点击标签
        [weakSelf startCurrencyTimerWithSegmentIndex:weakSelf.currentSegmentIndex
                                          labelIndex:index];
    };
    
    [self.switchSV addSubview:selectSV];
    
    self.selectSV = selectSV;
//    self.selectSV.scrollView.pagingEnabled = false;
}

- (void)addSubViewController {
    
  
    
    BaseWeakSelf;

    for (NSInteger i = 0; i < self.titles.count; i++) {
        if ([self.kind isEqualToString:kCurrency]) {
            //币种
            QuotesCurrencyVC *childVC = [[QuotesCurrencyVC alloc] init];
            self.CurrencyVC = childVC;
            childVC.currentSegmentIndex = 2;
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
            [self.CurrencyVCs addObject:childVC];
            [self.selectSV.scrollView addSubview:childVC.view];
           
        }else if ([self.kind isEqualToString:kOptional])
        {
            
            //自选
            QuotesPlatformVC *childVC = [[QuotesPlatformVC alloc] init];
            childVC.currentSegmentIndex = 3;
            self.PlatformVC = childVC;
            childVC.smallBtn = self.smallBtn;
            childVC.smallBtn.hidden = YES;

            [self.PlatformVCs addObject:childVC];

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
        else{
            
            
            //平台
            QuotesPlatForm *childVC = [[QuotesPlatForm alloc] init];
            childVC.currentSegmentIndex = 1;
            
            [self.forms addObject:childVC];

            childVC.seleBlock  = ^(NSString *idsar) {
                [weakSelf pushCurrencyKLineVCWith:idsar];
            };
            //            childVC.type = i == 0 ? PlatformTypeAll: (i == 1 ? PlatformTypeMoney: PlatformTypePlatform);
            childVC.platformTitleList = self.platformTitleList;
            childVC.platformTitleModel = childVC.platformTitleList[i];

            childVC.currentIndex = i;
//            childVC.type = PlatformTypePlatform;
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
        self.helper.showView =self.view;
        [self.tableView beginRefreshing];
        //刷新平台列表
//        [self.helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
//
//            weakSelf.platforms = objs;
//
//            weakSelf.tableView.platforms = objs;
//
//            [weakSelf.tableView reloadData_tl];
//
//        } failure:^(NSError *error) {
//
//        }];
    }
    
    //定时器停止
- (void)stopTimer {
        
        [self.timer invalidate];
        self.timer = nil;
        NSLog(@"平台定时器停止, index = %ld", self.currentSegmentIndex);
    }
//平台列表

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"])
    {
        NSValue *oldvalue = change[NSKeyValueChangeOldKey];
        NSValue *newvalue = change[NSKeyValueChangeNewKey];
        CGFloat oldoffset_y = oldvalue.UIOffsetValue.vertical;
        CGFloat newoffset_y = newvalue.UIOffsetValue.vertical;
        
        NSLog(@"self.tableView.contentSize%fself.tableView.contentSize%f",oldoffset_y,newoffset_y);

    }
    
    
}
- (void)requestPlatform {
//    [self.tableView addObserver: self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        BaseWeakSelf;
    [self.MbHud show:YES];
    self.view.userInteractionEnabled = NO;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"628350";
    for (SelectScrollView *selectview in self.view.subviews) {
        helper.showView = selectview;
    }
    
        if (self.platformTitleModel) {
            helper.parameters[@"exchangeEname"] = self.platformTitleModel.ename;
            
        }
        helper.parameters[@"start"] = @"0";
        helper.parameters[@"limit"] = @"100";
    if ([TLUser user].userId) {
        helper.parameters[@"userId"] = [TLUser user].userId;
        
    }
        if (weakSelf.titleModel) {
            helper.parameters[@"exchangeEname"] = weakSelf.platformTitleModel.ename;
            
        }
        if (weakSelf.percentChangeIndex >= 0) {
            helper.parameters[@"direction"] = [NSString stringWithFormat:@"%ld",weakSelf.percentChangeIndex];
        }
    
        
    
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
//                [weakSelf.MbHud hide:YES];
                weakSelf.platforms = objs;
                
                weakSelf.tableView.platforms = objs;
                
                [weakSelf.tableView reloadData_tl];
                CGFloat y = weakSelf.tableView.frame.origin.y;
                weakSelf.view.userInteractionEnabled = YES;
                NSLog(@"contenOffSet%@contenSize%@",NSStringFromCGPoint(weakSelf.tableView.contentOffset),NSStringFromCGSize(weakSelf.tableView.contentSize));
//                [weakSelf.tableView setContentOffset:CGPointMake(0, -54)];
            } failure:^(NSError *error) {
//                [weakSelf.MbHud hide:YES];
                weakSelf.view.userInteractionEnabled = YES;

            }];
        }];
        
        [self.tableView addLoadMoreAction:^{
            
            [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
                
                weakSelf.platforms = objs;
                
                weakSelf.tableView.platforms = objs;
                
                [weakSelf.tableView reloadData_tl];
                [weakSelf.tableView setContentOffset:CGPointMake(0, -54)];
                weakSelf.view.userInteractionEnabled = YES;

            } failure:^(NSError *error) {
                [weakSelf.MbHud hide:YES];
                weakSelf.view.userInteractionEnabled = YES;

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
//        [self segmenChildLableClick:segmentIndex :labelIndex];
        
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"DidSwitchLabel" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidSwitchLabel"
                                                        object:nil
                                                      userInfo:dic];
}

- (void)segmenChildLableClick: (NSInteger)segment : (NSInteger)labIndex
{
    if (!self.view.userInteractionEnabled) {
        return;
    }
    if (self.currentSegmentIndex == 2 || self.currentSegmentIndex == 3) {
        return;
    }
    NSLog(@"%@",self.titles);
    if (labIndex >= self.platformTitleList.count) {
        labIndex = 0;
        
    }
    
    if (self.platformTitleList >= 0 && self.platformTitleList) {
        self.platformTitleModel = self.platformTitleList[labIndex];
//                [self.tableView beginRefreshing];
//                [self requestPlatform];

    }else{
//        [self.tableView beginRefreshing];

        return;
    }
 
    
//    [self stopTimer];
    
}

#pragma mark - Data
- (void)titleSameHomeBarClick:(NSNotification *)notification {
    if (!self.view.userInteractionEnabled) {
        return;
    }
    if (self.currentSegmentIndex == 2 || self.currentSegmentIndex == 3) {
        return;
    }
    [self.MbHud show:YES];

    if (self.IsFirst == YES) {
        //第二次点击同一个跌幅榜
        self.percentChangeIndex = -1;
//        [self requestPlatform];
        [self.MbHud hide:YES];

        self.IsFirst = NO;
        
    }else{
        NSInteger index = [notification.userInfo[@"titleSameBarindex"] integerValue];
        
        self.percentChangeIndex = index;
//        [self requestPlatform];
        [self.MbHud hide:YES];

        self.IsFirst = YES;
        
    }
    
}
- (void)titleBarClick:(NSNotification *)notification {
    if (!self.view.userInteractionEnabled) {
        return;
    }
    if (self.currentSegmentIndex == 2 || self.currentSegmentIndex == 3) {
        return;
    }
    [self.MbHud show:YES];

//    if (self.currentSegmentIndex == 3 || self.currentSegmentIndex == 2) {
//        return;
//    }
    self.IsFirst = YES;
    
    NSInteger index = [notification.userInfo[@"titleBarindex"] integerValue];
    
    NSLog(@"点击了自选的第%ld个",index);
    if (self.percentTempIndex != index) {
        
        self.percentTempIndex = index;
        self.percentChangeIndex = index;
//        [self requestPlatform];
    }
    else {
        if(self.IsFirst == YES) {
            
            self.percentTempIndex = index;
            self.percentChangeIndex = index;
//            [self requestPlatform];
            [self.MbHud hide:YES];

        }
    }

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
    [self.MbHud show:YES];

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
        self.platformTitleModel = self.platformTitleList[0];
        self.kind = kPlatform;
//        [self initHeaderView];
        [self initSelectScrollViewWithIdx:0];
        [self addSubViewController];
//        [self initTableView];
        //添加滚动
       
       
        
    } failure:^(NSError *error) {

    }];
}

/**
 获取币种title列表
 */
- (void)requestCurrencyTitleList {
    [self.MbHud show:YES];

    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628307";
    helper.isList = YES;
    
    [helper modelClass:[CurrencyTitleModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        [weakSelf chose];
        if (weakSelf.titles.count > 1) {
            
        }else
        {
        weakSelf.currencyTitleList = objs;
        //遍历标题
        weakSelf.titles = [NSMutableArray arrayWithObject:@"全部"];
        
        [weakSelf.currencyTitleList enumerateObjectsUsingBlock:^(CurrencyTitleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.symbol) {

                [weakSelf.titles addObject:obj.symbol];
            }
        }];
        }
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

    if (index == 1) {
        [self.CurrencyVC.smallBtn removeFromSuperview];
        self.CurrencyVC.smallBtn.hidden = YES;
        [self.PlatformVC.smallBtn removeFromSuperview];
        self.PlatformVC.smallBtn.hidden = YES;
    }
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
//    NSInteger inde = -1;;

//    switch (index) {
//
//        case 0:
//            inde = ;
//            break;
//        case  1 :
//            inde = 0;
//
//
//        default:
//            break;
//    }
   
    [self.quotesView.headView resetSortBarWithNames:self.titleBars selectIndex:0];
//    [self.quotesView.headView setCurruntIndex:index];
    NSInteger labelIndex = 0;
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
    if ([TLUser user].isLogin == NO) {
        return;
    }
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
        [self.MbHud hide:YES];

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
