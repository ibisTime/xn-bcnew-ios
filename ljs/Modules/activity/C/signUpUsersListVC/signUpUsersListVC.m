//
//  signUpUsersListVC.m
//  ljs
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//
#import "MyArticleViewController.h"
#import "InfoManager.h"
//M
#import "NewsFlashModel.h"
#import "InfoTypeModel.h"
//V
#import "SelectScrollView.h"
#import "TopLabelUtil.h"
//C
#import "signUpUsersListVC.h"
#import "signUpUsersListV.h"
#import "signUpUsersListModel.h"
#import "DetailActModel.h"
#import "SignUpVc.h"
@interface signUpUsersListVC ()<SegmentDelegate>
//顶部切换
@property (nonatomic, strong) TopLabelUtil *labelUnil;
//大滚动
@property (nonatomic, strong) UIScrollView *switchSV;
//小滚动
@property (nonatomic, strong) SelectScrollView *selectSV;
//titles
@property (nonatomic, strong) NSMutableArray *titles;
//statusList
@property (nonatomic, strong) NSArray *statusList;
//类型
@property (nonatomic, copy) NSString *kind;
@property (nonatomic, strong) signUpUsersListV *signUpUserListV;

@property (nonatomic, strong) TLPageDataHelper *flashHelper;

@property (nonatomic, strong) NSArray <DetailActModel *>*detailActModels;


@end

@implementation signUpUsersListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = [NSMutableArray arrayWithObjects:@"已通过", @"未审核", nil];

    self.title = @"已报名用户";
    //添加通知
    [self addNotification];
    
    [self initSegmentView];
//    //活动
//    [self initsignUpUserListView];
//    //获取报名列表
//    [self requestSignUpUserList];
//    //刷新
//
//    [self.signUpUserListV beginRefreshing];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DidLoadSignUpUsersListVC"
                                                        object:nil];
    
    
}
- (void)initSegmentView {
    
    
    //***********设置顶部条**************************
    NSArray *titleArr = @[@"已报名用户"];
    
    self.statusList = @[ kHotNewsFlash];
    self.titles = [NSMutableArray array];
    CGFloat h = 34;
    self.labelUnil = [[TopLabelUtil alloc]initWithFrame:CGRectMake(kScreenWidth/2 - kWidth(200), (44-h), kWidth(199), h)];
    
    self.labelUnil.delegate = self;
    self.labelUnil.backgroundColor = kAppCustomMainColor;
    self.labelUnil.titleNormalColor = kWhiteColor;
    self.labelUnil.titleSelectColor = kWhiteColor;
    self.labelUnil.titleFont = Font(18);
    self.labelUnil.lineType = LineTypeButtonLength;
    self.labelUnil.titleArray = titleArr;
    //    self.labelUnil.layer.cornerRadius = h/2.0;
    //    self.labelUnil.layer.borderWidth = 1;
    //    self.labelUnil.layer.borderColor = kWhiteColor.CGColor;
    self.labelUnil.userInteractionEnabled = NO;
    self.labelUnil.selectBtn.selected = YES;
    [self.labelUnil.selectBtn setBackgroundColor:kAppCustomMainColor forState:UIControlStateNormal];
    [self.labelUnil.selectBtn setBackgroundColor:kAppCustomMainColor forState:UIControlStateSelected];
    
    
    self.navigationItem.titleView = self.labelUnil;
    //******************************************
    
    //1.切换背景
    self.switchSV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)];
    [self.view addSubview:self.switchSV];
    [self.switchSV setContentSize:CGSizeMake(titleArr.count*self.switchSV.width, self.switchSV.height)];
    self.switchSV.scrollEnabled = NO;
    //    //2.订单列表
    NSArray *kindArr = @[ kInformation];
    for (int i = 0; i < titleArr.count; i++) {
        
        self.kind = kindArr[i];
        
        if ([self.kind isEqualToString:kInformation]) {
            
            self.titles = [NSMutableArray arrayWithObjects:@"已通过", @"未审核", nil];
            
            [self initSelectScrollView:i];
            
        } else {
            //查询资讯类型
//            [self requestInfoTypeList];
        }
    }
    
}
- (void)initSelectScrollView:(NSInteger)index {
    
    SelectScrollView *selectSV = [[SelectScrollView alloc] initWithFrame:CGRectMake(index*kScreenWidth, 0, kScreenWidth, kSuperViewHeight - kTabBarHeight) itemTitles:self.titles];
    
    selectSV.tag = 25000 + index;
    
    [self.switchSV addSubview:selectSV];
    
    [self addSubViewController:index];
}

- (void)addSubViewController:(NSInteger)index {
    
    SelectScrollView *selectSV = (SelectScrollView *)[self.view viewWithTag:25000+index];
    
//    selectSV.IsUserList = YES;
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        
        SignUpVc *childVC = [[SignUpVc alloc] init];
        //
        //        if ([self.kind isEqualToString:kNewsFlash]) {
        //
        //            childVC.status = self.statusList[i];
        //
        //        } else {
        childVC.signUpUsersListM = self.signUpUsersListM;
        childVC.code = self.code;
        childVC.titleStr = self.titles[i];
        //        }
        childVC.view.frame = CGRectMake(kScreenWidth*i, 1, kScreenWidth, kSuperViewHeight  - kTabBarHeight);
        
        [self addChildViewController:childVC];
        
        [selectSV.scrollView addSubview:childVC.view];
    }
    
    selectSV.selectBlock = ^(NSInteger index) {
        NSString * str = [NSString stringWithFormat:@"%ld",index];
        NSLog(@"我的报名类型Tag%ld",index);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"indexChange" object:@{@"str":str}];
    };
}

#pragma mark - Init
- (void)addNotification {
    //用户登录刷新
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSignUpUsersListVC) name:kUserLoginNotification object:nil];
//    //用户退出登录刷新
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSignUpUsersListVC) name:kUserLoginOutNotification object:nil];
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
    
    self.signUpUserListV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    
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
    helper.isActivity = YES;
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
            if (objs.count == 0 || !objs) {
                weakSelf.signUpUserListV.tableFooterView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无用户"];
                [weakSelf.signUpUserListV reloadData_tl];

                return ;
            }
            weakSelf.signUpUsersListM = objs;
            
           
            
            weakSelf.signUpUserListV.signUpUsersListM = objs;
//
//
            [weakSelf.signUpUserListV reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    // 拉加载更多
    [self.signUpUserListV  addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
//            中转
            weakSelf.signUpUsersListM = objs;

            weakSelf.signUpUserListV.signUpUsersListM = objs;
            [weakSelf.signUpUserListV reloadData_tl];
            
        } failure:^(NSError *error) {
             weakSelf.signUpUserListV.tableFooterView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无用户"];
        }];
        
    }];
    
    [self.signUpUserListV endRefreshingWithNoMoreData_tl];
}
//



- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)segment:(TopLabelUtil *)segment didSelectIndex:(NSInteger)index {
    
    [self.switchSV setContentOffset:CGPointMake((index - 1) * self.switchSV.width, 0)];
    //    [self.labelUnil dyDidScrollChangeTheTitleColorWithContentOfSet:(index-1)*kScreenWidth];
    
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
