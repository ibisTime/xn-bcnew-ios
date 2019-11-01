//
//  CollectionActivityVC.m
//  ljs
//
//  Created by zhangfuyu on 2018/5/26.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "CollectionActivityVC.h"
#import "AcvitityInformationListTableView.h"
#import "detailActivityVC.h"
@interface CollectionActivityVC ()<RefreshDelegate>
@property (nonatomic , strong)AcvitityInformationListTableView *ActivityListTableView;
@property (nonatomic , strong)NSMutableArray <ActivityDetailModel *>*infos;
@property (nonatomic , strong) detailActivityVC * detOfActVC;
@property (nonatomic , strong) TLPlaceholderView * holdView;

@end

@implementation CollectionActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initActivityListTableView];
    [self requestInfoList];
    [self.ActivityListTableView beginRefreshing];

    // Do any additional setup after loading the view.
    
}
- (void)initActivityListTableView {
    
    self.ActivityListTableView = [[AcvitityInformationListTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.ActivityListTableView.siCollection = YES;
    
    //    self.repaymentListTableView.refreshDelegate = self;

    self.ActivityListTableView.placeHolderView  =self.holdView;
//    self.holdView = [TLPlaceholderView placeholderViewWithImage:@"暂无动态" text:@"暂无收藏"];
    self.ActivityListTableView.defaultNoDataText = @"暂无收藏";
    self.ActivityListTableView.defaultNoDataImage = kImage(@"暂无动态");
    self.ActivityListTableView.refreshDelegate = self;
    [self.view addSubview:self.ActivityListTableView];
    [self.ActivityListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.ActivityListTableView beginRefreshing];
}
- (void)requestInfoList {
    
    BaseWeakSelf;
    
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    
//    helper.code = @"628205";
    helper.code = @"628515";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.parameters[@"token"] = [TLUser user].token;
//    helper.parameters[@"type"] = self.code;
    helper.start = 1;
    helper.limit = 20;
    
    helper.tableView = self.ActivityListTableView;
    
    [helper modelClass:[ActivityDetailModel class]];
    
    [self.ActivityListTableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            if (objs.count <=0) {
                weakSelf.ActivityListTableView.infos = objs;
                [weakSelf.ActivityListTableView reloadData_tl];
                [weakSelf.ActivityListTableView addSubview:weakSelf.holdView];

                return ;
            }
            
            weakSelf.infos = objs;
            //数据转给tableview
            [weakSelf.holdView removeFromSuperview];
            weakSelf.ActivityListTableView.infos = objs;
            
            [weakSelf.ActivityListTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.ActivityListTableView addLoadMoreAction:^{
        
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            if (objs.count <=0) {
                [weakSelf.ActivityListTableView addSubview:weakSelf.holdView];
                weakSelf.ActivityListTableView.infos = objs;
                [weakSelf.ActivityListTableView reloadData_tl];

                return ;
            }
            weakSelf.infos = objs;
            [weakSelf.holdView removeFromSuperview];

            weakSelf.ActivityListTableView.infos = objs;
            
            [weakSelf.ActivityListTableView reloadData_tl];
            
        } failure:^(NSError *error) {
            
        }];
    }];
    
    [self.ActivityListTableView endRefreshingWithNoMoreData_tl];
}


#pragma mark - RefreshDelegate
- (void)refreshTableView:(TLTableView*)refreshTableview didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    [self.ActivityListTableView deselectRowAtIndexPath:indexPath animated:YES];
    detailActivityVC * detOfActVC = [[detailActivityVC alloc ] init ];
    self.detOfActVC = detOfActVC;
    
    ActivityDetailModel *model = self.infos[indexPath.row];
    
    detOfActVC.code = model.code;
    [self.navigationController pushViewController:detOfActVC animated:YES];
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
