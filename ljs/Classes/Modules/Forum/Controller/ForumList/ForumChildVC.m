//
//  ForumChildVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/13.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ForumChildVC.h"
//M
#import "ForumModel.h"
//V
#import "ForumListTableView.h"
#import "TLPlaceholderView.h"

//C
#import "ForumDetailVC.h"

@interface ForumChildVC ()<RefreshDelegate>
//
@property (nonatomic, strong) ForumListTableView *tableView;
//
@property (nonatomic, strong) NSMutableArray <ForumModel *>*forums;

@end

@implementation ForumChildVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (![TLUser user].isLogin && [self.type isEqualToString:kFoucsPost]) {

        self.tableView.tableFooterView = self.tableView.placeHolderView;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    [self initTableView];
    //获取币吧列表
    [self requestForumList];
    //刷新币吧列表
    [self.tableView beginRefreshing];
    //添加通知
    [self addNotification];
}

#pragma mark - Init
- (void)addNotification {
    //登录后刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogin) name:kUserLoginNotification object:nil];
    //退出登录刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:kUserLoginOutNotification object:nil];
    //关注或取消关注刷新界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshForumList) name:@"FollowOrCancelFollow" object:nil];
    //发布帖子刷新界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshForumList) name:@"RefreshCommentList" object:nil];

}

- (void)userLogin {
    
    //判断是否是关注列表
    if ([self.type isEqualToString:kFoucsPost]) {
        
        //获取币吧列表
        [self requestForumList];
        
        self.tableView.hiddenHeader = NO;
    }
    //刷新币吧列表
    [self.tableView beginRefreshing];
}

- (void)userLogout {
    
    //判断是否是关注列表
    if ([self.type isEqualToString:kFoucsPost]) {
        
        //清空数据
        self.tableView.forums = nil;
        [self.tableView reloadData];
        self.tableView.hiddenHeader = YES;
        self.tableView.tableFooterView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无币吧"];
        return ;
    }
    //刷新币吧列表
    [self.tableView beginRefreshing];
}

- (void)refreshForumList {

    //刷新币吧列表
    [self.tableView beginRefreshing];
}

- (void)initTableView {
    
    self.tableView = [[ForumListTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.refreshDelegate = self;
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无币吧"];
    self.tableView.postType = self.type;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Data
/**
 获取币种列表
 */
- (void)requestForumList {
    
    //判断是否是关注列表
    if ([self.type isEqualToString:kFoucsPost]) {
        
        if (![TLUser user].isLogin) {
            
            return ;
        }
    }
    
    NSString *code = [self.type isEqualToString:kFoucsPost] ? @"628245": @"628237";
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = code;
    
    if ([self.type isEqualToString:kHotPost]) {
        
        helper.parameters[@"location"] = @"1";
    }
    helper.tableView = self.tableView;
    
    [helper modelClass:[ForumModel class]];
    
    [self.tableView addRefreshAction:^{
        
        if ([TLUser user].isLogin) {
            
            helper.parameters[@"userId"] = [TLUser user].userId;
        } else {
            
            helper.parameters[@"userId"] = @"";
        }
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.forums = objs;
            
            weakSelf.tableView.forums = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.forums = objs;
            
            weakSelf.tableView.forums = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

/**
 关注
 */
- (void)followForum:(NSInteger)index {
    
    ForumModel *forumModel = self.forums[index];

    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628240";
    http.showView = self.view;
    http.parameters[@"code"] = forumModel.code;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *promptStr = [forumModel.isKeep isEqualToString:@"1"] ? @"取消关注成功": @"关注成功";
        [TLAlert alertWithSucces:promptStr];
        
        if ([forumModel.isKeep isEqualToString:@"1"]) {
            
            forumModel.isKeep = @"0";
            forumModel.keepCount -= 1;
            
        } else {
            
            forumModel.isKeep = @"1";
            forumModel.keepCount += 1;
        }
        
        [self.tableView reloadData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FollowOrCancelFollow" object:nil];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ForumDetailVC *detailVC = [ForumDetailVC new];
    
    detailVC.code = self.forums[indexPath.row].code;
    
    detailVC.type = ForumEntrancetypeForum;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)refreshTableViewButtonClick:(TLTableView *)refreshTableview button:(UIButton *)sender selectRowAtIndex:(NSInteger)index {
    
    BaseWeakSelf;
    [self checkLogin:^{
        
        //刷新关注状态
        [weakSelf.tableView beginRefreshing];

    } event:^{
        
        [weakSelf followForum:index];
    }];
}

/**
 VC被释放时移除通知
 */
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
