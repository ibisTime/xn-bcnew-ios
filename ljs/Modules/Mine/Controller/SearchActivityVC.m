//
//  SearchActivityVC.m
//  ljs
//
//  Created by shaojianfei on 2018/6/16.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SearchActivityVC.h"
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
#import "SearchActivityTableView.h"
@interface SearchActivityVC ()<RefreshDelegate>
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) SearchActivityTableView *ActivityListTableView;
//activities
@property (nonatomic, strong) NSMutableArray <ActivityListModel *>*activities;
//
@property (nonatomic, strong) detailActivityVC *detOfActVC;

@property (nonatomic, strong) TLPageDataHelper *flashHelper;
@property (nonatomic, strong) ActivityLimitModel *limitModel;

@property (nonatomic, strong) TLPlaceholderView *holfView;

@property (nonatomic, strong) TLPageDataHelper *http;

@property (nonatomic, copy) NSString *search;

@end

@implementation SearchActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];
    
    
    //活动
    [self initActivityListTableView];
    //获取活动列表
    //刷新
    
    [self.ActivityListTableView beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidLoadHomeVC"
                                                        object:nil];
    // Do any additional setup after loading the view.
}



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


- (void)searchRequestWith:(NSString *)search
{
//    self.isSearch = NO;
//    self.searchText = search;
    if (search.length != 0) {
        self.search = search;

        [self requestActivityList];
        [self.ActivityListTableView beginRefreshing];

        
    }
    
}

- (void)refreshActivityListTableView {
    
    //
    [self.ActivityListTableView beginRefreshing];
}
//
- (void)initActivityListTableView {
    
    self.ActivityListTableView = [[SearchActivityTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    
    //    self.repaymentListTableView.refreshDelegate = self;
    
    self.holfView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无活动"];
    self.ActivityListTableView.placeHolderView =self.holfView;
    self.ActivityListTableView.refreshDelegate = self;
    [self.view addSubview:self.ActivityListTableView];
    [self.ActivityListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}


#pragma mark - Data
- (void)requestActivityList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *http = [TLPageDataHelper new];
    self.http = http;
    //    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    http.code = @"628507";
    
    http.parameters[@"start"] = @"0";
    http.parameters[@"limit"] = @"10";
    http.parameters[@"status"] = @"1";
    self.http.parameters[@"keywords"] =self.search;

    http.showView = self.view;
    http.tableView = self.ActivityListTableView;
    [http modelClass:[ActivityListModel class]];

    [self.ActivityListTableView addRefreshAction:^{
        //
       
        [http refresh:^(NSMutableArray *objs, BOOL stillHave) {
            if (objs.count <= 0) {
                [weakSelf.ActivityListTableView addSubview:weakSelf.holfView];
                return ;
                
            }
            [weakSelf.holfView removeFromSuperview];
            weakSelf.activities = objs;
            [weakSelf.ActivityListTableView.infos removeAllObjects];
            [weakSelf.ActivityListTableView reloadData];
            weakSelf.ActivityListTableView.infos = objs;
            [weakSelf.ActivityListTableView reloadData_tl];
        
            
            
        } failure:^(NSError *error) {
            
        }];
    }];
    // 拉加载更多
    [self.ActivityListTableView  addLoadMoreAction:^{
        
        [http loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            if (objs.count <= 0) {
                [weakSelf.ActivityListTableView addSubview:weakSelf.holfView];
                return ;
                
            }
            [weakSelf.holfView removeFromSuperview];
            weakSelf.activities = objs;
            [weakSelf.ActivityListTableView.infos removeAllObjects];
            [weakSelf.ActivityListTableView reloadData];
            weakSelf.ActivityListTableView.infos = objs;
            [weakSelf.ActivityListTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    [self.ActivityListTableView endRefreshingWithNoMoreData_tl];
    
//    [http postWithSuccess:^(id responseObject) {
//        [ ActivityLimitModel mj_setupObjectClassInArray:^NSDictionary *{
//            return @{
//                     @"list" : @"ActivityListModel"
//                     };
//        }];
//        [ActivityListModel mj_setupObjectClassInArray:^NSDictionary *{
//            return @{
//                     @"activity" : @"ActivityDetailModel"
//                     };
//        }];
//
//        self.limitModel = [ActivityLimitModel mj_objectWithKeyValues:responseObject[@"data"]];
//        if (self.limitModel.list.count <= 0) {
//            [self.ActivityListTableView addSubview:self.holfView];
//            return ;
//
//        }
//        [self.holfView removeFromSuperview];
//        self.ActivityListTableView.infos = self.limitModel.list;
//        self.activities = [NSMutableArray array];
//
//        for (ActivityListModel*model in self.ActivityListTableView.infos) {
//            [self.activities addObject:model];
//        }
//        [self.ActivityListTableView reloadData];
//        //        NSLog(@"%@",self.limitModel);
//
//        //        self.detailActHead.detailActModel= self.detailActModel;
//        //        self.detailActMap.detailActModel= self.detailActModel;
//        //        self.signUpUseres.detailActModel= self.detailActModel;
//        //        self.activeCon.detailActModel= self.detailActModel;
//        //        self.activityBott.detailActModel= self.detailActModel;
//        //
//
//
//
//
//
//
//    } failure:^(NSError *error) {
//
//
//
//    }];
}
//
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self.ActivityListTableView deselectRowAtIndexPath:indexPath animated:YES];
    detailActivityVC * detOfActVC = [[detailActivityVC alloc ] init ];
    self.detOfActVC = detOfActVC;
    
    ActivityListModel *model = self.activities[indexPath.row];
    
    detOfActVC.code = model.code;
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
