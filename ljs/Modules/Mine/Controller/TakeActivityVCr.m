//
//  TakeActivityVCr.m
//  ljs
//
//  Created by shaojianfei on 2018/5/17.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TakeActivityVCr.h"
//Manager
#import "InfoManager.h"
//M
#import "NewsFlashModel.h"
#import "InfoTypeModel.h"
//V
#import "SelectScrollView.h"
#import "TopLabelUtil.h"
//C
#import "HomeChildVC.h"
#import "ActivityVC.h"
#import "ActivityListV.h"
#import "ActivityLimitModel.h"
#import "ActivityListModel.h"
#import "ActivityDetailModel.h"
#import "AcvitityInformationListTableView.h"
#import "detailActivityVC.h"
#import "CollectionActivityVC.h"
#import "TakeActicityUnVc.h"
#import "TakeActivityNextVc.h"
@interface TakeActivityVCr ()<RefreshDelegate>

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) AcvitityInformationListTableView *ActivityListTableView;
//activities
@property (nonatomic, strong) NSMutableArray <ActivityListModel *>*activities;
//
@property (nonatomic, strong) detailActivityVC *detOfActVC;
@property (nonatomic , strong)SelectScrollView *selectSV;

@property (nonatomic, strong) TLPageDataHelper *flashHelper;
@property (nonatomic, strong) ActivityLimitModel *limitModel;

@property (nonatomic, strong) TLPlaceholderView *holfView;


@end

@implementation TakeActivityVCr

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我参与的活动";
    self.view.backgroundColor = kBackgroundColor;
    [self addNotification];
    
    
    //活动
//    [self initActivityListTableView];
    //获取活动列表
    //刷新
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidLoadHomeVC"
                                                        object:nil];
    self.titles = [NSMutableArray arrayWithObjects:@"已通过",@"未通过", nil];
    self.selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) itemTitles:self.titles];
    self.selectSV.selectBlock = ^(NSInteger index) {
        NSString * str = [NSString stringWithFormat:@"%ld",index];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"indexChange" object:@{@"str":str}];
    };
    [self.view addSubview:self.selectSV];
    
    [self addsubview];
//    [self requestActivityList];
//    [self.ActivityListTableView beginRefreshing];

//    //监听推送
//    [self addPushNotification];
//    //顶部切换
//    [self initSegmentView];
}
- (void)addsubview
{
    for (NSInteger index = 0; index < self.titles.count; index ++) {
        if (index == 0) {
            TakeActicityUnVc *activity = [[TakeActicityUnVc alloc] init];
            [self addChildViewController:activity];
            activity.view.frame = CGRectMake(kScreenWidth*index, 1, kScreenWidth, kSuperViewHeight  - kTabBarHeight);
            [self.selectSV.scrollView addSubview:activity.view];
            
        }
        else
        {
            TakeActivityNextVc *activity = [[TakeActivityNextVc alloc] init];
            [self addChildViewController:activity];
            activity.view.frame = CGRectMake(kScreenWidth*index, 1, kScreenWidth, kSuperViewHeight  - kTabBarHeight);
            [self.selectSV.scrollView addSubview:activity.view];
        }
    }
}


#pragma mark - Init
- (void)addNotification {
    //用户登录刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshActivityListTableView) name:kUserLoginNotification object:nil];
    //用户退出登录刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshActivityListTableView) name:kUserLoginOutNotification object:nil];
    //收到推送刷新
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshActivityListTableView)
                                                 name:@"DidReceivePushNotification"
                                               object:nil];
}

- (void)refreshActivityListTableView {
    
    //
    [self.ActivityListTableView beginRefreshing];
}
//
- (void)initActivityListTableView {
    
//    self.ActivityListTableView = [[AcvitityInformationListTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//
//
//    //    self.repaymentListTableView.refreshDelegate = self;
//
//    self.holfView = [TLPlaceholderView placeholderViewWithImage:@"暂无活动" text:@"暂无活动"];
//    self.ActivityListTableView.placeHolderView =self.holfView;
//    self.ActivityListTableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActivity)];
//    self.ActivityListTableView.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextActivity)];
//    self.ActivityListTableView.refreshDelegate = self;
//    [self.view addSubview:self.ActivityListTableView];
//    [self.ActivityListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.edges.mas_equalTo(UIEdgeInsetsMake(kTabBarHeight, 0, 0, 0));
//    }];
}

//- (void)loadMoreActivity
//{
//    [self.ActivityListTableView.mj_header beginRefreshing];
//    [self requestActivityList];
//
//}
//- (void)loadNextActivity
//{
//    [self.ActivityListTableView.mj_header beginRefreshing];
//
//    [self requestActivityList];
//
//
//}

#pragma mark - Data
- (void)requestActivityList {
    
    BaseWeakSelf;
    TLNetworking *http = [TLNetworking new];

//    TLPageDataHelper *help = [[TLPageDataHelper alloc] init];
    
    http.code = @"628527";
    
        http.parameters[@"start"] = @"0";
        http.parameters[@"limit"] = @"10";
    http.parameters[@"status"] = @"1";

    http.showView = self.view;
    if ([TLUser user].isLogin) {
        
        http.parameters[@"userId"] = [TLUser user].userId;
        http.parameters[@"token"] = [TLUser user].token;

    } else {
        
        http.parameters[@"userId"] = @"";
        http.parameters[@"token"] = @"";

    }
    
    [http postWithSuccess:^(id responseObject) {
        [ ActivityLimitModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"list" : @"ActivityListModel"
                     };
        }];
        [ActivityListModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"activity" : @"ActivityDetailModel"
                     };
        }];
        
        self.limitModel = [ActivityLimitModel mj_objectWithKeyValues:responseObject[@"data"]];
        if (self.limitModel.list.count <= 0) {
            [self.ActivityListTableView addSubview:self.holfView];
            return ;
            [self.ActivityListTableView.mj_header endRefreshing];
        }
        [self.holfView removeFromSuperview];
        [self.ActivityListTableView.mj_header endRefreshing];

        self.ActivityListTableView.infos = self.limitModel.list;
        self.activities = [NSMutableArray array];

        for (ActivityListModel*model in self.ActivityListTableView.infos) {
            [self.activities addObject:model];
        }
        [self.ActivityListTableView reloadData];

        
        
        
        
        
        
    } failure:^(NSError *error) {
        
        [self.ActivityListTableView.mj_header endRefreshing];

        
    }];
}
//
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        [self.ActivityListTableView deselectRowAtIndexPath:indexPath animated:YES];
        detailActivityVC * detOfActVC = [[detailActivityVC alloc ] init ];
        self.detOfActVC = detOfActVC;
    
        ActivityListModel *model = self.activities[indexPath.row];
        
        detOfActVC.code = model.actCode;
        [self.navigationController pushViewController:detOfActVC animated:YES];
    
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
