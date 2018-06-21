//
//  PlatformAndOtherVC.m
//  ljs
//
//  Created by zhangfuyu on 2018/5/24.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PlatformAndOtherVC.h"
#import "PlatformAndOtherCell.h"
#import "CurrencyPriceModel.h"

@interface PlatformAndOtherVC ()<UITableViewDelegate , UITableViewDataSource,PlatformAndOtherCellDelegate>
@property (nonatomic , strong)UITableView *platformTable;
@property (nonatomic , strong)NSMutableArray *platformArry;
@property (nonatomic , strong) TLPlaceholderView *hold;
@property (nonatomic)NSInteger page;

@end

@implementation PlatformAndOtherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLists) name:kUserLoginNotification object:nil];
    self.page = 1;
    self.platformArry = [NSMutableArray arrayWithCapacity:0];
    [self.platformTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
//    [self getLists];
}
- (void)searchRequestWith:(NSString *)search
{
    self.searchText = search;
    [self.platformTable.mj_header beginRefreshing];

    [self getLists];
}
- (void)getLists
{
    
    
    
    TLPageDataHelper *http = [TLPageDataHelper new];
    http.showView = self.view;
    http.code = @"628350";;
//    if (self.isCurrency) {
//
//        http.parameters[@"symbol"] = self.searchText;
//    }else {
//
//        http.parameters[@"exchangeEname"] = self.searchText;
//    }
    http.parameters[@"userId"] = [TLUser user].userId;
    http.parameters[@"start"] = @(self.page);
    http.parameters[@"limit"] = @"20";
    http.parameters[@"keywords"] = self.searchText;
    [http modelClass:[CurrencyPriceModel class]];
    
    [http refresh:^(NSMutableArray *objs, BOOL stillHave) {
        if (self.page == 1) {
            [self.platformArry removeAllObjects];
        }
        if (objs.count == 0) {
            [self.platformTable addSubview:self.hold];
            [self.platformTable.mj_footer endRefreshing];
            [self.platformTable.mj_header endRefreshing];
            return ;
        }
        
        [self.hold removeFromSuperview];
        
        if (objs.count != 0) {
           
            self.platformArry = objs;
        }
        else
        {
            if (self.page != 1) {
                self.page --;

            }
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
     TLPlaceholderView *hold =  [TLPlaceholderView placeholderViewWithImage:@"暂无搜索结果" text:@"暂时没有搜索到你想要的信息"];
        self.hold = hold;
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
    cell.index = indexPath;
    cell.delegate = self;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68;
}
- (void)selectAddBtn:(NSIndexPath *)indexpath
{
    BaseWeakSelf;
    [self checkLogin:^{
        CurrencyPriceModel *model = [self.platformArry objectAtIndex:indexpath.row];
        TLNetworking *http = [TLNetworking new];
        
        if ([model.isChoice boolValue]) {
            http.code = @"628332";
            http.showView = self.view;
            http.parameters[@"id"] = model.choiceId;

            
            [http postWithSuccess:^(id responseObject) {
                
                [TLAlert alertWithSucces:@"移除成功"];
                
                model.isChoice = @"0";
                [weakSelf.platformArry replaceObjectAtIndex:indexpath.row withObject:model];
                [weakSelf.platformTable reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
                
            } failure:^(NSError *error) {
                
            }];
        }
        else
        {
            http.code = @"628330";
            http.showView = self.view;
            http.parameters[@"userId"] = [TLUser user].userId;
            http.parameters[@"exchangeEname"] = model.exchangeEname;
            http.parameters[@"symbol"] = model.symbol;
            http.parameters[@"toSymbol"] = model.toSymbol;
            
            [http postWithSuccess:^(id responseObject) {
                
                [TLAlert alertWithSucces:@"添加成功"];
                
                model.isChoice = @"1";
                [weakSelf.platformArry replaceObjectAtIndex:indexpath.row withObject:model];
                [weakSelf.platformTable reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
                
            } failure:^(NSError *error) {
                
            }];
        }
        
        
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
