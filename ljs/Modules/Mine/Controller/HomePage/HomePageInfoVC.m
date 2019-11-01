//
//  HomePageInfoVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/28.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "HomePageInfoVC.h"
//Category
#import "NSString+Extension.h"
//Extension
#import <UIImageView+WebCache.h>
//M
#import "MyCommentModel.h"
//V
#import "HomePageHeaderView.h"
#import "HomePageInfoTableView.h"
//C
#import "MyCommentDetailVC.h"
#import "InfoDetailVC.h"
#import "ArticleModel.h"
#import "ArticleCommentModel.h"
#import "TLPlaceholderView.h"
@interface HomePageInfoVC ()<RefreshDelegate>

//头部
@property (nonatomic, strong) HomePageHeaderView *headerView;
//
@property (nonatomic, strong) HomePageInfoTableView *tableView;
//数据
@property (nonatomic, strong) NSArray <MyCommentModel *>*pageModels;
@property (nonatomic, strong) ArticleModel *articleModel;
@property (nonatomic, strong) ArticleCommentModel *articleCommentModel;
@property (nonatomic, strong) NSArray <ArticleCommentModel *>*infos;

@property (nonatomic, strong) TLPlaceholderView *holderView;


@end

@implementation HomePageInfoVC

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    // 设置导航栏背景色
    [self.navigationController.navigationBar setBackgroundImage:[kHexColor(@"#2E2E2E") convertToImage] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    //子标题切换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(indexChange:) name:@"indexChange" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
   
    //
    [self initTableView];
    //获取信息列表
    [self requestPageList];
    //
    [self.tableView beginRefreshing];
    //获取用户信息
    [self requestUserInfo];
}

#pragma mark - Init
- (void)initTableView {
    
    if (self.IsCenter == NO) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
        
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = kImage(@"我的-背景");
        
        imageView.tag = 1500;
        imageView.backgroundColor = kAppCustomMainColor;
        
        

        [self.view addSubview:imageView];
        //tableview的header
        self.tableView = [[HomePageInfoTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) style:UITableViewStyleGrouped];
        
        self.tableView.refreshDelegate = self;
        self.tableView.placeHolderView = self.holderView;
        [self.view addSubview:self.tableView];
        self.headerView = [[HomePageHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
        
        self.headerView.backgroundColor = kHexColor(@"#2E2E2E");
        
        self.tableView.tableHeaderView = self.headerView;
    }
    
    
    self.tableView = [[HomePageInfoTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight) style:UITableViewStyleGrouped];
//    self.holderView = [TLPlaceholderView placeholderViewWithImage:@"暂无动态" text:@"暂无动态"];

    self.tableView.defaultNoDataText = @"暂无动态";
    self.tableView.defaultNoDataImage = kImage(@"暂无动态");
    self.tableView.refreshDelegate = self;
//    self.tableView.placeHolderView = self.holderView;
    [self.view addSubview:self.tableView];
    
   
    
}
//切换子标题
- (void)indexChange: (NSNotification*)not
{
    //子标题切换
    
    NSDictionary * infoDic = [not object];
    NSString * type = infoDic[@"str"];
    self.type = type;
    //获取个人中心资讯
    if ([self.type isEqualToString:@"0"]) {
        self.tableView.IsArticle = NO;
        [self.tableView beginRefreshing];

//        [self requestPageList];
    }else if ([self.type isEqualToString:@"1"]){
        self.tableView.IsArticle = YES;

        [self requestInfoList];
        [self.tableView beginRefreshing];

    }else{
        //点击活动 返回
        return;
    }
    
    
}
- (void)requestInfoList {
    
    BaseWeakSelf;
    if (self.holderView.superview) {
        [self.holderView removeFromSuperview];
    }
    TLNetworking *http = [TLNetworking new];
    //    U201805160952110342835
    http.code = @"628198";
    
//    http.parameters[@"type"] = self.type;
    http.parameters[@"status"] =@"1";
    http.parameters[@"start"] = @"0";
    http.parameters[@"limit"] = @"10";
    if ([TLUser user].isLogin) {
        
        http.parameters[@"userId"] = [TLUser user].userId;
        http.parameters[@"token"] = [TLUser user].token;
        
    } else {
        
        http.parameters[@"userId"] = @"";
        http.parameters[@"token"] = @"";
        
    }
    [http postWithSuccess:^(id responseObject) {
        [ ArticleModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{
                     @"list" : @"ArticleCommentModel"
                     };
        }];
        self.articleModel = [ArticleModel mj_objectWithKeyValues:responseObject[@"data"]];
        if (self.articleModel.list.count <= 0) {
            self.tableView.infos = [NSMutableArray array];
            self.tableView.pageModels =  [NSMutableArray array];

            [self.tableView reloadData];
//            self.tableView.placeHolderView = self.holderArticleView;
            [self.tableView addSubview:self.holderView];
            return ;
        }
        
        [self.holderView removeFromSuperview];
        self.infos = self.articleModel.list;
        self.tableView.infos = self.articleModel.list;
        [weakSelf.tableView reloadData];
        if (weakSelf.holderView.superview) {
            [weakSelf.holderView removeFromSuperview];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Data
/**
 评论我的和我评论的资讯分页查询
 */
- (void)requestPageList {
    if (self.holderView.superview) {
        [self.holderView removeFromSuperview];
    }
    BaseWeakSelf;
    if (self.tableView.IsArticle == YES && [self.type isEqualToString:@"1"]) {
        return;
    }
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628210";
    helper.parameters[@"userId"] = self.userId;
    
    helper.tableView = self.tableView;
    
    [helper modelClass:[MyCommentModel class]];
    
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            if (weakSelf.tableView.IsArticle == YES && [weakSelf.type isEqualToString:@"1"]) {
                [weakSelf requestInfoList];
                return;
            }
            if (objs.count <= 0) {
                weakSelf.tableView.pageModels =  [NSMutableArray array];
                [weakSelf.tableView reloadData];
//                weakSelf.tableView.placeHolderView = weakSelf.holderView;
                [weakSelf.tableView addSubview:weakSelf.holderView];
                return ;
            }
            [weakSelf.holderView removeFromSuperview];
            weakSelf.tableView.pageModels =  [NSMutableArray array];
            weakSelf.tableView.infos =  [NSMutableArray array];
            [weakSelf.tableView reloadData_tl];

            weakSelf.pageModels = objs;
            weakSelf.tableView.pageModels = objs;
            
            [weakSelf.tableView reloadData_tl];
            if (weakSelf.holderView.superview) {
                [weakSelf.holderView removeFromSuperview];
            }
            [weakSelf.tableView endRefreshingWithNoMoreData_tl];

        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.tableView addLoadMoreAction:^{

        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            if (objs.count <= 0) {
//                weakSelf.tableView.placeHolderView = weakSelf.holderView;
                [weakSelf.tableView addSubview:weakSelf.holderView];

                return ;
            }
            weakSelf.pageModels = objs;
            [weakSelf.holderView removeFromSuperview];
            weakSelf.tableView.pageModels = objs;

            [weakSelf.tableView reloadData_tl];

        } failure:^(NSError *error) {

        }];
    }];
    
    [self.tableView endRefreshingWithNoMoreData_tl];
}

/**
 获取用户信息
 */
- (void)requestUserInfo {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805121";
    http.parameters[@"userId"] = self.userId;
    
    [http postWithSuccess:^(id responseObject) {
        
        NSString *photo = responseObject[@"data"][@"photo"];
        NSString *nickname = responseObject[@"data"][@"nickname"];
        //
        [self.headerView.userPhoto sd_setImageWithURL:[NSURL URLWithString:[photo convertImageUrl]] placeholderImage:USER_PLACEHOLDER_SMALL];
        
        [self.headerView.nameBtn setTitle:nickname forState:UIControlStateNormal];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - RefreshDelegate

- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    MyCommentModel *comment = self.pageModels[indexPath.row];

    MyCommentDetailVC *detailVC = [MyCommentDetailVC new];

    detailVC.code = comment.code;
    detailVC.articleCode = comment.news.code;
    detailVC.typeName = comment.news.typeName;
    if (self.IsCenter == YES) {
        detailVC.IsHidden = YES;
    }

    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)refreshTableViewButtonClick:(TLTableView *)refreshTableview button:(UIButton *)sender selectRowAtIndex:(NSInteger)index {
    
    ArticleInfo *info = self.pageModels[index].news;
    
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
