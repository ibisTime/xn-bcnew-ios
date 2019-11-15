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
#import "BannerModel.h"

//V
#import "NewsFlashListTableView.h"
#import "InformationListTableView.h"
#import "TLPlaceholderView.h"
#import "TLBannerView.h"

//C
#import "NewsFlashDetailVC.h"
#import "InfoDetailVC.h"
#import "WebVC.h"
#import "detailActivityVC.h"

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
@property (nonatomic,strong) NSMutableArray <BannerModel *>*bannerRoom;


//轮播图
@property (nonatomic, strong) TLBannerView *bannerView;

//
@property (nonatomic, strong) TLPageDataHelper *flashHelper;

@property (nonatomic, strong) TLPlaceholderView *hold;

@property (nonatomic, copy)  NSString *currentSearch;

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
        //获取轮番图
        [self requestBannerList];
        //刷新
        [self.infoTableView beginRefreshing];
    }
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"SelectScrollViewNotification" object:nil];
}




#pragma mark -- 接收到通知
- (void)InfoNotificationAction:(NSNotification *)notification{
    
    NSInteger index = [notification.userInfo[@"index"] integerValue];
    if (_index == index) {
        
        //获取轮番图
        BaseWeakSelf;
        
        TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
        
        helper.code = @"628205";
        
        helper.parameters[@"type"] = self.code;
        
        helper.tableView = self.infoTableView;
        
        [helper modelClass:[InformationModel class]];
        
        if (weakSelf.currentSearch.length > 0) {
            helper.parameters[@"keywords"] = weakSelf.currentSearch;
            
        }
        [weakSelf requestBannerList];
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            if (objs.count <= 0) {
                weakSelf.infoTableView.placeHolderView = weakSelf.hold;
                [weakSelf.infoTableView addSubview:weakSelf.hold];
                [weakSelf.infoTableView reloadData];
                return ;
            }
            
            [weakSelf.hold removeFromSuperview];
            weakSelf.infos = objs;
            //数据转给tableview
            weakSelf.infoTableView.infos = objs;
            
            if (!weakSelf.isSearch) {
                [weakSelf.infoTableView reloadData_tl];
                
            }
            
            
        } failure:^(NSError *error) {
            
        }];
    }
}

#pragma mark -- 删除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SelectScrollViewNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
- (void)searchRequestWith:(NSString *)search
{
    self.isSearch = NO;
    if (search.length != 0) {
        self.flashHelper.parameters[@"keywords"] = search;
        self.currentSearch = search;
        [self refreshNewsFlash];
        
        if ([self.kind isEqualToString:kNewsFlash]) {
            //刷新
            [self.flashTableView beginRefreshing];
            
        } else {
            
            //刷新
            [self.infoTableView beginRefreshing];
        }
        
    }
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
    if (self.isSearch == YES) {
//        self.hold = [TLPlaceholderView placeholderViewWithImage:@"暂无搜索结果" text:@"暂时没有搜索到你想要的信息"];
        self.flashTableView.defaultNoDataText = @"暂时没有搜索到你想要的信息";
        self.flashTableView.defaultNoDataImage = kImage(@"暂无搜索结果");
    }else{
//        self.hold = [TLPlaceholderView placeholderViewWithImage:@"暂无动态" text:@"暂时没有资讯"];
        self.flashTableView.defaultNoDataText = @"暂时没有搜索到你想要的信息";
        self.flashTableView.defaultNoDataImage = kImage(@"暂无动态");
    }

//    self.flashTableView.placeHolderView = self.hold;

    [self.view addSubview:self.flashTableView];
    [self.flashTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

- (void)initInfoTableView {
    
    self.infoTableView = [[InformationListTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.infoTableView.refreshDelegate = self;
    
    
    if (self.isSearch == YES) {
        self.infoTableView.defaultNoDataText = @"暂时没有搜索到你想要的信息";
        self.infoTableView.defaultNoDataImage = kImage(@"暂无搜索结果");
//        self.hold = [TLPlaceholderView placeholderViewWithImage:@"暂无搜索结果" text:@"暂时没有搜索到你想要的信息"];
//
    }else{
        self.infoTableView.defaultNoDataText = @"暂时没有搜索到你想要的信息";
        self.infoTableView.defaultNoDataImage = kImage(@"暂无动态");
//        self.hold = [TLPlaceholderView placeholderViewWithImage:@"暂无动态" text:@"暂时没有资讯"];
//
//
    }
    self.infoTableView.placeHolderView = self.hold;

    [self.view addSubview:self.infoTableView];
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    if (self.isActivity) {
        self.infoTableView.tableHeaderView = self.bannerView;
    }
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
        if (weakSelf.currentSearch.length > 0) {
            helper.parameters[@"keywords"] = weakSelf.currentSearch;

        }

        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
//            if (objs.count <= 0) {
//                weakSelf.flashTableView.placeHolderView = weakSelf.hold;
//                [weakSelf.flashTableView addSubview:weakSelf.hold];
//                [weakSelf.flashTableView reloadData];
//                return ;
//            }
            
//            [weakSelf.hold removeFromSuperview];
            weakSelf.news = objs;
            
            weakSelf.flashTableView.news = objs;
            NSLog(@"....???%@",weakSelf.flashTableView.news);
            if (!weakSelf.isSearch) {
                [weakSelf.flashTableView reloadData_tl];

            }
            
        } failure:^(NSError *error) {
            
        }];
    }];
   // 拉加载更多
    [self.flashTableView addLoadMoreAction:^{
        if (weakSelf.currentSearch.length > 0) {
            helper.parameters[@"keywords"] = weakSelf.currentSearch;
            
        }
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
           //中转
//            if (objs.count <= 0) {
//                weakSelf.flashTableView.placeHolderView = weakSelf.hold;
//
//                [weakSelf.flashTableView addSubview:weakSelf.hold];
//                [weakSelf.flashTableView reloadData];
//                return ;
//            }
//
//            [weakSelf.hold removeFromSuperview];
            weakSelf.news = objs;
            
            weakSelf.flashTableView.news = objs;
            if (!weakSelf.isSearch) {
                [weakSelf.flashTableView reloadData_tl];
            }
            
            
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
        if (weakSelf.currentSearch.length > 0) {
            helper.parameters[@"keywords"] = weakSelf.currentSearch;
            
        }
        [weakSelf requestBannerList];
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
//            if (objs.count <= 0) {
//                weakSelf.infoTableView.placeHolderView = weakSelf.hold;
//                [weakSelf.infoTableView addSubview:weakSelf.hold];
//                [weakSelf.infoTableView reloadData];
//                return ;
//            }
//
//            [weakSelf.hold removeFromSuperview];
            weakSelf.infos = objs;
            //数据转给tableview
            weakSelf.infoTableView.infos = objs;
            
            if (!weakSelf.isSearch) {
                [weakSelf.infoTableView reloadData_tl];

            }
            
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.infoTableView addLoadMoreAction:^{
        if (weakSelf.currentSearch.length > 0) {
            helper.parameters[@"keywords"] = weakSelf.currentSearch;
            [weakSelf requestBannerList];

        }
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
//            if (objs.count <= 0) {
//                weakSelf.infoTableView.placeHolderView = weakSelf.hold;
//
//                [weakSelf.infoTableView addSubview:weakSelf.hold];
//                [weakSelf.infoTableView reloadData];
//                return ;
//            }
//
//            [weakSelf.hold removeFromSuperview];
            weakSelf.infos = objs;
            
            weakSelf.infoTableView.infos = objs;
            
            if (!weakSelf.isSearch) {
                [weakSelf.infoTableView reloadData_tl];
            }
            

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
        
//        flashModel.isRead = @"1";
//        flashModel.isSelect = YES;
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

- (TLBannerView *)bannerView {
    
    if (!_bannerView) {
        
        _bannerView = [[TLBannerView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kWidth(150))];
        BaseWeakSelf;
        _bannerView.selected = ^(NSInteger index) {
            BannerModel *model = [weakSelf.bannerRoom objectAtIndex:index];
            NSInteger  type = [model.contentType integerValue];
            switch (type) {
                case 1:
                    if (model.url.length!= 0) {
                        WebVC *webv = [[WebVC alloc]init];
                        webv.url = model.url;
                        [weakSelf.navigationController pushViewController:webv animated:YES];
                    }
                    break;
                case 2:
                    if (model.url.length!= 0) {
                        InfoDetailVC *detailVC = [InfoDetailVC new];
                        detailVC.IsNeed = YES;
                        detailVC.code = model.url;
                        detailVC.title = model.name;
                        
                        [weakSelf.navigationController pushViewController:detailVC animated:YES];
                    }
                   
                    break;
                case 3:
                    if (model.url.length !=0) {
                        detailActivityVC* detOfActVC = [[detailActivityVC alloc ] init ];
                        detOfActVC.code = model.url;
                        [weakSelf.navigationController pushViewController:detOfActVC animated:YES];

                    }
                    break;
                    
                default:
                    break;
            }
            
          
            
        };
        
    }
    return _bannerView;
}

- (void)requestBannerList {
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"805806";
    
    [http postWithSuccess:^(id responseObject) {
        
        self.bannerRoom = [BannerModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        NSMutableArray *imgUrls = [NSMutableArray array];
        NSMutableArray *nameArry = [NSMutableArray array];

        
        [self.bannerRoom enumerateObjectsUsingBlock:^(BannerModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (obj.pic) {
                
                [imgUrls addObject:obj.pic];
                [nameArry addObject:obj.name];
            }
        }];
        if (self.bannerRoom.count > 0) {
            [self.hold removeFromSuperview];
        }else
        {
            self.flashTableView.placeHolderView = self.hold;
            [self.flashTableView addSubview:self.hold];
        }
        self.bannerView.imgUrls = imgUrls;
        self.bannerView.nameArry = nameArry;
        //        self.infoTableView.tableHeaderView = self.headerView;
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
