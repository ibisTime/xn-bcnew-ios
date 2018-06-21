//
//  ForumInfoChildVC.m
//  ljs
//
//  Created by 蔡卓越 on 2018/3/23.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "ForumInfoChildVC.h"

//M
#import "InformationModel.h"
//V
#import "ForumInfoTableView.h"
#import "TLPlaceholderView.h"
//C
#import "InfoDetailVC.h"

@interface ForumInfoChildVC ()<RefreshDelegate>
//资讯
@property (nonatomic, strong) ForumInfoTableView *infoTableView;
//infoList
@property (nonatomic, strong) NSArray <InformationModel *>*infos;

@end

@implementation ForumInfoChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //资讯
    [self initInfoTableView];
    //获取资讯列表
    [self requestInfoList];
    //添加通知
    [self addNotification];
}

#pragma mark - Notification
- (void)addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"RefreshForumDetail" object:nil];
    
}

- (void)refresh:(NSNotification *)notification {
    
    //获取资讯列表
    [self requestInfoList];
}

#pragma mark - Setting
- (void)setVcCanScroll:(BOOL)vcCanScroll {
    
    _vcCanScroll = vcCanScroll;
    
    self.infoTableView.vcCanScroll = vcCanScroll;
    
    self.infoTableView.contentOffset = CGPointZero;
}

#pragma mark - Init
- (void)initInfoTableView {
    
    self.infoTableView = [[ForumInfoTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    self.infoTableView.refreshDelegate = self;
    self.infoTableView.tag = 1800 + self.index;
    self.infoTableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"暂无动态" text:@"暂无资讯"];
    
    [self.view addSubview:self.infoTableView];
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Data
- (void)requestInfoList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
    helper.code = @"628205";
    
    helper.parameters[@"toCoin"] = self.toCoin;
    
    helper.tableView = self.infoTableView;
    
    [helper modelClass:[InformationModel class]];
    
    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
        
        weakSelf.infos = objs;
        weakSelf.infoTableView.infos = objs;
        [weakSelf.infoTableView reloadData_tl];
        
        if (weakSelf.refreshSuccess) {
            
            weakSelf.refreshSuccess();
        }
        
    } failure:^(NSError *error) {
        
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

#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    InfoDetailVC *detailVC = [InfoDetailVC new];
    
    detailVC.code = self.infos[indexPath.row].code;
    
    [self.navigationController pushViewController:detailVC animated:YES];
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
