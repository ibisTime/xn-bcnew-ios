//
//  InfoCommentChildVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "InfoCommentChildVC.h"
//M
#import "MyCommentModel.h"
//V
#import "InfoCommentTableView.h"
//C
#import "MyCommentDetailVC.h"
#import "InfoDetailVC.h"

@interface InfoCommentChildVC ()<RefreshDelegate>
//
@property (nonatomic, strong) InfoCommentTableView *tableView;
//评论列表
@property (nonatomic, strong) NSArray <MyCommentModel *>*comments;

@property (nonatomic, strong) TLPlaceholderView *holdView;


@end

@implementation InfoCommentChildVC

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

    self.tableView = [[InfoCommentTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.tableView.isReplyMe = [self.type isEqualToString:@"0"] ? YES: NO;
    self.tableView.placeHolderView = self.holdView;
    self.tableView.defaultNoDataText = text;
    self.tableView.defaultNoDataImage = kImage(@"暂无动态");
    self.tableView.refreshDelegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Data
- (void)requestCommentList {
    
    NSString *code = [self.type isEqualToString:@"0"] ? @"628208": @"628209";
    BaseWeakSelf;
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = code;
    helper.parameters[@"userId"] = [TLUser user].userId;
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[MyCommentModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            if (objs.count <= 0) {
                [weakSelf.tableView addSubview:weakSelf.holdView];
                return ;
            }
            weakSelf.comments = objs;
            [weakSelf.holdView removeFromSuperview];
            weakSelf.tableView.comments = objs;
            
            [weakSelf.tableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            if (objs.count <= 0) {
                [weakSelf.tableView addSubview:weakSelf.holdView];
                return ;
            }
            [weakSelf.holdView removeFromSuperview];

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
    
    MyCommentModel *comment = self.comments[indexPath.row];
    
    MyCommentDetailVC *detailVC = [MyCommentDetailVC new];
    
    detailVC.code = comment.code;
    detailVC.articleCode = comment.news.code;
    detailVC.typeName = comment.news.typeName;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)refreshTableViewButtonClick:(TLTableView *)refreshTableview button:(UIButton *)sender selectRowAtIndex:(NSInteger)index {
    
    ArticleInfo *info = self.comments[index].news;
    
    InfoDetailVC *detailVC = [InfoDetailVC new];
    
    detailVC.code = info.code;
    detailVC.title = info.typeName;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
