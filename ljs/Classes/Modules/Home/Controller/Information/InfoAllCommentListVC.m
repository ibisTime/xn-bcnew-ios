//
//  InfoAllCommentListVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/4/3.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "InfoAllCommentListVC.h"

//Macro
#import "APICodeMacro.h"
//Category
#import "TLProgressHUD.h"
//M
#import "InfoDetailModel.h"
#import "InfoCommentModel.h"
//V
#import "BaseView.h"
#import "InfoAllCommentListTableView.h"
//C
#import "TLUserLoginVC.h"
#import "NavigationController.h"
#import "InfoCommentDetailVC.h"

@interface InfoAllCommentListVC ()<RefreshDelegate>
//评论
@property (nonatomic, strong) InfoAllCommentListTableView *tableView;
//infoList
@property (nonatomic, strong) InfoDetailModel *detailModel;
//commentList
@property (nonatomic, strong) NSArray <InfoCommentModel *>*comments;
@property (nonatomic, strong) TLPageDataHelper *helper;

@end

@implementation InfoAllCommentListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"评论列表";
    //评论
    [self initCommentTableView];
    //详情查资讯
    [self requestInfoDetail];
    //
    [self addNotification];
}

#pragma mark - Init
/**
 评论列表
 */
- (void)initCommentTableView {
    
    self.tableView = [[InfoAllCommentListTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无评论"];
    
    self.tableView.refreshDelegate = self;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
        make.bottom.equalTo(@(-kBottomInsetHeight));
    }];
    
}

#pragma mark - 通知
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCommentList) name:@"RefreshCommentList" object:nil];
}

#pragma mark - Data
- (void)requestInfoDetail {
    
    [TLProgressHUD show];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628206";
    
    http.parameters[@"code"] = self.code;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        self.detailModel = [InfoDetailModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        //获取最新评论列表
        [self requestCommentList];
        
    } failure:^(NSError *error) {
        
        [TLProgressHUD dismiss];
    }];
    
}

- (void)requestCommentList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628285";
    helper.parameters[@"objectCode"] = self.code;
    if ([TLUser user].userId) {
        
        helper.parameters[@"userId"] = [TLUser user].userId;
    }
    helper.tableView = self.tableView;
    self.helper = helper;
    
    [helper modelClass:[InfoCommentModel class]];
    
    [self.helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.comments = objs;
        
        weakSelf.tableView.detailModel = weakSelf.detailModel;
        weakSelf.tableView.newestComments = objs;
        //刷新
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData_tl];
        });
        
        [TLProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.comments = objs;
            
            weakSelf.tableView.newestComments = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

- (void)refreshCommentList {
    
    BaseWeakSelf;
    
    [self.helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.comments = objs;
        
        weakSelf.tableView.detailModel = weakSelf.detailModel;
        weakSelf.tableView.newestComments = objs;
        
        [weakSelf.tableView reloadData_tl];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)zanCommentWithComment:(InfoCommentModel *)commentModel {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628201";
    http.showView = self.view;
    http.parameters[@"type"] = @"2";
    http.parameters[@"objectCode"] = commentModel.code;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *promptStr = [commentModel.isPoint isEqualToString:@"1"] ? @"取消点赞成功": @"点赞成功";
        [TLAlert alertWithSucces:promptStr];
        
        if ([commentModel.isPoint isEqualToString:@"1"]) {
            
            commentModel.isPoint = @"0";
            commentModel.pointCount -= 1;
            
        } else {
            
            commentModel.isPoint = @"1";
            commentModel.pointCount += 1;
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InfoCommentModel *commentModel = indexPath.section == 0 ? self.detailModel.hotCommentList[indexPath.row]: self.comments[indexPath.row];
    
    InfoCommentDetailVC *detailVC = [InfoCommentDetailVC new];
    
    detailVC.code = commentModel.code;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)refreshTableViewButtonClick:(TLTableView *)refreshTableview button:(UIButton *)sender selectRowAtIndex:(NSInteger)index {
    
    BaseWeakSelf;
    [self checkLogin:^{
        
        //刷新点赞状态
        [weakSelf requestInfoDetail];
        
    } event:^{
        
        NSInteger section = index/1000;
        NSInteger row = index - section*1000;
        
        InfoCommentModel *commentModel = section == 0 ? weakSelf.detailModel.hotCommentList[row]: weakSelf.comments[row];
        
        [weakSelf zanCommentWithComment:commentModel];
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
