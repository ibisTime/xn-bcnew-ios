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
#import "UIBarButtonItem+convience.h"
@interface ArticleStateController ()<RefreshDelegate>
//快讯
@property (nonatomic, strong) NewsFlashListTableView *flashTableView;
//news
@property (nonatomic, strong) NSArray <NewsFlashModel *>*news;


//资讯
@property (nonatomic, strong) ArticleCommentTableView *infoTableView;
//infoList
@property (nonatomic, strong) NSMutableArray <ArticleCommentModel *>*infos;
//**********************************


//
@property (nonatomic, strong) TLPageDataHelper *flashHelper;

@property (nonatomic, strong) ArticleModel *articleModel;

@property (nonatomic, strong) ArticleCommentModel *commentModel;

@property (nonatomic, strong) TLPlaceholderView *holdView;


@property (nonatomic)NSInteger page;
@property (nonatomic,copy) NSString *currtntType;

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

- (void)callUs
{
    
    
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
    [self.infoTableView beginRefreshing];
    [self requestInfoList];
    
}

- (void)initInfoTableView {
    self.type = @"0";
    self.page = 1;
    self.infos = [NSMutableArray array];
    self.infoTableView = [[ArticleCommentTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.infoTableView.refreshDelegate = self;
    self.holdView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无文章"];
    self.infoTableView.placeHolderView = self.holdView;

    self.infoTableView.tableFooterView = [UIView new];
    self.infoTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic)];
    self.infoTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
    [self.view addSubview:self.infoTableView];
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Data
- (void)loadNewTopic
{
    self.page = 1;
    [self requestInfoList];
}
- (void)loadMoreTopic
{
    self.page ++;
    [self requestInfoList];
}
//
- (void)requestInfoList {
    
    BaseWeakSelf;
    
    TLNetworking *http = [TLNetworking new];
//    U201805160952110342835
    http.code = @"628198";
    
    http.parameters[@"type"] = self.code;
    http.parameters[@"status"] = self.type;
    http.parameters[@"start"] = @(self.page);
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
        if (self.articleModel.list.count > 0) {
            [self.placeholderView removeFromSuperview];
            self.currtntType = self.type;
            self.infos = self.articleModel.list;
            self.infoTableView.infos = self.articleModel.list;
            [self.infoTableView reloadData];
            [self.infoTableView.mj_footer endRefreshing];
            [self.infoTableView.mj_header endRefreshing];

        }else{
            if (self.type != self.currtntType) {
                self.infoTableView.infos = [NSMutableArray array];
                [self.infoTableView addSubview:self.holdView];
                if (self.page != 1) {
                    self.page --;
                    
                }
                [self.infoTableView.mj_footer endRefreshing];
                [self.infoTableView.mj_header endRefreshing];
            }else{
                
                [self.infoTableView addSubview:self.holdView];
                if (self.page != 1) {
                    self.page --;
                    
                }
                [self.infoTableView.mj_footer endRefreshing];
                [self.infoTableView.mj_header endRefreshing];
            }
//            [self.infoTableView reloadData];
            
        }
       
    } failure:^(NSError *error) {
        [self.placeholderView removeFromSuperview];

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

- (void)requstInfo
{
    
    
    BaseWeakSelf;
    
    TLPageDataHelper *httper = [TLPageDataHelper new];
    //    U201805160952110342835
    httper.code = @"628198";
    
    httper.parameters[@"type"] = self.code;
    httper.parameters[@"status"] = self.type;
    httper.parameters[@"start"] = @"0";
    httper.parameters[@"limit"] = @"1";
    if ([TLUser user].isLogin) {
        
        httper.parameters[@"userId"] = [TLUser user].userId;
        httper.parameters[@"token"] = [TLUser user].token;
        
    } else {
        
        httper.parameters[@"userId"] = @"";
        httper.parameters[@"token"] = @"";
        
    }
    [httper modelClass:[ArticleCommentModel class]];
    [self.infoTableView addRefreshAction:^{
        
        [httper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            if (objs.count == 0) {
                [weakSelf.view addSubview:weakSelf.placeholderView];
                return ;
            }
            weakSelf.infos = objs;
            weakSelf.infoTableView.infos = objs;
            
            [weakSelf.placeholderView removeFromSuperview];
            
            //            weakSelf.infos = objs;
            //            //数据转给tableview
            //            weakSelf.infoTableView.infos = objs;
            
            [weakSelf.infoTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            [weakSelf.view addSubview:weakSelf.placeholderView];

        }];
    }];
    
    [self.infoTableView addLoadMoreAction:^{
        
        [httper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            if (objs.count == 0) {
                [weakSelf.view addSubview:weakSelf.placeholderView];
                return ;
            }
            [weakSelf.placeholderView removeFromSuperview];

            weakSelf.infos = objs;
            
            weakSelf.infoTableView.infos = objs;
            
            [weakSelf.infoTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.infoTableView endRefreshingWithNoMoreData_tl];
    

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
