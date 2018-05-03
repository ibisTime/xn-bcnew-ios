//
//  CircleCommentChildVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CircleCommentChildVC.h"

//M
#import "CircleCommentModel.h"
//V
#import "CircleCommentTableView.h"
//C
#import "CircleCommentDetailVC.h"

@interface CircleCommentChildVC ()<RefreshDelegate>
//
@property (nonatomic, strong) CircleCommentTableView *tableView;
//评论列表
@property (nonatomic, strong) NSArray <CircleCommentModel *>*comments;

@end

@implementation CircleCommentChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self initTableView];
    //获取评论列表
    [self requestCommentList];
    //
    [self.tableView beginRefreshing];
}

#pragma mark - Init
- (void)initTableView {
    
    NSString *text = [self.type isEqualToString:@"0"] ? @"暂无回复": @"暂无评论";
    self.tableView = [[CircleCommentTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.isReplyMe = [self.type isEqualToString:@"0"] ? YES: NO;
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:text];
    self.tableView.refreshDelegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Data
- (void)requestCommentList {
    
    NSString *code = [self.type isEqualToString:@"0"] ? @"628664": @"628665";
    BaseWeakSelf;
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = code;
    helper.parameters[@"userId"] = [TLUser user].userId;
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[CircleCommentModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.comments = objs;
            
            weakSelf.tableView.comments = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.comments = objs;
            
            weakSelf.tableView.comments = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

#pragma mark - RefreshDelegate

- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CircleCommentModel *comment = self.comments[indexPath.row];
    
    CircleCommentDetailVC *detailVC = [CircleCommentDetailVC new];
    
    detailVC.code = comment.post.code;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
