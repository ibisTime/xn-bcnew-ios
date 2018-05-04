//
//  ActivityVC.m
//  ljs
//
//  Created by apple on 2018/5/1.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//


#import "AppColorMacro.h"
#import "ActivityVC.h"
//V
#import "ActivityListV.h"
//M
#import "activityModel.h"
@interface ActivityVC ()

//V
//list
@property (nonatomic, strong) ActivityListV *ActivityListTableView;
//activities
@property (nonatomic, strong) NSArray <activityModel *>*activities;
//
@property (nonatomic, strong) TLPageDataHelper *flashHelper;
@end

@implementation ActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活动";
    
//    self.view.backgroundColor =kMineBackGroundColor;
    //添加通知
    [self addNotification];
    
    
    //活动
    [self initActivityListTableView];
    //获取活动列表
    [self requestActivityList];
    //刷新
    
    [self.ActivityListTableView beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidLoadHomeVC"
                                                        object:nil];
    
    
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
    
    self.ActivityListTableView = [[ActivityListV alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    
    //    self.repaymentListTableView.refreshDelegate = self;
    
    self.ActivityListTableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无活动"];
    
    [self.view addSubview:self.ActivityListTableView];
    [self.ActivityListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}


#pragma mark - Data
- (void)requestActivityList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628507";
    
//    helper.parameters[@"type"] = self.status;
//    helper.parameters[@"status"] = @"1";
    helper.tableView = self.ActivityListTableView;
    
    self.flashHelper = helper;
    
    [helper modelClass:[activityModel class]];
    
    [self.ActivityListTableView addRefreshAction:^{
        //
        if ([TLUser user].isLogin) {
            
            helper.parameters[@"userId"] = [TLUser user].userId;
        } else {
            
            helper.parameters[@"userId"] = @"";
        }
        //
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.activities = objs;
            
            weakSelf.ActivityListTableView.activities = objs;
            
            
            [weakSelf.ActivityListTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    // 拉加载更多
    [self.ActivityListTableView  addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            //中转
            weakSelf.activities = objs;
            
            weakSelf.ActivityListTableView.activities = objs;
            [weakSelf.ActivityListTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    [self.ActivityListTableView endRefreshingWithNoMoreData_tl];
}
//



- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
