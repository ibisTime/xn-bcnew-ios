//
//  SignUpVc.m
//  ljs
//
//  Created by shaojianfei on 2018/5/31.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "SignUpVc.h"
#import "signUpUsersListModel.h"
#import "signUpUsersListV.h"
#import "DetailActModel.h"

@interface SignUpVc ()

@property (nonatomic, strong) signUpUsersListV *signUpUserListV;

@property (nonatomic, strong) TLNetworking *flashHelper;

@property (nonatomic, strong) NSArray <DetailActModel *>*detailActModels;
@property (nonatomic)NSInteger page;
@property (nonatomic,assign) NSInteger currtntType;
@property (nonatomic,assign) BOOL  IsLoad;

@end

@implementation SignUpVc

- (void)viewDidLoad {
    [super viewDidLoad];
    //活动
    self.type = 0;
    [self initsignUpUserListView];
    
    //刷新
    [self addNotification];
   
        //获取报名列表
    [self requestSignUpUserList];
    [self.signUpUserListV beginRefreshing];


    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidLoadSignUpUsersListVC"
                                                        object:nil];
    // Do any additional setup after loading the view.
}

-(NSArray<signUpUsersListModel *> *)signUpUsersListM
{
    
    if (_signUpUsersListM == nil) {
        _signUpUsersListM = [NSArray array];
    }
    
    return _signUpUsersListM;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(indexChangeType:) name:@"indexChange" object:nil];
}

//切换子标题
- (void)indexChangeType: (NSNotification*)not
{
   
    NSDictionary * infoDic = [not object];
    NSInteger  type = [infoDic[@"str"] integerValue];
    
    self.type = type;
    [self.signUpUserListV beginRefreshing];
//    [self requestSignUpUserList];
    
}
- (void)refreshSignUpUsersListVC {
    
    //
    [self.signUpUserListV beginRefreshing];
}
- (void)initsignUpUserListView {
    self.page = 1;
    self.signUpUserListV = [[signUpUsersListV alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    self.signUpUserListV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.signUpUserListV.tableFooterView = [UIView new];
    self.signUpUserListV.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic)];
    self.signUpUserListV.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
    self.signUpUserListV.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无用户"];
    
    [self.view addSubview:self.signUpUserListV];
    [self.signUpUserListV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}


- (void)loadNewTopic
{
    self.page = 1;
    [self.signUpUserListV beginRefreshing];
    [self requestSignUpUserList];
}
- (void)loadMoreTopic
{
    self.page ++;
    [self.signUpUserListV beginRefreshing];

    [self requestSignUpUserList];
}
#pragma mark - Data
- (void)requestSignUpUserList {
    self.IsLoad = YES;

    BaseWeakSelf;
    TLNetworking *helper = [TLNetworking new];

//    helper.isActivity = YES;
    helper.code = @"628528";
    
    helper.parameters[@"actCode"] = self.code;
    if (self.type == 1) {
        helper.parameters[@"status"] = [NSString stringWithFormat:@"%ld",self.type-1];

    }else{
        helper.parameters[@"status"] = [NSString stringWithFormat:@"%ld",self.type+1];

    }

    helper.parameters[@"start"] = @"0";
    helper.parameters[@"limit"] = @"10";
    helper.parameters[@"orderColumn"] = @"id";
    helper.parameters[@"orderDir"] = @"asc";

//    if ([TLUser user].isLogin) {
//        
//        helper.parameters[@"userId"] = [TLUser user].userId;
//    } else {
//        
//        helper.parameters[@"userId"] = @"";
//    }
    
    self.flashHelper = helper;
    [helper postWithSuccess:^(id responseObject) {
//        self.signUpUsersListM = [signUpUsersListModel mj_objectArrayWithKeyValuesArray:]
        weakSelf.signUpUsersListM = [signUpUsersListModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
        if (weakSelf.signUpUsersListM.count > 0) {
            self.currtntType = weakSelf.type;
            weakSelf.signUpUsersListM = weakSelf.signUpUsersListM;
            
            weakSelf.signUpUserListV.tableFooterView = nil;
            weakSelf.signUpUserListV.placeHolderView = nil;

            weakSelf.signUpUserListV.signUpUsersListM = weakSelf.signUpUsersListM;
            //
            //
            [weakSelf.signUpUserListV reloadData_tl];
            weakSelf.IsLoad = NO;
        }else{
            
            if (self.type != self.currtntType) {
                self.signUpUserListV.signUpUsersListM = [NSMutableArray array];
                
                weakSelf.signUpUserListV.tableFooterView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无用户"];
            }else{
                
                
            }
            [self.signUpUserListV reloadData];
            if (self.page != 1) {
                self.page --;
            }
            
        }
        [self.signUpUserListV reloadData];
        [self.signUpUserListV.mj_footer endRefreshing];
        [self.signUpUserListV.mj_header endRefreshing];
        
        
    } failure:^(NSError *error) {
        
        weakSelf.signUpUserListV.tableFooterView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无用户"];
        if (self.page != 1) {
            self.page --;
        }
            [weakSelf.signUpUserListV reloadData_tl];
            
            return ;
    }];
    
//    [self.signUpUserListV.mj_footer endRefreshing];
//    [self.signUpUserListV.mj_header endRefreshing];
    [self.signUpUserListV endRefreshingWithNoMoreData_tl];
}
//


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
