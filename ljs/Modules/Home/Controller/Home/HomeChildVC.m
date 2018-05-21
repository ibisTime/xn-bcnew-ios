//
//  HomeChildVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/12.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "HomeChildVC.h"
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

@interface HomeChildVC ()<RefreshDelegate>

//*************************************接盘
//快讯
@property (nonatomic, strong) NewsFlashListTableView *flashTableView;
//news
@property (nonatomic, strong) NSArray <NewsFlashModel *>*news;


//资讯
@property (nonatomic, strong) InformationListTableView *infoTableView;
//infoList
@property (nonatomic, strong) NSArray <InformationModel *>*infos;
//**********************************


//
@property (nonatomic, strong) TLPageDataHelper *flashHelper;

@end

@implementation HomeChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //添加通知
    [self addNotification];
    
    if ([self.kind isEqualToString:kNewsFlash]) {
        //快讯
        [self initFlashTableView];
        //获取快讯列表
        [self requestFlashList];
        //刷新
        [self.flashTableView beginRefreshing];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DidLoadHomeVC"
                                                            object:nil];
        
    } else {
        //资讯
        [self initInfoTableView];
        //获取资讯列表
        [self requestInfoList];
        //刷新
        [self.infoTableView beginRefreshing];
    }
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
}

- (void)refreshNewsFlash {
    
    //
    [self.flashTableView beginRefreshing];
}
//快讯全部
- (void)initFlashTableView {
    
    self.flashTableView = [[NewsFlashListTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    self.flashTableView.isAll = [self.status isEqualToString:kAllNewsFlash];
    self.flashTableView.refreshDelegate = self;
    self.flashTableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无快讯"];

    [self.view addSubview:self.flashTableView];
    [self.flashTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

- (void)initInfoTableView {
    
    self.infoTableView = [[InformationListTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.infoTableView.refreshDelegate = self;
    self.infoTableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无资讯"];
    
    [self.view addSubview:self.infoTableView];
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Data
- (void)requestFlashList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628097";

    helper.parameters[@"type"] = self.status;
    
    helper.tableView = self.flashTableView;
    
    self.flashHelper = helper;
    
    [helper modelClass:[NewsFlashModel class]];
    
    [self.flashTableView addRefreshAction:^{
      //
        if ([TLUser user].isLogin) {
            
            helper.parameters[@"userId"] = [TLUser user].userId;
        } else {
            
            helper.parameters[@"userId"] = @"";
        }
        //
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.news = objs;
            
            weakSelf.flashTableView.news = objs;
            NSLog(@"....???%@",weakSelf.flashTableView.news);

            [weakSelf.flashTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
   // 拉加载更多
    [self.flashTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
           //中转
            weakSelf.news = objs;
            
            weakSelf.flashTableView.news = objs;
            [weakSelf.flashTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
        
    }];
    
    [self.flashTableView endRefreshingWithNoMoreData_tl];
}
//
- (void)requestInfoList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628205";
    
    helper.parameters[@"type"] = self.code;
    
    helper.tableView = self.infoTableView;
    
    [helper modelClass:[InformationModel class]];
    
    [self.infoTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            
            weakSelf.infos = objs;
            //数据转给tableview
            weakSelf.infoTableView.infos = objs;
            
            [weakSelf.infoTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.infoTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
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
    
    if ([self.kind isEqualToString:kNewsFlash]) {
        
        NewsFlashModel *flashModel = self.news[indexPath.section];
        
        if ([[TLUser user] isLogin] && [flashModel.isRead isEqualToString:@"0"]) {
            
            //用户点击阅读快讯
            [self userClickNewsFlash:flashModel];
            
        }else {

            [self.flashTableView reloadData];
        }
        
        return ;
    }
    InfoDetailVC *detailVC = [InfoDetailVC new];
    detailVC.IsNeed = YES;
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


@end
