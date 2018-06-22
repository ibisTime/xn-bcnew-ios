//
//  QuotesPlatForm.m
//  ljs
//
//  Created by shaojianfei on 2018/6/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "QuotesPlatForm.h"
#import "PlatformTableView.h"
#import "CurrencyKLineVC.h"
#import "SelectScrollView.h"
@interface QuotesPlatForm ()
@property (nonatomic, strong) PlatformTableView *tableView;

//平台
//定时器
@property (nonatomic, strong) NSTimer *timer;
//
@property (nonatomic, strong) TLPageDataHelper *helper;
@property (nonatomic, strong) TLNetworking *help;
@property (nonatomic, strong) SelectScrollView *selectview;
@property (nonatomic, assign) NSInteger percentChangeIndex;
@property (nonatomic, assign) NSInteger percentTempIndex;
@property (nonatomic, assign) NSInteger CurrentLableIndex;
@property (nonatomic, assign) BOOL IsFirst;
@property (nonatomic, assign) BOOL IsRequsting;

@end

@implementation QuotesPlatForm

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    self.tableView.platforms = self.platforms;
    self.percentChangeIndex = -1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    //获取自选列表
    [self addNotification];
    
   
        [self requestPlatform];
        
    
    // Do any additional setup after loading the view.
}
#pragma mark - addNotification
- (void)addNotification {
    //登录后刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:kUserLoginNotification object:nil];
    //退出登录刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:kUserLoginOutNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"DidSwitchLabel" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSwitchLabel:) name:@"DidSwitchLabel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleBarClick:) name:@"titleBarindex" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleSamesBarClick:) name:@"titleSameBarindex" object:nil];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    UIButton *btn = [currentVC.view viewWithTag:20180618];
    [btn  removeFromSuperview];
    [super viewWillAppear:animated];

    
    
}
- (void)didSwitchLabel : (NSNotification *)notification
{
    self.IsRequsting = NO;

    NSInteger segmentIndex = [notification.userInfo[@"segmentIndex"] integerValue];
    NSInteger labIndex = [notification.userInfo[@"labelIndex"] integerValue];
    if (segmentIndex == 2  || segmentIndex == 3) {
        return;
    }
    
    if (!self.view.userInteractionEnabled) {
        return;
    }
    if (self.currentSegmentIndex == 2 || self.currentSegmentIndex == 3) {
        return;
    }
//    self.percentChangeIndex = -1;

    self.currentSegmentIndex = segmentIndex;
    if (labIndex >= self.platformTitleList.count) {
        labIndex = 0;
        
    }
    
    if (self.platformTitleList >= 0 && self.platformTitleList) {
        self.platformTitleModel = self.platformTitleList[labIndex];
        //                [self.tableView beginRefreshing];
//                [self.tableView beginRefreshing];

        [self requestPlatform];
        
    }else{
        
        return;
    }
    
    
    //    [self stopTimer];
    
}

#pragma mark - Data
- (void)titleSamesBarClick:(NSNotification *)notification {
    self.IsRequsting = NO;
    if (!self.view.userInteractionEnabled) {
        return;
    }
    if (self.currentSegmentIndex == 2 || self.currentSegmentIndex == 3) {
        return;
    }
    
    if (self.IsFirst == YES) {
        //第二次点击同一个跌幅榜
        self.percentChangeIndex = -1;
        [self requestPlatform];
        
        self.IsFirst = NO;
        
    }else{
        NSInteger index = [notification.userInfo[@"titleSameBarindex"] integerValue];
        
        self.percentChangeIndex = index;
        [self requestPlatform];
        
        self.IsFirst = YES;
        
    }
    
}
- (void)titleBarClick:(NSNotification *)notification {
    NSInteger index = [notification.userInfo[@"titleBarindex"] integerValue];
    self.IsRequsting = NO;

    if (!self.view.userInteractionEnabled) {
        return;
    }
    if (self.currentSegmentIndex == 2 || self.currentSegmentIndex == 3) {
        return;
    }
    
    //    if (self.currentSegmentIndex == 3 || self.currentSegmentIndex == 2) {
    //        return;
    //    }
    self.IsFirst = YES;
    
    
    NSLog(@"点击了自选的第%ld个",index);
    if (self.percentTempIndex != index) {
        
        self.percentTempIndex = index;
        self.percentChangeIndex = index;
        [self requestPlatform];
    }
    else {
        if(self.IsFirst == YES) {
            
            self.percentTempIndex = index;
            self.percentChangeIndex = index;
            [self requestPlatform];
            
        }
    }
    
}


- (void)userLogin {
    
    //刷新自选列表
    //    self.tableView.hiddenHeader = NO;
    [self.tableView beginRefreshing];
}

- (void)userLogout {
    //关闭定时器
//    [self stopTimer];
    //清空数据
    [self.tableView reloadData_tl];
    //    self.tableView.hiddenHeader = YES;
    self.tableView.tableFooterView = self.placeholderView;
}


- (void)initTableView {
    
    self.tableView = [[PlatformTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    BaseWeakSelf;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(44, 0, 0, 0));
        
    }];
    
    self.tableView.selectBlock = ^(NSString *idear) {
        [weakSelf pushCurrencyKLineVCWith:idear];
    };
    self.tableView.type = PlatformTypePlatform;
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无平台"];
    
    [self.view addSubview:self.tableView];
    self.tableView.pagingEnabled = false;

    //       self.tableView.tableHeaderView = self.headerView;
    [self requestPlatform];
    
    
    
    
}
- (void)requestPlatform {
    //    [self.tableView addObserver: self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    BaseWeakSelf;
    self.view.userInteractionEnabled =NO;
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    if (self.IsRequsting == YES) {
        weakSelf.view.userInteractionEnabled = YES;
        
        return;
    }
    helper.code = @"628350";
    helper.showView = self.view;
    
    if (self.platformTitleModel) {
        helper.parameters[@"exchangeEname"] = self.platformTitleModel.ename;
        
    }
    helper.parameters[@"start"] = @"0";
    helper.parameters[@"limit"] = @"100";
    if ([TLUser user].userId) {
        helper.parameters[@"userId"] = [TLUser user].userId;
        
    }
    if (weakSelf.platformTitleModel) {
        helper.parameters[@"exchangeEname"] = weakSelf.platformTitleModel.ename;
        
    }
    if (weakSelf.percentChangeIndex >= 0) {
        helper.parameters[@"direction"] = [NSString stringWithFormat:@"%ld",weakSelf.percentChangeIndex];
    }
    
    
    
    helper.tableView = self.tableView;
    [helper modelClass:[PlatformModel class]];
    
    self.helper = helper;
    self.IsRequsting = YES;
    [self.tableView addRefreshAction:^{
        if ([TLUser user].userId) {
            helper.parameters[@"userId"] = [TLUser user].userId;
            if (weakSelf.platformTitleModel) {
                helper.parameters[@"exchangeEname"] = weakSelf.platformTitleModel.ename;
                
            }
            if (weakSelf.percentChangeIndex >= 0) {
                helper.parameters[@"direction"] = [NSString stringWithFormat:@"%ld",weakSelf.percentChangeIndex];
            }
        }
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            

            if (objs.count == 0) {
                
                weakSelf.tableView.tableFooterView = weakSelf.placeholderView;
                
                return ;
            }
            //                weakSelf.tableView.tableFooterView = nil;
            //                [weakSelf.MbHud hide:YES];
            weakSelf.platforms = objs;
            
            weakSelf.tableView.platforms = objs;
            
            [weakSelf.tableView reloadData_tl];
            CGFloat y = weakSelf.tableView.frame.origin.y;
            weakSelf.view.userInteractionEnabled = YES;
            if (weakSelf.helper.refreshed == YES) {
                weakSelf.view.userInteractionEnabled = YES;
                
                return;
            } NSLog(@"contenOffSet%@contenSize%@",NSStringFromCGPoint(weakSelf.tableView.contentOffset),NSStringFromCGSize(weakSelf.tableView.contentSize));
            //                [weakSelf.tableView setContentOffset:CGPointMake(0, -54)];
        } failure:^(NSError *error) {
            //                [weakSelf.MbHud hide:YES];
            weakSelf.view.userInteractionEnabled = YES;
//            weakSelf.IsRequsting = NO;

        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        weakSelf.view.userInteractionEnabled = NO;

        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
//            weakSelf.IsRequsting = NO;

            weakSelf.platforms = objs;
            
            weakSelf.tableView.platforms = objs;
            
            [weakSelf.tableView reloadData_tl];
            [weakSelf.tableView setContentOffset:CGPointMake(0, -54)];
            weakSelf.view.userInteractionEnabled = YES;
            
        } failure:^(NSError *error) {
            weakSelf.view.userInteractionEnabled = YES;
            
        }];
    }];
    //        [self initHeaderView];
    self.IsRequsting = YES;

    [self.tableView beginRefreshing];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
