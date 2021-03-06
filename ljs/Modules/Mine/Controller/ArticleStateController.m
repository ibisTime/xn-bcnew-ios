//
//  ArticleStateController.m
//  ljs
//
//  Created by shaojianfei on 2018/5/18.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ArticleStateController.h"
//M
#import "NewsFlashModel.h"
#import "InformationModel.h"
#import "InfoManager.h"
//V
#import "NewsFlashListTableView.h"
#import "InformationListTableView.h"
#import "TLPlaceholderView.h"
//C
#import "NewsFlashDetailVC.h"
#import "InfoDetailVC.h"
#import "ArticleModel.h"
#import "MyCommentModel.h"
#import "ArticleCommentModel.h"
#import "ArticleCommentTableView.h"
@interface ArticleStateController ()<RefreshDelegate>
//快讯
@property (nonatomic, strong) NewsFlashListTableView *flashTableView;
//news
@property (nonatomic, strong) NSArray <NewsFlashModel *>*news;


//资讯
@property (nonatomic, strong) ArticleCommentTableView *infoTableView;
//infoList
@property (nonatomic, strong) NSArray <ArticleCommentModel *>*infos;
//**********************************


//
@property (nonatomic, strong) TLPageDataHelper *flashHelper;

@property (nonatomic, strong) ArticleModel *articleModel;

@property (nonatomic, strong) ArticleCommentModel *commentModel;


@end

@implementation ArticleStateController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加通知
    [self addNotification];
    
//    if ([self.kind isEqualToString:kNewsFlash]) {
//        //快讯
//        [self initFlashTableView];
//        //获取快讯列表
//        [self requestFlashList];
//        //刷新
//        [self.flashTableView beginRefreshing];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidLoadHomeVC"
//                                                            object:nil];
//
//    } else {
        //资讯
        [self initInfoTableView];
        //获取资讯列表
        [self requestInfoList];
        //刷新
        [self.infoTableView beginRefreshing];
//    }
    // Do any additional setup after loading the view.
}
#pragma mark - Init
- (void)addNotification {
    //用户登录刷新首页快讯
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewsFlash) name:kUserLoginNotification object:nil];
    //用户退出登录刷新首页快讯
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewsFlash) name:kUserLoginOutNotification object:nil];
    //收到推送刷新首页快讯
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshNewsFlash)
                                                 name:@"DidReceivePushNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(indexChange:) name:@"indexChange" object:nil];
    
}

- (void)refreshNewsFlash {
    
    //
    [self.flashTableView beginRefreshing];
}
//切换子标题
- (void)indexChange: (NSNotification*)not
{
    NSDictionary * infoDic = [not object];
    NSString * type = infoDic[@"str"];
    self.type = type;
    [self requestInfoList];
    
}

- (void)initInfoTableView {
    self.type = @"0";
    self.infoTableView = [[ArticleCommentTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.infoTableView.refreshDelegate = self;
    self.infoTableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无资讯"];
    
    [self.view addSubview:self.infoTableView];
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Data

//
- (void)requestInfoList {
    
    BaseWeakSelf;
    
    TLNetworking *http = [TLNetworking new];
//    U201805160952110342835
    http.code = @"628198";
    
    http.parameters[@"type"] = self.code;
    http.parameters[@"status"] = self.type;
    http.parameters[@"start"] = @"0";
    http.parameters[@"limit"] = @"1";
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
        self.infos = self.articleModel.list;
        self.infoTableView.infos = self.articleModel.list;
        
        [self.infoTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
//    helper.tableView = self.infoTableView;
    
//    [helper modelClass:[ArticleModel class]];
    
//    [self.infoTableView addRefreshAction:^{
//
//        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
//
//
//            weakSelf.infos = objs;
//            //数据转给tableview
//            weakSelf.infoTableView.infos = objs;
//
//            [weakSelf.infoTableView reloadData_tl];
//
//        } failure:^(NSError *error) {
//
//        }];
//    }];
//
//    [self.infoTableView addLoadMoreAction:^{
//
//        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
//
//            weakSelf.infos = objs;
//
//            weakSelf.infoTableView.infos = objs;
//
//            [weakSelf.infoTableView reloadData_tl];
//
//        } failure:^(NSError *error) {
//
//        }];
//    }];
//
//    [self.infoTableView endRefreshingWithNoMoreData_tl];
}

- (void)requstMyArticleList
{
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628198";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"status"] = @"0";
    http.parameters[@"start"] = @"0";
    http.parameters[@"limit"] = @"1";

    
    [http postWithSuccess:^(id responseObject) {
        

        
    } failure:^(NSError *error) {
        
    }];
    
    
}
/**
 用户点击cell阅读快讯
 */
- (void)userClickNewsFlash:(NewsFlashModel *)flashModel {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628094";
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"code"] = flashModel.code;
    
    [http postWithSuccess:^(id responseObject) {
        
        flashModel.isRead = @"1";
        flashModel.isSelect = YES;
        [self.flashTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BaseWeakSelf;
    
    
    InfoDetailVC *detailVC = [InfoDetailVC new];
    
    detailVC.code = self.infos[indexPath.row].code;
    detailVC.title = self.titleStr;
    detailVC.collectionBlock = ^{
        
        [weakSelf.infoTableView beginRefreshing];
    };
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)refreshTableViewButtonClick:(TLTableView *)refreshTableview button:(UIButton *)sender selectRowAtIndex:(NSInteger)index {
    
    NewsFlashModel *flashModel = self.news[index];
    
    NewsFlashDetailVC *detailVC = [NewsFlashDetailVC new];
    
    detailVC.code = flashModel.code;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    return ;
    //     [self.refreshDelegate refreshTableViewButtonClick:self button:sender selectRowAtIndex:index];
}

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
