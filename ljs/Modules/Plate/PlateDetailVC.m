//
//  PlateDetailVC.m
//  ljs
//
//  Created by shaojianfei on 2018/6/18.
//  Copyright © 2018年 caizhuoyue. All rights reserved.
//

#import "PlateDetailVC.h"
#import "PlateTopView.h"
#import "PlateDetailTableView.h"
@interface PlateDetailVC ()<RefreshDelegate>
@property (nonatomic ,strong) TLNetworking *help;

@property (nonatomic ,strong) PlateDetailTableView *tableView;
@property (nonatomic ,strong) PlateTopView *topView;

@end

@implementation PlateDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTable];
    [self.tableView beginRefreshing];
    [self requestPlatform];
    // Do any additional setup after loading the view.
}


- (void)initTable
{
    
    PlateTopView *topView = [[PlateTopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
    [self.view addSubview:topView];

    self.topView = topView;
    UIView *titleView = [[UIView alloc] init];
    CGFloat f1 = CGRectGetMaxY(topView.frame);
    titleView.frame = CGRectMake(0, f1+10, kScreenWidth, 34);
    [self.view addSubview:titleView];
    titleView.backgroundColor = kHexColor(@"#F5F5F5");
    
    UILabel *lab = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    
    UILabel *lab2 = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    UILabel *lab3 = [UILabel labelWithBackgroundColor:kClearColor textColor:kTextColor2 font:14];
    [titleView addSubview:lab];
    [titleView addSubview:lab2];
    [titleView addSubview:lab3];
    lab.frame = CGRectMake(10, 3, 160, 24);
    lab2.frame = CGRectMake(kScreenWidth/2+20, 3, 100, 24);
    lab3.frame = CGRectMake(kScreenWidth/2+20+100, 3, 100, 24);
    lab.text = @"货币/成交额(24h)";
    lab2.text = @"最新价";
    lab3.text = @"涨跌幅";

    self.tableView = [[PlateDetailTableView alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(titleView.frame), kScreenWidth -20, 250) style:UITableViewStylePlain];
    BaseWeakSelf;
    [self.view addSubview:self.tableView];
    
    self.tableView.placeHolderView = [TLPlaceholderView placeholderViewWithImage:@"" text:@"暂无平台"];
    self.tableView.refreshDelegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.pagingEnabled = false;
    
}
- (void)requestPlatform
{
    BaseWeakSelf;
    
    TLNetworking *helper = [[TLNetworking alloc] init];
    
    helper.code = @"628616";
    helper.showView = self.view;
   
    helper.parameters[@"code"] =self.code;
    
    
    
    self.help = helper;
    
    [helper postWithSuccess:^(id responseObject) {
        self.model = [PlateMineModel mj_objectWithKeyValues:responseObject[@"data"]];
        self.Plateforms = [plateDetailModel mj_objectArrayWithKeyValuesArray:self.model.list];
        self.topView.model = self.model;
        self.tableView.models = self.Plateforms;
        [self.tableView reloadData_tl];
        NSLog(@"%@",self.Plateforms);
    } failure:^(NSError *error) {
        
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
