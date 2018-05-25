//
//  PlatformAndOtherVC.m
//  ljs
//
//  Created by zhangfuyu on 2018/5/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PlatformAndOtherVC.h"
#import "PlatformAndOtherCell.h"

@interface PlatformAndOtherVC ()<UITableViewDelegate , UITableViewDataSource>
@property (nonatomic , strong)UITableView *platformTable;
@property (nonatomic , strong)NSMutableArray *platformArry;
@property (nonatomic)NSInteger page;

@end

@implementation PlatformAndOtherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.page = 1;
    self.platformArry = [NSMutableArray arrayWithCapacity:0];
    [self.platformTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
    [self getLists];
}
- (void)getLists
{
    
    TLNetworking *http = [TLNetworking new];
    http.showView = self.view;

    
    http.code = @"628350";;
    http.parameters[@"symbol"] = @"EOS";
    http.parameters[@"start"] = @(self.page);
    http.parameters[@"limit"] = @"20";
    
    [http postWithSuccess:^(id responseObject) {
        
        NSArray *newObjs = responseObject[@"data"][@"list"];
        if (self.page == 1) {
            [self.platformArry removeAllObjects];
        }
        if (newObjs.count != 0) {
            NSMutableArray *objs = [[CurrencyPriceModel class] mj_objectArrayWithKeyValuesArray:newObjs];
            [self.platformArry addObjectsFromArray:objs];
        }
        else
        {
            self.page --;
        }
        [self.platformTable reloadData];
        [self.platformTable.mj_footer endRefreshing];
        [self.platformTable.mj_header endRefreshing];

        
    } failure:^(NSError *error) {
    
    }];
    
//    TLPageDataHelper *helper = [[TLPageDataHelper alloc] init];
//    helper.showView = self.view;
//    helper.code = @"628350";
//    helper.parameters[@"symbol"] = @"EOS";
//
//
//    helper.parameters[@"start"] = @(self.page);
//    helper.parameters[@"limit"] = @"20";
//
//    helper.parameters[@"userId"] = [TLUser user].userId;
//
//    [helper modelClass:[CurrencyPriceModel class]];
//    [helper refresh:^(NSMutableArray *objs, BOOL stillHave) {
//        if (self.page == 1) {
//            [self.platformArry removeAllObjects];
//        }
//        NSLog(@"--->%@",objs);
//        [self.platformArry addObjectsFromArray:objs];
//        [self.platformTable reloadData];
//        [self.platformTable.mj_footer endRefreshing];
//        [self.platformTable.mj_header endRefreshing];
//
//
//    } failure:^(NSError *error) {
//
//    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UITableView *)platformTable
{
    if (!_platformTable) {
        _platformTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _platformTable.delegate = self;
        _platformTable.dataSource = self;
        _platformTable.tableFooterView = [UIView new];
        [self.view addSubview:_platformTable];
        
        _platformTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic)];
        _platformTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
    }
    return _platformTable;
}

- (void)loadNewTopic
{
    self.page = 1;
    [self getLists];
}
- (void)loadMoreTopic
{
    self.page ++;
    [self getLists];
}
#pragma mark - UITableviewDelegate &&datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.platformArry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidear = @"plarfoemcell";
    PlatformAndOtherCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidear];
    if (!cell) {
        cell = [[PlatformAndOtherCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidear];
    }
    cell.currency = (CurrencyPriceModel *)[self.platformArry objectAtIndex:indexPath.row];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
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
