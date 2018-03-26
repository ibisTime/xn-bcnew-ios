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
    
    if (![TLUser user].isLogin) {
        
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshForumList) name:kUserLoginNotification object:nil];
}

- (void)refreshForumList {
    
    //刷新币吧列表
    [self.tableView beginRefreshing];
}

- (void)initTableView {
    
    self.tableView = [[ForumListTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.refreshDelegate = self;
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无贴吧"];
    self.tableView.isAllPost = [self.type isEqualToString:kAllPost] ? YES: NO;
    
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
    
    if ([self.type isEqualToString:kFoucsPost]) {
        
        if (![TLUser user].isLogin) {
            
            return ;
        }
    }
    NSString *code = [self.type isEqualToString:kFoucsPost] ? @"628245": @"628237";
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = code;
    
    if ([TLUser user].isLogin) {
        
        helper.parameters[@"userId"] = [TLUser user].userId;
    }
    
    if ([self.type isEqualToString:kHotPost]) {
        
        helper.parameters[@"location"] = @"1";
    }
    helper.tableView = self.tableView;
    
    [helper modelClass:[ForumModel class]];
    
    [self.tableView addRefreshAction:^{
        
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
        
        [weakSelf followForum:index];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
