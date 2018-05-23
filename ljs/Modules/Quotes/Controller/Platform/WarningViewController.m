//
//  WarningViewController.m
//  ljs
//
//  Created by zhangfuyu on 2018/5/22.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "WarningViewController.h"
#import "WarningTirleView.h"
#import "WarningCurrencyView.h"
#import "TLAlert.h"
#import "PlatformWarningModel.h"
#import "WarningableViewCell.h"
#import <MJRefresh.h>
@interface WarningViewController ()<WarningCurrencyViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong)NSMutableArray *addWarningArry;
@property (nonatomic , strong)UITableView *warningTable;
@property (nonatomic)NSInteger page;
@end

@implementation WarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"预警";
    self.page = 1;
    
    self.addWarningArry = [NSMutableArray arrayWithCapacity:0];
    
    [self getcurrentList];
    
    [self addtopInfoView];
    
    
}
- (void)getcurrentList
{
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628395";
    http.showView = self.view;
    http.parameters[@"userId"] = [TLUser user].userId;
    
    http.parameters[@"exchangeEname"] = self.platform.exchangeCname;
    http.parameters[@"symbol"] = self.platform.symbol;
    http.parameters[@"toSymbol"] = self.platform.toSymbol;
    http.parameters[@"status"] = @"0";
    http.parameters[@"start"] = @(self.page);
    http.parameters[@"limit"] = @"10";
    http.parameters[@"id"] = self.platform.ID;


    BaseWeakSelf;
    [http postWithSuccess:^(id responseObject) {
        NSLog(@"--->%@",responseObject);
        NSArray *arry = responseObject[@"data"][@"list"];
        
        if (self.page == 1) {
            [self.addWarningArry removeAllObjects];
        }
        
        for (NSInteger index = 0 ; index < arry.count; index ++) {
            PlatformWarningModel *model = [PlatformWarningModel mj_objectWithKeyValues:(NSDictionary *)[arry objectAtIndex:index]];
            [self.addWarningArry addObject:model];
        }
        if (arry.count == 0) {
            self.page --;
        }
        [weakSelf.warningTable reloadData];
        [weakSelf.warningTable.mj_header endRefreshing];
        
        //结束尾部刷新
        [weakSelf.warningTable.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        NSLog(@"---->%@",error.localizedDescription);
    }];

}
- (void)addtopInfoView
{
    WarningTirleView *titleinfoView = [[WarningTirleView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 74)];
    titleinfoView.platform = self.platform;
    [self.view addSubview:titleinfoView];
    
    WarningCurrencyView *currencyview = [[WarningCurrencyView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleinfoView.frame), kScreenWidth, 180)];
    currencyview.delegate = self;
    [self.view addSubview:currencyview];
    
    [self.warningTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(currencyview.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    self.warningTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopic)];
    self.warningTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
}
- (void)loadNewTopic
{
    self.page = 1;
    [self getcurrentList];
}
- (void)loadMoreTopic
{
    self.page ++;
    [self getcurrentList];
}
#pragma mark - WarningCurrencyViewDelegate
- (void)addWarning:(NSString *)text isRmb:(BOOL)isRMB isUp:(BOOL)isup
{
    
    NSString *messagetitle = @"";
    
    BOOL isMiss = NO;
    
    if (isRMB) {
        if (isup) {
            if ([text floatValue] < [self.platform.lastCnyPrice floatValue]) {
                messagetitle = @"上涨不能低于当前人民币价格";
                isMiss = YES;
            }
        }
        else
        {
            if ([text floatValue] > [self.platform.lastCnyPrice floatValue]) {
                messagetitle = @"下跌不能高于当前人民币价格";
                isMiss = YES;
            }
        }
    }
    else
    {
        if (isup) {
            if ([text floatValue] < [self.platform.lastUsdPrice floatValue]) {
                messagetitle = @"上涨不能低于当前美元价格";
                isMiss = YES;
            }
        }
        else
        {
            if ([text floatValue] > [self.platform.lastUsdPrice floatValue]) {
                messagetitle = @"下跌不能高于当前美元价格";
                isMiss = YES;
            }
        }
    }
    
    if (isMiss) {
        [TLAlert alertWithTitle:@"警告" message:messagetitle confirmMsg:@"确定" confirmAction:^{
            
            
        }];
    }
    
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628390";
    http.showView = self.view;
    http.parameters[@"userId"] = [TLUser user].userId;

    http.parameters[@"exchangeEname"] = self.platform.exchangeCname;
    http.parameters[@"symbol"] = self.platform.symbol;
    http.parameters[@"toSymbol"] = self.platform.toSymbol;

    http.parameters[@"warnDirection"] = isup ? @"0" : @"1";
    http.parameters[@"warnCurrency"] = isRMB ? @"CNY" : @"USD";

    http.parameters[@"warnPrice"] = text;
    http.parameters[@"warnContent"] = @"赶紧卖";

    [http postWithSuccess:^(id responseObject) {
        
        NSLog(@"--->%@",responseObject);
        self.page = 1;
        [self getcurrentList];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (UITableView *)warningTable
{
    if (!_warningTable) {
        _warningTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _warningTable.delegate = self;
        _warningTable.dataSource = self;
        _warningTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _warningTable.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        _warningTable.tableFooterView = [UIView new];
        [self.view addSubview:_warningTable];
    }
    return _warningTable;
}
#pragma mark - UITableviewDelegate && UITableviewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addWarningArry.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdear = @"cellIdear";
    WarningableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdear];
    if (!cell) {
        cell = [[WarningableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdear];
    }
    cell.deleteBtn.tag = 100 + indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deletaWarning:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dataModel = [self.addWarningArry objectAtIndex:indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (void)deletaWarning:(UIButton *)sender
{
    NSLog(@"-%@",sender);
    PlatformWarningModel *moedl = [self.addWarningArry objectAtIndex:sender.tag - 100];
    
    TLNetworking *http = [TLNetworking new];
    
    http.code = @"628391";
    http.showView = self.view;
   
    http.parameters[@"id"] = moedl.id;
    
    
    
    [http postWithSuccess:^(id responseObject) {
        NSLog(@"--->%@",responseObject);
        [self.addWarningArry removeObjectAtIndex:sender.tag - 100];
        [self.warningTable deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag - 100 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
       
    } failure:^(NSError *error) {
        NSLog(@"---->%@",error.localizedDescription);
    }];
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
