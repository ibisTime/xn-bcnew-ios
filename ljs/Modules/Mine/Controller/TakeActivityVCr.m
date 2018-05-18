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
@interface TakeActivityVCr ()<RefreshDelegate>

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) AcvitityInformationListTableView *ActivityListTableView;
//activities
@property (nonatomic, strong) NSMutableArray <ActivityListModel *>*activities;
//
@property (nonatomic, strong) detailActivityVC *detOfActVC;

@property (nonatomic, strong) TLPageDataHelper *flashHelper;
@property (nonatomic, strong) ActivityLimitModel *limitModel;

@end

@implementation TakeActivityVCr

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我参与的活动";
    self.view.backgroundColor = kBackgroundColor;
    [self addNotification];
    
    
    //活动
    [self initActivityListTableView];
    //获取活动列表
    [self requestActivityList];
    //刷新
    
    [self.ActivityListTableView beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidLoadHomeVC"
                                                        object:nil];
//    self.titles = [NSMutableArray arrayWithObjects:@"待审核", @"审核中",@"已通过",@"未通过", nil];
//    //监听推送
//    [self addPushNotification];
//    //顶部切换
//    [self initSegmentView];
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
    
    self.ActivityListTableView = [[AcvitityInformationListTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    
    //    self.repaymentListTableView.refreshDelegate = self;
    
    self.ActivityListTableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无活动"];
    self.ActivityListTableView.refreshDelegate = self;
    [self.view addSubview:self.ActivityListTableView];
    [self.ActivityListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}


#pragma mark - Data
- (void)requestActivityList {
    
    BaseWeakSelf;
    TLNetworking *http = [TLNetworking new];

//    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    http.code = @"628527";
    
        http.parameters[@"start"] = @"0";
        http.parameters[@"limit"] = @"10";
    
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
        self.ActivityListTableView.infos = self.limitModel.list;
        self.activities = [NSMutableArray array];

        for (ActivityListModel*model in self.ActivityListTableView.infos) {
            [self.activities addObject:model];
        }
        [self.ActivityListTableView reloadData];
//        NSLog(@"%@",self.limitModel);
        
//        self.detailActHead.detailActModel= self.detailActModel;
//        self.detailActMap.detailActModel= self.detailActModel;
//        self.signUpUseres.detailActModel= self.detailActModel;
//        self.activeCon.detailActModel= self.detailActModel;
//        self.activityBott.detailActModel= self.detailActModel;
//
        
        
        
        
        
        
    } failure:^(NSError *error) {
        
        
        
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
        
   
    
    //
    //    localMapManager *detOfActVC = [[localMapManager alloc] init];
    [self.navigationController pushViewController:detOfActVC animated:YES];
    //    [self.viewController presentViewController:detOfActVC animated:YES completion:^{
    //
    //    } ];

    
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
