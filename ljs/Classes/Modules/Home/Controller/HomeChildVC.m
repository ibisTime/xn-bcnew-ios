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
//快讯
@property (nonatomic, strong) NewsFlashListTableView *flashTableView;
//news
@property (nonatomic, strong) NSArray <NewsFlashModel *>*news;
//资讯
@property (nonatomic, strong) InformationListTableView *infoTableView;
//infoList
@property (nonatomic, strong) NSArray <InformationModel *>*infos;

@end

@implementation HomeChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self.kind isEqualToString:kNewsFlash]) {
        //快讯
        [self initFlashTableView];
        //获取快讯列表
        [self requestFlashList];
        
        NSMutableArray <NewsFlashModel *>*arr = [NSMutableArray array];
        
        for (int i = 0; i < 10; i++) {
            
            NewsFlashModel *model = [NewsFlashModel new];
            
            model.title = @"天赋很重要";
            model.content = @"但也仅仅事关你艺术造诣上的突破，艺考这点事，犯不上每个人都得动用自己的天赋。艺考这东西已经体制化，僵硬化了用自己的天赋。艺考这东用自己的天赋。";
            model.time = @"May 1, 2018 3:27:08 AM";
            
            [arr addObject:model];
        }
        
        self.news = arr;
        
        self.flashTableView.news = self.news;
        
        [self.flashTableView reloadData];
        
        //
//        [self.flashTableView beginRefreshing];
        
    } else {
        //资讯
        [self initInfoTableView];
        //获取资讯列表
        [self requestInfoList];
        
        NSMutableArray <InformationModel *>*arr = [NSMutableArray array];
        
        for (int i = 0; i < 10; i++) {
            
            InformationModel *model = [InformationModel new];
            
            model.title = @"但也仅仅事关你艺术造诣上的突破，艺考这点事，犯不上每个人都得动用自己的天赋。艺考这东西已经体制化，僵硬化了用自己的天赋。艺考这东用自己的天赋。";
            model.time = @"May 1, 2018 3:27:08 AM";
            model.collectNum = 99;
            
            [arr addObject:model];
        }
        
        self.infoTableView.infos = arr;
        
        [self.infoTableView reloadData];
        
        //
//        [self.flashTableView beginRefreshing];
    }
}

#pragma mark - Init
- (void)initFlashTableView {
    
    self.flashTableView = [[NewsFlashListTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    self.flashTableView.refreshDelegate = self;
    self.flashTableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无订单" text:@"暂无快讯"];

    [self.view addSubview:self.flashTableView];
    [self.flashTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

- (void)initInfoTableView {
    
    self.infoTableView = [[InformationListTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.infoTableView.refreshDelegate = self;
    self.infoTableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无订单" text:@"暂无资讯"];
    
    [self.view addSubview:self.infoTableView];
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Data
- (void)requestFlashList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"";

    helper.parameters[@""] = [TLUser user].userId;
    
    helper.tableView = self.flashTableView;
    
    [helper modelClass:[NewsFlashModel class]];
    
    [self.flashTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.news = objs;
            
            weakSelf.flashTableView.news = objs;
            
            [weakSelf.flashTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.flashTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
        } failure:^(NSError *error) {
            
        }];
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.news = objs;
            
            weakSelf.flashTableView.news = objs;
            
            [weakSelf.flashTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.flashTableView endRefreshingWithNoMoreData_tl];
}

- (void)requestInfoList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"";
    
    helper.parameters[@""] = [TLUser user].userId;
    
    helper.tableView = self.infoTableView;
    
    [helper modelClass:[InformationModel class]];
    
    [self.infoTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.infos = objs;
            
            weakSelf.infoTableView.infos = objs;
            
            [weakSelf.infoTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
            
        }];
    }];
    
    [self.infoTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
        } failure:^(NSError *error) {
            
        }];
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            weakSelf.infos = objs;
            
            weakSelf.infoTableView.infos = objs;
            
            [weakSelf.infoTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.infoTableView endRefreshingWithNoMoreData_tl];
}

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InfoDetailVC *detailVC = [InfoDetailVC new];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)refreshTableViewButtonClick:(TLTableView *)refreshTableview button:(UIButton *)sender selectRowAtIndex:(NSInteger)index {
    
    NewsFlashModel *flashModel = self.news[index];
    
    NewsFlashDetailVC *detailVC = [NewsFlashDetailVC new];
    
    detailVC.flashModel = flashModel;
    
    [self.navigationController pushViewController:detailVC animated:YES];
    return ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
