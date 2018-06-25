//
//  QuotesCurrencyVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/21.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "QuotesCurrencyVC.h"

//M
#import "CurrencyModel.h"
#import "CurrencyPriceModel.h"
#import "CurrencyTitleModel.h"
//V
#import "BaseView.h"
//C
#import "ForumDetailVC.h"
#import "TLNetworking.h"
#import "SearchCurrencyVC.h"
#import "NavigationController.h"
#import "AddSearchCurreneyVC.h"
#import "SelectScrollView.h"
@interface QuotesCurrencyVC ()<RefreshDelegate>
//
@property (nonatomic, strong) NSArray <CurrencyModel *>*currencys;
@property (nonatomic, strong) NSArray <CurrencyPriceModel *>*currencyPrices;
//币种
@property (nonatomic, strong) CurrencyTableVIew *tableView;
//
@property (nonatomic, strong) BaseView *headerView;
//币种名称
@property (nonatomic, strong) UILabel *currencyNameLbl;
//帖子数
@property (nonatomic, strong) UILabel *postNumLbl;
//定时器
@property (nonatomic, strong) NSTimer *timer;
//
@property (nonatomic, strong) TLPageDataHelper *helper;
@property (nonatomic, strong) TLNetworking *help;

@property (nonatomic, assign) NSInteger percentChangeIndex;
@property (nonatomic, assign) NSInteger percentTempIndex;
@property (nonatomic, assign) NSInteger CurrentLableIndex;
@property (nonatomic, strong) UIViewController *currentVC;
@property (nonatomic, assign) BOOL IsFirst;


@end

@implementation QuotesCurrencyVC
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
    self.percentTempIndex = -1;
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self initTableView];
    //添加通知
    [self addNotification];
    
    if (self.type == CurrencyTypePrice) {
        //获取币价
        [self requestCurrencyPriceList];
;
        
//        return ;
    }
    //获取币种列表
    [self requestCurrencyList];
    //
//    [self.tableView beginRefreshing];
    //获取贴吧信息
//    [self requestForumInfo];
}
- (void)viewDidAppear:(BOOL)animated
{
  
    [super viewDidAppear:animated];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    self.currentVC = currentVC;
    self.smallBtn.hidden = NO;
    [super viewWillAppear:animated];
    
}

#pragma mark - 通知
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"DidSwitchLabel" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSwitchLabel:) name:@"DidSwitchLabel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleBarClick:) name:@"titleBarindex" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleSamesBarClick:) name:@"titleSameBarindex" object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(choseOptionList:) name:@"choseOptionList" object:nil];
    
}

- (void)choseOptionList : (NSNotification *)notification
{
//    NSArray *arr = self.currentSelectVC.subviews;
//    NSLog(@"%@",arr);
}

- (void)titleSamesBarClick:(NSNotification *)notification {
    if (!self.view.userInteractionEnabled) {
        return;
    }
    if (self.currentSegmentIndex == 1 || self.currentSegmentIndex == 3) {
        return;
    }
    if (self.IsFirst == YES) {
        //第二次点击同一个跌幅榜
        self.percentChangeIndex = -1;
        [self requestCurrencyList];
        self.IsFirst = NO;
        
    }else{
        NSInteger index = [notification.userInfo[@"titleSameBarindex"] integerValue];
        
        self.percentChangeIndex = index;
        [self requestCurrencyList];
        self.IsFirst = YES;
        
    }

    
    
}
- (void)titleBarClick:(NSNotification *)notification {
    if (!self.view.userInteractionEnabled) {
        return;
    }
    if (self.currentSegmentIndex == 1 || self.currentSegmentIndex == 3) {
        return;
    }
    self.IsFirst = YES;
    self.view.userInteractionEnabled = NO;
    NSInteger index = [notification.userInfo[@"titleBarindex"] integerValue];
    CurrencyTitleModel *titleModel;

    if (self.CurrentLableIndex == 0) {
        titleModel = nil;
        self.titleModel = titleModel;

    }else{
        titleModel = self.currencyTitleList[self.CurrentLableIndex-1];
        self.titleModel = titleModel;
    }
    
    if (self.percentTempIndex != index) {
        
        self.percentTempIndex = index;
        self.percentChangeIndex = index;
        [self requestCurrencyList];
    }
    else {
        if(self.IsFirst == YES) {
            
            self.percentTempIndex = index;
            self.percentChangeIndex = index;
            [self requestCurrencyList];
        }
    }
    

}

- (void)didSwitchLabel:(NSNotification *)notification {
//    self.percentChangeIndex = -1;
    NSInteger segmentIndex = [notification.userInfo[@"segmentIndex"] integerValue];
    if (segmentIndex != 2 ) {
        return;
    }
    
    if (segmentIndex == 2) {
        UIButton *smallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [smallBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [smallBtn setImage:kImage(@"添加 黑色") forState:UIControlStateNormal];
//        [smallBtn setTitle:@"➕" forState:UIControlStateNormal];
        self.smallBtn = smallBtn;
        [smallBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
        smallBtn.titleLabel.font = [UIFont systemFontOfSize:28];
        smallBtn.backgroundColor = [UIColor whiteColor];
        smallBtn.frame = CGRectMake(kScreenWidth - 60, 15, 60, 15);
        UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        smallBtn.tag = 20180618;
        UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
        self.currentVC = currentVC;
        self.smallBtn = smallBtn;
        [currentVC.view addSubview:smallBtn];
        
    }
    else{
        [self.smallBtn removeFromSuperview];
        self.smallBtn.hidden = YES;
    }
    if (!self.view.userInteractionEnabled) {
        return;
    }


    NSInteger labelIndex = [notification.userInfo[@"labelIndex"] integerValue];
    self.CurrentLableIndex = labelIndex;
    self.currentSegmentIndex = segmentIndex;

    if (labelIndex == self.currentIndex && segmentIndex == 2) {
        CurrencyTitleModel *titleModel;
        if (labelIndex == 0) {
            titleModel.symbol = @"全部";
         
            NSLog(@"index0");
        }else{
            titleModel = self.currencyTitleList[labelIndex-1];
            NSLog(@"indexNot0");

        }
        self.titleModel = titleModel;
        //刷新列表
        [self requestCurrencyList];
        //币价没有贴吧
        
        //定时器刷起来
//        [self startTimer];
        return ;
    }
    [self stopTimer];

    CurrencyTitleModel *titleModel;
    if (labelIndex == 0) {
    titleModel = self.currencyTitleList[labelIndex];
    }else{
    titleModel = self.currencyTitleList[labelIndex-1];
    }
    self.titleModel = titleModel;
    [self requestCurrencyList];
    
    //定时器停止
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    self.currentVC = currentVC;
    [self.smallBtn removeFromSuperview];
    self.smallBtn.hidden = YES;
    
    [super viewWillDisappear:animated];
    
}
- (void)addBtnClick
{
    //添加币种
    
    BaseWeakSelf;
    
    AddSearchCurreneyVC *searchVC = [AddSearchCurreneyVC new];
//    searchVC.currencyTitleList = self.currencyTitleList;
    searchVC.titles = [NSMutableArray array];
    CurrencyTitleModel * titleModel = [CurrencyTitleModel new];
    titleModel.symbol = @"全部";
  
    [self checkLogin:^{
        [searchVC.titles addObject:titleModel];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//        self.currencyTitleList  =[NSMutableArray array];
        NSData *data = [user objectForKey:@"choseOptionList"];
        searchVC.currencyTitleList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (searchVC.currencyTitleList.count <= 0) {
            searchVC.currencyTitleList = weakSelf.currencyTitleList;
        }else
        {
            weakSelf.currencyTitleList = searchVC.currencyTitleList;
        }
        
        NSMutableArray *Arr = [NSMutableArray array];
        
        
        [weakSelf.currencyTitleList enumerateObjectsUsingBlock:^(CurrencyTitleModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj) {
                obj.IsSelect = YES;
                [searchVC.titles addObject:obj];
            }
        }];
        
        [weakSelf.navigationController pushViewController:searchVC animated:YES];

        
    }];
    
  
        searchVC.currencyBlock = ^{
//            UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
//            UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
//            [currentVC.view addSubview:weakSelf.smallBtn];
            weakSelf.smallBtn.hidden = NO;
            
//            [weakSelf.tableView beginRefreshing];
        };
    
//    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:searchVC];
//    [self presentViewController:searchVC animated:YES completion:nil];
    
}
#pragma mark - 定时器
- (void)startTimer {
    
    //开启定时器,实时刷新
    self.timer = [NSTimer timerWithTimeInterval:10
                                         target:self
                                       selector:@selector(refreshCurrencyList)
                                       userInfo:nil
                                        repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    NSLog(@"币种定时器开启, index = %ld", self.currentIndex);

}

- (void)refreshCurrencyList {
    NSLog(@"币种定时器刷新中, index = %ld", self.currentIndex);

    BaseWeakSelf;
    if (self.view.userInteractionEnabled) {
        [self requestCurrencyList];

    }
    //刷新币种列表
//    [self.helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
//
//        weakSelf.currencyPrices = objs;
//
//        weakSelf.tableView.currencyPrices = objs;
//
//        [weakSelf.tableView reloadData_tl];
//
//    } failure:^(NSError *error) {
//
//    }];
}

//定时器停止
- (void)stopTimer {
    
    [self.timer invalidate];
    self.timer = nil;
    NSLog(@"币种定时器停止, index = %ld", self.currentIndex);

}

#pragma mark - Init
- (void)initHeaderView {
    
    self.headerView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
    
    self.headerView.backgroundColor = kWhiteColor;
    
    //币种名称
    self.currencyNameLbl = [UILabel labelWithBackgroundColor:kClearColor
                                                   textColor:kTextColor
                                                        font:17.0];
    self.currencyNameLbl.text = self.titleModel.symbol;
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

- (void)initTableView {
    self.percentChangeIndex = -1;

    self.tableView = [[CurrencyTableVIew alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@46);
        make.edges.mas_equalTo(UIEdgeInsetsMake(44, 0, 0, 0));
    }];
    BaseWeakSelf;
    self.tableView.selectBlock = ^(NSString *tosymbol) {
        weakSelf.selectBlock(tosymbol);
    };
    self.tableView.type = self.type;
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无币种"];
    self.tableView.refreshDelegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.pagingEnabled = false;
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.edges.mas_equalTo(0);
//    }];
    //判断是否是币价
    if (self.type != CurrencyTypePrice) {
        
        self.tableView.tableHeaderView = self.headerView;
    }
}

#pragma mark - Events
- (void)clickForum {
    
    ForumDetailVC *detailVC = [ForumDetailVC new];
    
    detailVC.toCoin = self.titleModel.symbol;
    detailVC.type = ForumEntrancetypeQuotes;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - Data
- (void)requestCurrencyPriceList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628341";
    helper.parameters[@"symbol"] = @"BTC";
    helper.tableView = self.tableView;
    helper.showView = self.view;
    [helper modelClass:[CurrencyPriceModel class]];
    self.helper = helper;
    
    [self.tableView addRefreshAction:^{
        
        weakSelf.view.userInteractionEnabled = NO;

        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.currencyPrices = objs;
            
            weakSelf.tableView.currencyPrices = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.currencyPrices = objs;
            
            weakSelf.tableView.currencyPrices = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

/**
 获取币种列表
 */
- (void)requestCurrencyList {
    
    BaseWeakSelf;
    
    self.view.userInteractionEnabled = NO;

    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    helper.code = @"628350";
    helper.showView = self.view;
    if (self.titleModel) {
        helper.parameters[@"symbol"] = self.titleModel.symbol;
    }
    helper.parameters[@"start"] = @"0";
    helper.parameters[@"limit"] = @"100";
    if (weakSelf.percentChangeIndex >= 0) {
        
        helper.parameters[@"direction"] = [NSString stringWithFormat:@"%ld",weakSelf.percentChangeIndex];
        
    }
    if ([TLUser user].isLogin == YES) {
        helper.parameters[@"userId"] = [TLUser user].userId;

    }
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[CurrencyPriceModel class]];
    
    [self.tableView addRefreshAction:^{
        
        weakSelf.view.userInteractionEnabled = NO;

        if (weakSelf.percentChangeIndex >= 0) {
            if (weakSelf.titleModel) {
                helper.parameters[@"symbol"] = weakSelf.titleModel.symbol;
                
            }

            
            helper.parameters[@"direction"] = [NSString stringWithFormat:@"%ld",weakSelf.percentChangeIndex];
            
        }

        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.currencyPrices = objs;
            
            weakSelf.tableView.currencyPrices = objs;
            
            [weakSelf.tableView reloadData_tl];
            weakSelf.view.userInteractionEnabled = YES;
            
        } failure:^(NSError *error) {
            
            weakSelf.view.userInteractionEnabled = YES;
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        weakSelf.view.userInteractionEnabled = NO;

        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.currencyPrices = objs;
            
            weakSelf.tableView.currencyPrices = objs;
            
            [weakSelf.tableView reloadData_tl];
            weakSelf.view.userInteractionEnabled = YES;
            
        } failure:^(NSError *error) {
            weakSelf.view.userInteractionEnabled = YES;
        }];
    }];
    
    [self.tableView beginRefreshing];
}

- (void)requestForumInfo {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628338";
    
    http.parameters[@"toCoin"] = self.titleModel.symbol;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.postNumLbl.text = [NSString stringWithFormat:@"现在有%@个贴在讨论,你也一起来吧!", responseObject[@"data"][@"totalCount"]];
        //判断贴吧是否存在并且是具体币种
        NSString *isExist = responseObject[@"data"][@"isExistPlate"];
        
        if ([isExist isEqualToString:@"1"] && (self.type == CurrencyTypeCurrency)) {
            
            self.tableView.tableHeaderView = self.headerView;
            return ;
        }
        self.tableView.tableHeaderView = nil;
        
    } failure:^(NSError *error) {
        
    }];
}
- (void)refreshTableView:(TLTableView*)refreshTableview didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"--->%ld",indexPath.row);
}

/**
 VC被释放时移除通知
 */
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
