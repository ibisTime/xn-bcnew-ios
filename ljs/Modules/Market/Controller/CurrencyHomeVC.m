//
//  CurrencyHomeVC.m
//  ljs
//
//  Created by 郑勤宝 on 2019/10/31.
//  Copyright © 2019 caizhuoyue. All rights reserved.
//

#import "CurrencyHomeVC.h"
#import "PlatformTableView.h"
#import "PlatformModel.h"
#import "CurrencyPriceModel.h"
#import "CurrencyTableVIew.h"
#import "UIButton+SGImagePosition.h"
#import "CurrencyKLineVC.h"
#import "TLProgressHUD.h"
@interface CurrencyHomeVC ()
@property (nonatomic , strong)CurrencyTableVIew *tableView;
@property (nonatomic, strong) NSArray <CurrencyPriceModel *>*platforms;
//
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation CurrencyHomeVC

-(void)viewWillAppear:(BOOL)animated
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(loadData) userInfo:nil repeats:YES];
    [self loadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBarHidden = NO;
    [self.timer invalidate];
    self.timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    
    BaseWeakSelf;
    [self.tableView addRefreshAction:^{
        [weakSelf loadData];
    }];
    [self.tableView beginRefreshing];
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(InfoNotificationAction:) name:@"SwitchDirection" object:nil];
}

#pragma mark -- 接收到通知
- (void)InfoNotificationAction:(NSNotification *)notification{
    self.direction = notification.userInfo[@"direction"];
    [self loadData];
}

#pragma mark -- 删除通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SwitchDirection" object:nil];
}

- (void)initTableView {
    
    self.tableView = [[CurrencyTableVIew alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    BaseWeakSelf;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(35, 0, 0, 0));
    }];
    self.tableView.pagingEnabled = false;
    self.tableView.type = PlatformTypeAll;
    self.tableView.selectBlock = ^(NSString *idear) {
        [weakSelf pushCurrencyKLineVCWith:idear];
    };
//    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无平台"];
    self.tableView.defaultNoDataText = @"暂无币种";
    self.tableView.defaultNoDataImage = kImage(@"暂无动态");
}

- (void)pushCurrencyKLineVCWith:(NSString *)idear
{
    CurrencyKLineVC *kineVC = [[CurrencyKLineVC alloc]init];
    kineVC.symbolID = idear;
    [self.navigationController pushViewController:kineVC animated:YES];
}

-(void)loadData
{
    BaseWeakSelf;
    TLNetworking *http = [TLNetworking new];
    http.code = @"628350";
    http.parameters[@"start"] = @"1";
    http.parameters[@"limit"] = @"1000";
    http.parameters[@"symbol"] = self.symbol;
    http.parameters[@"direction"] = self.direction;
    if ([TLUser user].isLogin == NO && [self.direction isEqualToString:@"2"]) {
        return;
    }else
    {
     
        http.parameters[@"userId"] = [TLUser user].userId;
    }
    [http postWithSuccess:^(id responseObject) {
        weakSelf.platforms = [PlatformModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
        weakSelf.tableView.currencyPrices = weakSelf.platforms;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView endRefreshHeader];
        [TLProgressHUD dismiss];
    } failure:^(NSError *error) {
        [weakSelf.tableView endRefreshHeader];
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
