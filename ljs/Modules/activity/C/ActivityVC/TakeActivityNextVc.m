//
//  TakeActivityNextVc.m
//  ljs
//
//  Created by shaojianfei on 2018/6/25.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "TakeActivityNextVc.h"
#import "AcvitityInformationListTableView.h"
#import "TLPlaceholderView.h"
#import "ActivityLimitModel.h"
#import "ActivityListModel.h"
#import "detailActivityVC.h"
@interface TakeActivityNextVc ()<RefreshDelegate>
@property (nonatomic, strong) NSMutableArray <ActivityListModel *>*activities;

@property (nonatomic , strong) AcvitityInformationListTableView*ActivityListTableView;

@property (nonatomic , strong) TLPlaceholderView*holfView;

@property (nonatomic , strong) ActivityLimitModel*limitModel;

@property (nonatomic , strong) detailActivityVC*detOfActVC;



@end

@implementation TakeActivityNextVc



- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];
    [self initActivityListTableView];
    [self requestActivityList];
    [self.ActivityListTableView beginRefreshing];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)addNotification {
    //用户登录刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshActivityListTableView) name:kUserLoginNotification object:nil];
    //用户退出登录刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshActivityListTableView) name:kUserLoginOutNotification object:nil];
    //子标题切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(indexChange:) name:@"indexChange" object:nil];
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
    
    self.ActivityListTableView = [[AcvitityInformationListTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    
    //    self.repaymentListTableView.refreshDelegate = self;
    
    self.holfView = [TLPlaceholderView placeholderViewWithImage:@"暂无动态" text:@"暂无活动"];
    self.ActivityListTableView.placeHolderView =self.holfView;
    self.ActivityListTableView.refreshDelegate = self;
    self.ActivityListTableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMoreActivity)];
    self.ActivityListTableView.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadNextActivity)];
    [self.view addSubview:self.ActivityListTableView];
    [self.ActivityListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}
//切换子标题
- (void)indexChange: (NSNotification*)not
{
    NSDictionary * infoDic = [not object];
    NSString * type = infoDic[@"str"];
    if ([type isEqualToString:@"0"]) {
        return;
    }
    [self loadMoreActivity];
    
    
}
- (void)loadMoreActivity
{
    
    [self requestActivityList];
    [self.ActivityListTableView.mj_header beginRefreshing];
}
- (void)loadNextActivity
{
    [self requestActivityList];
    
    [self.ActivityListTableView.mj_footer beginRefreshing];
    
    
}
#pragma mark - Data
- (void)requestActivityList {
    
    BaseWeakSelf;
    TLNetworking *http = [TLNetworking new];
    
    //    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    http.code = @"628527";
    
    http.parameters[@"start"] = @"0";
    http.parameters[@"limit"] = @"10";
    http.parameters[@"status"] = @"02";
    
    http.showView = self.view;
    if ([TLUser user].isLogin) {
        
        http.parameters[@"userId"] = [TLUser user].userId;
        http.parameters[@"token"] = [TLUser user].token;
        
    } else {
        
        http.parameters[@"userId"] = @"";
        http.parameters[@"token"] = @"";
        
    }
    [http postWithSuccess:^(id responseObject) {
        [self.ActivityListTableView.infos removeAllObjects];
        [self.ActivityListTableView reloadData];
        
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
            [self.ActivityListTableView.mj_header endRefreshing];
            [self.ActivityListTableView.mj_footer endRefreshing];

            return ;
            
        }
        [self.holfView removeFromSuperview];
        [self.ActivityListTableView.mj_header endRefreshing];
        [self.ActivityListTableView.mj_footer endRefreshing];

        self.ActivityListTableView.infos = self.limitModel.list;
        self.activities = [NSMutableArray array];
        
        for (ActivityListModel*model in self.ActivityListTableView.infos) {
            [self.activities addObject:model];
        }
        [self.ActivityListTableView reloadData];
        
        
        
        
        
        
        
    } failure:^(NSError *error) {
        
        [self.ActivityListTableView.mj_header endRefreshing];
        [self.ActivityListTableView.mj_footer endRefreshing];

        
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
