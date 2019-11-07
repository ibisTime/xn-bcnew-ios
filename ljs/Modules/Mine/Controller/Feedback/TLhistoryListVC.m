//
//  TLhistoryListVC.m
//  Coin
//
//  Created by shaojianfei on 2018/8/4.
//  Copyright © 2018年 chengdai. All rights reserved.
//

#import "TLhistoryListVC.h"
#import "QuestionListTableView.h"
#import "QuestionModel.h"

#import "TLPlaceholderView.h"
#import "FeedBookDetailsVC.h"
@interface TLhistoryListVC ()<RefreshDelegate>

@property (nonatomic ,strong) QuestionListTableView *tableView;
@property (nonatomic,strong) NSArray <QuestionModel *>*questions;

//@property (nonatomic, strong) UIView *placeHolderView;

@property (nonatomic, strong) UIView *placeHolderView;

@end

@implementation TLhistoryListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史反馈";
//    
    [self initTopView];
    
    [self loadList];
    // Do any additional setup after loading the view.
}
- (void)initTopView
{

    self.tableView = [[QuestionListTableView alloc]
                      initWithFrame:CGRectMake(0, 0, kScreenWidth, kSuperViewHeight)
                      style:UITableViewStyleGrouped];
    
//    self.tableView.placeHolderView = self.placeHolderView;
    
    self.tableView.refreshDelegate = self;
    self.tableView.defaultNoDataImage = kImage(@"暂无订单");
    self.tableView.defaultNoDataText = @"暂无明细";
    self.tableView.sectionHeaderHeight = 22;
    [self.view addSubview:self.tableView];
    
    
}

- (void)loadList
{
    MJWeakSelf;
    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
    if (![TLUser user].isLogin) {
        return;
    }
    helper.code = @"805107";
    helper.parameters[@"userId"] = [TLUser user].userId;
    helper.parameters[@"start"] = @"1";
    helper.parameters[@"limit"] = @"10";

   
    helper.tableView = self.tableView;
    [helper modelClass:[QuestionModel class]];
    [self.tableView addRefreshAction:^{
        
        [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
            
            if (objs.count == 0) {
                [weakSelf.tableView addSubview:weakSelf.placeHolderView];
                [weakSelf addPlaceholderView];

            }
            weakSelf.questions = objs;
            weakSelf.tableView.questions = objs;
            [weakSelf.tableView reloadData];
            NSLog(@"%@",objs);
            
        } failure:^(NSError *error) {
            
            [weakSelf addPlaceholderView];

        }];
        
        
        
    }];
    [self.tableView beginRefreshing];
    [self.tableView addLoadMoreAction:^{
        [helper loadMore:^(NSMutableArray *objs, BOOL stillHave) {
            
        } failure:^(NSError *error) {
            
        }];
    }];
   
    
    
    
}


-(void)refreshTableView:(TLTableView *)refreshTableview didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    QiestionDetailVC *d = [QiestionDetailVC new];
    FeedBookDetailsVC *vc = [FeedBookDetailsVC new];
    vc.code = self.questions[indexPath.row].code;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated{

//    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
//        [self.navigationController popToRootViewControllerAnimated:YES];
//
//    }

    [super viewWillDisappear:animated];
    
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
