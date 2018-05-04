//
//  signUpUsersListVC.m
//  ljs
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "signUpUsersListVC.h"
#import "signUpUsersListV.h"
#import "signUpUsersListModel.h"
@interface signUpUsersListVC ()
@property (nonatomic, strong) signUpUsersListV *signUpUserListV;

@property (nonatomic, strong) TLPageDataHelper *flashHelper;

@property (nonatomic, strong) NSArray <signUpUsersListModel *>*signUpUsersListM;


@end

@implementation signUpUsersListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"已报名用户";
    //添加通知
    [self addNotification];
    
    
    //活动
    [self initsignUpUserListView];
    //获取活动列表
    [self requestSignUpUserList];
    //刷新
    
    [self.signUpUserListV beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidLoadSignUpUsersListVC"
                                                        object:nil];
    
    
}

#pragma mark - Init
- (void)addNotification {
    //用户登录刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSignUpUsersListVC) name:kUserLoginNotification object:nil];
    //用户退出登录刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSignUpUsersListVC) name:kUserLoginOutNotification object:nil];
    //收到推送刷新
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshSignUpUsersListVC)
                                                 name:@"DidReceivePushNotification"
                                               object:nil];
}

- (void)refreshSignUpUsersListVC {
    
    //
    [self.signUpUserListV beginRefreshing];
}
//
- (void)initsignUpUserListView {
    
    self.signUpUserListV = [[signUpUsersListV alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    
    
    
    self.signUpUserListV.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无用户"];
    
    [self.view addSubview:self.signUpUserListV];
    [self.signUpUserListV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}


#pragma mark - Data
- (void)requestSignUpUserList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628508";
    
        helper.parameters[@"code"] = self.code;
    
    helper.tableView = self.signUpUserListV;
    
    self.flashHelper = helper;
    
    [helper modelClass:[signUpUsersListModel class]];
    
    [self.signUpUserListV addRefreshAction:^{
        //
        if ([TLUser user].isLogin) {
            
            helper.parameters[@"userId"] = [TLUser user].userId;
        } else {
            
            helper.parameters[@"userId"] = @"";
        }
        //
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
//            NSArray *qq = objs[approvedList];
            weakSelf.signUpUsersListM = objs;
            
            weakSelf.signUpUserListV.signUpUsersListM = objs;
            
            
            [weakSelf.signUpUserListV reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    // 拉加载更多
    [self.signUpUserListV  addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            //中转
            weakSelf.signUpUsersListM = objs;
            
//            weakSelf.ActivityListTableView.activities = objs;
            [weakSelf.signUpUserListV reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    [self.signUpUserListV endRefreshingWithNoMoreData_tl];
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
