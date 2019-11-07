//
//  FeedBookDetailsVC.m
//  Coin
//
//  Created by 郑勤宝 on 2019/5/20.
//  Copyright © 2019 chengdai. All rights reserved.
//

#import "FeedBookDetailsVC.h"
#import "QuestionModel.h"
#import "FeedBookDetailsTableView.h"
@interface FeedBookDetailsVC ()<RefreshDelegate>
@property (nonatomic ,strong) QuestionModel *questionModel;
@property (nonatomic , strong)FeedBookDetailsTableView *tableView;
@end

@implementation FeedBookDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"问题详情";
    
    [self initTableView];
    [self.view addSubview:self.tableView];
    [self loadList];
    
}

- (void)initTableView {
    self.tableView = [[FeedBookDetailsTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kNavigationBarHeight) style:(UITableViewStyleGrouped)];
    self.tableView.refreshDelegate = self;

    [self.view addSubview:self.tableView];
    
}

- (void)loadList
{
    MJWeakSelf;
    
    TLNetworking *helper = [[TLNetworking alloc] init];
    if (![TLUser user].isLogin) {
        return;
    }
    
    helper.code = @"805106";
    helper.parameters[@"code"] = self.code;
    
    
    [helper postWithSuccess:^(id responseObject) {
        weakSelf.questionModel = [QuestionModel mj_objectWithKeyValues:responseObject[@"data"]];
        weakSelf.tableView.questionModel = weakSelf.questionModel;
        [self.tableView reloadData];
        
        //        NSLog(@"%@",objs);
    } failure:^(NSError *error) {
        
    }];
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
